page 50013 "Vehicle Spec Inforamations"
{
    ApplicationArea = All;
    Caption = 'Vehicle Spec Inforamations';
    PageType = List;
    SourceTable = "Vehicle Spec  Information";
    UsageCategory = Lists;
    Editable = false;

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
                field("Category"; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field("Type"; Rec."SpecType")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
            }

            group(subpartdetail)
            {
                part(SubLink; "Part Detail List")
                {
                    SubPageLink = VIN = field(VIN), "Parts ID" = field("Parts ID"), Category = field(Category);
                }
            }
        }
    }
}
