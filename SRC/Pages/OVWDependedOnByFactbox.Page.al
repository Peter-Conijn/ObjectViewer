page 50137 "OVW Depended On By - Factbox"
{
    Caption = 'Depended On By';
    PageType = ListPart;
    SourceTable = "OVW App Dependency";
    SourceTableView = sorting("Dependent App Id");
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("App Name"; Rec."App Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the App Name field.';
                }
                field("App Publisher"; Rec."App Publisher")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the App Publisher field.';
                }
            }
        }
    }
}
