page 50012 "OCR Vehicle InformationConfirm"
{
    Caption = 'OCR Vehicle InformationConfirm';
    PageType = Card;
    SourceTable = Vehicle;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'Vehicle Information', KOR = '차량정보';

                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle No. field.';
                }
                field("Vehicle Identification No."; Rec."Vehicle Identification No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle Identification No. field.';
                }
                field("Licence-Plate No."; Rec."Licence-Plate No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Licence-Plate No. field.';
                }
                field("National Code"; Rec."National Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the National Code field.';
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registration Date field.';
                }
            }
            group(Spec)
            {
                CaptionML = ENU = 'Vehicle Spec Information', KOR = '차량 사양 정보';
                field("Vehicle Manufacturer"; Rec."Vehicle Manufacturer")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Model"; Rec."Vehicle Model")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Variant"; Rec."Vehicle Variant")
                {
                    ApplicationArea = All;
                }
                field("Body Type"; Rec."Body Type")
                {
                    ApplicationArea = All;
                }
                field("Engine No. (Type)"; Rec."Engine No. (Type)")
                {
                    ApplicationArea = All;
                }
                field(Fuel; Rec.Fuel)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendPZ)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'PartZone Search', KOR = '파트존 사양검색';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ServicePriceAdjustment;

                trigger OnAction()
                var
                    extint: Codeunit "Ext Integration";
                begin
                    extint.Send_PZ(Rec);
                    CurrPage.Update();
                end;
            }
            action(SendPZDetails)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'PartZone Parts Search', KOR = '파트존 부품상세 검색';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ItemLedger;

                trigger OnAction()
                var
                    extint: Codeunit "Ext Integration";
                begin
                    extint.Send_PZ_Detail(Rec);
                    CurrPage.Update();
                end;
            }
            action(ShowPZ)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'View Spec Information', KOR = '파트존 결과보기';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ServicePriceAdjustment;

                trigger OnAction()
                var
                    specPage: page "Vehicle Spec Inforamations";
                    specInforRecL: Record "Vehicle Spec  Information";
                    specTypeL: Enum "Spec Type";
                begin
                    specInforRecL.Reset();
                    specInforRecL.SetRange(VIN, Rec."Vehicle Identification No.");
                    specInforRecL.SetFilter(SpecType, '%1|%2', specTypeL::Spec, specTypeL::Part);
                    if specInforRecL.FindSet() then begin
                        specPage.SetTableView(specInforRecL);
                        specPage.Run();
                    end else begin
                        Message('해당 차량에 대한 부품정보가 없습니다. 먼저 부품조회를 해주세요.!');
                    end;
                end;
            }
        }
    }

    procedure setVehicleRecord(VehicleP: Record Vehicle temporary)
    begin
        Rec := VehicleP;
    end;

    procedure getVehicleRecord(var VehicleP: Record Vehicle)
    begin
        VehicleP := Rec;
    end;
}
