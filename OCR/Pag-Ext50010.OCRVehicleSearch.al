pageextension 50010 OCRVehicleSearch extends "Cust Contact Vehicle Creation"
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
        addfirst("TecRMI Vehicle Catalog")
        {

            action("ConfirmVehicleReg")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Confirm Vehicle Info.', KOR = '차량등록 정보확인';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CheckRulesSyntax;
                trigger OnAction()
                var
                    specInforpageL: page "OCR Vehicle InformationConfirm";
                    extTempVehicle: Record Vehicle temporary;
                begin
                    GetVehicleInfo(extTempVehicle);
                    Page.Run(50012, extTempVehicle);
                end;
            }
            action("OCR Search")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Take/Search a Photo of Veh.Reg.', KOR = '차량등록증 사진찍기/검색';
                Image = AdministrationSalesPurchases;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    IsSuccess: Boolean;
                    extTempVehicle: Record Vehicle temporary;
                    imageRec: Record Vehicle;
                begin
                    GetVehicleInfo(extTempVehicle);

                    IsSuccess := Camera.AddPicture(extTempVehicle, extTempVehicle.FieldNo("Vehicle Registration Card"));
                    if IsSuccess then begin
                        SendOCR.Send_OCR(extTempVehicle);
                        CurrPage.Update();
                    end;
                    SetVehicleInfo(extTempVehicle);
                end;
            }
            action("Import Veh.Reg.Card")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Import Veh.Reg Card Image', KOR = '차량등록증 업로드/검색';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                    extTempVehicle: Record Vehicle temporary;
                begin
                    GetVehicleInfo(extTempVehicle);

                    if extTempVehicle."Vehicle Registration Card".HasValue then
                        if not Confirm(OverrideImageQst) then
                            exit;

                    FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
                    if FileName = '' then
                        exit;

                    Clear(extTempVehicle."Vehicle Registration Card");
                    extTempVehicle."Vehicle Registration Card".ImportFile(FileName, ClientFileName);
                    if not extTempVehicle.Modify(true) then
                        extTempVehicle.Insert(true);

                    if FileManagement.DeleteServerFile(FileName) then;

                    //Send the image file.
                    if extTempVehicle."Vehicle Registration Card".HasValue then begin
                        SendOCR.Send_OCR(extTempVehicle);
                        CurrPage.Update();
                    end;
                    Message('모델년도 %1 / 차량등록일 %2', extTempVehicle.Year, extTempVehicle."Registration Date");
                    SetVehicleInfo(extTempVehicle);
                end;
            }
            /*
            action(ExportFile)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Export Veh.Reg.Card', KOR = '차량등록증 내보내기';
                Enabled = DeleteExportEnabled;
                Image = Export;
                ToolTip = 'Export the picture to a file.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DummyPictureEntity: Record "Picture Entity";
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                    extTempVehicle: Record Vehicle temporary;
                begin
                    GetVehicleInfo(extTempVehicle);
                    //extTempVehicle.TestField(extTempVehicle."Vehicle No.");

                    ToFile := DummyPictureEntity.GetDefaultMediaDescription(extTempVehicle);
                    ExportPath := TemporaryPath + extTempVehicle."Vehicle No." + Format(extTempVehicle."Vehicle Registration Card".MediaId);
                    extTempVehicle."Vehicle Registration Card".ExportFile(ExportPath);

                    FileManagement.ExportImage(ExportPath, ToFile);
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Delete Veh.Reg.Card', KOR = '차량등록증 삭제';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the Veh.Reg.Card.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    extTempVehicle: Record Vehicle temporary;
                begin
                    GetVehicleInfo(extTempVehicle);

                    //extTempVehicle.TestField(extTempVehicle."Vehicle No.");

                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(extTempVehicle."Vehicle Registration Card");
                    extTempVehicle.Modify(true);

                    SetVehicleInfo(extTempVehicle);
                end;
            }
            */
            /*
            action(ShowPZ)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'View Spec Information', KOR = '파트존 결과정보 보기';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ServicePriceAdjustment;

                trigger OnAction()
                var
                    specPage: page "Vehicle Spec Inforamations";
                    specInforRecL: Record "Vehicle Spec  Information";
                    extTempVehicle: Record Vehicle temporary;
                    specTypeL: Enum "Spec Type";
                begin
                    GetVehicleInfo(extTempVehicle);
                    specInforRecL.Reset();
                    specInforRecL.SetRange(VIN, extTempVehicle."Vehicle Identification No.");
                    specInforRecL.SetFilter(SpecType, '%1|%2', specTypeL::Spec, specTypeL::Part);
                    if specInforRecL.FindSet() then begin
                        specPage.SetTableView(specInforRecL);
                        specPage.Run();
                    end;
                end;
            }
            */

        }

    }

    // To Add the function for additional fields update of extend page.
    // procedure setAdditionalVehicleInfo(VehicleP: Record Vehicle)
    // begin
    //     VehicleYear := VehicleP.Year;
    //     TempVehicle.Validate(Year, VehicleYear);
    //     VehicleRegDate := VehicleP."Registration Date";
    //     TempVehicle.Validate("Registration Date", VehicleRegDate);

    //     CurrPage.Update();
    // end;

    var
        //TempVehicle: Record Vehicle temporary;
        Camera: Codeunit Camera;
        [InDataSet]
        CameraAvailable: Boolean;
        OverrideImageQst: Label '이미 등록된 이미지가 교체됩니다. 그래도 계속하시겠습니까?';
        DeleteImageQst: Label '등록된 이미지를 정말 삭제하시겠습니까?';
        SelectPictureTxt: Label '차량등록증 이미지를 선택하세요.';
        DeleteExportEnabled: Boolean;
        VehicleG: Record Vehicle temporary;
        SendOCR: Codeunit "Ext Integration";

}
