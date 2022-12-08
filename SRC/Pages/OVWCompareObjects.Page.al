page 50134 "OVW Compare Objects"
{
    PageType = Card;
    Caption = 'Compare Objects';
    DataCaptionExpression = Rec.Name;
    SourceTable = "NAV App Installed App";
    ObsoleteState = Pending;
    ObsoleteReason = 'This functionality has been marked as obsolete and will be removed. This warning will become an error in a later version.';
    ObsoleteTag = '1.2';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("App Name"; Rec.Name)
                {
                    Caption = 'App Name';
                    ToolTip = 'Specifies the value of the App Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Data)
            {
                group(GeneratedData)
                {
                    Caption = 'Generated Data';

                    field(NoOfGeneratedObjects; GetNoOfObjects(Enum::"OVW Origin"::Generated))
                    {
                        Caption = 'Total No. of Objects';
                        ToolTip = 'Specifies the total number of objects in the generated data.';
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(RemovedTables; GetNoOfObjectsWithoutCounterPart(Enum::"OVW Origin"::Generated, Enum::"OVW Object Type"::Table))
                    {
                        Caption = 'Removed Tables';
                        ToolTip = 'Specifies the number of tables the generated data that do not exist in the imported data.';
                        ApplicationArea = All;
                        Editable = false;

                        trigger OnDrillDown()
                        begin
                            ShowObjects(Enum::"OVW Origin"::Generated, Enum::"OVW Object Type"::Table);
                        end;
                    }
                    field(RemovedPages; GetNoOfObjectsWithoutCounterPart(Enum::"OVW Origin"::Generated, Enum::"OVW Object Type"::Page))
                    {
                        Caption = 'Removed Pages';
                        ToolTip = 'Specifies the number of pages the generated data that do not exist in the imported data.';
                        ApplicationArea = All;
                        Editable = false;

                        trigger OnDrillDown()
                        begin
                            ShowObjects(Enum::"OVW Origin"::Generated, Enum::"OVW Object Type"::Page);
                        end;
                    }
                }
                group(ImportedData)
                {
                    Caption = 'Imported Data';

                    field(NoOfImportedObjects; GetNoOfObjects(Enum::"OVW Origin"::Imported))
                    {
                        Caption = 'Total No. of Objects';
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(NewTables; GetNoOfObjectsWithoutCounterPart(Enum::"OVW Origin"::Imported, Enum::"OVW Object Type"::Table))
                    {
                        Caption = 'New Tables';
                        ToolTip = 'Specifies the number of tables the imported data that do not exist in the generated data.';
                        ApplicationArea = All;
                        Editable = false;

                        trigger OnDrillDown()
                        begin
                            ShowObjects(Enum::"OVW Origin"::Imported, Enum::"OVW Object Type"::Table);
                        end;
                    }
                    field(NewPages; GetNoOfObjectsWithoutCounterPart(Enum::"OVW Origin"::Imported, Enum::"OVW Object Type"::Page))
                    {
                        Caption = 'New Pages';
                        ToolTip = 'Specifies the number of pages the imported data that do not exist in the generated data.';
                        ApplicationArea = All;
                        Editable = false;

                        trigger OnDrillDown()
                        begin
                            ShowObjects(Enum::"OVW Origin"::Imported, Enum::"OVW Object Type"::Page);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateData)
            {
                ApplicationArea = All;
                Caption = 'Generate Data';
                ToolTip = 'Generate the list of objects for the current app.';

                trigger OnAction()
                begin
                    SetGeneratedData();
                end;
            }
            action(ExportData)
            {
                ApplicationArea = All;
                Enabled = HasGeneratedData;
                Image = Export;
                Caption = 'Export Data';
                ToolTip = 'Export the objects for this app to an xml file.';

                trigger OnAction()
                begin
                    ExportGeneratedData();
                end;
            }
            action(ImportData)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Import Data';
                ToolTip = 'Import the xml file with the objects to compare to this app.';

                trigger OnAction()
                begin
                    ImportExternalData();
                end;
            }
            action(CompareData)
            {
                ApplicationArea = All;
                Enabled = HasGeneratedData and HasImportedData;
                Image = Import;
                Caption = 'Compare Data';
                ToolTip = 'Compare the imported data to the generated data.';

                trigger OnAction()
                begin
                    CompareDataSets();
                end;
            }

        }
    }

    trigger OnOpenPage()
    begin
        UpdateHasData();
    end;

    internal procedure SetGeneratedData()
    var
        OVWComparisonManagement: Codeunit "OVW Comparison Management";
    begin
        OVWComparisonManagement.GenerateObjectData(Rec."Package ID", Rec.Name);
        UpdateHasData();
    end;

    local procedure ExportGeneratedData()
    var
        OVWComparisonManagement: Codeunit "OVW Comparison Management";
    begin
        OVWComparisonManagement.ExportData();
    end;

    local procedure ImportExternalData()
    var
        OVWComparisonManagement: Codeunit "OVW Comparison Management";
    begin
        OVWComparisonManagement.ImportData();
        UpdateHasData();
    end;

    local procedure CompareDataSets()
    var
        OVWComparisonManagement: Codeunit "OVW Comparison Management";
    begin
        OVWComparisonManagement.RunComparison();
    end;

    local procedure GetNoOfObjects(OVWOrigin: Enum "OVW Origin"): Integer
    var
        OVWComparisonManagement: Codeunit "OVW Comparison Management";
    begin
        exit(OVWComparisonManagement.GetNoOfObjects(OVWOrigin));
    end;

    local procedure GetNoOfObjectsWithoutCounterPart(OVWOrigin: Enum "OVW Origin"; OVWObjectType: Enum "OVW Object Type"): Integer
    var
        OVWObjectComparison: Record "OVW Object Comparison";
    begin
        SetCounterpartFilters(OVWOrigin, OVWObjectType, OVWObjectComparison);
        exit(OVWObjectComparison.Count());
    end;

    local procedure UpdateHasData()
    begin
        HasGeneratedData := GetNoOfObjects(Enum::"OVW Origin"::Generated) <> 0;
        HasImportedData := GetNoOfObjects(Enum::"OVW Origin"::Imported) <> 0;
    end;

    local procedure ShowObjects(OVWOrigin: Enum "OVW Origin"; OVWObjectType: Enum "OVW Object Type")
    var
        OVWObjectComparison: Record "OVW Object Comparison";
    begin
        SetCounterpartFilters(OVWOrigin, OVWObjectType, OVWObjectComparison);
        Page.Run(Page::"OVW Object Comparison", OVWObjectComparison);
    end;

    local procedure SetCounterpartFilters(OVWOrigin: Enum "OVW Origin"; OVWObjectType: Enum "OVW Object Type"; var OVWObjectComparison: Record "OVW Object Comparison")
    begin
        OVWObjectComparison.SetCurrentKey(Origin, "Object Type", "Has Counterpart");
        OVWObjectComparison.SetRange(Origin, OVWOrigin);
        OVWObjectComparison.SetRange("Object Type", OVWObjectType);
        OVWObjectComparison.SetRange("Has Counterpart", false);
    end;

    var
        HasGeneratedData: Boolean;
        HasImportedData: Boolean;
}