page 50133 "OVW Application Objects"
{
    PageType = ListPart;
    Caption = 'Application Objects';
    SourceTable = AllObjWithCaption;
    SourceTableView = where("Object Type" = filter(<> TableData));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

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
    }

    local procedure RunApplicationObject()
    var
        PCOObjectManagement: Codeunit "OVW Object Management";
    begin
        PCOObjectManagement.RunApplicationObject(Rec);
    end;
}