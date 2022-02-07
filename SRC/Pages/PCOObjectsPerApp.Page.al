page 50131 "PCO Objects per App"
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
            part(AppObjedcts; "PCO Application Objects")
            {
                ApplicationArea = All;
                SubPageLink = "App Package ID" = field("Package Id");
            }
        }
    }
}