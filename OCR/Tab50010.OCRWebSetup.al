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
        field(4; "PZ_Invoke URL"; Text[250])
        {
            Caption = 'PartZone Spec Invoke URL';
            DataClassification = ToBeClassified;
        }
        field(5; "PZ_Key Code"; Text[250])
        {
            Caption = 'PartZone Key Code';
            DataClassification = ToBeClassified;
        }
        field(6; "PZ_Parts_Invoke URL"; Text[250])
        {
            Caption = 'PartZone Parts Invoke URL';
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
}
