codeunit 50136 "OVW Download Handler"
{
    internal procedure DownloadPermissionSet(NAVAppInstalledApp: Record "NAV App Installed App"; PermissionXml: XmlDocument)
    var
        TempBlob: Codeunit "Temp Blob";
        ReadStream: InStream;
        WriteStream: OutStream;
        Filename: Text;
    begin
        TempBlob.CreateOutStream(WriteStream);
        PermissionXml.WriteTo(WriteStream);
        TempBlob.CreateInStream(ReadStream);

        Filename := GetPermissionSetFilename(NAVAppInstalledApp);
        DownloadFromStream(ReadStream, '', '', '', Filename);
    end;

    local procedure GetPermissionSetFilename(NAVAppInstalledApp: Record "NAV App Installed App"): Text
    var
        PermissionSetFilenameTxt: Label 'PermissionSet_%1_%2.%3.%4.%5.xml', Locked = true;
    begin
        exit(StrSubstNo(PermissionSetFilenameTxt, NAVAppInstalledApp.Name, NAVAppInstalledApp."Version Major", NAVAppInstalledApp."Version Minor", NAVAppInstalledApp."Version Build", NAVAppInstalledApp."Version Revision"));
    end;
}