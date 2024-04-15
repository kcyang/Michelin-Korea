pageextension 50021 MKValueEntries extends "Value Entries"
{
    layout
    {

        addafter("No.")
        {
            field("Your Reference"; rec."Your Reference")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Your Reference', KOR = '미쉐린 멤버쉽 번호';
            }
            field("Manufacturer Code"; rec."Manufacturer Code")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Manufacturer Code', KOR = '제조사 코드';
            }
        }


    }
}
