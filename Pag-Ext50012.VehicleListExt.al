pageextension 50012 VehicleListExt extends "Vehicle List"
{
    // +--------------------------------------------------------------+
    // | ¸ 2023 incadea Korea                                         |
    // +--------------------------------------------------------------+
    // | PURPOSE: OCR Recog.                                          |
    // +--------------------------------------------------------------+
    // 
    // VERSION  ID      WHO    DATE        DESCRIPTION
    // 231220   KR_0001 KY     2023-12-20  INITIAL RELEASE        
    layout
    {
        addfirst(factboxes)
        {
            part(VehRegCardPicture; VehRegCardPicture)
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Vehicle No." = FIELD("Vehicle No.");
            }
        }
    }
    actions
    {
        addfirst(Catalog)
        {
            action(test)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Message('TIMESTAMP[%1]', DateTimeToUnixTimestamp(System.CurrentDateTime));
                end;
            }
            action("OCR Search")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'OCR Search', KOR = '차량등록증 등록/검색';
                Image = AdministrationSalesPurchases;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    IsSuccess: Boolean;
                begin
                    Message('차량등록증 업로드/실행');
                    IsSuccess := Camera.AddPicture(Rec, Rec.FieldNo("Vehicle Registration Card"));
                    if IsSuccess then begin
                        VehicleG.Copy(Rec);
                        SendOCR.Send_OCR(VehicleG);
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
            action(ExportFile)
            {
                ApplicationArea = All;
                Caption = 'Export Veh.Reg.Card';
                Enabled = DeleteExportEnabled;
                Image = Export;
                ToolTip = 'Export the picture to a file.';

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
                Caption = 'Delete Veh.Reg.Card';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the Veh.Reg.Card.';

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
    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    trigger OnOpenPage()
    begin
        CameraAvailable := Camera.IsAvailable();
    end;

    var
        Camera: Codeunit Camera;
        [InDataSet]
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        VehicleG: Record Vehicle temporary;
        SendOCR: Codeunit "Ext Integration";

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec."Vehicle Registration Card".HasValue;
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
