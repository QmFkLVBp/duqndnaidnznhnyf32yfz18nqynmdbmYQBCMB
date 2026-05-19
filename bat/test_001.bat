@echo off
echo msgbox "All is working.", 64, "Security Lab Test" > %temp%\msg.vbs
wscript %temp%\msg.vbs
del %temp%\msg.vbs
exit
