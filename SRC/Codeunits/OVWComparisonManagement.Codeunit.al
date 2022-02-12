codeunit 50132 "OVW Comparison Management"
{
    internal procedure GenerateObjectData(PackageID: Guid; AppName: Text)
    var
        AllObj: Record AllObj;
    begin
        AllObj.SetRange("App Package ID", PackageID);
        if not AllObj.FindSet() then
            exit;
        ClearGeneratedData();
        repeat
            InsertObjectData(AllObj, AppName)
        until AllObj.Next() = 0;
    end;

    internal procedure ExportData()
    var
        OVWObjectComparison: Record "OVW Object Comparison";
        TempBlob: Codeunit "Temp Blob";
        OVWObjectDataIO: XmlPort "OVW Object Data I/O";
        FilenameLbl: Label 'Object_Export.xml', Locked = true;
        ReadStream: InStream;
        WriteStream: OutStream;
        Destination: Text;
    begin
        TempBlob.CreateOutStream(WriteStream, TextEncoding::UTF8);
        OVWObjectDataIO.SetTableView(OVWObjectComparison);
        OVWObjectDataIO.SetDestination(WriteStream);
        OVWObjectDataIO.Export();

        Destination := FilenameLbl;
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

        if not UploadIntoStream('Xml Files|*.xml', ReadStream) then
            exit;
        OVWObjectDataIO.SetSource(ReadStream);
        OVWObjectDataIO.Import();
    end;

    internal procedure RunComparison()
    begin
        RunComparison(Enum::"OVW Origin"::Generated);
        RunComparison(Enum::"OVW Origin"::Imported);
    end;

    local procedure RunComparison(OVWOrigin: Enum "OVW Origin")
    var
        OVWObjectComparison: Record "OVW Object Comparison";
        CounterpartOVWOrigin: Enum "OVW Origin";
    begin
        OVWObjectComparison.ModifyAll("Has Counterpart", false);
        if OVWOrigin = Enum::"OVW Origin"::Generated then
            CounterpartOVWOrigin := Enum::"OVW Origin"::Imported
        else
            CounterpartOVWOrigin := Enum::"OVW Origin"::Generated;

        OVWObjectComparison.SetRange(Origin, OVWOrigin);
        if OVWObjectComparison.FindSet() then
            repeat
                FindCounterPart(OVWObjectComparison, CounterpartOVWOrigin);
            until OVWObjectComparison.Next() = 0;

    end;

    local procedure InsertObjectData(AllObj: Record AllObj; AppName: Text)
    var
        OVWObjectComparison: Record "OVW Object Comparison";
        MissingAppNameErr: Label 'Missing app name.';
    begin
        if OVWObjectComparison.Get(Enum::"OVW Origin"::Generated, AllObj."Object Type", AllObj."Object ID") then
            exit;
        if AppName = '' then
            Error(MissingAppNameErr);
        OVWObjectComparison.Init();
        OVWObjectComparison.Origin := Enum::"OVW Origin"::Generated;
        OVWObjectComparison."App Name" := AppName;
        OVWObjectComparison."Object Type" := Enum::"OVW Object Type".FromInteger(AllObj."Object Type");
        OVWObjectComparison."Object ID" := AllObj."Object ID";
        OVWObjectComparison."Object Name" := AllObj."Object Name";
        OVWObjectComparison.Insert(true);
    end;

    local procedure ClearGeneratedData()
    var
        OVWObjectComparison: Record "OVW Object Comparison";
    begin
        OVWObjectComparison.SetRange(Origin);
        if not OVWObjectComparison.IsEmpty() then
            OVWObjectComparison.DeleteAll();
    end;

    local procedure FindCounterPart(var OVWObjectComparison: Record "OVW Object Comparison"; CounterpartOVWOrigin: Enum "OVW Origin")
    var
        OVWObjectComparison2: Record "OVW Object Comparison";
    begin
        if not OVWObjectComparison2.Get(CounterpartOVWOrigin, OVWObjectComparison."Object Type", OVWObjectComparison."Object ID") then
            exit;
        OVWObjectComparison."Has Counterpart" := true;
        OVWObjectComparison2."Has Counterpart" := true;

        OVWObjectComparison.Modify(true);
        OVWObjectComparison2.Modify(true);
    end;
}