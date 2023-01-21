tableextension 50131 "OVW Excel Buffer" extends "Excel Buffer"
{
    fields
    {
        field(50131; "OVW Value is BLOB"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Value is BLOB';
        }
    }

    procedure AddCell(RowNo: Integer; var ColumnNo: Integer; CellValue: Variant; HeadingTxt: Text[250]; ColumnIncrement: Integer)
    begin
        AddCellWithFormatting(RowNo, ColumnNo, CellValue, HeadingTxt, false, false, false, 2, ColumnIncrement);
    end;

    procedure AddCellWithFormatting(RowNo: Integer; var ColumnNo: Integer; CellValue: Variant; HeadingTxt: Text[250]; IsBold: Boolean; IsItalic: Boolean; IsUnderlined: Boolean; NumberOfDecimals: Integer; ColumnIncrement: Integer)
    var
        ExcelBuffer: Record "Excel Buffer";
        DecimalNotationTxt: Text;
    begin
        Init();
        Validate("Row No.", RowNo);
        Validate("Column No.", ColumnNo);
        TestField("Row No.");
        TestField("Column No.");
        Formula := '';
        Bold := IsBold;
        Italic := IsItalic;
        Underline := IsUnderlined;

        DecimalNotationTxt := '#,##0';
        if NumberOfDecimals > 0 then begin
            DecimalNotationTxt += '.';
            DecimalNotationTxt := PadStr(DecimalNotationTxt, StrLen(DecimalNotationTxt) + NumberOfDecimals, '0');
        end;

        case true of
            CellValue.IsInteger,
            CellValue.IsDecimal,
            CellValue.IsDuration,
            CellValue.IsBigInteger:
                begin
                    NumberFormat := '0';
                    "Cell Type" := "Cell Type"::Number;
                    if CellValue.IsDecimal then
                        NumberFormat := DecimalNotationTxt;
                end;

            CellValue.IsDate:
                begin
                    "Cell Type" := "Cell Type"::Date;
                end;

            CellValue.IsTime:
                begin
                    "Cell Type" := "Cell Type"::Time;
                end;

            CellValue.IsDateTime:
                begin
                    "Cell Type" := "Cell Type"::Date;
                end;

            else begin
                "Cell Type" := "Cell Type"::Text;
                if StrLen(Format(CellValue)) > MaxStrLen("Cell Value as Text") then begin
                    "OVW Value is BLOB" := true;
                    ConvertStringToBlob(Format(CellValue), TempBlob);
                    TempBlob.FromRecord(Rec, FieldNo("Cell Value as Blob"));
                end;
            end;
        end;
        if not "OVW Value is BLOB" then
            "Cell Value as Text" := Format(CellValue);

        if not ExcelBuffer.Get(Rec."Row No.", Rec."Column No.") then
            Rec.Insert()
        else
            Rec.Modify();

        AddHeading(ColumnNo, HeadingTxt);
        ColumnNo += ColumnIncrement;
    end;

    procedure AddHeading(ColumnNo: Integer; HeadingTxt: Text[250])
    begin
        AddHeadingAtRow(1, ColumnNo, HeadingTxt);
    end;

    procedure AddHeadingAtRow(RowNo: Integer; var ColumnNo: Integer; HeadingTxt: Text[250])
    begin
        IF HeadingTxt = '' THEN
            exit;
        if RowNo <> 1 then
            ColumnNo += 1;
        if Get(RowNo, ColumnNo) then
            exit;
        Init();
        Validate("Row No.", RowNo);
        Validate("Column No.", ColumnNo);
        "Cell Value as Text" := HeadingTxt;
        Bold := true;
        "Cell Type" := "Cell Type"::Text;
        Insert();
    end;

    procedure CreateExcelBook(SheetNameTxt: Text)
    begin
        CreateFile(SheetNameTxt);
    end;

    procedure CreateFile(SheetNameTxt: Text)
    begin
        CreateNewBook(SheetNameTxt);
        WriteSheet(CopyStr(SheetNameTxt, 1, 80), CompanyName, UserId);
        CloseBook();
        OpenExcel();
    end;


    procedure ConvertStringToBlob(Input: Text; var TempBlob: Codeunit "Temp Blob"): Integer
    var
        WriteStream: OutStream;
    begin
        TempBlob.CreateOutStream(WriteStream, TextEncoding::UTF8);
        WriteStream.WriteText(Input);
    end;

    var
        TempBlob: Codeunit "Temp Blob";

        ExcelBookCreated: Boolean;
        NewSheetName: text[20];
}