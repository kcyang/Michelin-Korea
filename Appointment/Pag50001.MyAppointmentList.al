page 50007 "My Appointment List"
{
    CaptionML = ENU = 'Today Appointment List', KOR = '당일 예약목록';
    CardPageId = "AppointmentCard";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = false;
    PageType = ListPart;
    SourceTable = "Appointment Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Appointment Date"; Rec."Appointment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Appointment Date field.';
                }
                field("Appointment Time"; Rec."Appointment Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Appointment Time field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Customer Mobile Phone No."; Rec."Customer Mobile Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Mobile Phone No. field.';
                }
                field("License No."; Rec."License No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the License No. field.';
                }
                field("Model No."; Rec."Model No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Model No. field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Open Company Message")
            {
                CaptionML = ENU = 'Open Appointment', KOR = '예약 열기';
                Image = CarryOutActionMessage;
                RunObject = Page "AppointmentCard";
                RunPageLink = "Entry No." = FIELD("Entry No.");
                Scope = Repeater;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Rec."Appointment Date", '%1', WorkDate());
        Rec.SetFilter(Rec.Status, '<>%1', Rec.Status::new); //It donesn't need to see the 'new' status code.
    end;
}
