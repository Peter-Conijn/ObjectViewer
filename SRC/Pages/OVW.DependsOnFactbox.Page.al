page 50136 "OVW Depends On - Factbox"
{
    Caption = 'Depends On';
    PageType = ListPart;
    SourceTable = "OVW App Dependency";
    SourceTableView = sorting("App Id", "Dependent App Id");
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Dependent App Name"; Rec."Dependent App Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dependent App Name field.';
                }
                field("Dependent App Publisher"; Rec."Dependent App Publisher")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dependent App Publisher field.';
                }
            }
        }
    }
}
