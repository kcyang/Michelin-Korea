tableextension 50020 MKValueEntry extends "Value Entry"
{
    fields
    {
        field(50000; "Your Reference"; Text[35])
        {
            CaptionML = ENU = 'Your Reference', KOR = '미쉐린 멤버쉽 번호';
            FieldClass = FlowField;
            //DataClassification = ToBeClassified;
            CalcFormula = lookup("Sales Invoice Header"."Your Reference" where("No." = field("Document No.")));


        }
        field(50001; "Item Category Code"; Code[20])
        {
            CaptionML = ENU = 'Item Category Code', KOR = '품목 카테고리 코드';
            FieldClass = FlowField;
            //DataClassification = ToBeClassified;
            CalcFormula = lookup("Item"."Item Category Code" where("No." = field("Item No.")));


        }

    }




}
