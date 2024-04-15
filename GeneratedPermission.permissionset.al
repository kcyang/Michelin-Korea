permissionset 50000 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata "Appointment Header" = RIMD,
        table "Appointment Header" = X,
        report "Daily Sales Register-MK" = X,
        report POImportLine = X,
        report "Vehicle Check Report-MK" = X,
        page "Appointment List" = X,
        page AppointmentCard = X,
        tabledata OCRLog = RIMD,
        tabledata OCRWebSetup = RIMD,
        tabledata "Vehicle Parts Details" = RIMD,
        tabledata "Vehicle Spec  Information" = RIMD,
        table OCRLog = X,
        table OCRWebSetup = X,
        table "Vehicle Parts Details" = X,
        table "Vehicle Spec  Information" = X,
        codeunit "Ext Integration" = X,
        page "OCR Log List" = X,
        page "OCR Vehicle InformationConfirm" = X,
        page OCRWebSetup = X,
        page "Part Detail List" = X,
        page "Vehicle Spec Inforamations" = X,
        page VehRegCardPicture = X,
        page "My Appointment List" = X;
}