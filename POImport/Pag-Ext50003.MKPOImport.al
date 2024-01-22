pageextension 50003 "MK PO Import" extends "Purchase Order"
{
    actions
    {
        addfirst(processing)
        {
            action(POImport)
            {
                CaptionML = ENU = 'Import Easy Order PO', KOR = 'Easy Order PO 불러오기';
                Promoted = true;
                PromotedIsBig = true;
                Image = ImportExcel;
                ApplicationArea = All;
                trigger OnAction()
                var
                    POImport: Report 50003;
                begin
                    POImport.SetServParameter(Rec);
                    POImport.Run();
                end;
            }
        }
    }
}
