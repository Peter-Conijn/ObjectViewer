table 50130 "OVW Object Comparison"
{
    DataClassification = SystemMetadata;
    Caption = 'Object Comparison';
    DrillDownPageId = "OVW Object Comparison";
    LookupPageId = "OVW Object Comparison";
    ObsoleteState = Pending;
    ObsoleteReason = 'This functionality has been marked as obsolete and will be removed. This warning will become an error in a later version.';
    ObsoleteTag = '1.2';


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
        key(Key3; Origin, "Object Type", "Has Counterpart")
        {
            MaintainSiftIndex = false;
        }
    }
}