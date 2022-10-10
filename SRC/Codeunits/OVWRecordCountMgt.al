codeunit 50133 "OVW Record Count Mgt."
{
    procedure GetRecordCount(TableId: Integer): Integer
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(TableId);
        exit(RecRef.Count);
    end;
}