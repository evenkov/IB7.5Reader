program ib75reader;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DateUtils,
  SqlTimSt,
  DataUnit in 'DataUnit.pas' {DM: TDataModule},
  Base64 in '..\..\Omeks2000\Omeks2kCommon\Base64.pas';

const
  sREAD_RTOTALFACTURA = 'GETINVOICES';
  sREAD_SPECIFICINFOICES = 'GETSPECINVOICES';
  sREAD_UP_AL3_OBOROT = 'GETPAYMENTS';

  SQL_SELECT_RTOTALFACTURA = 'SELECT DOCNO, TIPDOC, VIDDOC, DATEDOC, F_DISTRIBUTOR, ' +
    ' OUTFIRMNAME, OUTFIRMADRES, NOM_17.F_BULSTAT OUTBULSTAT, MESTOIZDAVANE,' +
    ' PAYMANT,DATEORDER, DATEPADEJ, TOTALSUM, TOTALDDS, TOTAL, DDSRATE, DATETAXEVENT,' +
    ' R_ADRES,R_COUNTRY,R_CITY,R_POSTCODE,F_BULSTAT, F_NAIMENOVANIE' +
    ' FROM RTOTALFACTURA ' +
    ' LEFT JOIN NOM_18 ON RTOTALFACTURA.F_DISTRIBUTOR = NOM_18.F_KONTRAGENT' +
    ' LEFT JOIN NOM_17 ON RTOTALFACTURA.F_KONTRAGENT = NOM_17.F_KONTRAGENT' +
    ' WHERE (SYS_DATE >= ''%s'') AND (SYS_DATE <= ''%s'')';

  SQL_SELECT_SPECIFICINVOICES = 'SELECT DOCNO, TIPDOC, VIDDOC, DATEDOC, F_DISTRIBUTOR, ' +
    ' OUTFIRMNAME, OUTFIRMADRES, NOM_17.F_BULSTAT OUTBULSTAT, MESTOIZDAVANE,' +
    ' PAYMANT,DATEORDER, DATEPADEJ, TOTALSUM, TOTALDDS, TOTAL, DDSRATE, DATETAXEVENT,' +
    ' R_ADRES,R_COUNTRY,R_CITY,R_POSTCODE,F_BULSTAT, F_NAIMENOVANIE' +
    ' FROM RTOTALFACTURA ' +
    ' LEFT JOIN NOM_18 ON RTOTALFACTURA.F_DISTRIBUTOR = NOM_18.F_KONTRAGENT' +
    ' LEFT JOIN NOM_17 ON RTOTALFACTURA.F_KONTRAGENT = NOM_17.F_KONTRAGENT ' +
    ' WHERE (DOCNO IN (%s))';

  SQL_SELECT_UP_AL3_OBOROT = 'SELECT UP_AL3_OBOROT.NUMBEROPER, UP_AL3_OBOROT.VIDDOKUMENT,UP_AL3_OBOROT.DOCNO,' +
    ' UP_AL3_OBOROT.DATEPAY,UP_AL3_OBOROT.B_DOCNO,UP_AL3_OBOROT.B_DATEDOC, UP_AL3_OBOROT.FTOTAL,' +
    ' UP_AL3_OBOROT.B_F_TYPEDOC,NOM_17.F_BULSTAT, NOM_17.F_NAIMENOVANIE, UP_AL3.DATEDOC FROM UP_AL3_OBOROT' +
    ' LEFT JOIN NOM_17 ON UP_AL3_OBOROT.F_KONTRAGENT = NOM_17.F_KONTRAGENT' +
    ' LEFT JOIN UP_AL3 ON (UP_AL3_OBOROT.DOCNO = UP_AL3.DOCNO)  AND (UP_AL3_OBOROT.VIDDOC = UP_AL3.VIDDOC)' +
    ' WHERE (UP_AL3_OBOROT.SYS_DATE >= ''%s'') AND (UP_AL3_OBOROT.SYS_DATE <= ''%s'')';

procedure WriteDataToFile(const FileName: string; const Data: AnsiString; AppendFile: Boolean = False);
const
  sTMP_ = 'tmp_%s';
var
  fXML: TextFile;
  sTmpFileName: string;
begin
    sTmpFileName := ExtractFilePath(FileName) + Format(sTMP_, [ExtractFileName(FileName)]);
    AssignFile(fXML, sTmpFileName);
    if (FileExists(sTmpFileName)) and (AppendFile) then
    begin
      Append(fXML);
    end
    else
    begin
      Rewrite(fXML);
    end;

    Write(fXML, Data);
    CloseFile(fXML);
    RenameFile(sTmpFileName, FileName);
end;

procedure ConnectToDB(const db: string);
begin
  try
    DM := TDM.Create(nil);
    DM.db.DatabaseName := db;
    DM.db.Connected := True;
  except
    on ex: Exception do
    begin
      WriteDataToFile('ib75reader_error.log', ex.Message, True);
    end;
  end;
end;

procedure DisconnectFromDB();
begin
  if (DM = nil) then
  begin
    Exit;
  end;

  try
    DM.CDS.Close;
    DM.qry.Close();
    DM.IBTransaction1.Commit;
    DM.db.Connected := FALSE;
    FreeAndNil(DM);
  except
    on ex: Exception do
    begin
      WriteDataToFile('ib75reader_error.log', ex.Message, True);
    end;
  end;
end;

procedure ReadData(const SQL: string; const sTimeFrom, sTimeTo: string; const filename: string; Options: Byte = 0);
var
  data: AnsiString;
  sT1, sT2: string;
begin
  data := '';
  try
    try
      if (Options <> 1) then
      begin
        sT1 := StringReplace(sTimeFrom, '#', ' ', [rfReplaceAll]);
        sT2 := StringReplace(sTimeTo, '#', ' ', [rfReplaceAll]);
        DM.qry.SQL.Text := Format(SQL, [sT1, sT2]);
      end
      else
      begin
        DM.qry.SQL.Text := SQL;
      end;
    except
      on E: Exception do
      begin
        data := 'ERROR:Connect database:' + E.Message;
        Exit;
      end;
    end;

    try
      DM.CDS.Open();
    except
      on E: Exception do
      begin
        data := 'ERROR:Open dataset:' + E.Message+#13'SQL:'+DM.qry.SQL.Text;
        Exit;
      end;
    end;

    data := AnsiToUtf8(DM.CDS.XMLData);

  finally
    WriteDataToFile(filename, data);
  end;
end;

begin
  DM := nil;

  try
    ConnectToDB(ParamStr(1));

    try
      repeat
        if (ParamStr(2) = sREAD_RTOTALFACTURA) then
        begin
          ReadData(SQL_SELECT_RTOTALFACTURA, ParamStr(3), ParamStr(4), ParamStr(5), 0);
          Break;
        end;

        if (ParamStr(2) = sREAD_UP_AL3_OBOROT) then
        begin
          ReadData(SQL_SELECT_UP_AL3_OBOROT, ParamStr(3), ParamStr(4), ParamStr(5), 0);
          Break;
        end;

        if (ParamStr(2) = sREAD_SPECIFICINFOICES) then
        begin
          ReadData(SQL_SELECT_SPECIFICINVOICES, TBase64.Base64DecodeStr(ParamStr(3)), '', ParamStr(5), 0);
          Break;
        end;

      until (True);

    except
      on ex: Exception do
      begin
        WriteDataToFile('ib75reader_error.log', ex.Message);
      end;
    end;
  finally
    DisconnectFromDB();
  end;
end.

