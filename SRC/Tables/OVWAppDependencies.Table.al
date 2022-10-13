table 50131 "OVW App Dependency"
{
    DataClassification = SystemMetadata;
    Access = Internal;

    fields
    {
        field(1; "App Id"; Guid)
        {
            Caption = 'App Id';
        }
        field(2; "Dependent App Id"; Guid)
        {
            Caption = 'Dependent App ID';
        }
        field(5; "App Name"; Text[1024])
        {
            Caption = 'App Name';
        }
        field(6; "Dependent App Name"; Text[1024])
        {
            Caption = 'Dependent App Name';
        }
        field(7; "App Publisher"; Text[1024])
        {
            Caption = 'App Publisher';
        }
        field(8; "Dependent App Publisher"; Text[1024])
        {
            Caption = 'Dependent App Publisher';
        }
    }

    keys
    {
        key(PK; "App Id", "Dependent App Id")
        {
            Clustered = true;
        }
        key(Key2; "Dependent App Id") { }
    }
}