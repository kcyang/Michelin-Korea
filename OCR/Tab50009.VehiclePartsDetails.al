table 50009 "Vehicle Parts Details"
{
    Caption = 'Vehicle Parts Details';
    DataClassification = CustomerContent;

    fields
    {
        field(1; VIN; Code[20])
        {
            Caption = 'VIN';
        }
        field(2; "Parts ID"; Integer)
        {
            Caption = 'Parts ID';
        }
        field(3; "Category"; Code[10])
        {
            Caption = 'Category';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Attribute Name"; Text[100])
        {
            Caption = 'Attribute Name';
        }
        field(6; "Attribute Value"; Text[250])
        {
            Caption = 'Attribute Value';
        }
    }
    keys
    {
        key(PK; VIN, "Parts ID", "Category", "Line No.")
        {
            Clustered = true;
        }
    }
}
