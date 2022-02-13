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
    SourceTableView = where("Object Type" = filter("Table" | "Page" | "Codeunit" | "Report"));

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
}