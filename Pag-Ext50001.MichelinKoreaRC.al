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
        addlast("New Sales Documents")
        {
            action(Appointment)
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Appointment List', KOR = '예약 목록';
                RunObject = page "Appointment List";
                Image = PrintReport;
            }
        }
    }
}
