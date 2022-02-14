page 50135 "OVW Object Comparison"
{
    PageType = List;
    Caption = 'Object Comparison';
    SourceTable = "OVW Object Comparison";

    layout
    {
        area(Content)
        {
            repeater(GeneralRepeater)
            {

                field("Object Type"; Rec."Object Type")
                {
                    ToolTip = 'Specifies the Object Type.';
                    ApplicationArea = All;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ToolTip = 'Specifies the Object Number.';
                    ApplicationArea = All;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ToolTip = 'Specifies the Object Name.';
                    ApplicationArea = All;
                }
                field(Origin; Rec.Origin)
                {
                    ToolTip = 'Specifies the Origin.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("App Name"; Rec."App Name")
                {
                    ToolTip = 'Specifies the App Name.';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
}