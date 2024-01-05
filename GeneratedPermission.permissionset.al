permissionset 50000 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata "Appointment Header" = RIMD,
        table "Appointment Header" = X,
        report "Daily Sales Register-MK" = X,
        report POImportLine = X,
        report "Vehicle Check Report-MK" = X,

        page "Appointment List" = X,
        page AppointmentCard = X;
}