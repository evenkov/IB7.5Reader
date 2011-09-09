unit TestMainUnit;

interface

uses
  ShareMem, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    edDB: TEdit;
    edSQL: TEdit;
    mmRes: TMemo;
    btnGet: TButton;
    procedure btnGetClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure ReadData(var db:AnsiString; var sql: AnsiString; var data: AnsiString); stdcall external 'Ib75Reader.dll';

procedure TForm1.btnGetClick(Sender: TObject);
var
  data, db, sql : String;
begin
  db := edDB.Text;
  sql := edSQL.Text;
  ReadData(db, sql, data);
  mmRes.Lines.Text := data;
end;

end.
