@echo off
chcp 65001 >nul
title Эмуляция взлома


:: Создаём файл с паролями (эмуляция)
echo Сайт: vk.com | Логин: user@vk.ru | Пароль: qwerty123 > "%USERPROFILE%\Desktop\passwords.txt"
echo Сайт: mail.ru | Логин: mymail@mail.ru | Пароль: superpass >> "%USERPROFILE%\Desktop\passwords.txt"
echo Сайт: google.com | Логин: victim@gmail.com | Пароль: chrome_pass >> "%USERPROFILE%\Desktop\passwords.txt"
echo. >> "%USERPROFILE%\Desktop\passwords.txt"
echo Внимание: это тестовый файл, реальные данные не похищены. >> "%USERPROFILE%\Desktop\passwords.txt"

:: Запускаем полноэкранное окно "Вас взломали!"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Add-Type -AssemblyName System.Windows.Forms; ^
$f = New-Object Windows.Forms.Form; ^
$f.FormBorderStyle = 'None'; ^
$f.WindowState = 'Maximized'; ^
$f.BackColor = 'Black'; ^
$l = New-Object Windows.Forms.Label; ^
$l.Text = 'ВАС ВЗЛОМАЛИ!'; ^
$l.ForeColor = 'Red'; ^
$l.Font = New-Object System.Drawing.Font('Courier New', 72, [System.Drawing.FontStyle]::Bold); ^
$l.AutoSize = $false; ^
$l.TextAlign = 'MiddleCenter'; ^
$l.Dock = 'Fill'; ^
$f.Controls.Add($l); ^
$f.Add_KeyDown({ if($_.KeyCode -eq 'Escape') { $f.Close() } }); ^
$f.ShowDialog()"

:: Конец
