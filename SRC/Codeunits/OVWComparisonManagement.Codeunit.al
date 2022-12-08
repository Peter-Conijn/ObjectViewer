codeunit 50132 "OVW Comparison Management"
{
    ObsoleteState = Pending;
    ObsoleteReason = 'This functionality has been marked as obsolete and will be removed. This warning will become an error in a later version.';
    ObsoleteTag = '1.2';

    [Obsolete('This functionality has been marked as obsolete and will be removed. This warning will become an error in a later version.', '1.2')]
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

    [Obsolete('This functionality has been marked as obsolete and will be removed. This warning will become an error in a later version.', '1.2')]
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

    [Obsolete('This functionality has been marked as obsolete and will be removed. This warning will become an error in a later version.', '1.2')]
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

    [Obsolete('This functionality has been marked as obsolete and will be removed. This warning will become an error in a later version.', '1.2')]
    internal procedure GetNoOfObjects(OVWOrigin: Enum "OVW Origin"): Integer
    var
        OVWObjectComparison: Record "OVW Object Comparison";
    begin
        OVWObjectComparison.SetRange(Origin, OVWOrigin);
        exit(OVWObjectComparison.Count());
    end;

    [Obsolete('This functionality has been marked as obsolete and will be removed. This warning will become an error in a later version.', '1.2')]
    internal procedure RunComparison()
    var
        DialogTextLbl: Label 'Comparing objects...\Old->New: #1# of #2# \New -> Old: #3# of #4# ', Comment = '#1 = Current index existing; #2 = Total; #3 = Current index new; #4 = Total;';
    begin
        OpenDialog(DialogTextLbl);

        RunComparison(Enum::"OVW Origin"::Generated);
        RunComparison(Enum::"OVW Origin"::Imported);

        CloseDialog();
    end;

    local procedure RunComparison(OVWOrigin: Enum "OVW Origin")
    var
        OVWObjectComparison: Record "OVW Object Comparison";
        CounterpartOVWOrigin: Enum "OVW Origin";
        DialogControlToUpdate: Integer;
        Index: Integer;
    begin
        OVWObjectComparison.ModifyAll("Has Counterpart", false);
        if OVWOrigin = Enum::"OVW Origin"::Generated then
            CounterpartOVWOrigin := Enum::"OVW Origin"::Imported
        else
            CounterpartOVWOrigin := Enum::"OVW Origin"::Generated;

        DialogControlToUpdate := GetDialogControlToUpdate(OVWOrigin);
        OVWObjectComparison.SetRange(Origin, OVWOrigin);
        if OVWObjectComparison.FindSet() then
            repeat
                Index += 1;
                FindCounterPart(OVWObjectComparison, CounterpartOVWOrigin);
                UpdateDialog(DialogControlToUpdate, Index, false);
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

    local procedure OpenDialog(DialogText: Text)
    begin
        if not GuiAllowed() then
            exit;

        DialogWindow.Open(DialogText);

        UpdateDialog(1, 0, true);
        UpdateDialog(2, GetNoOfObjects(Enum::"OVW Origin"::Generated), true);
        UpdateDialog(3, 0, true);
        UpdateDialog(4, GetNoOfObjects(Enum::"OVW Origin"::Imported), true);
    end;

    local procedure UpdateDialog(ControlNo: Integer; NewValue: Integer; ForceUpdate: Boolean)
    begin
        if LastUpdate = 0T then
            LastUpdate := Time();
        if (Time() - LastUpdate < 1000) then
            if not ForceUpdate then
                exit;

        DialogWindow.Update(ControlNo, NewValue);
        SetLastUpdate();
    end;

    local procedure CloseDialog()
    begin
        if GuiAllowed() then
            DialogWindow.Close();
    end;

    local procedure SetLastUpdate()
    begin
        LastUpdate := Time();
    end;

    local procedure GetDialogControlToUpdate(OVWOrigin: Enum "OVW Origin"): Integer;
    begin
        if OVWOrigin = OVWOrigin::Generated then
            exit(1);
        exit(3);
    end;

    var
        DialogWindow: Dialog;
        LastUpdate: Time;
}