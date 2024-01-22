page 50014 "Part Detail List"
{
    Caption = 'Part Detail List';
    PageType = ListPart;
    SourceTable = "Vehicle Parts Details";
    //SourceTableView = 
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Parts ID"; Rec."Parts ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Parts ID field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category field.';
                }
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
            }
        }
    }
}
