unit dm;

interface

uses
  SysUtils, Classes, Provider, DBTables, DB, DBClient, DBLocal, DBLocalB;

type
  TDataModule1 = class(TDataModule)
    cds: TBDEClientDataSet;
    cdsStaffNumber: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

end.
