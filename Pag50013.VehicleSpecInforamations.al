page 50013 "Vehicle Spec Inforamations"
{
    ApplicationArea = All;
    Caption = 'Vehicle Spec Inforamations';
    PageType = List;
    SourceTable = "Vehicle Spec  Information";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Attribute Name"; Rec."Attribute Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Attribute Name field.';
                }
                field("Attribute Value"; Rec."Attribute Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Attribute Value field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
            }
        }
    }
}
