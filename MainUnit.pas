unit MainUnit;

interface

uses

  ShareMem,
  SysUtils,
  Classes,
  Dialogs,
  DataUnit;

procedure ReadData(var db:AnsiString; var sql: AnsiString; var data: AnsiString); stdcall;

implementation

procedure ReadData(var db:AnsiString; var sql: AnsiString; var data: AnsiString); stdcall;
begin
  ShowMessage('begin');
  data := '';
  DM := nil;

  try
    try
      DM := TDM.Create(nil);
      ShowMessage('DM created');

      DM.db.DatabaseName := db;
      DM.db.Connected := TRUE;

      ShowMessage('Database connected');

      DM.qry.SQL.Text := sql;
    except
      on E: Exception do
      begin
        data := 'ERROR:Connect database:'+E.Message;
        Exit;
      end;
    end;

    try
      DM.CDS.Open();
      ShowMessage('ClientDataSet open');
    except
      on E: Exception do
      begin
        data := 'ERROR:Open dataset:'+E.Message;
        Exit;
      end;
    end;

    data := DM.CDS.XMLData;

    ShowMessage('Got data');
  finally
    If DM <> nil then
    begin
      DM.CDS.Close;
      DM.qry.Close();
      DM.IBTransaction1.Commit;
      DM.db.Connected := FALSE;

      ShowMessage('Disconnected');

      FreeAndNil(DM);

      ShowMessage('DM destroyed');
    end;
  end;
end;

end.
