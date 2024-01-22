pageextension 50002 "PagExt50002.VehicleCheck" extends "VCE Vehicle Check"
{

    actions
    {
        addafter("print")
        {
            action(PrintReportAction)
            {
                Image = Print;
                ApplicationArea = all;
                Promoted = true;
                CaptionML = ENU = 'MK - Vehicle Check Report', KOR = '차량점검보고서';
                trigger OnAction()
                var

                    VehicleCheckPrintL: Report "Vehicle Check Report-MK";
                begin
                    SelectLatestVersion();
                    VehicleCheckPrintL.PrintVeicleCheck(Rec);
                end;


            }
        }
    }







}
