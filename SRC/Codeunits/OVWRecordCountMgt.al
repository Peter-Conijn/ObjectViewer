codeunit 50133 "OVW Record Count Mgt."
{
    procedure GetRecordCount(TableId: Integer): Integer
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(TableId);
        if RecRef.ReadPermission() then
            exit(RecRef.Count);
    end;
}