codeunit 50137 "OVW Dependency Management"
{
    Permissions = tabledata "NAV App Installed App" = r,
                  tabledata "OVW App Dependency" = rimd;

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
    begin
        ModuleDependencies := GetDependencies(NAVAppInstalledApp);
        if ModuleDependencies.Count() = 0 then
            exit;

        foreach ModuleDependency in ModuleDependencies do begin
            InitDependencyRecord(NAVAppInstalledApp, ModuleDependency);
        end;
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
}