codeunit 50138 "OVW Export to Excel"
{
    trigger OnRun()
    begin

    end;

    procedure Rec2Excel(TableID: Integer)
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(TableID);
        if not RecRef.ReadPermission then
            exit;

        RowNo := 1;

        if RecRef.FindSet() then begin
            repeat
                Ref2Excel(RecRef, TableID);
            until RecRef.Next() = 0;
        end;
        TempExcelBuffer.CreateExcelBook(RecRef.Name); //change into table name?
    end;

    local procedure Ref2Excel(var Ref: RecordRef; TableID: Integer)
    var
        int: Integer;
    begin
        ColumnNo := 1;
        RowNo += 1;

        for int := 1 to Ref.FieldCount() do begin
            fRef2Excel(Ref, int, TableID);
        end;
    end;

    local procedure fRef2Excel(var Ref: RecordRef; var i: Integer; TableID: Integer)
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
        end;
    end;

    local procedure IsFieldEnabled(FRef: FieldRef; TableID: Integer): Boolean
    var
        FieldRecord: Record Field;
    begin
        if FieldRecord.Get(FRef.Record().Number, FRef.Number) then
            exit(FieldRecord.Enabled);
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ColumnNo: Integer;
        RowNo: Integer;
}