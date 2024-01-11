table 50011 OCRLog
{
    Caption = 'OCRLog';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Vehicle No."; Code[20])
        {
            Caption = 'Vehicle No.';
        }
        field(2; SendDateTime; DateTime)
        {
            Caption = 'SendDateTime';
        }
        field(3; SendText; Blob)
        {
            Caption = 'SendText';
        }
        field(4; RecvDateTime; DateTime)
        {
            Caption = 'RecvDateTime';
        }
        field(5; RecvText; Blob)
        {
            Caption = 'RecvText';
        }
        field(6; Status; Text[50])
        {
            Caption = 'Status';
        }
    }
    keys
    {
        key(PK; "Vehicle No.", SendDateTime)
        {
            Clustered = true;
        }
    }
}
