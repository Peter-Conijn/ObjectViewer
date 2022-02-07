codeunit 50130 "PCO IObjectManagement"
{
    procedure RunApplicationObject(AllObjWithCaption: Record AllObjWithCaption)
    var
        PCOObjectManagement: Codeunit "PCO Object Management";
    begin
        PCOObjectManagement.RunApplicationObject(AllObjWithCaption);
    end;
}