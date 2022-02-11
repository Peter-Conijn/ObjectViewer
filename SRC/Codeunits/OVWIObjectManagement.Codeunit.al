codeunit 50130 "OVW IObjectManagement"
{
    procedure RunApplicationObject(AllObjWithCaption: Record AllObjWithCaption)
    var
        PCOObjectManagement: Codeunit "OVW Object Management";
    begin
        PCOObjectManagement.RunApplicationObject(AllObjWithCaption);
    end;
}