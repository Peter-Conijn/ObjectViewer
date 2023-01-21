codeunit 50137 "OVW Dependency Management"
{
    Permissions = tabledata "NAV App Installed App" = R,
                  tabledata "OVW App Dependency" = RIMD;

    trigger OnRun()
    begin
        FillDependencyTable();
    end;

    local procedure FillDependencyTable()
    var
        NAVAppInstalledApp: Record "NAV App Installed App";
    begin
        ClearDependencyTable();
        if not NAVAppInstalledApp.FindSet() then
            exit;
        repeat
            InitDependencyRecords(NAVAppInstalledApp);
        until NAVAppInstalledApp.Next() = 0;
    end;

    local procedure InitDependencyRecords(NAVAppInstalledApp: Record "NAV App Installed App")
    var
        ModuleDependencies: List of [ModuleDependencyInfo];
        ModuleDependency: ModuleDependencyInfo;
        IsHandled: Boolean;
    begin
        OnBeforeInitDependencyRecords(NAVAppInstalledApp, IsHandled);
        if IsHandled then
            exit;

        ModuleDependencies := GetDependencies(NAVAppInstalledApp);
        if ModuleDependencies.Count() = 0 then
            exit;

        foreach ModuleDependency in ModuleDependencies do begin
            InitDependencyRecord(NAVAppInstalledApp, ModuleDependency);
        end;

        OnAfterInitDependencyRecords(NAVAppInstalledApp);
    end;

    local procedure InitDependencyRecord(NAVAppInstalledApp: Record "NAV App Installed App"; ModuleDependency: ModuleDependencyInfo)
    var
        OVWAppDependencies: Record "OVW App Dependency";
    begin
        OVWAppDependencies.Init();
        OVWAppDependencies."App Id" := NAVAppInstalledApp."App ID";
        OVWAppDependencies."Dependent App Id" := ModuleDependency.Id;
        OVWAppDependencies."App Name" := NAVAppInstalledApp.Name;
        OVWAppDependencies."Dependent App Name" := ModuleDependency.Name;
        OVWAppDependencies."App Publisher" := NAVAppInstalledApp.Publisher;
        OVWAppDependencies."Dependent App Publisher" := ModuleDependency.Publisher;

        OnBeforeInitDependencyRecord(NAVAppInstalledApp, ModuleDependency, OVWAppDependencies);
        OVWAppDependencies.Insert(true);
    end;

    local procedure GetDependencies(NAVAppInstalledApp: Record "NAV App Installed App"): List of [ModuleDependencyInfo];
    var
        Module: ModuleInfo;
    begin
        NavApp.GetModuleInfo(NAVAppInstalledApp."App ID", Module);
        exit(Module.Dependencies());
    end;

    local procedure ClearDependencyTable()
    var
        OVWAppDependencies: Record "OVW App Dependency";
    begin
        if not OVWAppDependencies.IsEmpty() then
            OVWAppDependencies.DeleteAll(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitDependencyRecords(var NAVAppInstalledApp: Record "NAV App Installed App"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitDependencyRecords(NAVAppInstalledApp: Record "NAV App Installed App")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitDependencyRecord(NAVAppInstalledApp: Record "NAV App Installed App"; ModuleDependency: ModuleDependencyInfo; var OVWAppDependencies: Record "OVW App Dependency")
    begin
    end;
}