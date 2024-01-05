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
        VehicleTemp: Record Vehicle temporary;


    procedure Get_OCR_Text(jsonText: Text)
    var
        jsonObj: JsonObject;
        jsonToken: JsonToken;
        jsonToken_ImagesL: JsonToken;
        jsonToken_FieldsL: JsonToken;
        jsonToken_eachField: JsonToken;
        jsonToken_inferText: JsonToken;
        jsonArray_FieldsL: JsonArray;
        jsonArrayL: JsonArray;
        indexofText: Integer;

        listFields: List of [Text];
        VINNoTextL: Text;
        VehicleLicenseNoL: Text;
        ModelYearL: Text;
        SpecL: Text;
        RegistDate: Text;
        tempRegist: Text;
        I: Integer;
        YearIdx: Integer;
        MontIdx: Integer;
        DayIdx: Integer;
        RegistDateDT: Date;
        RegistDateList: List of [Text];
        RegistListCnt: Integer;

        VehicleConfirmPage: Page "OCR Vehicle InformationConfirm";
    begin

        if jsonText = '' then
            Error('There is no text parameter');

        if not jsonObj.ReadFrom(jsonText) then
            Error('JSON Parsing Error');

        if jsonObj.Get('images', jsonToken) then begin
            //image array 토큰을 받아서,
            if jsonToken.IsArray then begin
                jsonArrayL := jsonToken.AsArray();
                //그 array 에서, 0번째 가져온 다음에,
                if jsonArrayL.Get(0, jsonToken_ImagesL) then begin
                    if jsonToken_ImagesL.IsObject then begin
                        jsonToken_ImagesL.AsObject().Get('fields', jsonToken_FieldsL);
                        if jsonToken_FieldsL.IsArray then begin
                            jsonArray_FieldsL := jsonToken_FieldsL.AsArray();
                            foreach jsonToken_eachField in jsonArray_FieldsL do begin
                                if jsonToken_eachField.IsObject then begin
                                    jsonToken_eachField.AsObject().Get('inferText', jsonToken_inferText);
                                    if jsonToken_inferText.IsValue then
                                        listFields.Add(DelChr(jsonToken_inferText.AsValue().AsText(), '='));
                                end;
                            end;
                            indexofText := 0;
                            //최초등록일 다음 5개
                            indexofText := listFields.IndexOf('최초등록일:');
                            if indexofText <> 0 then begin
                                //최소한 5개의 토큰을 확인하고
                                for I := 1 to 5 do begin
                                    listFields.Get(indexofText + I, tempRegist);
                                    RegistDate += tempRegist;
                                    //'일' 이라는 텍스트를 만나면 그만함.
                                    if tempRegist.Contains('일') then
                                        break;
                                end;
                                //불필요한 공백은 삭제처리.
                                RegistDate := DelChr(RegistDate, '=');
                                //년/월/일을 기준으로 숫자만 꺼내서,
                                RegistDateList := RegistDate.Split('년', '월', '일');
                                RegistListCnt := RegistDateList.Count;
                                //최소한 3개의 숫자를 확인하고 없다면 빈값을 넣어줌.
                                if RegistListCnt < 3 then begin
                                    for I := RegistListCnt to 3 do begin
                                        RegistDateList.Add('1');
                                    end;
                                end;
                                Evaluate(YearIdx, RegistDateList.Get(1));
                                Evaluate(MontIdx, RegistDateList.Get(2));
                                Evaluate(DayIdx, RegistDateList.Get(3));
                                //숫자로 변환한 내용을, 일자로 변환해줌.
                                RegistDateDT := DMY2Date(DayIdx, MontIdx, YearIdx);

                            end;

                            indexofText := 0;
                            //1자동차등록번호 다음 1개
                            indexofText := listFields.IndexOf('자동차등록번호');
                            if indexofText = 0 then begin
                                indexofText := listFields.IndexOf('1자동차등록번호')
                            end;
                            if indexofText <> 0 then
                                listFields.Get(indexofText + 1, VehicleLicenseNoL);

                            indexofText := 0;
                            //6차대번호 다음 1개
                            indexofText := listFields.IndexOf('차대번호');
                            if indexofText = 0 then begin
                                indexofText := listFields.IndexOf('6차대번호')
                            end;
                            if indexofText <> 0 then
                                listFields.Get(indexofText + 1, VINNoTextL);

                            //5형식및모델연도 다음 1개(형식) 그 다음(모델연도) 1개
                            indexofText := 0;
                            indexofText := listFields.IndexOf('형식및모델연도');
                            if indexofText = 0 then begin
                                indexofText := listFields.IndexOf('5형식및모델연도')
                            end;
                            if indexofText <> 0 then begin
                                listFields.Get(indexofText + 1, SpecL);
                                listFields.Get(indexofText + 2, ModelYearL);
                            end;

                            VehicleTemp.Init();
                            VehicleTemp."Vehicle No." := VehicleLicenseNoL;
                            VehicleTemp."Vehicle Identification No." := VINNoTextL;
                            VehicleTemp."Licence-Plate No." := VehicleLicenseNoL;
                            VehicleTemp."National Code" := SpecL;
                            VehicleTemp.Year := ModelYearL;
                            VehicleTemp."Registration Date" := RegistDateDT;
                            VehicleTemp.Insert(true);

                            Page.Run(50012, VehicleTemp);
                            // TODO 확인페이지에서 입력한 내용을 Vehicle 에 적용하기.
                            // TODO 그 다음에, Part Zone 에 보내기. 
                            //Message('최초등록일==>[%5]\nVIN==>[%1]\n차량번호==>[%2]\n형식==>[%3]\n모델연도==>[%4]', VINNoTextL, VehicleLicenseNoL, SpecL, ModelYearL, RegistDateDT);

                        end;
                    end;
                end;
            end;
        end;

    end;

    procedure Get_PZ_Text(jsonText: Text)
    var
        jsonObj: JsonObject;
        jsonToken: JsonToken;
    begin
        if jsonText = '' then
            Error('There is no text parameter');

        if not jsonObj.ReadFrom(jsonText) then
            Error('JSON Parsing Error');


    end;

    procedure Send_OCR(var vehicleG: Record Vehicle temporary)
    var
        base64string: Text;
        regcardname: Text;
        ocrsetup: Record OCRWebSetup;
        ocrlog: Record OCRLog;
        ocrlogdatetime: DateTime;
        sendText: BigText;
        recvText: BigText;
        OStream: OutStream;
        ROStream: OutStream;
    begin
        ClearAll();

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
            sendText.AddText(jsonBody);

            ocrlog.Init();
            ocrlogdatetime := CurrentDateTime;
            ocrlog."Vehicle No." := vehicleG."Vehicle No.";
            ocrlog.SendDateTime := ocrlogdatetime;
            ocrlog.Insert();

            ocrlog.SendText.CreateOutStream(OStream);
            sendText.Write(OStream);
            ocrlog.Modify();

            httpContent.WriteFrom(jsonBody);
            httpContent.GetHeaders(httpHeader);
            httpHeader.Remove('Content-Type');
            httpHeader.Add('Content-Type', 'application/json');
            httpHeader.Add('X-OCR-SECRET', ocrsetup."Security Key");

            httpClient.Post(ocrsetup."Invoke URL", httpContent, httpResponse);
            httpResponse.Content().ReadAs(respText);

            recvText.AddText(respText);

            if httpResponse.HttpStatusCode = 200 then begin
                Get_OCR_Text(respText);
                ocrlog.Status := 'Success';
            end else begin
                ocrlog.Status := 'Error';
                Message('Error :: %1', respText);
            end;

            ocrlog.RecvText.CreateOutStream(ROStream);
            recvText.Write(ROStream);
            ocrlog.Modify();

        end;
    end;


    procedure Send_PZ(var vehicleG: Record Vehicle temporary)
    var
        base64string: Text;
        regcardname: Text;
        ocrsetup: Record OCRWebSetup;
        ocrlog: Record OCRLog;
        ocrlogdatetime: DateTime;
        sendText: BigText;
        recvText: BigText;
        OStream: OutStream;
        ROStream: OutStream;
    begin
        ClearAll();

        if ocrsetup.Get() then begin
            if ocrsetup."PZ_Key Code" = '' then
                Error('PartZone Key Code is empty.');
            if ocrsetup."PZ_Invoke URL" = '' then
                Error('PartZone Invoke URL is empty.');
        end;

        jsonBody := '{"keycode" : "' + ocrsetup."PZ_Key Code" + '","vin" : "' + vehicleG."Vehicle Identification No." + '","type":"1"}';

        sendText.AddText(jsonBody);

        ocrlog.Init();
        ocrlogdatetime := CurrentDateTime;
        ocrlog."Vehicle No." := vehicleG."Vehicle No.";
        ocrlog.SendDateTime := ocrlogdatetime;
        ocrlog.Insert();

        ocrlog.SendText.CreateOutStream(OStream);
        sendText.Write(OStream);
        ocrlog.Modify();

        httpContent.WriteFrom(jsonBody);
        httpContent.GetHeaders(httpHeader);
        httpHeader.Remove('Content-Type');
        httpHeader.Add('Content-Type', 'application/json');

        httpClient.Post(ocrsetup."PZ_Invoke URL", httpContent, httpResponse);
        httpResponse.Content().ReadAs(respText);

        if httpResponse.HttpStatusCode = 200 then begin
            Get_PZ_Text(respText);
            ocrlog.Status := 'Success';
        end else begin
            ocrlog.Status := 'Error';
            Message('Error :: %1', respText);
        end;

        ocrlog.RecvText.CreateOutStream(ROStream);
        recvText.Write(ROStream);
        ocrlog.Modify();
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
