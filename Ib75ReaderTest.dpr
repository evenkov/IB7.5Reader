program Ib75ReaderTest;

uses
  Forms,
  TestMainUnit in 'TestMainUnit.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
