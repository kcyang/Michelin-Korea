page 50012 "OCR Vehicle InformationConfirm"
{
    Caption = 'OCR Vehicle InformationConfirm';
    PageType = Card;
    SourceTable = Vehicle;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'Vehicle Information', KOR = '차량정보';

                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle No. field.';
                }
                field("Vehicle Identification No."; Rec."Vehicle Identification No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle Identification No. field.';
                }
                field("Licence-Plate No."; Rec."Licence-Plate No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Licence-Plate No. field.';
                }
                field("National Code"; Rec."National Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the National Code field.';
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registration Date field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendPZ)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'PartZone Search', KOR = '파트존 검색';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ServicePriceAdjustment;

                trigger OnAction()
                var
                    extint: Codeunit "Ext Integration";
                begin
                    extint.Send_PZ(Rec);
                end;
            }
        }
    }
}
