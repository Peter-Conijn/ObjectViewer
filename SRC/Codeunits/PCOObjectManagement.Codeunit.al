codeunit 50131 "PCO Object Management"
{
    Access = Internal;

    [ErrorBehavior(ErrorBehavior::Collect)]
    internal procedure RunApplicationObject(AllObjWithCaption: Record AllObjWithCaption)
    var
        Url: Text;
    begin
        Url := GetUrl(ClientType::Web, CompanyName(), GetObjectType(AllObjWithCaption."Object Type"), AllObjWithCaption."Object ID");
        if not TryOpenUrl(Url) then
            GenerateError(AllObjWithCaption);
    end;

    [TryFunction]
    local procedure TryOpenUrl(Url: Text)
    begin
        ClearCollectedErrors();
        if Url <> '' then
            Hyperlink(Url);
    end;

    local procedure GetObjectType(ObjectTypeOption: Option): ObjectType
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        case ObjectTypeOption of
            AllObjWithCaption."Object Type"::Table:
                exit(ObjectType::Table);
            AllObjWithCaption."Object Type"::Page:
                exit(ObjectType::Page);
            AllObjWithCaption."Object Type"::Codeunit:
                exit(ObjectType::Codeunit);
            AllObjWithCaption."Object Type"::Report:
                exit(ObjectType::Report);
        end;
    end;

    local procedure GenerateError(AllObjWithCaption: Record AllObjWithCaption)
    var
        NewErrorInfo: ErrorInfo;
    begin
        NewErrorInfo := ErrorInfo.Create(GetLastErrorText());
        NewErrorInfo.Collectible := true;
        NewErrorInfo.DataClassification := DataClassification::SystemMetadata;
        NewErrorInfo.RecordId := AllObjWithCaption.RecordId();
        NewErrorInfo.Verbosity := Verbosity::Error;
        NewErrorInfo.DetailedMessage := 'Hyperlinking to the selected object failed. Please see the message for more information.';

        Error(NewErrorInfo);
    end;
}