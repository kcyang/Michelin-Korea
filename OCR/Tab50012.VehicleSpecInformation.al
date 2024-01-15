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
        field(2; "Type"; Option)
        {
            Caption = 'Type';
            OptionCaptionML = ENU = 'Spec,Part,Detail', KOR = '사양,부품,부품정보';
            OptionMembers = Spec,Part;
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
    }
    keys
    {
        key(PK; VIN, "Type", ID)
        {
            Clustered = true;
        }
    }
}
