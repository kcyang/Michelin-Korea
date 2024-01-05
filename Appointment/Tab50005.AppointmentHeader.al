table 50005 "Appointment Header"
{
    Caption = 'Appointment Header';
    DataClassification = ToBeClassified;





    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Appointment Date"; Date)
        {
            CaptionML = ENU = 'Appointment Date', KOR = '예약 일자';
        }
        field(3; "Appointment Time"; Time)
        {
            CaptionML = ENU = 'Appointment Time', KOR = '예약 시간';
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(5; "Customer Name"; Text[50])
        {
            CaptionML = ENU = 'Customer Name', KOR = '고객명';
        }
        field(6; "Customer Mobile Phone No."; Text[30])
        {
            CaptionML = ENU = 'Customer Mobile Phone No.', KOR = '고객 핸드폰번호';
        }
        field(7; "Customer Email"; Text[100])
        {
            CaptionML = ENU = 'Customer Email', KOR = '고객 이메일';
        }
        field(8; "Customer Request"; Text[1024])
        {
            CaptionML = ENU = 'Customer Request', KOR = '고객요청 사항';
        }
        field(9; Notes; Text[1024])
        {
            CaptionML = ENU = 'Notes', KOR = '메모';
        }
        field(10; "Service Representative"; Text[30])
        {

            CaptionML = ENU = 'Service Representative', KOR = '서비스 대리인';
        }
        field(11; "Service Repre Mobile No."; Text[30])
        {
            CaptionML = ENU = 'Servie Representative Mobile No.', KOR = '서비스 대리인 연락처';
        }
        field(12; "License No."; Code[11])
        {
            CaptionML = ENU = 'License No.', KOR = '차량 번호';
        }
        field(13; "Model Year"; Text[30])
        {
            CaptionML = ENU = 'Model Year', KOR = '연도';
        }
        field(14; "Make Code"; Code[20])
        {
            CaptionML = ENU = 'Make Code', KOR = '브랜드';
        }
        field(15; "Model No."; Code[20])
        {
            CaptionML = ENU = 'Model No.', KOR = '모델 번호';
        }
        field(16; "Tire Size"; Text[100])
        {
            CaptionML = ENU = 'Tire Size', KOR = '타이어 사이즈';
        }
        field(17; VIN; Code[20])
        {
            Caption = 'VIN';
        }
        field(18; "Tire Service"; Boolean)
        {
            CaptionML = ENU = 'Tire Service', KOR = '타이어 서비스';
        }
        field(19; "Engine Oil Service"; Boolean)
        {
            CaptionML = ENU = 'Engine Oil Service', KOR = '엔진오일 서비스';
        }
        field(20; "Battery Service"; Boolean)
        {
            CaptionML = ENU = 'Battery Service', KOR = '베터리 서비스';
        }
        field(21; "Vehicle Insp Service"; Boolean)
        {
            CaptionML = ENU = 'Vehicle Insp Service', KOR = '차량 점검 서비스';
        }
        field(22; "Creation Date"; Date)
        {
            CaptionML = ENU = 'Creation Date', KOR = '생성 일자';
        }
        field(23; "Creation Time"; Time)
        {
            CaptionML = ENU = 'Creation Time', KOR = '생성 시간';
        }
        field(24; "Created By"; Code[50])
        {
            CaptionML = ENU = 'Created By', KOR = '생성자';
        }
        field(25; Status; Option)
        {
            CaptionML = ENU = 'Status', KOR = '예약 상태';
            OptionMembers = new,confirmed,declined,Receive;
            OptionCaptionML = ENU = 'NEW, CONFIRMED, DECLINED, Receive', KOR = '신규,고객확정,고객취소(부도),고객방문';
        }
        field(26; "Confirmed Date"; Date)
        {
            CaptionML = ENU = 'Confirmed Date', KOR = '확정 일자';
        }
        field(27; "Confirmed Time"; Time)
        {
            CaptionML = ENU = 'Confirmed Time', KOR = '확정 시간';
        }
        field(28; "External Document No."; Code[35])
        {
            CaptionML = ENU = 'External Document No.', KOR = '외부 문서 번호';
        }
        field(29; "Receive Date"; Date)
        {
            CaptionML = ENU = 'Receive Date', KOR = '입고 일자';
        }
        field(30; "Receive Time"; Time)
        {
            CaptionML = ENU = 'Receive Time', KOR = '입고 시간';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        ApptHdr: Record "Appointment Header";
    begin

        ApptHdr.RESET;
        IF ApptHdr.FINDLAST THEN
            rec."Entry No." := ApptHdr."Entry No." + 1
        ELSE
            rec."Entry No." := 1;
        rec."Created By" := USERID;
        rec."Creation Date" := TODAY;
        rec."Creation Time" := TIME;
        rec.Status := rec.Status::new;

    end;
}
