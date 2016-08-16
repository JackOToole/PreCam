unit Search;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TfmSearch = class(TForm)
    btnFind: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Edit: TEdit;
    lblfindText: TLabel;
    Lblmsg: TLabel;
  private
    function Gettext: string;
    { Private declarations }
  public
    { Public declarations }
    property Text:string read Gettext;
  end;

var
  fmSearch: TfmSearch;

implementation

{$R *.dfm}

{ TfmSearch }

function TfmSearch.Gettext: string;
begin
  result := Edit.Text;
end;

end.
