report 50000 "Daily Sales Register-MK"
{
    // +--------------------------------------------------------------+
    // | © 2015 ff. Begusch Software Systeme                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Fastfit                                             |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION  ID       WHO   DATE        DESCRIPTION
    // 081100   IT_20434 SG    2015-03-13  INITIAL RELEASE
    // 081100   IT_20894 CM    2016-01-28  added Profit to excel export
    //                                           added Unit of Measure to excel export
    // 081100   IT_20882 SG    2016-02-03  added folowing filter on the request page:
    //                                             "Promotion Condition No." and "Promotion Bonus Line No."
    // 081200   IT_20913 SG    2016-02-22  Merged to NAV 2016 CU04
    // 083000   IT_21246 SS    2017-02-07  added column Additional Sales Amount on report and for excel export
    // 083000   IT_21279 PW    2017-02-16  Header should not be filled in every record of the dataset
    // 083000   IT_21406 SS    2017-06-14  added german captions for columns: Daily Sales Register, Company Name, Report Name
    // 084010   IT_21547 PW    2017-09-19  added duration threshold
    // 084010   IT_21598 PW    2017-10-11  added german captions DEU to Sales and Sales Return labels
    //                                     set captions of last 3 columns of "Sales" Layout CanGrow to TRUE
    // 090000   IT_21705 SS    2018-02-05  corrected the format of field quantity in the layot
    // 090000   IT_21698 1CF   2018-03-09  Function MakeExcelInfo() changed:
    //                                       ExcelBuf.AddInfoColumn() standard parameter change
    //                                     Changed properties of DataItems - use field 1310 instead of 1300 (obsolete) in DataItemTableView:
    //                                       "Sales Cr.Memo Header1"
    //                                       "Sales Cr.Memo Header"
    // 090000   IT_21665 HI    2018-07-05  Bug fix for Report layout Alignment Issue.
    // 091000  TFS_14781 CM    2018-10-30  Added event function "OnAfterPostReport()"
    // 091000  TFS_14783 CM    2018-11-11  Added grouping on payment method with group totals
    //                                     Added "Remaining Amount" as "Balance"
    // 091000   IT_21940 PW    2018-09-19  the duration threshold should only be checked if the flag "Export to Excel" is set.
    // UPGBC140 2019-06-17 1CF_RPA Upgrade to NAVBC140
    //                             Extend local/global variables
    // 
    // --- SLA ---
    // FEATURE ID  DATE      WHO  ID     DESCRIPTION
    // AP.0025610  20.03.19  HI   25670  Removed DEA captions
    // AP.0034118  30.07.19  GV   34118  SLA: Repeat header captions on page break.
    // 092000
    // AP.0033020  30.07.19  GV   34119  Merge of SLA 34118.
    // AP.0037886  22.10.19  GV   38194  Upgrade to NAVBC140 CU05
    // AP.0043273  11.05.20  SU   34782  "Exoprt to Excel" hidden as the feature since the feature is available in standard

    DefaultLayout = RDLC;
    RDLCLayout = './DailySalesRegisterMK.rdl';

    Caption = 'Daily Sales Register-MK';


    dataset
    {
        dataitem(Header; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
            column(Filters; Filters)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Name_____CompanyInfo__Name_2_; CompanyInfo.Name + ' ' + CompanyInfo."Name 2")
            {
            }
            column(FORMAT_TODAY_0_7_; Format(Today, 0, 7))
            {
            }
            column(C_BSS_INF001_____COPYSTR_CurrReport_OBJECTID_FALSE__8_____; C_BSS_INF001 + '(' + CopyStr(CurrReport.ObjectId(false), 8) + ')')
            {
            }
            column(TIME; Format(Time))
            {
            }
            column(PrintSummary; PrintSummary)
            {
            }
            column(ReturnReasonCaption; C_BSS_INF014)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //++BSS.IT_21279.PW
                //Integer_1ID += 1;
                //--BSS.IT_21279.PW
            end;

            trigger OnPreDataItem()
            begin
                //++BSS.IT_21279.PW
                //CLEAR(Integer1_ID);
                //--BSS.IT_21279.PW

                if ServCenter.Get(SCMgt.GetSalesFilter()) then begin
                    FormatAddr.ServCenter(CompanyAddr, ServCenter);

                    CompanyInfo.Name := ServCenter.Name;
                    CompanyInfo."Name 2" := ServCenter."Name 2";
                    CompanyInfo.Address := ServCenter.Address;
                    CompanyInfo."Address 2" := ServCenter."Address 2";
                    CompanyInfo.City := ServCenter.City;
                    CompanyInfo."Post Code" := ServCenter."Post Code";
                    CompanyInfo.County := ServCenter.County;
                    CompanyInfo."Country/Region Code" := ServCenter."Country/Region Code";

                    CompanyInfo."Phone No." := ServCenter."Phone No.";
                    CompanyInfo."Fax No." := ServCenter."Fax No.";
                end else begin
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                end;
            end;
        }
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "Service Center", "Posting Date", "Sell-to Customer No.", "Bill-to Customer No.", "Sell-to Contact No.", "Bill-to Contact No.", "Vehicle No.", "Licence-Plate No.", "Campaign No.";
            column(Sales_Invoice_Header_ID; Sales_Invoice_Header_ID)
            {
            }
            column(Sales_Invoice_Header_ID2; 'DI')
            {
            }
            column(CustName; CustName)
            {
            }
            column(PaymentMode; PaymentMode)
            {
            }
            column(Invoice_No__Date_; C_BSS_INF010)
            {
            }
            column(Sales_Invoice_Header__Sales_Invoice_Header___No__; "Sales Invoice Header"."No.")
            {
            }
            column(Sales_Invoice_Header__Sales_Invoice_Header___Posting_Date_; Format("Sales Invoice Header"."Posting Date"))
            {
            }
            column(Sales_Invoice_Header__Sales_Invoice_Header___Licence_Plate_No__; "Sales Invoice Header"."Licence-Plate No.")
            {
            }
            column(TotalAmtForSales; TotalAmtForSales)
            {
            }
            column(TotalDisForSales; TotalDisForSales)
            {
            }
            column(GRAND_TOTAL_FOR_SALES_; C_BSS_INF012)
            {
            }
            column(C_BSS_INF011; C_BSS_INF011)
            {
            }
            column(TotalTaxForSales; TotalTaxForSales)
            {
            }
            column(TotalQtyForSales; TotalQtyForSales)
            {
            }
            column(Sales_Invoice_HeaderNotifReminderSent; Format("Notif. Reminder Sent"))
            {
            }
            column(ServiceRemSentTotalSales; ServiceRemSentTotalSales)
            {
            }
            column(AdditionalTotalProfitAmountInvoice; AdditionalTotalProfitAmountInvoice)
            {
            }
            column(Sales_Invoice_Header_Remaining_Amount; "Remaining Amount")
            {
            }
            column(Sales_Invoice_Header_Remaining_Amount_Caption; C_BSS_TXT004)
            {
            }
            column(Sales_Invoice_Header_Cash_Payment_Method; CashPaymentMethod)
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending);
                RequestFilterFields = Type, "No.", "Item Category Code", "Promotion Condition No.", "Promotion Bonus Line No.";
                column(Sales_Invoice_Line_ID; Sales_Invoice_Line_ID)
                {
                }
                column(Sales_Invoice_Line_ID2; 'DI')
                {
                }
                column(Desc; Desc)
                {
                }
                column(Sales_Invoice_Line_Quantity; Quantity)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(UnitPrice; UnitPrice)
                {
                }
                column(Sales_Invoice_Line__Line_Discount_Amount_; "Line Discount Amount")
                {
                }
                column(Sales_Invoice_Line__ItemNo_; "No.")
                {
                }
                column(Amount_Including_VAT__Amount; "Amount Including VAT" - Amount)
                {
                }
                column(Sales_Invoice_Line__Amount_Including_VAT_; "Amount Including VAT")
                {
                }
                column(Sales_Invoice_Line_Additional_Sale; Format("Additional Sale"))
                {
                }
                column(Sales_Invoice_Line_Additional_Sale_Integer; AdditionalSaleInteger)
                {
                }
                column(Sales_Invoice_Line_AdditionalSaleFlagTotalDocument; AdditionalSaleFlagTotalDocument)
                {
                }
                column(Sales_Invoice_Line_AdditionalSaleFlagTotalSales; AdditionalSaleFlagTotaSales)
                {
                }
                column(Sales_Invoice_Line_AdditionalDocumentProfitAmountInvoice; AdditionalDocumentProfitAmountInvoice)
                {
                }
                column(AdditionalSalesAmountLine; AdditionalAmountLine)
                {
                }
                column(PaymentModeLine; PaymentMode)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Sales_Invoice_Line_ID += 1;
                    UnitPrice := "Unit Price";
                    //++BSS.IT_20894.CM
                    LineCost := "Unit Cost" * Quantity;
                    //++BSS.IT_22219.SS
                    //ProfitAmount := ("Unit Price" * Quantity) - LineCost;
                    ProfitAmount := "Line Amount" - LineCost;
                    //--BSS.IT_22219.SS
                    if LineCost <> 0 then
                        ProfitPercentage := ProfitAmount / LineCost * 100
                    else
                        ProfitPercentage := 100;
                    //--BSS.IT_20894.CM
                    if OnlyAdditionalSale and not "Additional Sale" then
                        CurrReport.Skip;
                    //++BSS.IT_21246.SS
                    AdditionalAmountLine := 0;
                    //--BSS.IT_21246.SS
                    if "Additional Sale" then begin
                        AdditionalSaleFlagTotalDocument += 1;
                        AdditionalSaleFlagTotaSales += 1;
                        //++BSS.IT_21246.SS
                        AdditionalDocumentProfitAmountInvoice += "Amount Including VAT";
                        AdditionalTotalProfitAmountInvoice += "Amount Including VAT";
                        AdditionalAmountLine := "Amount Including VAT";
                        //--BSS.IT_22246.SS
                    end;

                    if (Type = Type::"G/L Account") then begin
                        if ("No." = '161504') then
                            Desc := 'Round off Amount'
                        else
                            Desc := Description + ' ' + "Description 2";
                    end else
                        Desc := Description + ' ' + "Description 2";

                    TotalQtyForSales += Quantity;
                    TotalDisForSales += "Line Discount Amount";
                    TotalAmtForSales += "Amount Including VAT";
                    TotalTaxForSales += "Amount Including VAT" - Amount;
                    TotalQtyForDoc += Quantity;
                    TotalDisForDoc += "Line Discount Amount";
                    TotalAmtForDoc += "Amount Including VAT";
                    TotalTaxForDoc += "Amount Including VAT" - Amount;

                    //++BSS.IT_20894.CM
                    DocumentCost += LineCost;
                    ProfitAmountDocument += ProfitAmount;
                    if DocumentCost <> 0 then
                        ProfitPercentageDocument := ProfitAmountDocument / DocumentCost * 100
                    else
                        ProfitPercentageDocument := 100;

                    TotalCostInvoice += LineCost;
                    TotalProfitAmountInvoice += ProfitAmount;
                    if TotalCostInvoice <> 0 then
                        TotalProfitPercentage := TotalProfitAmountInvoice / TotalCostInvoice * 100
                    else
                        TotalProfitPercentage := 100;
                    //--BSS.IT_20894.CM

                    if ExportExcel and not PrintSummary then
                        MakeExcelDataBody("Sales Invoice Header"."No.", Format("Sales Invoice Header"."Posting Date"), CustName, "Sales Invoice Header"."Licence-Plate No.", PaymentMode, '',
                          //++BSS.IT_21246.SS
                          /*
                          //++BSS.IT_20894.CM
                              //Desc,FORMAT(Quantity),FORMAT("Unit Price"),FORMAT("Line Discount Amount"),FORMAT("Amount Including VAT" - Amount),FORMAT("Amount Including VAT"), FORMAT("Additional Sale"),FORMAT("Sales Invoice Header"."Notif. Reminder Sent"));
                              Desc,FORMAT(Quantity),FORMAT("Unit Price"),FORMAT("Line Discount Amount"),FORMAT("Amount Including VAT" - Amount),FORMAT("Amount Including VAT"), FORMAT("Additional Sale"),FORMAT("Sales Invoice Header"."Notif. Reminder Sent"),
                              FORMAT(ProfitAmount),FORMAT(ProfitPercentage),"Unit of Measure Code");
                          //--BSS.IT_20894.CM
                          */
                          Desc, Format(Quantity), Format("Unit Price"), Format("Line Discount Amount"), Format("Amount Including VAT" - Amount), Format("Amount Including VAT"), Format("Additional Sale"),
                          Format(AdditionalAmountLine), Format("Sales Invoice Header"."Notif. Reminder Sent"),
                          Format(ProfitAmount), Format(ProfitPercentage), "Unit of Measure Code");
                    //--BSS.IT_21246.SS

                    //++BSS.TFS_14783.CM
                    Clear(AdditionalSaleInteger);
                    if "Additional Sale" then
                        AdditionalSaleInteger := 1;
                    //--BSS.TFS_14783.CM

                end;

                trigger OnPostDataItem()
                begin
                    if ExportExcel and PrintSummary then
                        MakeExcelDataBody("Sales Invoice Header"."No.", Format("Sales Invoice Header"."Posting Date"), CustName, "Sales Invoice Header"."Licence-Plate No.", PaymentMode, '', Format(TotalQtyForDoc),
                          //++BSS.IT_21246.SS
                          /*
                          //++BSS.IT_20894.CM
                              //FORMAT(TotalDisForDoc),FORMAT(TotalTaxForDoc),FORMAT(TotalAmtForDoc), FORMAT(AdditionalSaleFlagTotalDocument),FORMAT("Sales Invoice Header"."Notif. Reminder Sent"),'','')
                              FORMAT(TotalDisForDoc),FORMAT(TotalTaxForDoc),FORMAT(TotalAmtForDoc),FORMAT(ProfitAmountDocument),FORMAT(ProfitPercentageDocument),
                              '','',FORMAT(AdditionalSaleFlagTotalDocument),FORMAT("Sales Invoice Header"."Notif. Reminder Sent"),'');
                          //--BSS.IT_20894.CM
                          */
                          Format(TotalDisForDoc), Format(TotalTaxForDoc), Format(TotalAmtForDoc), Format(ProfitAmountDocument), Format(ProfitPercentageDocument),
                          '', '', Format(AdditionalSaleFlagTotalDocument), Format(AdditionalDocumentProfitAmountInvoice), Format("Sales Invoice Header"."Notif. Reminder Sent"), '');
                    //--BSS.IT_21246.SS

                end;

                trigger OnPreDataItem()
                begin
                    Clear(Sales_Invoice_Line_ID);
                    UnitPrice := 0;
                    if "Sales Invoice Line".GetFilter(Type) = '' then
                        "Sales Invoice Line".SetFilter(Type, '<>''''');
                end;
            }

            trigger OnAfterGetRecord()
            var
                PstCRTransLineL: Record "Post. Cash Reg. Transact. Line";
                MofPmtBufferL: Record "Cash Register Means of Payment" temporary;
                PstCrHeaderL: Record "Posted Cash Register Header";
                PstCrLineL: Record "Posted Cash Register Line";
                SalesInvLineL: Record "Sales Invoice Line";
                PaymentMethodL: Record "Payment Terms";
            begin
                Clear(AdditionalSaleFlagTotalDocument);
                Clear(TotalQtyForDoc);
                Clear(TotalDisForDoc);
                Clear(TotalAmtForDoc);
                Clear(TotalTaxForDoc);
                //++BSS.IT_20894.CM
                Clear(DocumentCost);
                Clear(ProfitAmountDocument);
                Clear(ProfitPercentageDocument);
                //--BSS.IT_20894.CM
                //++BSS.IT_21246.SS
                Clear(AdditionalDocumentProfitAmountInvoice);
                //--BSS.IT_21246.SS
                //++BSS.TFS_14783.CM
                Clear(CashPaymentMethod);
                //--BSS.TFS_14783.CM

                if OnlyAdditionalSale then begin
                    SalesInvLineL.SetRange(SalesInvLineL."Document No.", "Sales Invoice Header"."No.");
                    SalesInvLineL.SetRange("Additional Sale", true);
                    if not SalesInvLineL.FindSet then
                        CurrReport.Skip;
                end;
                if OnlyServiceReminderSent and not "Sales Invoice Header"."Notif. Reminder Sent" then
                    CurrReport.Skip;
                if "Sales Invoice Header"."Notif. Reminder Sent" then
                    ServiceRemSentTotalSales += 1;
                Sales_Invoice_Header_ID += 1;
                PaymentMode := '';
                PostedCashRegLine.Reset;
                PostedCashRegLine.SetRange("Document No.", "Cash Register Receipt");
                //++BSS.TFS_14783.CM
                PostedCashRegLine.SetCurrentKey("Means of Payment Code");
                //--BSS.TFS_14783.CM
                if PostedCashRegLine.Find('-') then begin
                    PaymentMode := PostedCashRegLine."Means of Payment Code";
                    repeat
                        if PaymentMode <> PostedCashRegLine."Means of Payment Code" then
                            PaymentMode := PaymentMode + ',' + PostedCashRegLine."Means of Payment Code";

                        if not MofPmtBufferL.Get(PostedCashRegLine."Means of Payment Code") then begin
                            MofPmtBufferL.Code := PostedCashRegLine."Means of Payment Code";
                            MofPmtBufferL.Insert;
                        end;

                    until PostedCashRegLine.Next = 0;
                end else
                    PaymentMode := '';

                if PaymentMode = '' then
                    //++BSS.TFS_14783.CM
                    //PaymentMode := 'CREDIT';
                    PaymentMode := 'CREDIT'
                else
                    CashPaymentMethod := true;
                //--BSS.TFS_14783.CM

                if "Payment Method Code" = 'CASH' then begin
                    CustName := "Sell-to Contact";
                    if CustName = '' then
                        CustName := "Sell-to Customer Name";
                end
                else
                    CustName := "Sell-to Customer Name";

                NoofRec := 0;
                SalesInvLine.Reset;
                SalesInvLine.SetRange("Document No.", "No.");
                if Gvtype <> '' then
                    SalesInvLine.SetRange(Type, Gvtype1);
                if ItemCategory <> '' then
                    SalesInvLine.SetRange("Item Category Code", ItemCategory);
                if Desc1 <> '' then
                    SalesInvLine.SetFilter(Description, Desc1);

                NoofRec := SalesInvLine.Count;
            end;

            trigger OnPreDataItem()
            begin
                "Sales Invoice Header".SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                Clear(Sales_Invoice_Header_ID);
                TotalQtyForSales := 0;
                TotalDisForSales := 0;
                TotalAmtForSales := 0;
                TotalTaxForSales := 0;
                CompanyInfo.Get;
                CompanyInfo.CalcFields(CompanyInfo.Picture);

                if ServCenter.Get("Service Center") then begin
                    FormatAddr.ServCenter(CompanyAddr, ServCenter);

                    CompanyInfo.Name := ServCenter.Name;
                    CompanyInfo."Name 2" := ServCenter."Name 2";
                    CompanyInfo.Address := ServCenter.Address;
                    CompanyInfo."Address 2" := ServCenter."Address 2";
                    CompanyInfo.City := ServCenter.City;
                    CompanyInfo."Post Code" := ServCenter."Post Code";
                    CompanyInfo.County := ServCenter.County;
                    CompanyInfo."Country/Region Code" := ServCenter."Country/Region Code";

                    CompanyInfo."Phone No." := ServCenter."Phone No.";
                    CompanyInfo."Fax No." := ServCenter."Fax No.";
                end else begin
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                end;

                if ExportExcel then begin
                    //++BSS.IT_20894.CM
                    /*
                    MakeExcelDataBodyBold('','','',C_BSS_INF004,'','','','','','','','','','');
                    IF PrintSummary THEN
                      MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),'',"Sales Invoice Line".FIELDCAPTION(Quantity),
                        C_BSS_INF007,C_BSS_INF008,C_BSS_INF009, "Sales Invoice Line".FIELDCAPTION("Additional Sale"),C_BSS_INF022,'','')
                    ELSE
                      MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),'',"Sales Invoice Line".FIELDCAPTION(Description),
                      "Sales Invoice Line".FIELDCAPTION(Quantity),"Sales Invoice Line".FIELDCAPTION("Unit Price"),C_BSS_INF007,C_BSS_INF008,C_BSS_INF009, "Sales Invoice Line".FIELDCAPTION("Additional Sale"),C_BSS_INF022);
                    */
                    //++BSS.IT_21246.SS
                    /*
                      MakeExcelDataBodyBold('','','',C_BSS_INF004,'','','','','','','','','','','','','');

                      IF PrintSummary THEN
                        MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),'',"Sales Invoice Line".FIELDCAPTION(Quantity),
                          C_BSS_INF007,C_BSS_INF008,C_BSS_INF009,C_BSS_TXT002,C_BSS_TXT001,'','',"Sales Invoice Line".FIELDCAPTION("Additional Sale"),C_BSS_INF022,'')
                      ELSE
                        MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),'',"Sales Invoice Line".FIELDCAPTION(Description),
                        "Sales Invoice Line".FIELDCAPTION(Quantity),"Sales Invoice Line".FIELDCAPTION("Unit Price"),C_BSS_INF007,C_BSS_INF008,C_BSS_INF009, "Sales Invoice Line".FIELDCAPTION("Additional Sale"),C_BSS_INF022,C_BSS_TXT002,C_BSS_TXT001,
                        "Sales Invoice Line".FIELDCAPTION("Unit of Measure Code"));

                      //--BSS.IT_20894.CM
                    */
                    MakeExcelDataBodyBold('', '', '', C_BSS_INF004, '', '', '', '', '', '', '', '', '', '', '', '', '', '');
                    if PrintSummary then
                        MakeExcelDataBodyBold(C_BSS_INF020, C_BSS_INF021, C_BSS_INF018, C_BSS_INF019, "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Payment Method Code"), '', "Sales Invoice Line".FieldCaption(Quantity),
                          C_BSS_INF007, C_BSS_INF008, C_BSS_INF009, C_BSS_TXT002, C_BSS_TXT001, '', '', "Sales Invoice Line".FieldCaption("Additional Sale"), C_BSS_TXT003, C_BSS_INF022, '')
                    else
                        MakeExcelDataBodyBold(C_BSS_INF020, C_BSS_INF021, C_BSS_INF018, C_BSS_INF019, "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Payment Method Code"), '', "Sales Invoice Line".FieldCaption(Description),
                        "Sales Invoice Line".FieldCaption(Quantity), "Sales Invoice Line".FieldCaption("Unit Price"), C_BSS_INF007, C_BSS_INF008, C_BSS_INF009, "Sales Invoice Line".FieldCaption("Additional Sale"), C_BSS_TXT003, C_BSS_INF022, C_BSS_TXT002, C_BSS_TXT001,
                        "Sales Invoice Line".FieldCaption("Unit of Measure Code"));
                    //--BSS.IT_21246.SS

                end;

            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            CalcFields = Cancelled;
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE(Cancelled = CONST(false));
            column(Sales_Cr_Memo_Header_ID; Sales_Cr_Memo_Header_ID)
            {
            }
            column(Sales_Cr_Memo_Header_ID2; 'DI')
            {
            }
            column(Sales_Cr_Memo_Header__No__; "No.")
            {
            }
            column(PaymentMode_Control1000000032; PaymentMode)
            {
            }
            column(Credit_Memo_No__Date_; C_BSS_INF013)
            {
            }
            column(Sales_Cr_Memo_Header__Sales_Cr_Memo_Header___Posting_Date_; Format("Sales Cr.Memo Header"."Posting Date"))
            {
            }
            column(ApplyInvDesc; ApplyInvDesc)
            {
            }
            column(CustName_Control1100023011; CustName)
            {
            }
            column(Sales_Cr_Memo_Header__Sales_Cr_Memo_Header___Licence_Plate_No__; "Sales Cr.Memo Header"."Licence-Plate No.")
            {
            }
            column(TotalAmtForSalesCr; TotalAmtForSalesCr)
            {
            }
            column(TotalDisForSalesCr; TotalDisForSalesCr)
            {
            }
            column(GRAND_TOTAL_FOR_RETURN__; C_BSS_INF015)
            {
            }
            column(C_BSS_INF011_Control1000000057; C_BSS_INF011)
            {
            }
            column(TotalTaxForSalesCr; TotalTaxForSalesCr)
            {
            }
            column(TotalQtyForSalesCr; TotalQtyForSalesCr)
            {
            }
            column(Sales_Cr_Memo_Header_Cash_Payment_Method; CashPaymentMethod)
            {
            }
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) WHERE(Type = FILTER(<> " "));
                column(Sales_Cr_Memo_Line_ID; Sales_Cr_Memo_Line_ID)
                {
                }
                column(Sales_Cr_Memo_Line_ID2; 'DI')
                {
                }
                column(Sales_Cr_Memo_Line_Description; Description)
                {
                }
                column(Sales_Cr_Memo_Line_Quantity; Quantity)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(UnitPrice_Control1000000045; UnitPrice)
                {
                }
                column(Sales_Cr_Memo_Line__Line_Discount_Amount_; "Line Discount Amount")
                {
                }
                column(Amount_Including_VAT__Amount_Control1000000031; "Amount Including VAT" - Amount)
                {
                }
                column(Sales_Cr_Memo_Line__Amount_Including_VAT_; "Amount Including VAT")
                {
                }
                column(Document_No___GrTot_5; "Document No.")
                {
                }
                column(Sales_Cr_Memo_Line_ReturnReasonText; ReturnReasonText)
                {
                }
                column(ReturnReasonCode_1; "Return Reason Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if OnlyAdditionalSale or OnlyServiceReminderSent then
                        CurrReport.Skip;

                    Sales_Cr_Memo_Line_ID += 1;
                    UnitPrice := "Unit Price";

                    //++BSS.IT_20894.CM
                    LineCost := "Unit Cost" * Quantity;
                    ProfitAmount := ("Unit Price" * Quantity) - LineCost;
                    if LineCost <> 0 then
                        ProfitPercentage := ProfitAmount / LineCost * 100
                    else
                        ProfitPercentage := 100;
                    //++BSS.IT_20894.CM

                    TotalQtyForSalesCr += Quantity;
                    TotalDisForSalesCr += "Line Discount Amount";
                    TotalAmtForSalesCr += "Amount Including VAT";
                    TotalTaxForSalesCr += "Amount Including VAT" - Amount;
                    TotalQtyForDoc += Quantity;
                    TotalDisForDoc += "Line Discount Amount";
                    TotalAmtForDoc += "Amount Including VAT";
                    TotalTaxForDoc += "Amount Including VAT" - Amount;
                    //++BSS.IT_20894.CM
                    DocumentCost += LineCost;
                    ProfitAmountDocument += ProfitAmount;
                    if DocumentCost <> 0 then
                        ProfitPercentageDocument := ProfitAmountDocument / DocumentCost * 100
                    else
                        ProfitPercentageDocument := 100;

                    TotalCostCrMemo += LineCost;
                    TotalProfitAmountCrMemo += ProfitAmount;
                    if TotalCostCrMemo <> 0 then
                        TotalProfitPercentage := TotalProfitAmountCrMemo / TotalCostCrMemo * 100
                    else
                        TotalProfitPercentage := 100;
                    //--BSS.IT_20894.CM

                    if ("Return Reason Code" <> '') and (StrPos(ReturnReasonText, "Return Reason Code") = 0) then
                        if ReturnReasonText = '' then
                            ReturnReasonText := "Return Reason Code"
                        else
                            ReturnReasonText += ',' + "Return Reason Code";

                    if ExportExcel and not PrintSummary then
                        MakeExcelDataBody("Sales Cr.Memo Header"."No.", Format("Sales Cr.Memo Header"."Posting Date"), CustName, "Sales Cr.Memo Header"."Licence-Plate No.", PaymentMode, "Return Reason Code" + ' ' + ApplyInvDesc,
                        //++BSS.IT_21246.SS
                        /*
                        //++BSS.IT_20894.CM
                          //Description + '' + "Description 2",FORMAT(Quantity),FORMAT("Unit Price"),FORMAT("Line Discount Amount"),FORMAT("Amount Including VAT" - Amount),FORMAT("Amount Including VAT"),'','');
                          Description + '' + "Description 2",FORMAT(Quantity),FORMAT("Unit Price"),FORMAT("Line Discount Amount"),FORMAT("Amount Including VAT" - Amount),FORMAT("Amount Including VAT"),
                          '','',FORMAT(ProfitAmount),FORMAT(ProfitPercentage),"Sales Cr.Memo Line"."Unit of Measure Code");
                        //--BSS.IT_20894.CM
                        */
                        Description + '' + "Description 2", Format(Quantity), Format("Unit Price"), Format("Line Discount Amount"), Format("Amount Including VAT" - Amount), Format("Amount Including VAT"),
                        '', '', Format(ProfitAmount), Format(ProfitPercentage), "Sales Cr.Memo Line"."Unit of Measure Code", '');
                    //--BSS.IT_21246.SS

                end;

                trigger OnPostDataItem()
                begin
                    if OnlyAdditionalSale or OnlyServiceReminderSent then
                        CurrReport.Skip;

                    if ExportExcel and PrintSummary then
                        MakeExcelDataBody("Sales Cr.Memo Header"."No.", Format("Sales Cr.Memo Header"."Posting Date"), CustName, "Sales Cr.Memo Header"."Licence-Plate No.", PaymentMode, ReturnReasonText + ' ' + ApplyInvDesc, Format(TotalQtyForDoc),
                          //++BSS.IT_21246.SS
                          /*
                          //++BSS.IT_20894.CM
                              //FORMAT(TotalDisForDoc),FORMAT(TotalTaxForDoc),FORMAT(TotalAmtForDoc),'','','','');
                              FORMAT(TotalDisForDoc),FORMAT(TotalTaxForDoc),FORMAT(TotalAmtForDoc),FORMAT(ProfitAmountDocument),FORMAT(ProfitPercentageDocument),'','','','','');
                          //--BSS.IT_20894.CM
                          */
                          Format(TotalDisForDoc), Format(TotalTaxForDoc), Format(TotalAmtForDoc), Format(ProfitAmountDocument), Format(ProfitPercentageDocument), '', '', '', '', '', '');
                    //--BSS.IT_21246.SS

                end;

                trigger OnPreDataItem()
                begin
                    if OnlyAdditionalSale or OnlyServiceReminderSent then
                        CurrReport.Skip;

                    Clear(Sales_Cr_Memo_Line_ID);
                    SetFilter(Type, "Sales Invoice Line".GetFilter(Type));
                    SetFilter("No.", "Sales Invoice Line".GetFilter("No."));
                    SetFilter("Item Category Code", "Sales Invoice Line".GetFilter("Item Category Code"));
                    //++BSS.IT_20882.SG
                    SetFilter("Promotion Condition No.", "Sales Invoice Line".GetFilter("Promotion Condition No."));
                    SetFilter("Promotion Bonus Line No.", "Sales Invoice Line".GetFilter("Promotion Bonus Line No."));
                    //--BSS.IT_20882.SG

                    UnitPrice := 0;

                    if SellCustNo <> '' then
                        SetFilter("Sell-to Customer No.", SellCustNo);

                    if Gvtype <> '' then
                        SetRange(Type, Gvtype1);
                    if ItemCategory <> '' then
                        SetFilter("Item Category Code", ItemCategory);
                    if Desc1 <> '' then
                        SetFilter(Description, Desc1);
                end;
            }

            trigger OnAfterGetRecord()
            var
                SalesCrMemoLine11: Record "Sales Cr.Memo Line";
            begin
                if OnlyAdditionalSale or OnlyServiceReminderSent then
                    CurrReport.Skip;
                Sales_Cr_Memo_Header_ID += 1;
                Clear(TotalQtyForDoc);
                Clear(TotalDisForDoc);
                Clear(TotalAmtForDoc);
                Clear(TotalTaxForDoc);
                Clear(ReturnReasonText);
                //++BSS.IT_20894.CM
                Clear(DocumentCost);
                Clear(ProfitAmountDocument);
                Clear(ProfitPercentageDocument);
                //--BSS.IT_20894.CM
                //++BSS.TFS_14783.CM
                Clear(CashPaymentMethod);
                //--BSS.TFS_14783.CM
                PaymentMode := '';
                PostedCashRegLine.Reset;
                PostedCashRegLine.SetRange("Document No.", "Cash Register Receipt");
                //++BSS.TFS_14783.CM
                PostedCashRegLine.SetCurrentKey("Means of Payment Code");
                //--BSS.TFS_14783.CM
                if PostedCashRegLine.Find('-') then begin
                    PaymentMode := PostedCashRegLine."Means of Payment Code";
                    repeat
                        if PaymentMode <> PostedCashRegLine."Means of Payment Code" then
                            PaymentMode := PaymentMode + ',' + PostedCashRegLine."Means of Payment Code";
                    until PostedCashRegLine.Next = 0
                end else
                    PaymentMode := '';

                if PaymentMode = '' then
                    //++BSS.TFS_14783.CM
                    //PaymentMode := 'CREDIT';
                    PaymentMode := 'CREDIT'
                else
                    CashPaymentMethod := true;
                //--BSS.TFS_14783.CM

                if "Payment Method Code" = 'CASH' then begin
                    CustName := "Sell-to Contact";
                    if CustName = '' then
                        CustName := "Sell-to Customer Name";
                end
                else
                    CustName := "Sell-to Customer Name";


                SalesCrMemoLine.Reset;
                SalesCrMemoLine.SetRange(SalesCrMemoLine."Document No.", "No.");
                SalesCrMemoLine.SetRange(Type, 0);
                if SalesCrMemoLine.FindFirst then
                    ApplyInvDesc := SalesCrMemoLine.Description
                else
                    ApplyInvDesc := '';

                NoofRecCr := 0;
                SalesCrMemoLine11.Reset;
                SalesCrMemoLine11.SetRange("Document No.", "No.");
                if SellCustNo <> '' then
                    SalesCrMemoLine11.SetFilter("Sell-to Customer No.", SellCustNo);
                if Gvtype <> '' then
                    SalesCrMemoLine11.SetRange(Type, Gvtype1);
                if ItemCategory <> '' then
                    SalesCrMemoLine11.SetFilter("Item Category Code", ItemCategory);
                if Desc1 <> '' then
                    SalesCrMemoLine11.SetFilter(Description, Desc1);

                NoofRecCr := SalesCrMemoLine11.Count;
            end;

            trigger OnPostDataItem()
            begin
                if OnlyAdditionalSale or OnlyServiceReminderSent then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin

                if OnlyAdditionalSale or OnlyServiceReminderSent then
                    CurrReport.Skip;

                Clear(Sales_Cr_Memo_Header_ID);
                TotalQtyForSalesCr := 0;
                TotalDisForSalesCr := 0;
                TotalAmtForSalesCr := 0;
                TotalTaxForSalesCr := 0;

                SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                SetFilter("Service Center", "Sales Invoice Header".GetFilter("Service Center"));
                SetFilter("Sell-to Customer No.", "Sales Invoice Header".GetFilter("Sell-to Customer No."));
                SetFilter("Bill-to Customer No.", "Sales Invoice Header".GetFilter("Bill-to Customer No."));
                SetFilter("Sell-to Contact No.", "Sales Invoice Header".GetFilter("Sell-to Contact No."));
                SetFilter("Bill-to Contact No.", "Sales Invoice Header".GetFilter("Bill-to Contact No."));
                SetFilter("Vehicle No.", "Sales Invoice Header".GetFilter("Vehicle No."));
                SetFilter("Licence-Plate No.", "Sales Invoice Header".GetFilter("Licence-Plate No."));
                SetFilter("Campaign No.", "Sales Invoice Header".GetFilter("Campaign No."));

                if ExportExcel then begin
                    //++BSS.IT_20894.CM
                    /*
                    IF PrintSummary THEN
                      MakeExcelDataBodyBold('','','','','',C_BSS_INF012,FORMAT(TotalQtyForSales),FORMAT(TotalDisForSales),
                        FORMAT(TotalTaxForSales),FORMAT(TotalAmtForSales), FORMAT(AdditionalSaleFlagTotaSales),FORMAT(ServiceRemSentTotalSales),'','')
                    ELSE
                      MakeExcelDataBodyBold('','','','','','',C_BSS_INF012,FORMAT(TotalQtyForSales),'',FORMAT(TotalDisForSales),
                        FORMAT(TotalTaxForSales),FORMAT(TotalAmtForSales), FORMAT(AdditionalSaleFlagTotaSales),FORMAT(ServiceRemSentTotalSales));
                    MakeExcelDataBodyBold('','','','','','','','','','','','','','');
                    MakeExcelDataBodyBold('','','',C_BSS_INF005,'','','','','','','','','','');
                    IF PrintSummary THEN
                      MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),C_BSS_INF014,
                        "Sales Invoice Line".FIELDCAPTION(Quantity),C_BSS_INF007,C_BSS_INF008,C_BSS_INF009,'','','','')
                    ELSE
                      MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),C_BSS_INF014,"Sales Invoice Line".FIELDCAPTION(Description),
                        "Sales Invoice Line".FIELDCAPTION(Quantity),"Sales Invoice Line".FIELDCAPTION("Unit Price"),C_BSS_INF007,C_BSS_INF008,C_BSS_INF009,'','');
                    */
                    //++BSS.IT_21246.SS
                    /*
                      IF PrintSummary THEN
                        MakeExcelDataBodyBold('','','','','',C_BSS_INF012,FORMAT(TotalQtyForSales),FORMAT(TotalDisForSales),
                          FORMAT(TotalTaxForSales),FORMAT(TotalAmtForSales),FORMAT(TotalProfitAmountInvoice),FORMAT(TotalProfitPercentage),'','', FORMAT(AdditionalSaleFlagTotaSales),FORMAT(ServiceRemSentTotalSales),'')
                      ELSE
                        MakeExcelDataBodyBold('','','','','','',C_BSS_INF012,FORMAT(TotalQtyForSales),'',FORMAT(TotalDisForSales),
                          FORMAT(TotalTaxForSales),FORMAT(TotalAmtForSales), FORMAT(AdditionalSaleFlagTotaSales),FORMAT(ServiceRemSentTotalSales),FORMAT(TotalProfitAmountInvoice),FORMAT(TotalProfitPercentage),'');

                      MakeExcelDataBodyBold('','','','','','','','','','','','','','','','','');
                      MakeExcelDataBodyBold('','','',C_BSS_INF005,'','','','','','','','','','','','','');

                      IF PrintSummary THEN
                        MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),C_BSS_INF014,
                          "Sales Invoice Line".FIELDCAPTION(Quantity),C_BSS_INF007,C_BSS_INF008,C_BSS_INF009,C_BSS_TXT002,C_BSS_TXT001,'','','','','')
                      ELSE
                        MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),C_BSS_INF014,"Sales Invoice Line".FIELDCAPTION(Description),
                          "Sales Invoice Line".FIELDCAPTION(Quantity),"Sales Invoice Line".FIELDCAPTION("Unit Price"),C_BSS_INF007,C_BSS_INF008,C_BSS_INF009,'','',C_BSS_TXT002,C_BSS_TXT001,"Sales Cr.Memo Line".FIELDCAPTION("Unit of Measure Code"));
                    */
                    if PrintSummary then
                        MakeExcelDataBodyBold('', '', '', '', '', C_BSS_INF012, Format(TotalQtyForSales), Format(TotalDisForSales),
                          Format(TotalTaxForSales), Format(TotalAmtForSales), Format(TotalProfitAmountInvoice), Format(TotalProfitPercentage), '', '', Format(AdditionalSaleFlagTotaSales), Format(AdditionalTotalProfitAmountInvoice), Format(ServiceRemSentTotalSales), '')
                    else
                        MakeExcelDataBodyBold('', '', '', '', '', '', C_BSS_INF012, Format(TotalQtyForSales), '', Format(TotalDisForSales),
                          Format(TotalTaxForSales), Format(TotalAmtForSales), Format(AdditionalSaleFlagTotaSales), Format(AdditionalTotalProfitAmountInvoice), Format(ServiceRemSentTotalSales), Format(TotalProfitAmountInvoice), Format(TotalProfitPercentage), '');

                    MakeExcelDataBodyBold('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
                    MakeExcelDataBodyBold('', '', '', C_BSS_INF005, '', '', '', '', '', '', '', '', '', '', '', '', '', '');

                    if PrintSummary then
                        MakeExcelDataBodyBold(C_BSS_INF020, C_BSS_INF021, C_BSS_INF018, C_BSS_INF019, "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Payment Method Code"), C_BSS_INF014,
                          "Sales Invoice Line".FieldCaption(Quantity), C_BSS_INF007, C_BSS_INF008, C_BSS_INF009, C_BSS_TXT002, C_BSS_TXT001, '', '', '', '', '', '')
                    else
                        MakeExcelDataBodyBold(C_BSS_INF020, C_BSS_INF021, C_BSS_INF018, C_BSS_INF019, "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Payment Method Code"), C_BSS_INF014, "Sales Invoice Line".FieldCaption(Description),
                          "Sales Invoice Line".FieldCaption(Quantity), "Sales Invoice Line".FieldCaption("Unit Price"), C_BSS_INF007, C_BSS_INF008, C_BSS_INF009, '', '', C_BSS_TXT002, C_BSS_TXT001, "Sales Cr.Memo Line".FieldCaption("Unit of Measure Code"), '');


                    //--BSS.IT_21246.SS

                    TotalProfitPercentage := 0;

                    //--BSS.IT_20894.CM
                end;

            end;
        }
        dataitem("Sales Cr.Memo Header1"; "Sales Cr.Memo Header")
        {
            CalcFields = Cancelled;
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE(Cancelled = CONST(true));
            column(Sales_Cr_Memo_Header1_ID; Sales_Cr_Memo_Header1_ID)
            {
            }
            column(Sales_Cr_Memo_Header1_ID2; 'DI')
            {
            }
            column(Sales_Cr_Memo_Header1__No__; "No.")
            {
            }
            column(PaymentMode_Control1100023023; PaymentMode)
            {
            }
            column(Credit_Memo_No__Date__Control1100023024; C_BSS_INF013)
            {
            }
            column(Sales_Cr_Memo_Header___Posting_Date_; Format("Sales Cr.Memo Header"."Posting Date"))
            {
            }
            column(ApplyInvDesc_Control1100023027; ApplyInvDesc)
            {
            }
            column(CustName_Control1100023029; CustName)
            {
            }
            column(Sales_Cr_Memo_Header1__Sales_Cr_Memo_Header1___Licence_Plate_No__; "Sales Cr.Memo Header1"."Licence-Plate No.")
            {
            }
            column(TotalAmtForSalesCr_Control1100023042; TotalAmtForSalesCr)
            {
            }
            column(TotalDisForSalesCr_Control1100023043; TotalDisForSalesCr)
            {
            }
            column(C_BSS_INF016; C_BSS_INF016)
            {
            }
            column(C_BSS_INF011_Control1100023038; C_BSS_INF011)
            {
            }
            column(TotalTaxForSalesCr_Control1100023045; TotalTaxForSalesCr)
            {
            }
            column(TotalQtyForSalesCr_Control1100023047; TotalQtyForSalesCr)
            {
            }
            column(Sales_Cr_Memo_Header1_Cash_Payment_Method; CashPaymentMethod)
            {
            }
            dataitem("Sales Cr.Memo Line1"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) WHERE(Type = FILTER(<> " "));
                column(Sales_Cr_Memo_Line1_ID; Sales_Cr_Memo_Line1_ID)
                {
                }
                column(Sales_Cr_Memo_Line1_ID2; 'DI')
                {
                }
                column(Sales_Cr_Memo_Line1_Description; Description)
                {
                }
                column(Sales_Cr_Memo_Line1_Quantity; Quantity)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(UnitPrice_Control1100023033; UnitPrice)
                {
                }
                column(Sales_Cr_Memo_Line1__Line_Discount_Amount_; "Line Discount Amount")
                {
                }
                column(Amount_Including_VAT__Amount_Control1100023035; "Amount Including VAT" - Amount)
                {
                }
                column(Sales_Cr_Memo_Line1__Amount_Including_VAT_; "Amount Including VAT")
                {
                }
                column(Document_No___GrTot_7; "Document No.")
                {
                }
                column(Sales_Cr_Memo_Line1_ReturnReasonText; ReturnReasonText)
                {
                }
                column(ReturnReasonCode_2; "Return Reason Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if OnlyAdditionalSale or OnlyServiceReminderSent then
                        CurrReport.Skip;

                    Sales_Cr_Memo_Line1_ID += 1;
                    UnitPrice := "Unit Price";

                    //++BSS.IT_20894.CM
                    LineCost := "Unit Cost" * Quantity;
                    ProfitAmount := ("Unit Price" * Quantity) - LineCost;
                    if LineCost <> 0 then
                        ProfitPercentage := ProfitAmount / LineCost * 100
                    else
                        ProfitPercentage := 100;
                    //++BSS.IT_20894.CM

                    TotalQtyForSalesCr2 += Quantity;
                    TotalDisForSalesCr2 += "Line Discount Amount";
                    TotalAmtForSalesCr2 += "Amount Including VAT";
                    TotalTaxForSalesCr2 += "Amount Including VAT" - Amount;
                    TotalQtyForDoc += Quantity;
                    TotalDisForDoc += "Line Discount Amount";
                    TotalAmtForDoc += "Amount Including VAT";
                    TotalTaxForDoc += "Amount Including VAT" - Amount;
                    //++BSS.IT_20894.CM
                    DocumentCost += LineCost;
                    ProfitAmountDocument += ProfitAmount;
                    if DocumentCost <> 0 then
                        ProfitPercentageDocument := ProfitAmountDocument / DocumentCost * 100
                    else
                        ProfitPercentageDocument := 100;

                    TotalCostCrMemo2 += LineCost;
                    TotalProfitAmountCrMemo2 += ProfitAmount;
                    if TotalCostCrMemo2 <> 0 then
                        TotalProfitPercentage := TotalProfitAmountCrMemo2 / TotalCostCrMemo2 * 100
                    else
                        TotalProfitPercentage := 100;
                    //--BSS.IT_20894.CM

                    if ("Return Reason Code" <> '') and (StrPos(ReturnReasonText, "Return Reason Code") = 0) then
                        if ReturnReasonText = '' then
                            ReturnReasonText := "Return Reason Code"
                        else
                            ReturnReasonText += ',' + "Return Reason Code";

                    if ExportExcel and not PrintSummary then
                        MakeExcelDataBody("Sales Cr.Memo Header1"."No.", Format("Sales Cr.Memo Header1"."Posting Date"), CustName, "Sales Cr.Memo Header1"."Licence-Plate No.", PaymentMode, "Return Reason Code" + ' ' + ApplyInvDesc,
                        //++BSS.IT_21246.SS
                        /*
                        //++BSS.IT_20894.CM
                          //Description + '' + "Description 2",FORMAT(Quantity),FORMAT("Unit Price"),FORMAT("Line Discount Amount"),FORMAT("Amount Including VAT" - Amount),FORMAT("Amount Including VAT"),'','');
                          Description + '' + "Description 2",FORMAT(Quantity),FORMAT("Unit Price"),FORMAT("Line Discount Amount"),FORMAT("Amount Including VAT" - Amount),FORMAT("Amount Including VAT"),'','',
                          FORMAT(ProfitAmount),FORMAT(ProfitPercentage),"Sales Cr.Memo Line1"."Unit of Measure Code");
                        //--BSS.IT_20894.CM
                        */
                        Description + '' + "Description 2", Format(Quantity), Format("Unit Price"), Format("Line Discount Amount"), Format("Amount Including VAT" - Amount), Format("Amount Including VAT"), '', '',
                        Format(ProfitAmount), Format(ProfitPercentage), "Sales Cr.Memo Line1"."Unit of Measure Code", '');
                    //--BSS.IT_21246.SS

                end;

                trigger OnPostDataItem()
                begin
                    if OnlyAdditionalSale or OnlyServiceReminderSent then
                        CurrReport.Skip;

                    if ExportExcel and PrintSummary then
                        MakeExcelDataBody("Sales Cr.Memo Header1"."No.", Format("Sales Cr.Memo Header1"."Posting Date"), CustName, "Sales Cr.Memo Header1"."Licence-Plate No.", PaymentMode, ReturnReasonText + ' ' + ApplyInvDesc, Format(TotalQtyForDoc),
                          //++BSS.IT_21246.SS
                          /*
                          //++BSS.IT_20894.CM
                              //FORMAT(TotalDisForDoc),FORMAT(TotalTaxForDoc),FORMAT(TotalAmtForDoc),'','','','');
                              FORMAT(TotalDisForDoc),FORMAT(TotalTaxForDoc),FORMAT(TotalAmtForDoc),FORMAT(ProfitAmountDocument),FORMAT(ProfitPercentageDocument),'','','','','');
                          //--BSS.IT_20894.CM
                          */
                          Format(TotalDisForDoc), Format(TotalTaxForDoc), Format(TotalAmtForDoc), Format(ProfitAmountDocument), Format(ProfitPercentageDocument), '', '', '', '', '', '');
                    //--BSS.IT_21246.SS

                end;

                trigger OnPreDataItem()
                begin
                    if OnlyAdditionalSale or OnlyServiceReminderSent then
                        CurrReport.Skip;

                    Clear(Sales_Cr_Memo_Line1_ID);
                    SetFilter(Type, "Sales Invoice Line".GetFilter(Type));
                    SetFilter("No.", "Sales Invoice Line".GetFilter("No."));
                    SetFilter("Item Category Code", "Sales Invoice Line".GetFilter("Item Category Code"));
                    //++BSS.IT_20882.SG
                    SetFilter("Promotion Condition No.", "Sales Invoice Line".GetFilter("Promotion Condition No."));
                    SetFilter("Promotion Bonus Line No.", "Sales Invoice Line".GetFilter("Promotion Bonus Line No."));
                    //--BSS.IT_20882.SG

                    UnitPrice := 0;

                    if SellCustNo <> '' then
                        SetFilter("Sell-to Customer No.", SellCustNo);

                    if Gvtype <> '' then
                        SetRange(Type, Gvtype1);
                    if ItemCategory <> '' then
                        SetFilter("Item Category Code", ItemCategory);
                    if Desc1 <> '' then
                        SetFilter(Description, Desc1);
                end;
            }

            trigger OnAfterGetRecord()
            var
                SalesCrMemoLine11: Record "Sales Cr.Memo Line";
            begin
                if OnlyAdditionalSale or OnlyServiceReminderSent then
                    CurrReport.Skip;

                Sales_Cr_Memo_Header1_ID += 1;
                Clear(TotalQtyForDoc);
                Clear(TotalDisForDoc);
                Clear(TotalAmtForDoc);
                Clear(TotalTaxForDoc);
                Clear(ReturnReasonText);
                //++BSS.IT_20894.CM
                Clear(DocumentCost);
                Clear(ProfitAmountDocument);
                Clear(ProfitPercentageDocument);
                //--BSS.IT_20894.CM
                //++BSS.TFS_14783.CM
                Clear(CashPaymentMethod);
                //--BSS.TFS_14783.CM
                PaymentMode := '';
                PostedCashRegLine.Reset;
                PostedCashRegLine.SetRange("Document No.", "Cash Register Receipt");
                //++BSS.TFS_14783.CM
                PostedCashRegLine.SetCurrentKey("Means of Payment Code");
                //--BSS.TFS_14783.CM
                if PostedCashRegLine.Find('-') then begin
                    PaymentMode := PostedCashRegLine."Means of Payment Code";
                    repeat
                        if PaymentMode <> PostedCashRegLine."Means of Payment Code" then
                            PaymentMode := PaymentMode + ',' + PostedCashRegLine."Means of Payment Code";
                    until PostedCashRegLine.Next = 0
                end else
                    PaymentMode := '';

                if PaymentMode = '' then
                    //++BSS.TFS_14783.CM
                    //PaymentMode := 'CREDIT';
                    PaymentMode := 'CREDIT'
                else
                    CashPaymentMethod := true;
                //--BSS.TFS_14783.CM

                if "Payment Method Code" = 'CASH' then begin
                    CustName := "Sell-to Contact";
                    if CustName = '' then
                        CustName := "Sell-to Customer Name";
                end
                else
                    CustName := "Sell-to Customer Name";


                SalesCrMemoLine.Reset;
                SalesCrMemoLine.SetRange(SalesCrMemoLine."Document No.", "No.");
                SalesCrMemoLine.SetRange(Type, 0);
                if SalesCrMemoLine.FindFirst then
                    ApplyInvDesc := SalesCrMemoLine.Description
                else
                    ApplyInvDesc := '';

                NoofRecCr := 0;
                SalesCrMemoLine11.Reset;
                SalesCrMemoLine11.SetRange("Document No.", "No.");
                if SellCustNo <> '' then
                    SalesCrMemoLine11.SetFilter("Sell-to Customer No.", SellCustNo);
                if Gvtype <> '' then
                    SalesCrMemoLine11.SetRange(Type, Gvtype1);
                if ItemCategory <> '' then
                    SalesCrMemoLine11.SetFilter("Item Category Code", ItemCategory);
                if Desc1 <> '' then
                    SalesCrMemoLine11.SetFilter(Description, Desc1);

                NoofRecCr := SalesCrMemoLine11.Count;
            end;

            trigger OnPostDataItem()
            begin
                if OnlyAdditionalSale or OnlyServiceReminderSent then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                if OnlyAdditionalSale or OnlyServiceReminderSent then
                    CurrReport.Skip;

                Clear(Sales_Cr_Memo_Header1_ID);
                TotalQtyForSalesCr2 := 0;
                TotalDisForSalesCr2 := 0;
                TotalAmtForSalesCr2 := 0;
                TotalTaxForSalesCr2 := 0;
                SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                SetFilter("Service Center", "Sales Invoice Header".GetFilter("Service Center"));
                SetFilter("Sell-to Customer No.", "Sales Invoice Header".GetFilter("Sell-to Customer No."));
                SetFilter("Bill-to Customer No.", "Sales Invoice Header".GetFilter("Bill-to Customer No."));
                SetFilter("Sell-to Contact No.", "Sales Invoice Header".GetFilter("Sell-to Contact No."));
                SetFilter("Bill-to Contact No.", "Sales Invoice Header".GetFilter("Bill-to Contact No."));
                SetFilter("Vehicle No.", "Sales Invoice Header".GetFilter("Vehicle No."));
                SetFilter("Licence-Plate No.", "Sales Invoice Header".GetFilter("Licence-Plate No."));
                SetFilter("Campaign No.", "Sales Invoice Header".GetFilter("Campaign No."));


                if ExportExcel then begin
                    //++BSS.IT_20894.CM
                    /*
                    IF PrintSummary THEN
                      MakeExcelDataBodyBold('','','','','',C_BSS_INF015,FORMAT(TotalQtyForSalesCr),FORMAT(TotalDisForSalesCr),
                        FORMAT(TotalTaxForSalesCr),FORMAT(TotalAmtForSalesCr),'','','','')
                    ELSE
                      MakeExcelDataBodyBold('','','','','','',C_BSS_INF015,FORMAT(TotalQtyForSalesCr),'',FORMAT(TotalDisForSalesCr),
                        FORMAT(TotalTaxForSalesCr),FORMAT(TotalAmtForSalesCr),'','');
                    MakeExcelDataBody('','','','','','','','','','','','','','');
                    MakeExcelDataBodyBold('','','',C_BSS_INF006,'','','','','','','','','','');
                    IF PrintSummary THEN
                      MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),C_BSS_INF014,
                        "Sales Invoice Line".FIELDCAPTION(Quantity),C_BSS_INF007,C_BSS_INF008,C_BSS_INF009,'','','','')
                    ELSE
                      MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),C_BSS_INF014,"Sales Invoice Line".FIELDCAPTION(Description),
                        "Sales Invoice Line".FIELDCAPTION(Quantity),"Sales Invoice Line".FIELDCAPTION("Unit Price"),C_BSS_INF007,C_BSS_INF008,C_BSS_INF009,'','');
                    */
                    //++BSS.IT_21246.SS
                    /*
                      IF PrintSummary THEN
                        MakeExcelDataBodyBold('','','','','',C_BSS_INF015,FORMAT(TotalQtyForSalesCr),FORMAT(TotalDisForSalesCr),
                          FORMAT(TotalTaxForSalesCr),FORMAT(TotalAmtForSalesCr),FORMAT(TotalProfitAmountCrMemo),FORMAT(TotalProfitPercentage),'','','','','')
                      ELSE
                        MakeExcelDataBodyBold('','','','','','',C_BSS_INF015,FORMAT(TotalQtyForSalesCr),'',FORMAT(TotalDisForSalesCr),
                          FORMAT(TotalTaxForSalesCr),FORMAT(TotalAmtForSalesCr),'','',FORMAT(TotalProfitAmountCrMemo),FORMAT(TotalProfitPercentage),'');

                      MakeExcelDataBody('','','','','','','','','','','','','','','','','');
                      MakeExcelDataBodyBold('','','',C_BSS_INF006,'','','','','','','','','','','','','');

                      IF PrintSummary THEN
                        MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),C_BSS_INF014,
                          "Sales Invoice Line".FIELDCAPTION(Quantity),C_BSS_INF007,C_BSS_INF008,C_BSS_INF009,C_BSS_TXT002,C_BSS_TXT001,'','','','','')
                      ELSE
                        MakeExcelDataBodyBold(C_BSS_INF020,C_BSS_INF021,C_BSS_INF018,C_BSS_INF019,"Sales Invoice Header".FIELDCAPTION("Sales Invoice Header"."Payment Method Code"),C_BSS_INF014,"Sales Invoice Line".FIELDCAPTION(Description),
                          "Sales Invoice Line".FIELDCAPTION(Quantity),"Sales Invoice Line".FIELDCAPTION("Unit Price"),C_BSS_INF007,C_BSS_INF008,C_BSS_INF009,'','',C_BSS_TXT002,C_BSS_TXT001,"Sales Cr.Memo Line1".FIELDCAPTION("Unit of Measure Code"));
                    */
                    if PrintSummary then
                        MakeExcelDataBodyBold('', '', '', '', '', C_BSS_INF015, Format(TotalQtyForSalesCr), Format(TotalDisForSalesCr),
                          Format(TotalTaxForSalesCr), Format(TotalAmtForSalesCr), Format(TotalProfitAmountCrMemo), Format(TotalProfitPercentage), '', '', '', '', '', '')
                    else
                        MakeExcelDataBodyBold('', '', '', '', '', '', C_BSS_INF015, Format(TotalQtyForSalesCr), '', Format(TotalDisForSalesCr),
                          Format(TotalTaxForSalesCr), Format(TotalAmtForSalesCr), '', '', Format(TotalProfitAmountCrMemo), Format(TotalProfitPercentage), '', '');

                    MakeExcelDataBody('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
                    MakeExcelDataBodyBold('', '', '', C_BSS_INF006, '', '', '', '', '', '', '', '', '', '', '', '', '', '');

                    if PrintSummary then
                        MakeExcelDataBodyBold(C_BSS_INF020, C_BSS_INF021, C_BSS_INF018, C_BSS_INF019, "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Payment Method Code"), C_BSS_INF014,
                          "Sales Invoice Line".FieldCaption(Quantity), C_BSS_INF007, C_BSS_INF008, C_BSS_INF009, C_BSS_TXT002, C_BSS_TXT001, '', '', '', '', '', '')
                    else
                        MakeExcelDataBodyBold(C_BSS_INF020, C_BSS_INF021, C_BSS_INF018, C_BSS_INF019, "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Payment Method Code"), C_BSS_INF014, "Sales Invoice Line".FieldCaption(Description),
                          "Sales Invoice Line".FieldCaption(Quantity), "Sales Invoice Line".FieldCaption("Unit Price"), C_BSS_INF007, C_BSS_INF008, C_BSS_INF009, '', '', C_BSS_TXT002, C_BSS_TXT001, "Sales Cr.Memo Line1".FieldCaption("Unit of Measure Code"), '');


                    //--BSS.IT_21246.SS
                    TotalProfitPercentage := 0;

                    //--BSS.IT_20894.CM
                end;

            end;
        }
        dataitem(Footer; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            MaxIteration = 1;
            column(Integer_ID; Integer_ID)
            {
            }
            column(TotalAmtForSales__TotalAmtForSalesCr; TotalAmtForSales - TotalAmtForSalesCr)
            {
            }
            column(TotalDisForSales_TotalDisForSalesCr; TotalDisForSales - TotalDisForSalesCr)
            {
            }
            column(C_BSS_INF017; C_BSS_INF017)
            {
            }
            column(TotalTaxForSales___TotalTaxForSalesCr; TotalTaxForSales - TotalTaxForSalesCr)
            {
            }
            column(TotalQtyForSales___TotalQtyForSalesCr; TotalQtyForSales - TotalQtyForSalesCr)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Integer_ID += 1;
            end;

            trigger OnPostDataItem()
            var
                NetTotalCost: Decimal;
                NetTotalProfitAmount: Decimal;
                NetTotalProfitPercentage: Decimal;
            begin
                if OnlyAdditionalSale or OnlyServiceReminderSent then
                    CurrReport.Skip;

                if ExportExcel then begin
                    //++BSS.IT_20894.CM
                    /*
                    IF PrintSummary THEN
                      MakeExcelDataBodyBold('','','','','',C_BSS_INF016,FORMAT(TotalQtyForSalesCr2),FORMAT(TotalDisForSalesCr2),
                        FORMAT(TotalTaxForSalesCr2),FORMAT(TotalAmtForSalesCr2),'','','','')
                    ELSE
                      MakeExcelDataBodyBold('','','','','','',C_BSS_INF016,FORMAT(TotalQtyForSalesCr2),'',FORMAT(TotalDisForSalesCr2),
                        FORMAT(TotalTaxForSalesCr2),FORMAT(TotalAmtForSalesCr2),'','');
                    MakeExcelDataBodyBold('','','','','','','','','','','','','','');
                    IF PrintSummary THEN
                      MakeExcelDataBodyBold('','','','','',C_BSS_INF017,FORMAT(TotalQtyForSales - TotalQtyForSalesCr2),
                        FORMAT(TotalDisForSales-TotalDisForSalesCr2),FORMAT(TotalTaxForSales - TotalTaxForSalesCr2),FORMAT(TotalAmtForSales - TotalAmtForSalesCr2),'','','','')
                    ELSE
                      MakeExcelDataBodyBold('','','','','','',C_BSS_INF017,FORMAT(TotalQtyForSales - TotalQtyForSalesCr2),'',
                        FORMAT(TotalDisForSales-TotalDisForSalesCr2),FORMAT(TotalTaxForSales - TotalTaxForSalesCr2),FORMAT(TotalAmtForSales - TotalAmtForSalesCr2),'','');
                    */

                    //++BSS.IT_21246.SS
                    /*
                      IF PrintSummary THEN
                        MakeExcelDataBodyBold('','','','','',C_BSS_INF016,FORMAT(TotalQtyForSalesCr2),FORMAT(TotalDisForSalesCr2),
                          FORMAT(TotalTaxForSalesCr2),FORMAT(TotalAmtForSalesCr2),FORMAT(TotalProfitAmountCrMemo2),FORMAT(TotalProfitPercentage),'','','','','')
                      ELSE
                        MakeExcelDataBodyBold('','','','','','',C_BSS_INF016,FORMAT(TotalQtyForSalesCr2),'',FORMAT(TotalDisForSalesCr2),
                          FORMAT(TotalTaxForSalesCr2),FORMAT(TotalAmtForSalesCr2),'','',FORMAT(TotalProfitAmountCrMemo2),FORMAT(TotalProfitPercentage),'');

                      MakeExcelDataBodyBold('','','','','','','','','','','','','','','','','');
                     */
                    if PrintSummary then
                        MakeExcelDataBodyBold('', '', '', '', '', C_BSS_INF016, Format(TotalQtyForSalesCr2), Format(TotalDisForSalesCr2),
                          Format(TotalTaxForSalesCr2), Format(TotalAmtForSalesCr2), Format(TotalProfitAmountCrMemo2), Format(TotalProfitPercentage), '', '', '', '', '', '')
                    else
                        MakeExcelDataBodyBold('', '', '', '', '', '', C_BSS_INF016, Format(TotalQtyForSalesCr2), '', Format(TotalDisForSalesCr2),
                          Format(TotalTaxForSalesCr2), Format(TotalAmtForSalesCr2), '', '', Format(TotalProfitAmountCrMemo2), Format(TotalProfitPercentage), '', '');

                    MakeExcelDataBodyBold('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
                    //--BSS.IT_21246.SS
                    NetTotalCost := TotalCostInvoice - TotalCostCrMemo - TotalCostCrMemo2;
                    NetTotalProfitAmount := (TotalAmtForSales - TotalTaxForSales - TotalCostInvoice) - (TotalAmtForSalesCr2 - TotalTaxForSalesCr2 - TotalCostCrMemo2) - (TotalAmtForSalesCr - TotalTaxForSalesCr - TotalCostCrMemo);
                    if NetTotalCost <> 0 then
                        NetTotalProfitPercentage := NetTotalProfitAmount / NetTotalCost * 100
                    else
                        NetTotalProfitPercentage := 100;
                    //++BSS.IT_21246.SS
                    /*
                      IF PrintSummary THEN
                        MakeExcelDataBodyBold('','','','','',C_BSS_INF017,FORMAT(TotalQtyForSales - TotalQtyForSalesCr2 - TotalQtyForSalesCr),
                          FORMAT(TotalDisForSales-TotalDisForSalesCr2-TotalDisForSalesCr),FORMAT(TotalTaxForSales - TotalTaxForSalesCr2 - TotalTaxForSalesCr),
                          FORMAT(TotalAmtForSales - TotalAmtForSalesCr2 - TotalAmtForSalesCr),
                          FORMAT(NetTotalProfitAmount),FORMAT(NetTotalProfitPercentage),'','','','','')
                      ELSE
                        MakeExcelDataBodyBold('','','','','','',C_BSS_INF017,FORMAT(TotalQtyForSales - TotalQtyForSalesCr2 - TotalQtyForSalesCr),'',
                          FORMAT(TotalDisForSales-TotalDisForSalesCr2-TotalDisForSalesCr),FORMAT(TotalTaxForSales - TotalTaxForSalesCr2 - TotalTaxForSalesCr),
                          FORMAT(TotalAmtForSales - TotalAmtForSalesCr2 - TotalAmtForSalesCr),'','',
                          FORMAT(NetTotalProfitAmount),FORMAT(NetTotalProfitPercentage),'');
                    //--BSS.IT_20894.CM
                    */
                    if PrintSummary then
                        MakeExcelDataBodyBold('', '', '', '', '', C_BSS_INF017, Format(TotalQtyForSales - TotalQtyForSalesCr2 - TotalQtyForSalesCr),
                          Format(TotalDisForSales - TotalDisForSalesCr2 - TotalDisForSalesCr), Format(TotalTaxForSales - TotalTaxForSalesCr2 - TotalTaxForSalesCr),
                          Format(TotalAmtForSales - TotalAmtForSalesCr2 - TotalAmtForSalesCr),
                          Format(NetTotalProfitAmount), Format(NetTotalProfitPercentage), '', '', '', '', '', '')
                    else
                        MakeExcelDataBodyBold('', '', '', '', '', '', C_BSS_INF017, Format(TotalQtyForSales - TotalQtyForSalesCr2 - TotalQtyForSalesCr), '',
                          Format(TotalDisForSales - TotalDisForSalesCr2 - TotalDisForSalesCr), Format(TotalTaxForSales - TotalTaxForSalesCr2 - TotalTaxForSalesCr),
                          Format(TotalAmtForSales - TotalAmtForSalesCr2 - TotalAmtForSalesCr), '', '',
                          Format(NetTotalProfitAmount), Format(NetTotalProfitPercentage), '', '');
                    //--BSS.IT_21246.SS
                end;

            end;

            trigger OnPreDataItem()
            begin
                Clear(Integer_ID);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Sales Period")
                    {
                        Caption = 'Sales Period';
                        field(StartDate; StartDate)
                        {
                            Caption = 'Starting Date';
                            ShowCaption = true;

                            trigger OnValidate()
                            begin
                                //++BSS.IT_21940.PW
                                if ExportExcel then
                                    //--BSS.IT_21940.PW
                                    //++BSS.IT_21547.PW
                                    ReportingFunctionsG.CalcDurationThreshold(StartDate, EndDate);
                                //--BSS.IT_21547.PW
                            end;
                        }
                        field(EndDate; EndDate)
                        {
                            Caption = 'Ending Date';
                            ShowCaption = true;

                            trigger OnValidate()
                            begin
                                //++BSS.IT_21940.PW
                                if ExportExcel then
                                    //--BSS.IT_21940.PW
                                    //++BSS.IT_21547.PW
                                    ReportingFunctionsG.CalcDurationThreshold(StartDate, EndDate);
                                //--BSS.IT_21547.PW
                            end;
                        }
                    }
                    field(PrintSummary; PrintSummary)
                    {
                        Caption = 'Summary';
                    }
                    field(OnlyAdditionalSale; OnlyAdditionalSale)
                    {
                        Caption = 'Only "Additional Sale"';
                    }
                    field(OnlyServiceReminderSent; OnlyServiceReminderSent)
                    {
                        Caption = 'Only "Sevice Rem. Sent"';
                    }
                    field(ExportExcel; ExportExcel)
                    {
                        Caption = 'Export to Excel';
                        Visible = false;

                        trigger OnValidate()
                        begin
                            //++BSS.IT_21940.PW
                            if ExportExcel then
                                ReportingFunctionsG.CalcDurationThreshold(StartDate, EndDate);
                            //--BSS.IT_21940.PW
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            //StartDate := WorkDate;
            //EndDate := WorkDate;
        end;
    }

    labels
    {
        PageCaptionLbl = 'Page';
        SalesCaptionLbl = 'Sales';
        BeschreibungCaptionLbl = 'Descripton';
        MengeCaptionLbl = 'Quantity';
        VK___PreisCaptionLbl = 'Unit Price';
        Betrag_inkl__MwSt_CaptionLbl = 'Amount Including VAT';
        Rabattbetrag_GesamtCaptionLbl = 'Total Discount Amount';
        SteuerbetragCaptionLbl = 'Tax Amount';
        Name_CaptionLbl = 'Name:';
        Sales_ReturnCaptionLbl = 'Sales Return';
        DescriptionCaptionLbl = 'Description';
        QuantityCaptionLbl = 'Quantity';
        Unit_PriceCaptionLbl = 'Unit Price';
        Amount_Including_TaxCaptionLbl = 'Amount Including Tax';
        Total_Discount_AmountCaptionLbl = 'Total Discount Amount';
        Tax_AmountCaptionLbl = 'Tax Amount';
        Cancellation_Against_CaptionLbl = 'Cancellation Against.';
        Name_Caption_Control1100023010Lbl = 'Name:';
        StornierungCaptionLbl = 'Cancellation';
        DescriptionCaption_Control1100023015Lbl = 'Description';
        QuantityCaption_Control1100023016Lbl = 'Quantity';
        Unit_PriceCaption_Control1100023017Lbl = 'Unit Price';
        Amount_Including_TaxCaption_Control1100023018Lbl = 'Amount Including Tax';
        Total_Discount_AmountCaption_Control1100023019Lbl = 'Total Discount Amount';
        Tax_AmountCaption_Control1100023021Lbl = 'Tax Amount';
        Cancellation_Against_Caption_Control1100023026Lbl = 'Cancellation Against.';
        Name_Caption_Control1100023028Lbl = 'Name:';
        Additional_Sale = 'Add. Sale';
        Service_Reminder_Sent = 'Service Rem. Sent';
        Additional_Sale_Amount = 'Add. Sales Amount';
    }

    trigger OnPostReport()
    begin
        if ExportExcel then
            CreateExcelBook;

        //++BSS.TFS_14781.CM
        OnAfterPostReport();
        //--BSS.TFS_14781.CM
    end;

    trigger OnPreReport()
    begin
        "Sales Invoice Header".SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
        DocNo := "Sales Invoice Header".GetFilter("No.");
        Gvtype := "Sales Invoice Line".GetFilter(Type);
        Evaluate(Gvtype1, Gvtype);
        ItemCategory := "Sales Invoice Line".GetFilter("Item Category Code");
        Desc1 := "Sales Invoice Line".GetFilter(Description);
        SellCustNo := "Sales Invoice Header".GetFilter("Sell-to Customer No.");

        Filters := "Sales Invoice Header".GetFilters + ' ' + "Sales Invoice Line".GetFilters;

        CompanyInfo.Get;
        CompanyInfo.CalcFields(CompanyInfo.Picture);

        if ExportExcel then
            MakeExcelInfo;
    end;

    var
        PrintSummary: Boolean;
        UnitPrice: Decimal;
        StartDate: Date;
        EndDate: Date;
        TotalQtyForSales: Decimal;
        TotalDisForSales: Decimal;
        TotalAmtForSales: Decimal;
        TotalQtyForSalesCr: Decimal;
        TotalDisForSalesCr: Decimal;
        TotalAmtForSalesCr: Decimal;
        Desc: Text[102];
        ReturnReason: Record "Return Reason";
        Gvtype1: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        ItemCategory: Code[20];
        Desc1: Text[100];
        Gvtype: Text[30];
        PostedCashRegLine: Record "Posted Cash Register Line";
        PaymentMode: Text;
        CustName: Text[100];
        TotalTaxForSales: Decimal;
        TotalTaxForSalesCr: Decimal;
        DocNo: Code[20];
        ApplyInvDesc: Text[100];
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesInvLine: Record "Sales Invoice Line";
        NoofRec: Integer;
        NoofRecCr: Integer;
        TINNo: Code[20];
        Customer: Record Customer;
        TINNoText: Text[50];
        SellCustNo: Code[250];
        BillCustNo: Code[20];
        CompanyInfo: Record "Company Information";
        ServCenter: Record "Service Center";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[100];
        C_BSS_INF001: Label 'Daily Sales Register';
        Filters: Text[1024];
        SCMgt: Codeunit "Service Center Management";
        ExcelBuf: Record "Excel Buffer" temporary;
        ExportToXL: Boolean;
        ExportExcel: Boolean;
        PrintOptionCaption: Text[50];
        PrintToCSV: Boolean;
        GeneralFunctions: Codeunit "General Functions";
        C_BSS_INF002: Label 'Company Name';
        C_BSS_INF003: Label 'Report Name';
        C_BSS_INF004: Label 'Sales';
        C_BSS_INF005: Label 'Sales Return';
        C_BSS_INF006: Label 'Cancellation';
        C_BSS_INF007: Label 'Total Discount Amount';
        C_BSS_INF008: Label 'Tax Amount';
        C_BSS_INF009: Label 'Amount Including VAT';
        C_BSS_INF010: Label 'No./Date:';
        C_BSS_INF011: Label 'Total';
        C_BSS_INF012: Label 'Grand Total for Sales';
        C_BSS_INF013: Label 'No./Date:';
        C_BSS_INF014: Label 'Return Reason:';
        C_BSS_INF015: Label 'Grand Total for Sales Return';
        C_BSS_INF016: Label 'Grand Total for Cancellation';
        C_BSS_INF017: Label 'Net Total';
        DontPrintSalesReturnHdr: Boolean;
        DontPrintCancellationHdr: Boolean;
        DontPrintSalesHdr: Boolean;
        OnlyCancelOfInvoice: Boolean;
        Integer_ID: Integer;
        Sales_Invoice_Header_ID: Integer;
        Sales_Invoice_Line_ID: Integer;
        Sales_Cr_Memo_Header_ID: Integer;
        Sales_Cr_Memo_Line_ID: Integer;
        Sales_Cr_Memo_Header1_ID: Integer;
        Sales_Cr_Memo_Line1_ID: Integer;
        OnlyAdditionalSale: Boolean;
        AdditionalSaleFlagTotalDocument: Integer;
        AdditionalSaleFlagTotaSales: Integer;
        TotalQtyForDoc: Decimal;
        TotalDisForDoc: Decimal;
        TotalAmtForDoc: Decimal;
        TotalTaxForDoc: Decimal;
        TotalQtyForSalesCr2: Decimal;
        TotalDisForSalesCr2: Decimal;
        TotalAmtForSalesCr2: Decimal;
        TotalTaxForSalesCr2: Decimal;
        C_BSS_INF018: Label 'Name';
        C_BSS_INF019: Label 'Licence Plate No';
        C_BSS_INF020: Label 'Invoice No.';
        C_BSS_INF021: Label 'Date';
        C_BSS_INF022: Label 'Service Rem. Sent';
        OnlyServiceReminderSent: Boolean;
        ServiceRemSentTotalSales: Integer;
        ReturnReasonText: Text;
        C_BSS_TXT001: Label 'Profit %';
        C_BSS_TXT002: Label 'Profit Amount';
        LineCost: Decimal;
        DocumentCost: Decimal;
        ProfitAmount: Decimal;
        ProfitAmountDocument: Decimal;
        ProfitPercentage: Decimal;
        ProfitPercentageDocument: Decimal;
        TotalProfitPercentage: Decimal;
        TotalCostInvoice: Decimal;
        TotalCostCrMemo: Decimal;
        TotalCostCrMemo2: Decimal;
        TotalProfitAmountInvoice: Decimal;
        TotalProfitAmountCrMemo: Decimal;
        TotalProfitAmountCrMemo2: Decimal;
        AdditionalTotalProfitAmountInvoice: Decimal;
        AdditionalDocumentProfitAmountInvoice: Decimal;
        C_BSS_TXT003: Label 'Add.Sales Amount';
        AdditionalAmountLine: Decimal;
        ReportingFunctionsG: Codeunit "Reporting Functions";
        AdditionalSaleInteger: Integer;
        C_BSS_TXT004: Label 'Balance:';
        CashPaymentMethod: Boolean;

    [Scope('OnPrem')]
    procedure MakeExcelInfo()
    begin
        //++BSS.IT_21698.1CF
        //ExcelBuf.SetUseInfoSheet;
        //ExcelBuf.AddInfoColumn(FORMAT(C_BSS_INF002),FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.AddInfoColumn(COMPANYNAME,FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.NewRow;
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn(FORMAT(C_BSS_INF003),FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.AddInfoColumn(FORMAT(C_BSS_INF001),FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn('Printed on',FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.AddInfoColumn(TODAY,FALSE,'',TRUE,FALSE,FALSE,'',1);
        //
        //
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn('Printed By',FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.AddInfoColumn(USERID, FALSE,'',FALSE,FALSE,FALSE,'',1);

        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(Format(C_BSS_INF002), false, true, false, false, '', 1);
        ExcelBuf.AddInfoColumn(CompanyName, false, true, false, false, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(C_BSS_INF003), false, true, false, false, '', 1);
        ExcelBuf.AddInfoColumn(Format(C_BSS_INF001), false, true, false, false, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn('Printed on', false, true, false, false, '', 1);
        ExcelBuf.AddInfoColumn(Today, false, true, false, false, '', 1);


        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn('Printed By', false, true, false, false, '', 1);
        ExcelBuf.AddInfoColumn(UserId, false, false, false, false, '', 1);
        //--BSS.IT_21698.1CF

        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.AddColumn(C_BSS_INF001 + '(' + CopyStr(CurrReport.ObjectId(false), 8) + ')', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(Today, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(Time, false, '', false, false, false, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CompanyInfo.Name + ' ' + CompanyInfo."Name 2", false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(UserId, false, '', false, false, false, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Filters, false, '', false, false, false, '', 1);
        ExcelBuf.NewRow;
    end;

    [Scope('OnPrem')]
    procedure CreateExcelBook()
    var
        FileNameL: Text;
    begin
        //++BSS.IT_20913.SG
        //ExcelBuf.CreateBookAndOpenExcel(C_BSS_INF002,C_BSS_INF003,COMPANYNAME,USERID);
        ExcelBuf.CreateBookAndOpenExcel(FileNameL, C_BSS_INF002, C_BSS_INF003, CompanyName, UserId);
        //--BSS.IT_20913.SG
    end;

    [Scope('OnPrem')]
    procedure MakeExcelDataBody(par1: Text[150]; par2: Text[150]; par3: Text[150]; par4: Text[150]; par5: Text[150]; par6: Text[150]; par7: Text[150]; par8: Text[150]; par9: Text; par10: Text; par11: Text; par12: Text; par13: Text; par14: Text; par15: Text; par16: Text; par17: Text; par18: Text)
    var
        BlankFiller: Text[250];
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(par1, false, '', false, false, false, '', 0);
        ExcelBuf.AddColumn(par2, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par3, false, '', false, false, false, '', 0);
        ExcelBuf.AddColumn(par4, false, '', false, false, false, '', 0);
        ExcelBuf.AddColumn(par5, false, '', false, false, false, '', 0);
        ExcelBuf.AddColumn(par6, false, '', false, false, false, '', 0);
        ExcelBuf.AddColumn(par7, false, '', false, false, false, '0.00', 0);
        //++BSS.IT_20894.CM
        ExcelBuf.AddColumn(par17, false, '', false, false, false, '0.00', 0);
        //--BSS.IT_20894.CM
        ExcelBuf.AddColumn(par8, false, '', false, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par9, false, '', false, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par10, false, '', false, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par11, false, '', false, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par12, false, '', false, false, false, '0.00', 0);
        //++BSS.IT_20894.CM
        ExcelBuf.AddColumn(par15, false, '', false, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par16, false, '', false, false, false, '0.00', 0);
        //--BSS.IT_20894.CM
        ExcelBuf.AddColumn(par13, false, '', false, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par14, false, '', false, false, false, '0.00', 0);

        //++BSS.IT_21246.SS
        ExcelBuf.AddColumn(par18, false, '', false, false, false, '0.00', 0);
        //--BSS.IT_21246.SS
    end;

    [Scope('OnPrem')]
    procedure MakeExcelDataBodyBold(par1: Text[150]; par2: Text[150]; par3: Text[150]; par4: Text[150]; par5: Text[150]; par6: Text[150]; par7: Text[150]; par8: Text[150]; par9: Text; par10: Text; par11: Text; par12: Text; par13: Text; par14: Text; par15: Text; par16: Text; par17: Text; par18: Text)
    var
        BlankFiller: Text[250];
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(par1, false, '', true, false, false, '', 0);
        ExcelBuf.AddColumn(par2, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par3, false, '', true, false, false, '', 0);
        ExcelBuf.AddColumn(par4, false, '', true, false, false, '', 0);
        ExcelBuf.AddColumn(par5, false, '', true, false, false, '', 0);
        ExcelBuf.AddColumn(par6, false, '', true, false, false, '', 0);
        ExcelBuf.AddColumn(par7, false, '', true, false, false, '0.00', 0);
        //++BSS.IT_20894.CM
        ExcelBuf.AddColumn(par17, false, '', true, false, false, '', 0);
        //--BSS.IT_20894.CM
        ExcelBuf.AddColumn(par8, false, '', true, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par9, false, '', true, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par10, false, '', true, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par11, false, '', true, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par12, false, '', true, false, false, '0.00', 0);
        //++BSS.IT_20894.CM
        ExcelBuf.AddColumn(par15, false, '', true, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par16, false, '', true, false, false, '0.00', 0);
        //--BSS.IT_20894.CM
        ExcelBuf.AddColumn(par13, false, '', true, false, false, '0.00', 0);
        ExcelBuf.AddColumn(par14, false, '', true, false, false, '0.00', 0);
        //++BSS.IT_21246.SS
        ExcelBuf.AddColumn(par18, false, '', true, false, false, '0.00', 0);
        //--BSS.IT_21246.SS
    end;

    local procedure __EVENTS__()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostReport()
    begin
    end;
}

