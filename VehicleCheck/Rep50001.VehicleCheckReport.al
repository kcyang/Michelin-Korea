report 50001 "Vehicle Check Report-MK"
{
    ApplicationArea = All;
    Caption = 'Vehicle Check Report-MK';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './VehicleCheck/Rep.VehicleCheckReport.rdl';

    dataset
    {
        dataitem(VehicleCheck; "Vehicle Check")
        {
            DataItemTableView = sorting("Document Type", "Document No.", Code);
            column(VehicleCheckInfoHeader_No; "Document No.") { }
            dataitem(HeaderData; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(CompanyInfoPicture; CompanyInfoG.Picture) { }
                column(VehicleCheckInfoHeader_Comment; VehicleCheck.Comments) { }
                column(LogoHeader; LogoHeaderG) { }
                column(LogoText_1; LogoTextG[1]) { }
                column(LogoText_2; LogoTextG[2]) { }
                column(LogoText_3; LogoTextG[3]) { }
                column(LogoText_4; LogoTextG[4]) { }
                column(DocumentHeaderText; DocumentHeaderTextG) { }
                column(NameCaption; NameCaptionG) { }
                column(DocumentNo; DocumentNoG) { }
                column(CheckTemplateName; CheckTemplateNameG) { }
                column(ShowReplaceNotes; ShowReplaceNotesG) { }
                column(ShowAttentionNotes; ShowAttentionNotesG) { }
                column(PrintColor; PrintColorG) { }
                column(Color_Replace; Color_Replace) { }
                column(Color_Attention; Color_Attention) { }
                column(Color_New; Color_New) { }
                column(Color_OK; Color_OK) { }
                column(CustomerData_1; CustomerDataG[1]) { }
                column(CustomerData_2; CustomerDataG[2]) { }
                column(CustomerData_3; CustomerDataG[3]) { }
                column(CustomerData_4; CustomerDataG[4]) { }
                column(DocumentData_1; DocumentDataG[1]) { }
                column(DocumentData_2; DocumentDataG[2]) { }
                column(DocumentData_3; DocumentDataG[3]) { }
                column(DocumentData_4; DocumentDataG[4]) { }
                column(DocumentData_5; DocumentDataG[5]) { }
                column(C_BSS_TXT000; C_BSS_TXT000) { }
                column(C_BSS_TXT002; C_BSS_TXT002) { }
                column(C_BSS_TXT003; C_BSS_TXT003) { }
                column(C_BSS_TXT004; C_BSS_TXT004) { }
                column(C_BSS_TXT006; C_BSS_TXT006) { }
                column(C_BSS_TXT007; C_BSS_TXT007) { }
                column(C_BSS_TXT008; C_BSS_TXT008) { }
                column(C_BSS_TXT009; C_BSS_TXT009) { }
                column(C_BSS_TXT010; C_BSS_TXT010) { }
                column(C_BSS_TXT011; C_BSS_TXT011) { }
                column(C_BSS_TXT012; C_BSS_TXT012) { }
                column(C_BSS_TXT013; C_BSS_TXT013) { }
                column(C_BSS_TXT014; C_BSS_TXT014) { }
                column(C_BSS_TXT015; C_BSS_TXT015) { }
                column(C_BSS_TXT016; C_BSS_TXT016) { }
                column(Lbl_TXT001; Lbl_TXT001) { }
                column(Lbl_TXT002; Lbl_TXT002) { }
                column(Lbl_TXT003; Lbl_TXT003) { }
                column(Lbl_TXT004; Lbl_TXT004) { }
                column(Lbl_TXT005; Lbl_TXT005) { }
                column(Lbl_TXT006; Lbl_TXT006) { }
                column(Lbl_TXT007; Lbl_TXT007) { }
                column(Lbl_TXT008; Lbl_TXT008) { }
                column(Lbl_TXT009; Lbl_TXT009) { }
                column(Lbl_TXT010; Lbl_TXT010) { }
                //HeaderData
                trigger OnPreDataItem()
                var
                    ServCenterL: Record "Service Center";
                    ReportSettingL: Record "Report Extended Settings";
                    SalesHeaderL: Record "Sales Header";
                    SalesInvHeaderL: Record "Sales Invoice Header";
                    GenFuncL: Codeunit "General Functions";
                    ReportExtTextFunL: Codeunit "Report Ext. Text Functions";
                    FormatAddressL: Codeunit "Format Address";
                    ServiceCenterCodeL: Code[30];
                    DisplayHeaderL: Boolean;
                begin
                    Clear(SalesHeaderL);
                    Clear(SalesInvHeaderL);
                    case VehicleCheck."Document Type" of
                        VehicleCheck."Document Type"::Order,
                        VehicleCheck."Document Type"::Quote,
                        VehicleCheck."Document Type"::ShoppingBasket:
                            begin
                                if SalesHeaderL.Get(VehicleCheck."Document Type", VehicleCheck."Document No.") then begin
                                    ServiceCenterCodeL := SalesHeaderL."Service Center";
                                    FormatAddressL.SalesHeaderSellTo(CustomerDataG, SalesHeaderL);
                                    GetSalesDocData(SalesHeaderL);
                                end else begin
                                    Clear(SalesInvHeaderL);
                                    SalesInvHeaderL.Reset();
                                    SalesInvHeaderL.SetRange("Order No.", VehicleCheck."Document No.");
                                    if SalesInvHeaderL.FindLast() then;
                                    ServiceCenterCodeL := SalesInvHeaderL."Service Center";
                                    FormatAddressL.SalesInvSellTo(CustomerDataG, SalesInvHeaderL);
                                    GetSalesInvDocData(SalesInvHeaderL);
                                end;
                            end;
                        2:
                            begin
                                if SalesInvHeaderL.Get(VehicleCheck."Document No.") then;
                                ServiceCenterCodeL := SalesInvHeaderL."Service Center";
                                FormatAddressL.SalesInvSellTo(CustomerDataG, SalesInvHeaderL);
                                GetSalesInvDocData(SalesInvHeaderL);
                            end;
                    end;

                    LogoHeaderG := '';
                    DocumentHeaderTextG := '';
                    CLEAR(FooterTextG);
                    CLEAR(LogoTextG);

                    DisplayHeaderL := not ReportSettingL.IsPreprintedFormUsed(Report::"Vehicle Check Report", GenFuncL.GetSCCode());

                    if DisplayHeaderL then begin
                        ReportExtTextFunL.GetHeaderText('PAGE_HEADER_HEAD', 'PAGE_HEADER_TEXT',
                           ServiceCenterCodeL, CurrReport.LANGUAGE, LogoHeaderG, LogoTextG);
                        ReportExtTextFunL.GetFooterText('PAGE_FOOTER_TEXT',
                          ServiceCenterCodeL, CurrReport.LANGUAGE, FooterTextG);
                        CompanyInfoG.CALCFIELDS(Picture);
                        IF ServCenterL.GET(ServiceCenterCodeL) then
                            DocumentHeaderTextG := ServCenterL."Document Header Text";
                    end
                    else
                        CompanyInfoG.GET;
                end;

                trigger OnAfterGetRecord()
                begin
                end;

                trigger OnPostDataItem()
                begin
                end;
            }
            dataitem(VHCILItem; "Vehicle Check Checkpoint")
            {
                DataItemTableView = sorting("Document Type", "Document No.", Code, "Category No.", "No.");
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), Code = field(Code);
                column(VHCILItem_Type; LineTypeG) { }
                column(VHCILItem_Description; VHCILItem."Description 2") { }
                column(VHCILItem_Replace; Replace) { }
                column(VHCILItem_Attention; VHCILItem.Attention) { }
                column(VHCILItem_OK; VHCILItem.Ok) { }
                column(VHCILItem_New; VHCILItem.New) { }
                column(VHCILItem_Comment; VHCILItem.Comment) { }
                column(VHCILItem_TyreStatus; TyreStatusG) { }
                column(VHCILItem_CheckNotes; CheckNotesG) { }
                column(VHCILItem_Recommandation; CheckRecommandationG) { }
                column(VHCILItem_ReplaceValue; ReplaceValueG) { }
                column(VHCILItem_AttentionValue; AttentionValueG) { }
                column(VHCILItem_OkValue; OkValueG) { }
                column(VHCILItem_NewValue; NewValueG) { }
                column(SummaryNotesReplaceTxt; ReplaceNotesG) { }
                column(SummaryNotesAttentionTxt; AttentionNotesG) { }

                trigger OnPreDataItem()
                begin
                end;

                trigger OnAfterGetRecord()
                var
                    VehicleCheckFindingTypeL: Record "Vehicle Check Finding Type";
                    VehicleCheckSolutionL: Record "Vehicle Check Solution";
                    ValueL: Decimal;
                begin
                    //Line Type
                    case "Checkpoint Type" of
                        "Checkpoint Type"::" ":
                            LineTypeG := LineTypeG::" ";
                        "Checkpoint Type"::Tyre:
                            LineTypeG := LineTypeG::Item;
                        else
                            LineTypeG := LineTypeG::Service;
                    end;

                    //TyreStatus
                    // if VHCILItem."Exact Status" = 0 then
                    //     TyreStatusG := ''
                    // else
                    //     TyreStatusG := Format(VHCILItem."Exact Status");
                    TyreStatusG := '';
                    ValueL := VHCILItem."Exact Status";
                    if VHCILItem."Checkpoint Type" in [VHCILItem."Checkpoint Type"::Tyre, VHCILItem."Checkpoint Type"::"Brake Pads"] then
                        TyreStatusG := Format(ValueL, 0, 9);
                    if VHCILItem."Exact Status" = 0 then
                        TyreStatusG := '';



                    //MK CUSTOMIZATION
                    if VHCILItem."Checkpoint Type" = VHCILItem."Checkpoint Type"::Tyre then begin
                        if (ValueL = 2) or (ValueL = 3) or (ValueL = 4) then
                            AttentionValueG := '√'
                        else
                            AttentionValueG := '';
                        if VHCILItem.New = true then
                            OkValueG := '√'
                        else
                            OkValueG := '';
                    end;

                    //Notes
                    ReplaceNotesG := '';
                    AttentionNotesG := '';
                    CheckNotesG := '';
                    CheckRecommandationG := '';

                    VehicleCheckFindingTypeL.Reset();
                    VehicleCheckFindingTypeL.SetRange("Document Type", VHCILItem."Document Type");
                    VehicleCheckFindingTypeL.SetRange("Document No.", VHCILItem."Document No.");
                    VehicleCheckFindingTypeL.SetRange(Code, VHCILItem.Code);
                    VehicleCheckFindingTypeL.SetRange("Category No.", VHCILItem."Category No.");
                    VehicleCheckFindingTypeL.SetRange("Checkpoint No.", VHCILItem."No.");
                    VehicleCheckFindingTypeL.SetRange("Is Default", false);
                    VehicleCheckFindingTypeL.SetRange(Select, true);
                    if VehicleCheckFindingTypeL.FindSet() then
                        repeat
                            CheckNotesG := CheckNotesG + ' ' + VehicleCheckFindingTypeL.Description;
                        until VehicleCheckFindingTypeL.Next() = 0;

                    VehicleCheckSolutionL.Reset();
                    VehicleCheckSolutionL.SetRange("Document Type", VHCILItem."Document Type");
                    VehicleCheckSolutionL.SetRange("Document No.", VHCILItem."Document No.");
                    VehicleCheckSolutionL.SetRange(Code, VHCILItem.Code);
                    VehicleCheckSolutionL.SetRange("Category No.", VHCILItem."Category No.");
                    VehicleCheckSolutionL.SetRange("Checkpoint No.", VHCILItem."No.");
                    VehicleCheckSolutionL.SetRange("Finding Type No.", 0);
                    VehicleCheckSolutionL.SetRange("Is Default", false);
                    VehicleCheckSolutionL.SetRange(Select, true);
                    if VehicleCheckSolutionL.FindSet() then begin
                        if VHCILItem.Replace then
                            ReplaceNotesG := VHCILItem."Description 2" + ': ';
                        if VHCILItem.Attention then
                            AttentionNotesG := VHCILItem."Description 2" + ': ';
                        repeat
                            CheckRecommandationG := CheckRecommandationG + ' ' + VehicleCheckSolutionL.Description;
                            if VHCILItem.Replace then
                                ReplaceNotesG := ReplaceNotesG + ' ' + VehicleCheckSolutionL.Description;
                            if VHCILItem.Attention then
                                AttentionNotesG := AttentionNotesG + ' ' + VehicleCheckSolutionL.Description;
                        until VehicleCheckSolutionL.Next() = 0;
                    end;

                    if VHCILItem.Replace then
                        ReplaceValueG := '√'
                    else
                        ReplaceValueG := '';

                    if VHCILItem.Attention then
                        AttentionValueG := '√'
                    else
                        AttentionValueG := '';

                    if VHCILItem.OK then
                        OkValueG := '√'
                    else
                        OkValueG := '';

                    if VHCILItem.New then
                        NewValueG := '√'
                    else
                        NewValueG := '';

                    // if not VehicleCheck."Attention Visible" then
                    //     AttentionValueG := '';
                    // if not VehicleCheck."OK Visible" then
                    //     OkValueG := '';
                    // if not VehicleCheck."New Visible" then
                    //     NewValueG := '';
                end;

                trigger OnPostDataItem()
                begin
                end;
            }
            dataitem(NewPage; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                trigger OnAfterGetRecord()
                begin
                end;
            }
            trigger OnAfterGetRecord() //Vehicle Check
            begin
                DocumentNoG := VehicleCheck."Document No.";
                CheckTemplateNameG := VehicleCheck.Description;
                if VehicleCheck.Posted and (VehicleCheck."Posted Document No." <> '') then
                    DocumentNoG := VehicleCheck."Posted Document No.";
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Option)
                {
                    ShowCaption = false;
                    Caption = 'Option';
                    field(ShowReplaceNotes; ShowReplaceNotesG)
                    {
                        Caption = 'ShowReplaceNotes';
                    }
                    field(ShowAttentionNotes; ShowAttentionNotesG)
                    {
                        Caption = 'ShowAttentionNotes';
                    }
                    field(PrintColor; PrintColorG)
                    {
                        Caption = 'PrintColor';
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        ShowAttentionNotesG := true;
        ShowReplaceNotesG := true;
        PrintColorG := true;
    end;

    trigger OnPreReport()
    begin
        FastfitSetupAppG.Get();
    end;

    trigger OnPostReport()
    begin

    end;

    local procedure GetSalesDocData(SalesHeaderP: Record "Sales Header")
    begin
        DocumentDataG[1] := FORMAT(SalesHeaderP."Posting Date");
        DocumentDataG[2] := SalesHeaderP."Sell-to Customer No.";
        if SalesHeaderP."Sell-to Contact" <> '' then begin
            DocumentDataG[3] := SalesHeaderP."Sell-to Contact";
            NameCaptionG := C_BSS_TXT005;
        end else begin
            DocumentDataG[3] := SalesHeaderP."Sell-to Customer Name";
            NameCaptionG := C_BSS_TXT015;
        end;
        DocumentDataG[4] := SalesHeaderP."Vehicle No.";
        DocumentDataG[5] := SalesHeaderP."Licence-Plate No.";
    end;

    local procedure GetSalesInvDocData(SalesInvHeaderP: Record "Sales Invoice Header")
    begin
        DocumentDataG[1] := FORMAT(SalesInvHeaderP."Posting Date");
        DocumentDataG[2] := SalesInvHeaderP."Sell-to Customer No.";
        if SalesInvHeaderP."Sell-to Contact" <> '' then begin
            DocumentDataG[3] := SalesInvHeaderP."Sell-to Contact";
            NameCaptionG := C_BSS_TXT005;
        end else begin
            DocumentDataG[3] := SalesInvHeaderP."Sell-to Customer Name";
            NameCaptionG := C_BSS_TXT015;
        end;
        DocumentDataG[4] := SalesInvHeaderP."Vehicle No.";
        DocumentDataG[5] := SalesInvHeaderP."Licence-Plate No.";
    end;

    procedure PrintVeicleCheck(VehicleCheckP: Record "Vehicle Check")
    var
        VehicleCheckL: Record "Vehicle Check";
        VehicleCheckPrintL: Report "Vehicle Check Report-MK";
    begin
        Commit();
        Clear(VehicleCheckL);
        Clear(VehicleCheckPrintL);
        VehicleCheckL.Reset();
        VehicleCheckL.SetRange("Document Type", VehicleCheckP."Document Type");
        VehicleCheckL.SetRange("Document No.", VehicleCheckP."Document No.");
        VehicleCheckL.SetRange(Code, VehicleCheckP.Code);
        if VehicleCheckL.FindFirst() then;
        VehicleCheckPrintL.SetTableView(VehicleCheckL);
        VehicleCheckPrintL.Run();
    end;

    var
        CompanyInfoG: Record "Company Information";
        FastfitSetupAppG: Record "Fastfit Setup - Application";
        LineTypeG: Option " ","Service","Item";
        DocumentNoG: Code[20];
        LogoHeaderG: Text[250];
        DocumentHeaderTextG: Text[250];
        NameCaptionG: Text[250];
        TyreStatusG: Text[250];
        CheckNotesG: Text[250];
        CheckRecommandationG: Text[250];
        ReplaceValueG: Text[1];
        AttentionValueG: Text[1];
        OkValueG: Text[1];
        NewValueG: Text[1];

        LogoTextG: array[15] of Text[250];
        FooterTextG: array[5] of Text[250];
        CustomerDataG: array[8] of Text[50];
        DocumentDataG: array[20] of Text[50];
        CheckTemplateNameG: Text;
        ReplaceNotesG: Text;
        AttentionNotesG: Text;
        ShowReplaceNotesG: Boolean;
        ShowAttentionNotesG: Boolean;
        PrintColorG: Boolean;
        C_BSS_TXT000: Label '차량 점검 보고서';
        C_BSS_TXT001: Label '교체필요';
        C_BSS_TXT002: Label 'Vehicle Check';
        C_BSS_TXT003: Label '날짜';
        C_BSS_TXT004: Label 'Customer No.';
        C_BSS_TXT005: Label 'Contact Name';
        C_BSS_TXT006: Label 'Vehicle No.';
        C_BSS_TXT007: Label '차량번호';
        C_BSS_TXT008: Label '문서번호';
        C_BSS_TXT009: Label 'Status (mm)';
        C_BSS_TXT010: Label 'Next Service Date';
        C_BSS_TXT011: Label 'Car Service';
        C_BSS_TXT012: Label 'Status (%)';
        C_BSS_TXT013: Label 'Year';
        C_BSS_TXT014: Label 'Additional Comment:';
        C_BSS_TXT015: Label '고객명';
        C_BSS_TXT016: Label 'Brake Pads';
        BrakePadStatus2: Label '44263';
        BrakePadStatus4: Label '44422';
        Lbl_TXT001: Label '교체필요';
        Lbl_TXT002: Label '소모율 50% 이상(*차후 방문시 교체 요망)';
        Lbl_TXT003: Label '해당 사항 없음(정상)';
        Lbl_TXT004: Label '신규';
        Lbl_TXT005: Label '타이어 상태';
        Lbl_TXT006: Label '노트';
        Lbl_TXT007: Label '권장';
        Lbl_TXT008: Label 'Summary of Recommendation';
        Lbl_TXT009: Label '작업 필요 내역 및 권장 사항';
        Lbl_TXT010: Label '차량 점검 품목';
        Color_Replace: Label 'Red';
        Color_Attention: Label 'Orange';
        Color_New: Label 'Blue';
        Color_OK: Label 'Green';

}
