codeunit 50010 "Ext Integration"
{
    var
        GVOS_OutputStream: OutStream;
        GVOS_InputStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        base64Convert: Codeunit "Base64 Convert";
        jsonBody: Text;
        httpClient: HttpClient;
        httpContent: HttpContent;
        httpResponse: HttpResponseMessage;
        httpRequest: HttpRequestMessage;
        httpHeader: HttpHeaders;
        respText: Text;

    procedure Send_OCR(var vehicleG: Record Vehicle temporary)
    var
        base64string: Text;
        regcardname: Text;
        ocrsetup: Record OCRWebSetup;
    begin
        Clear(base64string);
        Clear(regcardname);

        if ocrsetup.Get() then begin
            if ocrsetup."Security Key" = '' then
                Error('Security Key is empty.');
            if ocrsetup."Invoke URL" = '' then
                Error('Invoke URL is empty.');
        end;


        if vehicleG."Vehicle Registration Card".HasValue() then begin

            TempBlob.CreateOutStream(GVOS_OutputStream);
            vehicleG."Vehicle Registration Card".ExportStream(GVOS_OutputStream);
            regcardname := vehicleG."Vehicle No.";

            TempBlob.CreateInStream(GVOS_InputStream);
            base64string := base64Convert.ToBase64(GVOS_InputStream);

            jsonBody := '{"version" : "v2"'
                        + ',"requestId" : "' + vehicleG."Vehicle Registration Card".MediaId()
                        + '","timestamp" : ' + FORMAT(DateTimeToUnixTimestamp(System.CurrentDateTime))
                        + ',"images" : [{'
                        + '"format":"png"'
                        + ',"name":"' + vehicleG."Vehicle No."
                        + '","data":"' + base64string
                        + '"}]}';
            //Message('JSON --> %1', jsonBody);
            httpContent.WriteFrom(jsonBody);
            httpContent.GetHeaders(httpHeader);
            httpHeader.Remove('Content-Type');
            httpHeader.Add('Content-Type', 'application/json');
            httpHeader.Add('X-OCR-SECRET', ocrsetup."Security Key");

            httpClient.Post(ocrsetup."Invoke URL", httpContent, httpResponse);
            httpResponse.Content().ReadAs(respText);

            if httpResponse.HttpStatusCode = 200 then begin
                Message('The file sent.!');
            end else begin
                Error('Error :: %1', respText);
            end;
        end;
    end;

    local procedure DateTimeToUnixTimestamp(DateTimeValue: DateTime): BigInteger
    var
        EpochDateTime: DateTime;
    begin
        // Calculate the Unix timestamp based on the Epoch datetime of 1/1/1970
        EpochDateTime := CreateDateTime(DMY2Date(1, 1, 1970), 0T);
        exit((DateTimeValue - EpochDateTime));
    end;
}
