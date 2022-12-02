tableextension 50131 "OVW Excel Buffer" extends "Excel Buffer"
{
    fields
    {
        field(50131; "OVW Value is BLOB"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
    }

    procedure AddCell(pintRow: Integer; var pintColumn: Integer; pvarValue: Variant; ptxtHeading: Text[250]; pintColumnIncrement: Integer)
    begin
        AddCellWithFormatting(pintRow, pintColumn, pvarValue, ptxtHeading, false, false, false, 2, pintColumnIncrement); //34764+-
    end;

    procedure AddCellWithFormatting(RowNo: Integer; var ColumnNo: Integer; CellValue: Variant; CellHeading: Text[250]; IsBold: Boolean; IsItalic: Boolean; IsUnderlined: Boolean; NumberOfDecimals: Integer; ColumnIncrementValue: Integer)
    var
        DecimalNotation: Text;
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

        DecimalNotation := '#,##0';
        if NumberOfDecimals > 0 then begin
            DecimalNotation += '.';
            DecimalNotation := PadStr(DecimalNotation, StrLen(DecimalNotation) + NumberOfDecimals, '0');
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
                        NumberFormat := DecimalNotation;
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
        if not Insert() then
            Modify();
        AddHeading(ColumnNo, CellHeading);
        ColumnNo += ColumnIncrementValue;
    end;

    [Obsolete('This procedure is no longer used and will be deprecated. This warning will become an error in the future.', '19.1.20220408')]
    procedure AddFormula(pintRow: Integer; var pintColumn: Integer; ptxtFormula: Text[250]; ptxtHeading: Text[250]; pintColumnIncrement: Integer)
    begin
        Init();
        Validate("Row No.", pintRow);
        Validate("Column No.", pintColumn);
        "Cell Value as Text" := '';
        Formula := ptxtFormula;
        if not Insert() then
            Modify();
        AddHeading(pintColumn, ptxtHeading);
        pintColumn += pintColumnIncrement;
    end;

    procedure AddHeading(pintColumn: Integer; ptxtHeading: Text[250])
    begin
        AddHeadingAtRow(1, pintColumn, ptxtHeading);
    end;

    procedure AddHeadingAtRow(RowNo: Integer; var ColumnNo: Integer; ColumnHeading: Text[250])
    begin
        IF ColumnHeading = '' THEN
            exit;
        if RowNo <> 1 then
            ColumnNo += 1;
        if Get(RowNo, ColumnNo) then
            exit;
        Init();
        Validate("Row No.", RowNo);
        Validate("Column No.", ColumnNo);
        "Cell Value as Text" := ColumnHeading;
        Bold := true;
        "Cell Type" := "Cell Type"::Text;
        Insert();
    end;

    procedure CreateExcelBook(SheetName: Text)
    begin
        CreateFile(SheetName);
    end;

    procedure CreateFile(SheetName: Text)
    begin
        CreateNewBook(SheetName);
        WriteSheet(CopyStr(SheetName, 1, 80), CompanyName, UserId);
        CloseBook();
        OpenExcel();
    end;

    [Obsolete('This procedure is no longer used and will be deprecated. This warning will become an error in the future.', '19.1.20220408')]
    procedure OnlyCreateFile(SheetName: Text; BookCreated: boolean)
    var
        FileName: text;
    begin
        ExcelBookCreated := BookCreated;
        NewSheetName := SheetName;
        if not BookCreated then
            CreateNewBook(SheetName);

        WriteSheet(CopyStr(SheetName, 1, 80), CompanyName, UserId);
        if ExcelBookCreated then
            SelectOrAddSheet(NewSheetName);
    end;

    procedure CreateFileWithoutOpening(ptxtSheetName: Text)
    begin
        CreateNewBook(ptxtSheetName);
        WriteSheet(CopyStr(ptxtSheetName, 1, 80), CompanyName, UserId);
        CloseBook();
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