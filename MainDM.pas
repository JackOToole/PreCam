unit MainDM;

interface

uses
  SysUtils, Classes, Provider, DBTables, DB, DBClient, DBLocal, DBLocalB;

type
  TDM = class(TDataModule)
    cds: TBDEClientDataSet;
    cdsStaffNumber: TStringField;
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
