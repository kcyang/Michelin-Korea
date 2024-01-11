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
            action("OCR Search")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'OCR Search', KOR = '차량등록증 등록/검색';
                Image = AdministrationSalesPurchases;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Message('차량등록증 업로드/실행');
                end;
            }

        }

    }

    var
        TempVehicle: Record Vehicle temporary;
}
