@echo off
chcp 65001 >nul
title Webhook Sender

set WEBHOOK_URL=https://eset-bot-sender--0xw1zard.replit.app/api/eset-webhook

:: Формируем JSON (можно изменить текст в кавычках)
set JSON_PAYLOAD={"text":"Тестове повідомлення від Bad-Pi лабораторії","timestamp":"%date% %time%","hostname":"%COMPUTERNAME%"}

echo Отправка данных на сервер...
curl -X POST -H "Content-Type: application/json" -d "%JSON_PAYLOAD%" %WEBHOOK_URL%

echo.
echo Готово. Нажмите любую клавишу...
pause >nul
