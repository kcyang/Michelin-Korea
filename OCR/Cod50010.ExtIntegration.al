dotnet
{
    assembly(MKRUtilities)
    {
        type(MKRUtilities.WebServiceClient; mkrutil) { }
    }
}
codeunit 50010 "Ext Integration"
{
    var
        GVOS_OutputStream: OutStream;
        GVOS_InputStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        base64Convert: Codeunit "Base64 Convert";
        jsonBody: Text;
        // httpClient: HttpClient;
        // httpContent: HttpContent;
        // httpResponse: HttpResponseMessage;
        // // httpRequest: HttpRequestMessage;
        // httpHeader: HttpHeaders;
        respText: Text;
        mkrutil: DotNet mkrutil;
    //VehicleTemp: Record Vehicle temporary;
    procedure Get_OCR_Text(jsonText: Text; VehicleNoP: Code[20]; var VehicleTempP: Record Vehicle temporary)
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
        VehicleP: Record Vehicle temporary;
        VehicleL: Record Vehicle;

        VehicleConfirmPage: Page "Cust Contact Vehicle Creation";
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

                            VehicleP.Init();
                            VehicleP."Vehicle No." := VehicleNoP;
                            VehicleP.Insert();
                            if VehicleP.Get(VehicleNoP) then begin
                                VehicleP."Vehicle Identification No." := VINNoTextL;
                                VehicleP."Licence-Plate No." := VehicleLicenseNoL;
                                VehicleP."National Code" := SpecL;
                                VehicleP.Year := ModelYearL;
                                VehicleP."Registration Date" := RegistDateDT;
                                VehicleP.Modify();
                                Commit();
                                if Page.RunModal(50012, VehicleP) = Action::LookupOK then begin
                                    if VehicleL.Get(VehicleNoP) then begin //find the real record.
                                        if (VehicleL."Vehicle Identification No." <> '') AND (VehicleL."Vehicle Identification No." <> VehicleP."Vehicle Identification No.") then begin
                                            if Confirm('조회된 VIN 번호가 차량카드의 VIN 번호와 다릅니다.그래도 업데이트 할까요?', true, 'OK', 'Cancel') then begin
                                                VehicleL."Vehicle Identification No." := VehicleP."Vehicle Identification No.";
                                            end;
                                        end else begin
                                            VehicleL."Vehicle Identification No." := VehicleP."Vehicle Identification No.";
                                        end;
                                        if (VehicleL."Licence-Plate No." <> '') AND (VehicleL."Licence-Plate No." <> VehicleP."Licence-Plate No.") then begin
                                            if Confirm('조회된 차량번호가 차량카드의 차량 번호와 다릅니다.그래도 업데이트 할까요?', true, 'OK', 'Cancel') then begin
                                                VehicleL."Licence-Plate No." := VehicleP."Licence-Plate No.";
                                            end;
                                        end else begin
                                            VehicleL."Licence-Plate No." := VehicleP."Licence-Plate No.";
                                        end;
                                        if (VehicleL."National Code" <> '') AND (VehicleL."National Code" <> VehicleP."National Code") then begin
                                            if Confirm('조회된 국가코드가 차량카드의 국가코드와 다릅니다.그래도 업데이트 할까요?', true, 'OK', 'Cancel') then begin
                                                VehicleL."National Code" := VehicleP."National Code";
                                            end;
                                        end else begin
                                            VehicleL."National Code" := VehicleP."National Code";
                                        end;
                                        if (VehicleL.Year <> '') AND (VehicleL.Year <> VehicleP.Year) then begin
                                            if Confirm('조회된 모델년도가 차량카드의 모델년도와 다릅니다.그래도 업데이트 할까요?', true, 'OK', 'Cancel') then begin
                                                VehicleL.Year := VehicleP.Year;
                                            end;
                                        end else begin
                                            VehicleL.Year := VehicleP.Year;
                                        end;
                                        if (VehicleL."Registration Date" <> 0D) AND (VehicleL."Registration Date" <> VehicleP."Registration Date") then begin
                                            if Confirm('조회된 차량등록일이 차량카드의 차량등록일과 다릅니다.그래도 업데이트 할까요?', true, 'OK', 'Cancel') then begin
                                                VehicleL."Registration Date" := VehicleP."Registration Date";
                                            end;
                                        end else begin
                                            VehicleL."Registration Date" := VehicleP."Registration Date";
                                        end;

                                        if (VehicleL."Vehicle Manufacturer" <> '') AND (VehicleL."Vehicle Manufacturer" <> VehicleP."Vehicle Manufacturer") then begin
                                            if Confirm('조회된 차량제조사가 차량카드의 차량제조사와 다릅니다.그래도 업데이트 할까요?', true, 'OK', 'Cancel') then begin
                                                VehicleL."Vehicle Manufacturer" := VehicleP."Vehicle Manufacturer";
                                            end;
                                        end else begin
                                            VehicleL."Vehicle Manufacturer" := VehicleP."Vehicle Manufacturer";
                                        end;
                                        if (VehicleL."Vehicle Model" <> '') AND (VehicleL."Vehicle Model" <> VehicleP."Vehicle Model") then begin
                                            if Confirm('조회된 차량모델이 차량카드의 차량모델과 다릅니다.그래도 업데이트 할까요?', true, 'OK', 'Cancel') then begin
                                                VehicleL."Vehicle Model" := VehicleP."Vehicle Model";
                                            end;
                                        end else begin
                                            VehicleL."Vehicle Model" := VehicleP."Vehicle Model";
                                        end;
                                        if (VehicleL."Vehicle Variant" <> '') AND (VehicleL."Vehicle Variant" <> VehicleP."Vehicle Variant") then begin
                                            if Confirm('조회된 차량유형이 차량카드의 차량유형과 다릅니다.그래도 업데이트 할까요?', true, 'OK', 'Cancel') then begin
                                                VehicleL."Vehicle Variant" := VehicleP."Vehicle Variant";
                                            end;
                                        end else begin
                                            VehicleL."Vehicle Variant" := VehicleP."Vehicle Variant";
                                        end;
                                        if (VehicleL."Body Type" <> '') AND (VehicleL."Body Type" <> VehicleP."Body Type") then begin
                                            if Confirm('조회된 차량바디유형이 차량카드의 차량바디유형과 다릅니다.그래도 업데이트 할까요?', true, 'OK', 'Cancel') then begin
                                                VehicleL."Body Type" := VehicleP."Body Type";
                                            end;
                                        end else begin
                                            VehicleL."Body Type" := VehicleP."Body Type";
                                        end;
                                        if (VehicleL."Engine No. (Type)" <> '') AND (VehicleL."Engine No. (Type)" <> VehicleP."Engine No. (Type)") then begin
                                            if Confirm('조회된 차량엔진이 차량카드의 차량엔진과 다릅니다.그래도 업데이트 할까요?', true, 'OK', 'Cancel') then begin
                                                VehicleL."Engine No. (Type)" := VehicleP."Engine No. (Type)";
                                            end;
                                        end else begin
                                            VehicleL."Engine No. (Type)" := VehicleP."Engine No. (Type)";
                                        end;
                                        if (VehicleL.Fuel <> '') AND (VehicleL.Fuel <> VehicleP.Fuel) then begin
                                            if Confirm('조회된 차량연료방식이 차량카드의 차량연료방식과 다릅니다.그래도 업데이트 할까요?', true, 'OK', 'Cancel') then begin
                                                VehicleL.Fuel := VehicleP.Fuel;
                                            end;
                                        end else begin
                                            VehicleL.Fuel := VehicleP.Fuel;
                                        end;
                                        vehicleL.Modify();
                                    end else begin
                                        //if VehicleTempP.Get(VehicleNoP) then begin //find in the temp.
                                        VehicleTempP."Vehicle Identification No." := VINNoTextL;
                                        VehicleTempP."Licence-Plate No." := VehicleLicenseNoL;
                                        VehicleTempP."National Code" := SpecL;
                                        VehicleTempP.Year := ModelYearL;
                                        VehicleTempP."Registration Date" := RegistDateDT;
                                        VehicleTempP."Vehicle Manufacturer" := VehicleP."Vehicle Manufacturer";
                                        VehicleTempP."Vehicle Model" := VehicleP."Vehicle Model";
                                        VehicleTempP."Vehicle Variant" := VehicleP."Vehicle Variant";
                                        VehicleTempP."Body Type" := VehicleP."Body Type";
                                        VehicleTempP."Engine No. (Type)" := VehicleP."Engine No. (Type)";
                                        VehicleTempP.Fuel := VehicleP.Fuel;

                                        VehicleTempP.Modify();
                                        //end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;

    end;

    procedure Get_PZ_Detail_Text(jsonText: Text; var vehicleG: Record Vehicle temporary)
    var
        jsonObj: JsonObject;
        jsonToken: JsonToken;
        Token_resultCodeL: JsonToken;
        jsonTokenSpecL: JsonToken;
        jsonToken_ModelL: JsonToken;
        jsonObj_pz_v1_ObjectL: JsonObject;
        specTokenL: JsonToken;
        partsTokenL: JsonToken;
        jsonArray_parts: JsonArray;
        detailTokenL: JsonToken;
        valueTokenL: JsonToken;
        partnameTokenL: JsonToken;
        partCategoryL: JsonToken;

        partDetailObjL: JsonObject;
        partDetailTokenL: JsonToken;

        partKeysL: List of [Text];
        KeyL: Text;

        //dictKeyL: Text;
        //IDNoL: Integer;
        iCnt: Integer;
        I: Integer;

        specInformationL: Record "Vehicle Spec  Information";
        specL: Record "Vehicle Spec  Information";
        specTypeL: Enum "Spec Type";
        partDetialL: Record "Vehicle Parts Details";

    begin
        if jsonText = '' then
            Error('There is no text parameter');

        if not jsonObj.ReadFrom(jsonText) then
            Error('JSON Parsing Error');

        if jsonObj.Get('code', Token_resultCodeL) then begin
            if Token_resultCodeL.IsValue then begin
                if not (Token_resultCodeL.AsValue().AsText() = '0000') then begin
                    jsonObj.Get('message', Token_resultCodeL);
                    Error('🪛파트존 메시지 :: %1', Token_resultCodeL.AsValue().AsText());
                end;
            end;

        end;
        if jsonObj.Get('data', jsonToken) then begin
            if jsonToken.IsObject then begin
                jsonToken.AsObject().Get('part', jsonTokenSpecL);
                if jsonTokenSpecL.IsArray then begin
                    jsonArray_parts := jsonTokenSpecL.AsArray();
                    iCnt := jsonArray_parts.Count;
                    if iCnt > 0 then begin
                        specInformationL.Reset();
                        specInformationL.SetRange(VIN, vehicleG."Vehicle Identification No.");
                        specInformationL.SetRange(SpecType, specTypeL::Part);
                        if specInformationL.FindSet() then begin
                            specInformationL.DeleteAll();
                        end;
                        partDetialL.Reset();
                        partDetialL.SetRange(VIN, vehicleG."Vehicle Identification No.");
                        if partDetialL.FindSet() then
                            partDetialL.DeleteAll();

                        I := 100;
                        foreach detailTokenL in jsonArray_parts do begin
                            I += 10;
                            if detailTokenL.IsObject then begin
                                partDetailObjL := detailTokenL.AsObject();
                                partKeysL := partDetailObjL.Keys;

                                partDetailObjL.Get('stockNo', valueTokenL);
                                partDetailObjL.Get('productEngName', partnameTokenL);
                                partDetailObjL.Get('category', partCategoryL);
                                if valueTokenL.IsValue then begin
                                    specInformationL.Reset();
                                    specInformationL.SetRange(VIN, vehicleG."Vehicle Identification No.");
                                    specInformationL.SetRange(SpecType, specTypeL::Part);
                                    specInformationL.SetFilter("Parts ID", '%1', valueTokenL.AsValue().AsDecimal());
                                    specInformationL.SetFilter("Attribute Name", '%1', 'PartName');
                                    specInformationL.SetFilter("category", '%1', partCategoryL.AsValue().AsText());
                                    if specInformationL.FindSet() then begin
                                        ;
                                    end else begin
                                        specL.Init();
                                        specL.VIN := vehicleG."Vehicle Identification No.";
                                        specL.SpecType := specTypeL::Part;
                                        specL.ID := getLastNumber(specL, vehicleG."Vehicle Identification No.") + I + 10;
                                        specL.Insert();
                                        specL."Parts ID" := valueTokenL.AsValue().AsDecimal();
                                        specL."Attribute Name" := 'PartName';
                                        specL."Attribute Value" := partnameTokenL.AsValue().AsText();
                                        specL.Category := partCategoryL.AsValue().AsText();
                                        specL.Modify();

                                        foreach KeyL in partKeysL do begin
                                            partDetailObjL.Get(KeyL, partDetailTokenL);

                                            partDetialL.Init();
                                            partDetialL.VIN := vehicleG."Vehicle Identification No.";
                                            partDetialL."Parts ID" := valueTokenL.AsValue().AsDecimal();
                                            partDetialL.Category := partCategoryL.AsValue().AsText();
                                            partDetialL."Line No." += 10;
                                            partDetialL.Insert();

                                            partDetialL."Attribute Name" := KeyL;

                                            if KeyL = 'stockNo' then
                                                partDetialL."Attribute Value" := FORMAT(partDetailTokenL.AsValue().AsDecimal())
                                            else begin
                                                if partDetailTokenL.AsValue().IsNull then
                                                    partDetialL."Attribute Value" := ''
                                                else
                                                    partDetialL."Attribute Value" := partDetailTokenL.AsValue().AsText();
                                            end;
                                            partDetialL.Modify();
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure Get_PZ_Text(jsonText: Text; var vehicleG: Record Vehicle temporary)
    var
        jsonObj: JsonObject;
        jsonToken: JsonToken;
        Token_resultCodeL: JsonToken;
        jsonTokenSpecL: JsonToken;
        jsonToken_ModelL: JsonToken;
        jsonObj_pz_v1_ObjectL: JsonObject;
        specTokenL: JsonToken;

        specListL: List of [Text];
        specDictL: Dictionary of [Text, Text];
        specValuesL: List of [Text];
        specKeyL: Text;

        dictKeyL: Text;
        IDNoL: Integer;

        specInformationL: Record "Vehicle Spec  Information";
        specTypeL: Enum "Spec Type";

    begin
        if jsonText = '' then
            Error('There is no text parameter');

        if not jsonObj.ReadFrom(jsonText) then
            Error('JSON Parsing Error');

        if jsonObj.Get('code', Token_resultCodeL) then begin
            if Token_resultCodeL.IsValue then begin
                if not (Token_resultCodeL.AsValue().AsText() = '0000') then begin
                    jsonObj.Get('message', Token_resultCodeL);
                    Error('🪛파트존 메시지 :: %1', Token_resultCodeL.AsValue().AsText());
                end;
            end;

        end;
        if jsonObj.Get('data', jsonToken) then begin
            if jsonToken.IsObject then begin
                jsonToken.AsObject().Get('spec', jsonTokenSpecL);
                if jsonTokenSpecL.IsObject then begin
                    jsonObj_pz_v1_ObjectL := jsonTokenSpecL.AsObject();
                    specListL := jsonObj_pz_v1_ObjectL.Keys;
                    foreach specKeyL in specListL do begin
                        jsonObj_pz_v1_ObjectL.Get(specKeyL, specTokenL);
                        if specTokenL.IsValue then begin
                            specDictL.Add(specKeyL, specTokenL.AsValue().AsText());
                            if specKeyL = 'maker' then begin
                                vehicleG."Vehicle Manufacturer" := specTokenL.AsValue().AsText();
                            end;
                            if specKeyL = 'model' then begin
                                vehicleG."Vehicle Model" := specTokenL.AsValue().AsText();
                            end;
                            if specKeyL = 'series' then begin
                                vehicleG."Vehicle Variant" := specTokenL.AsValue().AsText();
                            end;
                            if specKeyL = 'yearDate' then begin
                                vehicleG.Year := specTokenL.AsValue().AsText();
                            end;
                            if specKeyL = 'chassis' then begin
                                vehicleG."Body Type" := specTokenL.AsValue().AsText();
                            end;
                            if specKeyL = 'engine' then begin
                                vehicleG."Engine No. (Type)" := specTokenL.AsValue().AsText();
                            end;
                            if specKeyL = 'fuelType' then begin
                                vehicleG.Fuel := specTokenL.AsValue().AsText();
                            end;
                        end;
                    end;

                    if specDictL.Count > 0 then begin
                        IDNoL := 10000;
                        foreach dictKeyL in specDictL.Keys do begin
                            specInformationL.Reset();
                            specInformationL.SetRange(VIN, vehicleG."Vehicle Identification No.");
                            specInformationL.SetRange(SpecType, specTypeL::Spec);
                            specInformationL.SetFilter("Attribute Name", dictKeyL);
                            if specInformationL.FindSet() then begin
                                specInformationL."Attribute Value" := specDictL.Get(dictKeyL);
                                specInformationL.Modify();
                            end else begin
                                specInformationL.Init();
                                specInformationL.VIN := vehicleG."Vehicle Identification No.";
                                specInformationL.SpecType := specTypeL::Spec;
                                specInformationL.ID += 10;
                                specInformationL.Insert();
                                specInformationL."Attribute Name" := dictKeyL;
                                specInformationL."Attribute Value" := specDictL.Get(dictKeyL);
                                specInformationL.Modify();
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure Send_OCR(var vehicleG: Record Vehicle)
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
        DLG.Open('이미지를 분석중입니다....');
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
            /* //Old way - Modified to use dotnet function for proxy settings.
                        httpContent.WriteFrom(jsonBody);
                        httpContent.GetHeaders(httpHeader);
                        httpHeader.Remove('Content-Type');
                        httpHeader.Add('Content-Type', 'application/json');
                        httpHeader.Add('X-OCR-SECRET', ocrsetup."Security Key");

                        httpClient.Post(ocrsetup."Invoke URL", httpContent, httpResponse);
                        httpResponse.Content().ReadAs(respText);
            */
            /*
            if ocrsetup."Proxy URL" = '' then begin
                Message('프록시 서버셋업이 누락되었습니다. 웹설정을 확인하세요.');
                exit;
            end;
            */

            mkrutil := mkrutil.WebServiceClient(ocrsetup."Proxy URL");
            respText := mkrutil.CallWebService_OCR(ocrsetup."Invoke URL", jsonBody, ocrsetup."Security Key");

            recvText.AddText(respText);
            /* //Old way - Modified to use dotnet function for proxy settings.
            if httpResponse.HttpStatusCode = 200 then begin
                Get_OCR_Text(respText, vehicleG);
                ocrlog.Status := 'Success';
            end else begin
                ocrlog.Status := 'Error';
                Message('Error :: %1', respText);
            end;
            */
            if respText <> '' then begin
                Get_OCR_Text(respText, vehicleG."Vehicle No.", vehicleG);
                ocrlog.Status := 'Success';
            end else begin
                ocrlog.Status := 'Error';
                Message('Error :: 서버가 응답하지 않습니다.');
            end;
            ocrlog.RecvText.CreateOutStream(ROStream);
            recvText.Write(ROStream);
            ocrlog.Modify();
            DLG.Close();
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

        DLG.Open(TEXT0001);

        if ocrsetup.Get() then begin
            if ocrsetup."PZ_Key Code" = '' then
                Error('PartZone Key Code is empty.');
            if ocrsetup."PZ_Invoke URL" = '' then
                Error('PartZone Invoke URL is empty.');
            /*    
            if ocrsetup."Proxy URL" = '' then
                Error('Proxy URL is missing.');
            */
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

        // httpContent.WriteFrom(jsonBody);
        // httpContent.GetHeaders(httpHeader);
        // httpHeader.Remove('Content-Type');
        // httpHeader.Add('Content-Type', 'application/json');

        // httpClient.Post(ocrsetup."PZ_Invoke URL", httpContent, httpResponse);
        // httpResponse.Content().ReadAs(respText);

        mkrutil := mkrutil.WebServiceClient(ocrsetup."Proxy URL");
        respText := mkrutil.CallWebService(ocrsetup."PZ_Invoke URL", jsonBody);

        // if httpResponse.HttpStatusCode = 200 then begin
        //     Get_PZ_Text(respText, vehicleG);
        //     ocrlog.Status := 'Success';
        // end else begin
        //     ocrlog.Status := 'Error';
        //     Message('Error :: %1', respText);
        // end;
        if respText <> '' then begin
            Get_PZ_Text(respText, vehicleG);
            ocrlog.Status := 'Success';
        end else begin
            ocrlog.Status := 'Error';
            Message('Error :: 서버가 응답하지 않습니다.');
        end;

        ocrlog.RecvText.CreateOutStream(ROStream);
        recvText.Write(ROStream);
        ocrlog.Modify();
        DLG.Close();
        Message('파트존 조회완료!');
    end;

    procedure Send_PZ_Detail(var vehicleG: Record Vehicle temporary)
    var
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
        DLG.Open(TEXT0001);

        if ocrsetup.Get() then begin
            if ocrsetup."PZ_Key Code" = '' then
                Error('PartZone Key Code is empty.');
            //Check the Parts Detail URL.
            if ocrsetup."PZ_Parts_Invoke URL" = '' then
                Error('PartZone Invoke URL is empty.');
            if ocrsetup."Proxy URL" = '' then
                Error('Proxy URL is missing.');
        end;

        jsonBody := '{"keycode" : "' + ocrsetup."PZ_Key Code" + '","vin" : "' + vehicleG."Vehicle Identification No." + '","service":"3","packageClass":"20"}';

        sendText.AddText(jsonBody);

        ocrlog.Init();
        ocrlogdatetime := CurrentDateTime;
        ocrlog."Vehicle No." := vehicleG."Vehicle No.";
        ocrlog.SendDateTime := ocrlogdatetime;
        ocrlog.Insert();

        ocrlog.SendText.CreateOutStream(OStream);
        sendText.Write(OStream);
        ocrlog.Modify();

        // httpContent.WriteFrom(jsonBody);
        // httpContent.GetHeaders(httpHeader);
        // httpHeader.Remove('Content-Type');
        // httpHeader.Add('Content-Type', 'application/json');

        // httpClient.Post(ocrsetup."PZ_Parts_Invoke URL", httpContent, httpResponse);
        // httpResponse.Content().ReadAs(respText);

        mkrutil := mkrutil.WebServiceClient(ocrsetup."Proxy URL");
        respText := mkrutil.CallWebService(ocrsetup."PZ_Parts_Invoke URL", jsonBody);

        // if httpResponse.HttpStatusCode = 200 then begin
        //     Get_PZ_Detail_Text(respText, vehicleG);
        //     ocrlog.Status := 'Success';
        // end else begin
        //     ocrlog.Status := 'Error';
        //     Message('Error :: %1', respText);
        // end;
        if respText <> '' then begin
            Get_PZ_Detail_Text(respText, vehicleG);
            ocrlog.Status := 'Success';
        end else begin
            ocrlog.Status := 'Error';
            Message('Error :: 서버가 응답하지 않습니다.');
        end;

        ocrlog.RecvText.CreateOutStream(ROStream);
        recvText.Write(ROStream);
        ocrlog.Modify();
        DLG.Close();
        Message('파트존 부품조회완료!');
    end;

    local procedure DateTimeToUnixTimestamp(DateTimeValue: DateTime): BigInteger
    var
        EpochDateTime: DateTime;
    begin
        // Calculate the Unix timestamp based on the Epoch datetime of 1/1/1970
        EpochDateTime := CreateDateTime(DMY2Date(1, 1, 1970), 0T);
        exit((DateTimeValue - EpochDateTime));
    end;

    local procedure getLastNumber(specInforRecord: Record "Vehicle Spec  Information"; VIN: code[20]): Integer
    var
        specTypeL: Enum "Spec Type";
    begin
        specInforRecord.Reset();
        specInforRecord.SetRange(VIN, VIN);
        specInforRecord.SetRange(SpecType, specTypeL::Spec);

        if specInforRecord.FindLast() then begin
            EXIT(specInforRecord.ID);
        end;

    end;


    var
        DLG: Dialog;
        TEXT0001: TextConst ENU = 'Search Parts Information...', KOR = '부품 검색중...';
}
