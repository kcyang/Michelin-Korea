pageextension 50001 "Michelin Korea RC" extends "BSS Front Office RC"
{
    actions
    {
        addlast("Day End")
        {
            action(MK)
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Michelin KR Daily Sales Register', KOR = '판매마감 보고서';
                RunObject = report "Daily Sales Register-MK";
                Image = PrintReport;
            }
        }
        addlast("Master Data")
        {
            action("Web Services Setup")
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Web Service Setup', KOR = '웹서비스 설정';
                RunObject = page OCRWebSetup;
                Image = CoupledUnitOfMeasure;
            }
        }
    }
}
