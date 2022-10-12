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
}