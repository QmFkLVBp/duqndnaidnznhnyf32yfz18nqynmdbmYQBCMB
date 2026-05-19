@echo off
echo msgbox "Систему успішно протестовано! Макрос працює.", 64, "Security Lab Test" > %temp%\msg.vbs
wscript %temp%\msg.vbs
del %temp%\msg.vbs
exit
