codeunit 50132 "OVW Comparison Management"
{
    internal procedure ExportData(TypeFilter: Text)
    var
        OVWObjectComparison: Record "OVW Object Comparison";
        TempBlob: Codeunit "Temp Blob";
        OVWObjectDataIO: XmlPort "OVW Object Data I/O";
        ReadStream: InStream;
        WriteStream: OutStream;
        Destination: Text;
    begin
        if TypeFilter <> '' then
            OVWObjectComparison.SetFilter("Object Type", TypeFilter);

        TempBlob.CreateOutStream(WriteStream, TextEncoding::UTF8);
        OVWObjectDataIO.SetTableView(OVWObjectComparison);
        OVWObjectDataIO.SetDestination(WriteStream);
        OVWObjectDataIO.Export();

        TempBlob.CreateInStream(ReadStream, TextEncoding::UTF8);
        DownloadFromStream(ReadStream, '', '', '', Destination);
    end;

    internal procedure ImportData()
    var
        OVWObjectComparison: Record "OVW Object Comparison";
        TempBlob: Codeunit "Temp Blob";
        OVWObjectDataIO: XmlPort "OVW Object Data I/O";
        ReadStream: InStream;
        WriteStream: OutStream;
    begin
        OVWObjectComparison.SetRange(Origin, Enum::"OVW Origin"::Imported);
        if not OVWObjectComparison.IsEmpty() then
            OVWObjectComparison.DeleteAll();

        if not UploadIntoStream('', ReadStream) then
            exit;
        OVWObjectDataIO.SetSource(ReadStream);
        OVWObjectDataIO.Import();
    end;

    local procedure InsertObjectData(AllObj: Record AllObj)
    var
        OVWObjectComparison: Record "OVW Object Comparison";
    begin
        if OVWObjectComparison.Get(Enum::"OVW Origin"::Generated, AllObj."Object Type", AllObj."Object ID") then
            exit;
        OVWObjectComparison.Init();
        OVWObjectComparison.Origin := Enum::"OVW Origin"::Generated;
        OVWObjectComparison."Object Type" := Enum::"OVW Object Type".FromInteger(AllObj."Object Type");
        OVWObjectComparison."Object ID" := AllObj."Object ID";
        OVWObjectComparison.Insert(true);
    end;
}