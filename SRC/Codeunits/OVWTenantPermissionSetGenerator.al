codeunit 50135 "OVW Tenant Perm. Set Generator"
{
    TableNo = "NAV App Installed App";

    trigger OnRun()
    begin
        GenerateAndDownloadPermissionSet(Rec);
    end;

    local procedure GenerateAndDownloadPermissionSet(NAVAppInstalledApp: Record "NAV App Installed App")
    var
        TempBlob: Codeunit "Temp Blob";
        PermissionXml: XmlDocument;
    begin
        PermissionXml := GeneratePermissionSet(NAVAppInstalledApp);
        DownloadPermissionSet(NAVAppInstalledApp, PermissionXml);
    end;

    local procedure GeneratePermissionSet(NAVAppInstalledApp: Record "NAV App Installed App") PermissionXml: XmlDocument;
    var
        AllObjWithCaption: Record AllObjWithCaption;
        PermissionSetElement: XmlElement;
    begin
        AllObjWithCaption.SetRange("App Package ID", NAVAppInstalledApp."Package Id");
        if not AllObjWithCaption.FindSet() then
            exit;

        PermissionSetElement := InitPermissionSet(PermissionXml, NAVAppInstalledApp.Name);

        repeat
            AddPermissionsForObject(PermissionSetElement, AllObjWithCaption);
        until AllObjWithCaption.Next() = 0;
    end;

    local procedure InitPermissionSet(var PermissionXml: XmlDocument; AppName: Text[250]) PermissionSetXmlElement: XmlElement;
    var
        RootElement: XmlElement;
        PermissionSetsLbl: Label 'PermissionSets', Locked = true;
        PermissionSetLbl: Label 'PermissionSet', Locked = true;
    begin
        PermissionXml := XmlDocument.Create();
        PermissionXml.SetDeclaration(XmlDeclaration.Create('1.0', 'utf-8', 'yes'));
        PermissionXml.Add(XmlElement.Create(PermissionSetsLbl));
        PermissionXml.GetRoot(RootElement);

        PermissionSetXmlElement := XmlElement.Create(PermissionSetLbl);
        AddAttribute(PermissionSetXmlElement, 'RoleID', CopyStr(AppName.ToUpper(), 1, 20));
        AddAttribute(PermissionSetXmlElement, 'RoleName', AppName);
        AddAttribute(PermissionSetXmlElement, 'Scope', 'Tenant');
        RootElement.Add(PermissionSetXmlElement);
    end;

    local procedure AddPermissionsForObject(PermissionSetElement: XmlElement; AllObjWithCaption: Record AllObjWithCaption)
    begin
        case AllObjWithCaption."Object Type" of
            AllObjWithCaption."Object Type"::TableData:
                AddTableDataPermissions(PermissionSetElement, AllObjWithCaption);
            AllObjWithCaption."Object Type"::Table:
                AddTablePermissions(PermissionSetElement, AllObjWithCaption);
            AllObjWithCaption."Object Type"::Report:
                AddReportPermissions(PermissionSetElement, AllObjWithCaption);
            AllObjWithCaption."Object Type"::Codeunit:
                AddCodeunitPermissions(PermissionSetElement, AllObjWithCaption);
            AllObjWithCaption."Object Type"::XMLport:
                AddXmlPortPermissions(PermissionSetElement, AllObjWithCaption);
            AllObjWithCaption."Object Type"::Page:
                AddPagePermissions(PermissionSetElement, AllObjWithCaption);
            AllObjWithCaption."Object Type"::Query:
                AddQueryPermissions(PermissionSetElement, AllObjWithCaption);
        end;
    end;

    local procedure AddTableDataPermissions(var RootElement: XmlElement; AllObjWithCaption: Record AllObjWithCaption)
    begin
        AddPermissionSet(RootElement, AllObjWithCaption."Object ID", AllObjWithCaption."Object Type", true, true, true, true, false);
    end;

    local procedure AddTablePermissions(var RootElement: XmlElement; AllObjWithCaption: Record AllObjWithCaption)
    begin
        AddPermissionSet(RootElement, AllObjWithCaption."Object ID", AllObjWithCaption."Object Type", false, false, false, false, true);
    end;

    local procedure AddReportPermissions(RootElement: XmlElement; AllObjWithCaption: Record AllObjWithCaption)
    begin
        AddPermissionSet(RootElement, AllObjWithCaption."Object ID", AllObjWithCaption."Object Type", false, false, false, false, true);
    end;

    local procedure AddCodeunitPermissions(RootElement: XmlElement; AllObjWithCaption: Record AllObjWithCaption)
    begin
        AddPermissionSet(RootElement, AllObjWithCaption."Object ID", AllObjWithCaption."Object Type", false, false, false, false, true);
    end;

    local procedure AddXmlPortPermissions(RootElement: XmlElement; AllObjWithCaption: Record AllObjWithCaption)
    begin
        AddPermissionSet(RootElement, AllObjWithCaption."Object ID", AllObjWithCaption."Object Type", false, false, false, false, true);
    end;

    local procedure AddPagePermissions(RootElement: XmlElement; AllObjWithCaption: Record AllObjWithCaption)
    begin
        AddPermissionSet(RootElement, AllObjWithCaption."Object ID", AllObjWithCaption."Object Type", false, false, false, false, true);
    end;

    local procedure AddQueryPermissions(RootElement: XmlElement; AllObjWithCaption: Record AllObjWithCaption)
    begin
        AddPermissionSet(RootElement, AllObjWithCaption."Object ID", AllObjWithCaption."Object Type", false, false, false, false, true);
    end;

    local procedure AddPermissionSet(var PermissionSetElement: XmlElement; PermissionObjectId: Integer; PermissionObjectType: Option; ReadPermission: Boolean; InsertPermission: Boolean; ModifyPermission: Boolean; DeletePermission: Boolean; ExecutePermission: Boolean)
    var
        PermissionElement: XmlElement;
    begin
        PermissionElement := XmlElement.Create('TenantPermission');
        PermissionElement.Add(XmlElement.Create('ObjectType', XmlText.Create(Format(PermissionObjectType))));
        PermissionElement.Add(XmlElement.Create('ObjectID', PermissionObjectId));

        AddPermissionToElement('ReadPermission', ReadPermission, PermissionElement);
        AddPermissionToElement('InsertPermission', InsertPermission, PermissionElement);
        AddPermissionToElement('ModifyPermission', ModifyPermission, PermissionElement);
        AddPermissionToElement('DeletePermission', DeletePermission, PermissionElement);
        AddPermissionToElement('ExecutePermission', ExecutePermission, PermissionElement);

        PermissionSetElement.Add(PermissionElement);
    end;

    local procedure AddPermissionToElement(PermissionName: Text; PermissionValue: Boolean; var PermissionElement: XmlElement)
    begin
        if PermissionValue then
            PermissionElement.Add(XmlElement.Create(PermissionName, CreateXmlText(PermissionValue)));
    end;

    local procedure CreateXmlText(XmlTextValue: Variant): XmlText
    begin
        exit(XmlText.Create(FormatValueAsXml(XmlTextValue)));
    end;

    local procedure FormatValueAsXml(ValueToFormat: Variant): Text
    begin
        exit(Format(ValueToFormat, 0, 1));
    end;

    local procedure AddAttribute(var Element: XmlElement; AttributeName: Text; AttributeValue: Text)
    begin
        if AttributeName = '' then
            exit;
        Element.Add(XmlAttribute.Create(AttributeName, AttributeValue));
    end;

    local procedure DownloadPermissionSet(NAVAppInstalledApp: Record "NAV App Installed App"; PermissionXml: XmlDocument)
    var
        OVWDownloadHandler: Codeunit "OVW Download Handler";
    begin
        OVWDownloadHandler.DownloadPermissionSet(NAVAppInstalledApp, PermissionXml);
    end;
}