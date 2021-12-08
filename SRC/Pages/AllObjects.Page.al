page 50130 "PCO All Objects"
{
    Caption = 'Object Management';
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
                field("App Package ID"; Rec."App Package ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the object.';
                    Visible = false;
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
        AppInfo: ModuleInfo;
    begin
        if NavApp.GetModuleInfo(Rec."App Package ID", AppInfo) then
            exit(AppInfo.Name);
    end;

    local procedure GetObjectType(ObjectTypeOption: Option): ObjectType
    begin
        case ObjectTypeOption of
            Rec."Object Type"::Table:
                exit(ObjectType::Table);
            Rec."Object Type"::Page:
                exit(ObjectType::Page);
            Rec."Object Type"::Codeunit:
                exit(ObjectType::Codeunit);
            Rec."Object Type"::Report:
                exit(ObjectType::Report);
        end;
    end;

    local procedure RunApplicationObject()
    var
        Url: Text;
    begin
        Url := GetUrl(ClientType::Web, CompanyName(), GetObjectType(Rec."Object Type"), Rec."Object ID");
        if Url <> '' then
            Hyperlink(Url);
    end;
}