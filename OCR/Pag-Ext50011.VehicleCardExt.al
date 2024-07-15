pageextension 50011 VehicleCardExt extends "Vehicle Card Generic"
{
    // +--------------------------------------------------------------+
    // | ¸ 2023 incadea Korea                                         |
    // +--------------------------------------------------------------+
    // | PURPOSE: OCR Recog.                                          |
    // +--------------------------------------------------------------+
    // 
    // VERSION  ID      WHO    DATE        DESCRIPTION
    // 231220   KR_0001 KY     2023-12-20  INITIAL RELEASE        
    actions
    {
        addfirst(Catalog)
        {
            action(runLog)
            {
                ApplicationArea = All;
                Image = LineDescription;
                RunObject = page "OCR Log List";
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
            }
            action(ConfirmVehicleReg)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Confirm Vehicle Info.', KOR = '차량등록 정보확인';
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Image = CheckRulesSyntax;
                trigger OnAction()
                var
                    specInforpageL: page "OCR Vehicle InformationConfirm";
                begin
                    //기존에 Vehilce Card 에서 열때에는 기존 Record 와 연결된 내용으로 아래와 같이 열것.
                    Page.Run(50012, Rec);
                end;
            }
            action("OCR Search")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'OCR Search', KOR = '차량등록증 사진찍기/검색';
                Image = AdministrationSalesPurchases;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    IsSuccess: Boolean;
                begin
                    // Message('차량등록증 업로드/실행');
                    IsSuccess := Camera.AddPicture(Rec, Rec.FieldNo("Vehicle Registration Card"));
                    if IsSuccess then begin
                        if Rec."Vehicle Registration Card".HasValue then begin
                            VehicleG.Copy(Rec);
                            SendOCR.Send_OCR(VehicleG);
                        end;
                    end;
                end;
            }
            action("OCR VINSearch")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'OCR VIN Search', KOR = '차대번호VIN 사진찍기/검색';
                Image = AdministrationSalesPurchases;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    IsSuccess: Boolean;
                begin
                    // Message('차량등록증 업로드/실행');
                    IsSuccess := Camera.AddPicture(Rec, Rec.FieldNo("Vehicle Registration Card"));
                    if IsSuccess then begin
                        if Rec."Vehicle Registration Card".HasValue then begin
                            VehicleG.Copy(Rec);
                            SendOCR.Send_VIN_OCR(VehicleG);
                        end;
                    end;
                end;
            }
            action("Veh.Reg.Card Import")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Import Veh.Reg.Card', KOR = '차량등록증 등록/가져오기';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                begin
                    Rec.TestField(Rec."Vehicle No.");

                    if Rec."Vehicle Registration Card".HasValue then
                        if not Confirm(OverrideImageQst) then
                            exit;

                    FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
                    if FileName = '' then
                        exit;

                    Clear(Rec."Vehicle Registration Card");
                    Rec."Vehicle Registration Card".ImportFile(FileName, ClientFileName);
                    if not Rec.Modify(true) then
                        Rec.Insert(true);

                    if FileManagement.DeleteServerFile(FileName) then;

                    //Send the image file.
                    if Rec."Vehicle Registration Card".HasValue then begin
                        VehicleG.Copy(Rec);
                        SendOCR.Send_OCR(VehicleG);
                    end;
                end;
            }
            action("VehVIN Import")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Import VIN', KOR = '차대번호VIN 등록/가져오기';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                begin
                    Rec.TestField(Rec."Vehicle No.");

                    if Rec."Vehicle Registration Card".HasValue then
                        if not Confirm(OverrideImageQst) then
                            exit;

                    FileName := FileManagement.UploadFile(SelectVINPictureTxt, ClientFileName);
                    if FileName = '' then
                        exit;

                    Clear(Rec."Vehicle Registration Card");
                    Rec."Vehicle Registration Card".ImportFile(FileName, ClientFileName);
                    if not Rec.Modify(true) then
                        Rec.Insert(true);

                    if FileManagement.DeleteServerFile(FileName) then;

                    //Send the image file.
                    if Rec."Vehicle Registration Card".HasValue then begin
                        VehicleG.Copy(Rec);
                        SendOCR.Send_VIN_OCR(VehicleG);
                    end;
                end;
            }
            action(ExportFile)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Export Veh.Reg.Card', KOR = '이미지(등록증/VIN) 내보내기';
                Enabled = DeleteExportEnabled;
                Image = Export;
                ToolTip = 'Export the picture to a file.';
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DummyPictureEntity: Record "Picture Entity";
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                begin
                    Rec.TestField(Rec."Vehicle No.");

                    ToFile := DummyPictureEntity.GetDefaultMediaDescription(Rec);
                    ExportPath := TemporaryPath + Rec."Vehicle No." + Format(Rec."Vehicle Registration Card".MediaId);
                    Rec."Vehicle Registration Card".ExportFile(ExportPath);

                    FileManagement.ExportImage(ExportPath, ToFile);
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Delete Veh.Reg.Card', KOR = '이미지(등록증/VIN) 삭제';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the Veh.Reg.Card.';
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField(Rec."Vehicle No.");

                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Rec."Vehicle Registration Card");
                    Rec.Modify(true);
                end;
            }
        }
    }
    var
        Camera: Codeunit Camera;
        [InDataSet]
        CameraAvailable: Boolean;
        OverrideImageQst: Label '이미 등록된 이미지가 교체됩니다. 그래도 계속하시겠습니까?';
        DeleteImageQst: Label '등록된 이미지를 정말 삭제하시겠습니까?';
        SelectPictureTxt: Label '차량등록증 이미지를 선택하세요.';
        SelectVINPictureTxt: Label '차대번호 이미지를 선택하세요.';
        DeleteExportEnabled: Boolean;
        VehicleG: Record Vehicle temporary;
        SendOCR: Codeunit "Ext Integration";
}

