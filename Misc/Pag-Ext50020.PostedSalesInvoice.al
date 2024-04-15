pageextension 50020 PostedSalesInvoice extends "Posted Sales Invoices"
{
    layout
    {

        addafter("No.")
        {
            field("Your Reference"; rec."Your Reference")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Your Reference', KOR = '미쉐린 멤버쉽 번호';
            }
        }


    }
}
