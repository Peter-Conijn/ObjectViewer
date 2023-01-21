codeunit 50138 "OVW Export to Excel"
{
    internal procedure ExportRecordToExcel(TableID: Integer)
    var
        RecRef: RecordRef;
    begin
        if not TryOpenRecRef(RecRef, TableID) then
            exit;

        if not RecRef.ReadPermission then
            exit;

        RowNo := 1;
        if RecRef.FindSet() then begin
            repeat
                EXportRecordRefToExcel(RecRef, TableID);
            until RecRef.Next() = 0;
        end;
        TempExcelBuffer.CreateExcelBook(RecRef.Name); //change into table name?
    end;

    local procedure EXportRecordRefToExcel(var Ref: RecordRef; TableID: Integer)
    var
        FieldIndex: Integer;
    begin
        ColumnNo := 1;
        RowNo += 1;

        for FieldIndex := 1 to Ref.FieldCount() do begin
            ExportFieldRefToExcel(Ref, FieldIndex, TableID);
        end;
    end;

    local procedure ExportFieldRefToExcel(var Ref: RecordRef; var i: Integer; TableID: Integer)
    var
        FRef: FieldRef;
    begin
        FRef := Ref.FieldIndex(i);

        if not IsFieldEnabled(FRef, TableID) then
            exit;

        case FRef.Class of
            FRef.Class::Normal:
                begin
                    TempExcelBuffer.AddCell(RowNo, ColumnNo, FRef.Value, FRef.Caption, 1);
                end;

            FRef.Class::FlowField:
                begin
                    FRef.CalcField();
                    TempExcelBuffer.AddCell(RowNo, ColumnNo, FRef.Value, FRef.Caption, 1);
                end;
            else
                OnAfterAddCellWithFieldClass(RowNo, ColumnNo, FRef);
        end;
    end;

    local procedure IsFieldEnabled(FRef: FieldRef; TableID: Integer): Boolean
    var
        FieldRecord: Record Field;
    begin
        if FieldRecord.Get(FRef.Record().Number, FRef.Number) then
            exit(FieldRecord.Enabled);
    end;

    [TryFunction]
    local procedure TryOpenRecRef(RecRef: RecordRef; TableID: Integer)
    begin
        RecRef.Open(TableID);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAddCellWithFieldClass(RowNo: Integer; ColumnNo: Integer; FRef: FieldRef)
    begin
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ColumnNo: Integer;
        RowNo: Integer;
}