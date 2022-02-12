table 50130 "OVW Object Comparison"
{
    DataClassification = SystemMetadata;
    Caption = 'Object Comparison';
    DrillDownPageId = "OVW Object Comparison";
    LookupPageId = "OVW Object Comparison";

    fields
    {
        field(1; Origin; Enum "OVW Origin")
        {
            DataClassification = SystemMetadata;
            Caption = 'Origin';
        }
        field(2; "Object Type"; Enum "OVW Object Type")
        {
            DataClassification = SystemMetadata;
            Caption = 'Object Type';
        }
        field(3; "Object ID"; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Object Number';
        }
        field(4; "Object Name"; Text[100])
        {
            DataClassification = SystemMetadata;
            Caption = 'Object Name';
        }
        field(6; "App Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'App Name';
        }
        field(7; "Has Counterpart"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Has Counterpart';
        }
    }

    keys
    {
        key(PK; Origin, "Object Type", "Object ID")
        {
            Clustered = true;
        }
        key(Key3; Origin, "Has Counterpart")
        {
            MaintainSiftIndex = false;
        }
    }
}