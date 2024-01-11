page 50099 VehRegCardPicture
{
    Caption = 'VehRegCardPicture';
    PageType = CardPart;
    SourceTable = Vehicle;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Vehicle Registration Card"; Rec."Vehicle Registration Card")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle Registration Card field.';
                }
            }
        }
    }
}
