page 50131 "OVW Objects per App"
{
    PageType = ListPlus;
    Caption = 'Objects per App';
    ApplicationArea = All;
    UsageCategory = Lists;
    DataCaptionFields = Name;
    SourceTable = "NAV App Installed App";
    DataCaptionExpression = Rec.Name;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                repeater(Apps)
                {
                    field(Name; Rec.Name)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the name of the extension.';
                    }
                    field(Publisher; Rec.Publisher)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the publisher of the app you want to see the objects for.';
                    }
                    field("Published As"; Rec."Published As")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies how the app was published. This might affect the options you have for app management.';
                    }
                }
            }
            part(AppObjedcts; "OVW Application Objects")
            {
                ApplicationArea = All;
                SubPageLink = "App Package ID" = field("Package Id");
            }
        }

        area(FactBoxes)
        {
            part(DependsOn; "OVW Depends On - Factbox")
            {
                SubPageLink = "App Id" = field("App ID");
            }
            part(DependedOnBy; "OVW Depended On By - Factbox")
            {
                SubPageLink = "Dependent App Id" = field("App ID");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CompareObjects)
            {
                ApplicationArea = All;
                Caption = 'Compare Objects';
                Image = CompareCOA;
                ToolTip = 'Opens the object comparison screen which enables you to import and compare objects of two different versions.';
                Ellipsis = true;
                ObsoleteState = Pending;
                ObsoleteReason = 'This functionality has been marked as obsolete and will be removed. This warning will become an error in a later version.';
                ObsoleteTag = '1.2';
                RunObject = Page "OVW Compare Objects";
                RunPageOnRec = true;
            }
            group(PermissionsSetsGroup)
            {
                Caption = 'Permission Sets';
                Image = Permission;

                action(GeneratePermissionSet)
                {
                    ApplicationArea = All;
                    Caption = 'Generate Permission Set';
                    Image = Permission;
                    ToolTip = 'Generate a legacy permission set for this app. Legacy permission sets are used in Business Central versions up to and including Business Central 2020 release wave 2.';

                    trigger OnAction()
                    var
                        OVWPermissionSetGenerator: Codeunit "OVW Permission Set Generator";
                    begin
                        OVWPermissionSetGenerator.Run(Rec);
                    end;
                }

                action(GenerateTenantPermissionSet)
                {
                    ApplicationArea = All;
                    Caption = 'Generate Tenant Permission Set';
                    Image = Permission;
                    ToolTip = 'Generate a tenant permission set for this app. Tenant permission sets are used in Business Central 2021 release wave 1 and later versions.';

                    trigger OnAction()
                    var
                        OVWTenantPermSetGenerator: Codeunit "OVW Tenant Perm. Set Generator";
                    begin
                        OVWTenantPermSetGenerator.Run(Rec);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        InitDependencyTable();
    end;

    local procedure InitDependencyTable()
    var
        OVWDependencyManagement: Codeunit "OVW Dependency Management";
    begin
        OVWDependencyManagement.Run();
    end;
}