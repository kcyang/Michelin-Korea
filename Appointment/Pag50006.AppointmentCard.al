page 50006 AppointmentCard
{

    CaptionML = ENU = 'Appointment Card', KOR = '예약 카드';
    PageType = Card;
    SourceTable = "Appointment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', KOR = '일반';

                field("Appointment Date"; Rec."Appointment Date")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Appointment Date', KOR = '예약 일자';
                }
                field("Appointment Time"; Rec."Appointment Time")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Appointment Time', KOR = '예약 시간';
                }

                field("Confirmed Date"; Rec."Confirmed Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Confirmed Date', KOR = '확정 일자';
                }
                field("Confirmed Time"; Rec."Confirmed Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Confirmed Time', KOR = '확정 시간';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Created By', KOR = '생성자';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Creation Date', KOR = '생성 일자';
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Creation Time', KOR = '생성 시간';
                }
                field("Customer Email"; Rec."Customer Email")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Customer Email', KOR = '고객 이메일';
                }
                field("Customer Mobile Phone No."; Rec."Customer Mobile Phone No.")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Customer Mobile Phone No.', KOR = '고객 핸드폰번호';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Customer Name', KOR = '고객명';
                }

                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'External Document No.', KOR = '외부 문서 번호';
                }

                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    CaptionML = ENU = 'Notes', KOR = '메모';
                }
                field("Receive Date"; Rec."Receive Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Receive Date', KOR = '입고 일자';
                }
                field("Receive Time"; Rec."Receive Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Receive Time', KOR = '입고 시간';
                }
                field("Service Repre Mobile No."; Rec."Service Repre Mobile No.")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Servie Representative Mobile No.', KOR = '서비스 대리인 연락처';
                }
                field("Service Representative"; Rec."Service Representative")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Service Representative', KOR = '서비스 대리인';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Status', KOR = '예약 상태';
                    Editable = false;
                }




            }
            group("Request Details")
            {
                CaptionML = ENU = 'Request Details', KOR = '예약 상세';

                field("Tire Service"; Rec."Tire Service")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Tire Service', KOR = '타이어 서비스';
                }
                field("Battery Service"; Rec."Battery Service")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Battery Service', KOR = '베터리 서비스';
                }
                field("Vehicle Insp Service"; Rec."Vehicle Insp Service")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Vehicle Insp Service', KOR = '차량 점검 서비스';
                }

                field("Engine Oil Service"; Rec."Engine Oil Service")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Engine Oil Service', KOR = '엔진오일 서비스';
                }
                field("Tire Size"; Rec."Tire Size")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Tire Size', KOR = '타이어 사이즈';
                }
                field("Customer Request"; Rec."Customer Request")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    CaptionML = ENU = 'Customer Request', KOR = '고객요청 사항';
                }
            }
            group("Vehicle Information")
            {
                CaptionML = ENU = 'Vehicle Information', KOR = '차량 정보';
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = All;

                }
                field("License No."; Rec."License No.")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'License No.', KOR = '차량 번호';
                }
                field("Make Code"; Rec."Make Code")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Make Code', KOR = '브랜드';
                }
                field("Model No."; Rec."Model No.")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Model No.', KOR = '모델 번호';
                }
                field("Model Year"; Rec."Model Year")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Model Year', KOR = '연도';
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("Handle")
            {
                action("ContactSearch")
                {
                    CaptionML = ENU = 'Vehicle Search', KOR = '차량 검색';
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = FindCreditMemo;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ContactSearchResultsL: Page "Contact Search Results";
                    begin
                        ContactSearchResultsL.SetSearchNameStringEntered(Rec."License No.");
                        ContactSearchResultsL.Run;
                    end;

                }
                action("Confirm")
                {
                    CaptionML = ENU = 'Confirm', KOR = '예약 확정';
                    Promoted = true;
                    PromotedIsBig = true;

                    Image = Confirm;
                    ApplicationArea = All;
                    trigger OnAction()

                    begin
                        IF rec.Status = rec.Status::new THEN BEGIN
                            ConfirmCust := DIALOG.CONFIRM(CustConfirm);
                            IF ConfirmCust = TRUE THEN BEGIN
                                rec."Confirmed Date" := TODAY;
                                rec."Confirmed Time" := TIME;
                                rec.Status := rec.Status::confirmed;
                                rec.MODIFY;
                            END ELSE BEGIN
                                EXIT;
                            END;
                        END;

                    end;
                }
                action("Decline")
                {
                    CaptionML = ENU = 'Decline', KOR = '예약 취소';
                    Promoted = true;
                    PromotedIsBig = true;

                    Image = Reject;
                    ApplicationArea = All;
                    trigger OnAction()

                    begin
                        IF rec.Status = rec.Status::new THEN BEGIN
                            DeclineCust := DIALOG.CONFIRM(CustDecline);
                            IF DeclineCust = TRUE THEN BEGIN
                                rec.Status := rec.Status::declined;
                                rec.MODIFY;
                            END ELSE BEGIN
                                EXIT;
                            END;
                        END;

                    END;


                }
                action("Receive")
                {
                    CaptionML = ENU = 'Receive', KOR = '차량 입고';
                    Promoted = true;
                    PromotedIsBig = true;


                    ApplicationArea = All;
                    trigger OnAction()

                    begin
                        ReceiveCust := DIALOG.CONFIRM(ReceiveCusttx);
                        IF ReceiveCust = TRUE THEN BEGIN
                            rec.Status := rec.Status::"receive";
                            rec."Receive Date" := TODAY;
                            rec."Receive Time" := TIME;
                            rec.MODIFY;
                        END ELSE BEGIN
                            EXIT;
                        END;

                    END;


                }
            }
        }

    }
    var
        ConfirmCust: Boolean;
        DeclineCust: Boolean;
        ReceiveCust: Boolean;
        CustConfirm: TextConst ENU = 'Do you wish to change the appointment status to be confirmed?', KOR = '고객으로부터 예약확정을 확인하였으며 해당 예약건에 대한 확정을 진행하시겠습니까?';
        CustDecline: TextConst ENU = 'Do you wish to change the appointment status to be declined?', KOR = '예약 취소를 하시겠습니까?';
        ReceiveCusttx: TextConst ENU = 'Do you confirm the customer has visited at the dealership?', KOR = '차량 입고 등록을 하시겠습니까?';
}







