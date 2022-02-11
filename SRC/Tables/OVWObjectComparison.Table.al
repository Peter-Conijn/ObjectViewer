table 50130 "OVW Object Comparison"
{
    DataClassification = ToBeClassified;

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
        field(5; "Object Hash"; Text[1024])
        {
            DataClassification = SystemMetadata;
            Caption = 'Object Hash';
        }
    }

    keys
    {
        key(PK; Origin, "Object Type", "Object ID")
        {
            Clustered = true;
        }
        key(Key2; Origin, "Object Hash")
        {
            Unique = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        CreateObjectHash();
    end;

    local procedure CreateObjectHash()
    var
        CryptographyManagement: Codeunit "Cryptography Management";
        HashInputLbl: Label '%1-%2-%3', Locked = true;
        HashInput: Text;
    begin
        HashInput := StrSubstNo(HashInputLbl, "Object Type", "Object ID", "Object Name");
        "Object Hash" := CryptographyManagement.GenerateHash(HashInput, 0);
    end;

}