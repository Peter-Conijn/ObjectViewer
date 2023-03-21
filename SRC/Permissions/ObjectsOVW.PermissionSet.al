permissionset 50130 "OVW - Objects"
{
    Assignable = false;
    Access = Internal;

    Permissions = tabledata "OVW Object Comparison" = RIMD,
        table "OVW Object Comparison" = X,
        codeunit "OVW Comparison Management" = X,
        codeunit "OVW Object Management" = X,
        codeunit "OVW Permission Set Generator" = X,
        codeunit "OVW Record Count Mgt." = X,
        xmlport "OVW Object Data I/O" = X,
        page "OVW Application Objects" = X,
        page "OVW Compare Objects" = X,
        page "OVW Installed Applications" = X,
        page "OVW Object Comparison" = X,
        page "OVW Object Viewer" = X,
        page "OVW Objects per App" = X,
        tabledata "OVW App Dependency" = RIMD,
        table "OVW App Dependency" = X,
        codeunit "OVW Dependency Management" = X,
        codeunit "OVW Download Handler" = X,
        codeunit "OVW Tenant Perm. Set Generator" = X,
        page "OVW Depended On By - Factbox" = X,
        page "OVW Depends On - Factbox" = X,
        codeunit "OVW Export to Excel" = X;
}