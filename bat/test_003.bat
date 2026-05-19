@echo off
chcp 65001 >nul
title Webhook Sender

echo Відправка вебхука...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$body = @{message='Test payload executed successfully'; timestamp=(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'); hostname=$env:COMPUTERNAME} | ConvertTo-Json; ^
Invoke-RestMethod -Uri 'https://eset-bot-sender--0xw1zard.replit.app/api/eset-webhook' -Method Post -Body $body -ContentType 'application/json'"

echo.
echo Вебхук відправлено. Натисніть будь-яку клавішу...
pause >nul
