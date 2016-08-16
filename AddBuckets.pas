unit AddBuckets;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls,GetData, Grids;

type
  TfmADDBuckets = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    sgPatterns: TStringGrid;
    rgLimit: TRadioGroup;
    listTripCodes: TListBox;
    lblLimit: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure listTripCodesDblClick(Sender: TObject);
    procedure rgLimitClick(Sender: TObject);
    procedure sgPatternsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Clear;

  end;

var
  fmADDBuckets: TfmADDBuckets;

implementation

{$R *.dfm}

procedure TfmADDBuckets.OKBtnClick(Sender: TObject);
var
  index:integer;
begin
  addBucket.Patterns.Clear;
  for index := 0 to 9 do
  begin
    sgPatterns.cells[0,index] := uppercase(sgPatterns.cells[0,index]);
    addBucket.Patterns.add(sgPatterns.cells[0,index]);
  end;
  addBucket.Limit    := rgLimit.ItemIndex + 1;
end;

procedure TfmADDBuckets.FormCreate(Sender: TObject);
begin
  rgLimit.ItemIndex := 0;
end;

procedure TfmADDBuckets.listTripCodesDblClick(Sender: TObject);
{add trip to bucket}
var
  i:integer;
begin
  for i := 0 to 9 do
    if sgPatterns.cells[0,i] = '' then
    begin
      sgPatterns.Cells[0,i] := listTripCodes.items[listTripCodes.itemindex];
      break;
    end;

end;
// ----------------------------------------------------------------------------
procedure TfmADDBuckets.rgLimitClick(Sender: TObject);
begin
  lblLimit.Caption := 'Limit ' + inttostr(rgLimit.ItemIndex +1);
end;
// ----------------------------------------------------------------------------
procedure TfmADDBuckets.Clear;
var
  i :integer;
begin
  for i := 0 to 9 do
    sgPatterns.Cells[0,i] :='';
  rgLimit.ItemIndex := 0;  
end;
// ----------------------------------------------------------------------------
procedure TfmADDBuckets.sgPatternsDblClick(Sender: TObject);

var
  i,arow:integer;
begin
  aRow := sgPatterns.Row;
  for i := arow  to 8 do
    sgPatterns.Cells[0,i] := sgPatterns.Cells[0,i+ 1];

end;

end.
