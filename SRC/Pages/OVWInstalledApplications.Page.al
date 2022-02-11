page 50132 "OVW Installed Applications"
{
    PageType = ListPart;
    Caption = 'Installed Applications';
    SourceTable = "NAV App Installed App";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(RepeaterControl)
            {
                Caption = 'General';
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the app you want to see the objects for.';
                }
                field(Publisher; Rec.Publisher)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the publisher of the app you want to see the objects for.';
                }
            }
        }
    }
}