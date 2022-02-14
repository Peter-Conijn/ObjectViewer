xmlport 50130 "OVW Object Data I/O"
{
    Caption = 'Object Data I/O';
    Format = Xml;
    Encoding = UTF8;
    UseDefaultNamespace = true;

    schema
    {
        textelement(objectData)
        {
            tableelement(objects; "OVW Object Comparison")
            {
                textelement(object)
                {
                    MaxOccurs = Unbounded;
                    fieldattribute(app; objects."App Name")
                    {
                        Occurrence = Required;
                    }

                    fieldelement("type"; objects."Object Type")
                    {
                        MinOccurs = Once;
                        MaxOccurs = Once;
                    }
                    fieldelement("id"; objects."Object ID")
                    {
                        MinOccurs = Once;
                        MaxOccurs = Once;
                    }
                    fieldelement("name"; objects."Object Name")
                    {
                        MinOccurs = Once;
                        MaxOccurs = Once;
                    }
                }

                trigger OnBeforeInsertRecord()
                begin
                    objects.Origin := Enum::"OVW Origin"::Imported;
                end;
            }
        }
    }
}