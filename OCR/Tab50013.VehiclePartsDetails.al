table 50013 "Vehicle Parts Details"
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
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Attribute Name"; Text[100])
        {
            Caption = 'Attribute Name';
        }
        field(5; "Attribute Value"; Text[250])
        {
            Caption = 'Attribute Value';
        }
    }
    keys
    {
        key(PK; VIN, "Parts ID", "Line No.")
        {
            Clustered = true;
        }
    }
}
