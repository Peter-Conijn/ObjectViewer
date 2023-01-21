permissionset 50131 "OVW - Execute"
{
    Assignable = true;
    Access = Public;
    Caption = 'Object Viewer - Execute', MaxLength = 30;

    IncludedPermissionSets =
        "OVW - Objects";

    Permissions =
        tabledata "NAV App Installed App" = R,
        tabledata AllObjWithCaption = R;
}
