table 50012 "Vehicle Spec  Information"
{
    Caption = 'Vehicle Spec  Information';
    DataClassification = CustomerContent;

    fields
    {
        field(1; VIN; Code[20])
        {
            Caption = 'VIN';
        }
        field(2; "SpecType"; Enum "Spec Type")
        {
            Caption = 'Type';
        }
        field(3; ID; Integer)
        {
            Caption = 'ID';
        }
        field(4; "Parts ID"; Integer)
        {
            Caption = 'Parts ID';
        }
        field(5; "Attribute Name"; Text[100])
        {
            Caption = 'Attribute Name';
        }
        field(6; "Attribute Value"; Text[100])
        {
            Caption = 'Attribute Value';
        }
        field(7; "Category"; Code[10])
        {
            Caption = 'Category';
        }
    }
    keys
    {
        key(PK; VIN, "SpecType", ID)
        {
            Clustered = true;
        }
    }
}
