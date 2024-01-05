page 50005 "Appointment List"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Appointment List', KOR = '예약 목록';
    PageType = List;
    SourceTable = "Appointment Header";
    UsageCategory = Lists;
    CardPageId = AppointmentCard;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Appointment Date"; Rec."Appointment Date")
                {
                    ApplicationArea = All;

                }
                field("Appointment Time"; Rec."Appointment Time")
                {
                    ApplicationArea = All;
                }
                field("License No."; Rec."License No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Customer Mobile Phone No."; Rec."Customer Mobile Phone No.")
                {
                    ApplicationArea = All;
                }

                field("Battery Service"; Rec."Battery Service")
                {
                    ApplicationArea = All;
                }
                field("Confirmed Date"; Rec."Confirmed Date")
                {
                    ApplicationArea = All;
                }
                field("Confirmed Time"; Rec."Confirmed Time")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ApplicationArea = All;
                }
                field("Customer Email"; Rec."Customer Email")
                {
                    ApplicationArea = All;
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Request"; Rec."Customer Request")
                {
                    ApplicationArea = All;
                }
                field("Engine Oil Service"; Rec."Engine Oil Service")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }

                field("Make Code"; Rec."Make Code")
                {
                    ApplicationArea = All;
                }
                field("Model No."; Rec."Model No.")
                {
                    ApplicationArea = All;
                }
                field("Model Year"; Rec."Model Year")
                {
                    ApplicationArea = All;
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                }
                field("Receive Date"; Rec."Receive Date")
                {
                    ApplicationArea = All;
                }
                field("Receive Time"; Rec."Receive Time")
                {
                    ApplicationArea = All;
                }
                field("Service Repre Mobile No."; Rec."Service Repre Mobile No.")
                {
                    ApplicationArea = All;
                }
                field("Service Representative"; Rec."Service Representative")
                {
                    ApplicationArea = All;
                }


                field("Tire Service"; Rec."Tire Service")
                {
                    ApplicationArea = All;
                }
                field("Tire Size"; Rec."Tire Size")
                {
                    ApplicationArea = All;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = All;
                }
                field("Vehicle Insp Service"; Rec."Vehicle Insp Service")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
