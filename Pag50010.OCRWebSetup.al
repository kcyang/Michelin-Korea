page 50010 OCRWebSetup
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
    PageType = Card;
    SourceTable = OCRWebSetup;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
            }
        }
    }
}
