unit DataUnit;

interface

uses
  SysUtils, Classes, DBXpress, DB, SqlExpr, FMTBcd, DBClient, Provider,
  IBDatabase, IBCustomDataSet, IBQuery;

type
  TDM = class(TDataModule)
    DataSetProvider1: TDataSetProvider;
    CDS: TClientDataSet;
    qry: TIBQuery;
    db: TIBDatabase;
    IBTransaction1: TIBTransaction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

end.
