page 50130 "OVW Object Viewer"
{
    Caption = 'Object Viewer';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = AllObjWithCaption;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    PromotedActionCategories = 'Filters,Processing';
    SourceTableView = where("Object Type" = filter("Table" | "Page" | "Codeunit" | "Report"),
                            "Object ID" = filter(< 2000000000));
    Permissions = tabledata AllObjWithCaption = r;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the object.';
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the object.';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the object.';
                }
                field("Object Caption"; Rec."Object Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the language-specific caption of the object.';
                }
                field("Object Subtype"; Rec."Object Subtype")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subtype of the object.';
                    Visible = false;
                }
                field("App Package Name"; GetAppPackageName())
                {
                    ApplicationArea = All;
                    Caption = 'App Name';
                    ToolTip = 'Specifies the name of the name of the app that the object belongs to.';
                }
                field(RecordCount; GetRecordCount(Rec."Object Type", Rec."Object ID"))
                {
                    ApplicationArea = All;
                    Caption = 'Record Count';
                    ToolTip = 'Specifies the number of records in the table for the current company.';
                    BlankZero = true;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunObject)
            {
                ApplicationArea = All;
                Caption = 'Run Object';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RunApplicationObject();
                end;
            }

            action(ExportToExcel)
            {
                ApplicationArea = All;
                Caption = 'Export To Excel';
                ToolTip = 'The records of this table will be exported to Excel';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Enabled = Rec."Object Type" = Rec."Object Type"::Table;

                trigger OnAction();
                begin
                    DoExportToExcel();
                end;
            }
        }
        area(Navigation)
        {
            action(ShowAll)
            {
                ApplicationArea = All;
                Caption = 'Show All';
                Image = Start;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Rec.SetRange("Object Type");
                end;
            }
            action(ShowTables)
            {
                ApplicationArea = All;
                Caption = 'Show Tables';
                Image = "Table";
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Rec.SetRange("Object Type", Rec."Object Type"::Table);
                end;
            }
            action(ShowPages)
            {
                ApplicationArea = All;
                Caption = 'Show Pages';
                Image = ViewPage;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Rec.SetRange("Object Type", Rec."Object Type"::Page);
                end;
            }
            action(ShowCodeunits)
            {
                ApplicationArea = All;
                Caption = 'Show Codeunits';
                Image = Setup;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Rec.SetRange("Object Type", Rec."Object Type"::Codeunit);
                end;
            }
            action(RunReports)
            {
                ApplicationArea = All;
                Caption = 'Show Reports';
                Image = Report;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Rec.SetRange("Object Type", Rec."Object Type"::Report);
                end;
            }
        }
    }

    local procedure GetAppPackageName(): Text
    var
        NAVAppInstalledApp: Record "NAV App Installed App";
        InsufficientReadPermissionsMsg: Label 'Insufficient read permissions.';
        UnknownAppMsg: Label '--- Unknown ---';
        AppInfo: ModuleInfo;
    begin
        if not NAVAppInstalledApp.ReadPermission() then
            exit(InsufficientReadPermissionsMsg);
        NAVAppInstalledApp.SetRange("Package ID", Rec."App Package ID");
        if NAVAppInstalledApp.FindFirst() then
            if NavApp.GetModuleInfo(NAVAppInstalledApp."App ID", AppInfo) then
                exit(AppInfo.Name);
        exit(UnknownAppMsg);
    end;

    local procedure RunApplicationObject()
    var
        PCOObjectManagement: Codeunit "OVW Object Management";
    begin
        PCOObjectManagement.RunApplicationObject(Rec);
    end;

    local procedure GetRecordCount(ForObjectType: Option; ForObjectID: Integer): Integer
    var
        OVWRecordCountMgt: Codeunit "OVW Record Count Mgt.";
    begin
        if ForObjectType <> Rec."Object Type"::Table then
            exit;
        exit(OVWRecordCountMgt.GetRecordCount(ForObjectID));
    end;

    local procedure DoExportToExcel()
    var
        OVWExporttoExcel: Codeunit "OVW Export to Excel";
        NoTableErr: Label 'Export is only possible for object type Table';
    begin
        if Rec."Object Type" <> Rec."Object Type"::Table then
            Error(NoTableErr);

        OVWExporttoExcel.ExportRecordToExcel(Rec."Object ID");
    end;
}