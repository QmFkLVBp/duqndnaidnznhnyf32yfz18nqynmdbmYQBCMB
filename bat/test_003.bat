@echo off
chcp 65001 >nul
title Webhook Sender

set WEBHOOK_URL=https://eset-bot-sender--0xw1zard.replit.app/api/eset-webhook
set MSG_TEXT=Тестове повідомлення від Bad-Pi лабораторії

echo Надсилання даних на сервер...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$body = @{text='%MSG_TEXT%'; timestamp=(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); hostname=$env:COMPUTERNAME} | ConvertTo-Json; ^
Invoke-RestMethod -Uri '%WEBHOOK_URL%' -Method Post -Body $body -ContentType 'application/json'; ^
Write-Host 'Готово.'"

pause
