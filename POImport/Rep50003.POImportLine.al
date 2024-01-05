report 50003 POImportLine
{
    Caption = 'MK PO Import Report';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Integer;
        Integer)
        {
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, 1);
                AnalyzeData();
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    CaptionML = ENU = 'Options', KOR = '옵션';

                    field(FileNameG; FileNameG)
                    {
                        Editable = false;
                        CaptionML = ENU = 'Workbook File Name', KOR = '워크북 파일 이름';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            FileNameOnAfterValidate();
                        end;

                        trigger OnAssistEdit()
                        begin
                            RequestFile();
                            SheetNameG := ExcelBufG.SelectSheetsName(ServerFileNameG);
                        end;
                    }
                    field(SheetNameG; SheetNameG)
                    {
                        CaptionML = ENU = 'Worksheet Name', KOR = '워크시트 이름';
                        ApplicationArea = All;
                        Editable = false;
                        trigger OnAssistEdit()
                        begin
                            if ServerFileNameG = '' then
                                RequestFile();
                            SheetNameG := ExcelBufG.SelectSheetsName(ServerFileNameG);
                        end;
                    }

                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    local procedure AnalyzeData()
    var
        SkipL: Boolean;
    begin
        Window.OPEN(
          Text007 +
          '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.UPDATE(1, 0);

        TotalRecNo := ExcelBufG.COUNT;
        RecNo := 0;
        CLEAR(Lastentry);
        PurchLineG.RESET;
        PurchLineG.SETRANGE("Document No.", PurchHDRG."No.");
        IF PurchLineG.FINDLAST THEN
            Lastentry := PurchLineG."Line No." + 10000
        ELSE
            Lastentry := 10000;

        ExcelBufG.SETFILTER(ExcelBufG."Row No.", '>2');
        IF ExcelBufG.FINDSET THEN BEGIN
            REPEAT
                RecNo := RecNo + 1;
                Window.UPDATE(1, ROUND(RecNo / TotalRecNo * 10000, 1));

                CASE ExcelBufG.xlColID OF
                    'A':
                        BEGIN //Read Item
                            CLEAR(EasyPO);
                            CLEAR(CAINO);
                            CLEAR(DescriptionG);
                            CLEAR(Qty);
                            CLEAR(DirectCost);
                            CLEAR(Description2G);
                            EVALUATE(EasyPO, ExcelBufG."Cell Value as Text");
                            PurchHDRG."Vendor Order No." := EasyPO;
                            PurchHDRG.MODIFY;
                        END;
                    'G':
                        BEGIN //Clear all fields, Read LineTYpe

                            EVALUATE(CAINO, ExcelBufG."Cell Value as Text");
                        END;
                    'L':
                        BEGIN //Read Item
                            EVALUATE(DirectCost, ExcelBufG."Cell Value as Text");
                        END;
                    'M':
                        BEGIN //Read Item
                            EVALUATE(Qty, ExcelBufG."Cell Value as Text");
                        END;
                    'O':
                        BEGIN //Read Item

                            EVALUATE(DescriptionG, ExcelBufG."Cell Value as Text");
                        END;
                    'Q':
                        BEGIN //Read Description2
                            if CAINO <> '' then begin
                                EVALUATE(Description2G, ExcelBufG."Cell Value as Text");
                                PurchLineG.RESET;
                                PurchLineG.SETRANGE("Document No.", PurchHDRG."No.");
                                IF PurchLineG.FINDSET THEN BEGIN
                                    PurchLineG.INIT;
                                    PurchLineG."Document Type" := PurchLineG."Document Type"::Order;
                                    PurchLineG."Document No." := PurchHDRG."No.";
                                    PurchLineG."Line No." := Lastentry;
                                    PurchLineG.Type := PurchLineG.Type::Item;
                                    PurchLineG.INSERT;
                                    PurchLineG.VALIDATE("No.", CAINO);
                                    PurchLineG.VALIDATE(Quantity, Qty);
                                    PurchLineG.VALIDATE("Direct Unit Cost", DirectCost);
                                    PurchLineG."Description 2" := DescriptionG + ' / ' + Description2G;
                                    PurchLineG.MODIFY();
                                END ELSE BEGIN
                                    PurchLineG.INIT;
                                    PurchLineG."Document Type" := PurchLineG."Document Type"::Order;
                                    PurchLineG."Document No." := PurchHDRG."No.";
                                    PurchLineG."Line No." := Lastentry;
                                    PurchLineG.Type := PurchLineG.Type::Item;
                                    PurchLineG.INSERT;
                                    PurchLineG.VALIDATE("No.", CAINO);
                                    PurchLineG.VALIDATE(Quantity, Qty);
                                    PurchLineG.VALIDATE("Direct Unit Cost", DirectCost);
                                    PurchLineG."Description 2" := DescriptionG + ' / ' + Description2G;
                                    PurchLineG.MODIFY();
                                END;
                                Lastentry += 10000;
                            end;

                        END;

                END;

            UNTIL ExcelBufG.NEXT = 0;

        END;

        Window.CLOSE;
    end;

    procedure RequestFile()
    begin
        IF FileNameG <> '' THEN
            ServerFileNameG := FileMgtG.UploadFile(Text006, FileNameG)
        ELSE
            ServerFileNameG := FileMgtG.UploadFile(Text006, '.xlsx');

        ValidateServerFileName;
        FileNameG := FileMgtG.GetFileName(ServerFileNameG);
    end;

    LOCAL PROCEDURE FileNameOnAfterValidate();
    BEGIN
        RequestFile();
    END;

    LOCAL PROCEDURE ValidateServerFileName();
    BEGIN
        IF ServerFileNameG = '' THEN BEGIN
            FileNameG := '';
            SheetNameG := '';
            ERROR(Text029);
        END;
    END;

    PROCEDURE SetServParameter(PurchHdrP: Record "Purchase Header");
    BEGIN
        CLEAR(PurchHDRG);
        PurchHDRG := PurchHdrP;
    END;

    trigger OnPreReport()
    begin
        ExcelBufG.OpenBook(ServerFileNameG, SheetNameG);
        ExcelBufG.ReadSheet;
    end;

    trigger OnPostReport()
    begin
        ExcelBufG.DELETEALL;
    end;


    var
        ExcelBufG: Record "Excel Buffer" temporary;
        FileMgtG: Codeunit "File Management";
        ServerFileNameG: Text;
        FileNameG: Text;
        SheetNameG: Text;
        TotalRecNo: Integer;
        RecNo: Integer;
        Window: Dialog;
        Description: Text;
        ExcelBuf_ErrG: Record "Excel Buffer" temporary;
        Text000: TextConst ENU = 'You must specify a budget name to import to.', KOR = '내보내기 대상에 대한 예산 이름을 명시 하세요.';
        Text001: TextConst ENU = 'Do you want to create a %1 with the name %2?', KOR = '이름 %2 %1을 생성 하시겠습니까?';
        Text002: TextConst ENU = '%1 %2 is blocked. You cannot import entries.', KOR = '%1 %2 는 잠김 되었습니다. 기장을 불러오기 할 수 없습니다.';
        Text004: TextConst ENU = '%1 table has been successfully updated with %2 entries.', KOR = '%1 테이블은 %2 기장과 함께 성공적으로 업데이트 되었습니다.';
        Text005: TextConst ENU = '"Imported from Excel "', KOR = '"불러오기 대상 엑셀 "';
        Text006: TextConst ENU = 'Import Excel File', KOR = '불러오기 엑셀 파일';
        Text007: TextConst ENU = 'Analyzing Data...\\', KOR = '데이터 분석중...\\';
        Text029: TextConst ENU = 'You must enter a file name.', KOR = '파일 이름을 입력 해야 합니다.';
        GVTC_TXT0000: TextConst ENU = 'Order No. does not exist.', KOR = '주문 번호는 필수 조건 값입니다.';
        GVTC_TXT00002: TextConst ENU = 'There''s an error.\Please check the error log excel and try again!', KOR = '업로드 데이터에 에러가 존재하여 작업을 진행할 수 없습니다..\ - EXCEL 파일을 확인해주세요!';
        GVTC_TXT00003: TextConst ENU = 'There is an error in the upload data.', KOR = '업로드 완료!';
        GVTC_Head0001: TextConst KOR = '품목번호';
        GVTC_Head0002: TextConst KOR = '에러';
        GVTC_FILE0001: TextConst ENU = 'Error Data', KOR = '에러 데이터';
        GVTC_FILE0002: TextConst ENU = 'Sales Line', KOR = '서비스 품목 라인';
        GVTC_Err0001: TextConst ENU = '품목 목록에 존재하지 않습니다.', KOR = '아래 품목은 품목 목록에 존재하지 않습니다.';
        INC_TC_Item: TextConst ENU = '부품', KOR = '부품';
        INC_TC_Item1: TextConst ENU = '부품', KOR = '품목';
        Text015: TextConst ENU = '%1 item(s) has not been successfully added because they were not in the Item Master table.\\ Items %2.', KOR = '품목 마스터에 존재하지 않기 때문에 %1 부품(들)은 불러와지지 않았습니다.\\ 부품 %2.';
        Text300: TextConst ENU = 'Type(Part(1)/Labor) **Service Only** |  Item No.  | Description 2 |  Quantity', KOR = '유형(부품/공임) **서비스문서만 적용**  |  부품/공임 번호  |  적요2  | 수량';
        Text301: TextConst ENU = 'Posting Date | Document No. | Reason Code | Item No. | Quantity | Unit Cost', KOR = '기장 일자 | 문서 번호 | 사유 코드 | 품목 번호 | 수량 | 단위 원가';
        Text302: TextConst ENU = 'Item No. | Shelf No.', KOR = '품목 번호 | 선반 번호(적재 위치)';
        CallPageG: Integer;
        ErrText001: TextConst ENU = 'Item No. Error', KOR = '품번 에러';
        ErrText002: TextConst ENU = 'Item No. and Quantity Error', KOR = '품번 및 수량 에러';
        ErrText003: TextConst ENU = 'Dose not exist Item No.', KOR = '품번 없음';
        ErrText004: TextConst ENU = 'Does not exist Item No. and Quantity Error', KOR = '품번 없음 및 수량 에러';
        ErrText005: TextConst ENU = 'Quantity Error', KOR = '수량 에러';
        ErrText006: TextConst ENU = 'Does not exist Purchase Order.', KOR = '발주 없음';
        ErrText007: TextConst ENU = 'Does not exist Purchase Order and Item No.', KOR = '발주 없음';
        ItemJnlTemplateNameG: Code[20];
        ItemJnlBatchNameG: Code[20];
        CAINO: Code[20];
        DescriptionG: Text;
        Description2G: Text;
        Qty: Decimal;
        DirectCost: Decimal;
        PurchHDRG: Record 38;
        Lastentry: Integer;
        PurchLineG: Record 39;
        EasyPO: Code[20];
}
