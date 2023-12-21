table 50010 OCRWebSetup
{
    // +--------------------------------------------------------------+
    // | ¸ 2023 incadea Korea                                         |
    // +--------------------------------------------------------------+
    // | PURPOSE: Setup for OCR Recog.                                |
    // +--------------------------------------------------------------+
    // 
    // VERSION  ID      WHO    DATE        DESCRIPTION
    // 231220   KR_0001 KY     2023-12-20  INITIAL RELEASE    
    Caption = 'OCRWebSetup';
    DataClassification = ToBeClassified;
    Extensible = true;

    fields
    {
        field(1; "No."; Code[10])
        {
            Caption = 'No.';
        }
        field(2; "Security Key"; Text[50])
        {
            Caption = 'Security Key';
            DataClassification = ToBeClassified;
        }
        field(3; "Invoke URL"; Text[250])
        {
            Caption = 'Invoke URL';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    [Scope('OnPrem')]
    procedure GetOCRNamespace(): Text
    begin

        exit('http://server.cat.tecdoc.net')

    end;
}
