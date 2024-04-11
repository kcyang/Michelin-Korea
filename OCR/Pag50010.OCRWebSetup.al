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
                Caption = 'OCR Naver API';
                field("Security Key"; Rec."Security Key")
                {
                    CaptionML = ENU = 'Security Key', KOR = '암호키';
                    ApplicationArea = All;
                }
                field("Invoke URL"; Rec."Invoke URL")
                {
                    CaptionML = ENU = 'Invoke URL', KOR = '접속URL';
                    ApplicationArea = All;
                }
            }
            group(PartZone)
            {
                Caption = 'PartZone API';
                field("Partzone Spec Invoke URL"; rec."PZ_Invoke URL")
                {
                    CaptionML = ENU = 'PartZone Spec Invoke URL', KOR = '파트존 사양접속URL';
                    ApplicationArea = All;
                }
                field("Partzone Parts Invoke URL"; rec."PZ_Parts_Invoke URL")
                {
                    CaptionML = ENU = 'PartZone Parts Invoke URL', KOR = '파트존 부품접속URL';
                    ApplicationArea = All;
                }
                field("Partzone Key Code"; rec."PZ_Key Code")
                {
                    CaptionML = ENU = 'PartZone Key Code', KOR = '파트존 키코드';
                    ApplicationArea = All;
                }
            }
            group(Proxy)
            {
                Caption = 'Server Configuration';
                field("Proxy Server URL"; rec."Proxy URL")
                {
                    CaptionML = ENU = 'Proxy URL', KOR = '프록시 서버 URL';
                    ApplicationArea = All;
                }
            }
        }
    }
}
