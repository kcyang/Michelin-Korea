page 50011 "OCR Log List"
{
    ApplicationArea = All;
    Caption = 'OCR Log List';
    PageType = List;
    SourceTable = OCRLog;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle No. field.';
                }
                field(SendDateTime; Rec.SendDateTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SendDateTime field.';
                }
                field(SendText; Rec.SendText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SendText field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(RecvDateTime; Rec.RecvDateTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RecvDateTime field.';
                }
                field(RecvText; Rec.RecvText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RecvText field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowSendText)
            {
                ApplicationArea = All;
                Caption = '보낸메시지 보기';
                Image = ShowList;

                trigger OnAction()
                var
                    IStream: InStream;
                    SendTextL: Text;
                begin
                    if Rec.SendText.HasValue then begin
                        Rec.SendText.CreateInStream(IStream);
                        IStream.ReadText(SendTextL);
                        Message('%1', SendTextL);
                    end;
                end;

            }
            action(ShowRecvText)
            {
                ApplicationArea = All;
                Caption = '받은메시지 보기';
                Image = ShowList;

                trigger OnAction()
                var
                    IStream: InStream;
                    RecvTextL: Text;
                begin
                    if Rec.RecvText.HasValue then begin
                        Rec.RecvText.CreateInStream(IStream);
                        IStream.ReadText(RecvTextL);
                        Message('%1', RecvTextL);
                    end;
                end;

            }
        }
    }
}
