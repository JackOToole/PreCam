unit categories;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles;

type
  TfmCategories = class(TForm)
    btnClose: TButton;
    EditStr: TEdit;
    btnAdd: TButton;
    btnDelete: TButton;
    listCategories: TListBox;
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure listCategoriesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure listCategoriesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure listCategoriesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCategories: TfmCategories;
  NumX,NumY:integer;

implementation


{$R *.dfm}
//------------------------------------------------------------------------------
procedure TfmCategories.btnAddClick(Sender: TObject);
begin
  if (EditStr.text <> '') then
    begin
      listCategories.Items.Add(EditStr.Text);
      EditStr.Clear;
    end;
end;
//------------------------------------------------------------------------------
procedure TfmCategories.btnCloseClick(Sender: TObject);
var
  i:integer;
  filename:string;
  sl:Tstringlist;

begin
  sl:= Tstringlist.Create;
  filename := ExtractFileDir( Application.ExeName)+ '\Categories.txt';

  if listCategories.Items.Count > 0 then
  begin
    for i := 0 to listCategories.Count - 1 do
      begin
        sl.Add(listCategories.Items[i]);
      end;
    sl.SaveToFile(filename);
  end;

  sl.free;
  fmCategories.ModalResult := mrOk;
end;
//------------------------------------------------------------------------------
procedure TfmCategories.btnDeleteClick(Sender: TObject);
begin
  if (listCategories.Items.Count >0 ) then
    listCategories.Items.Delete(listCategories.ItemIndex);
  EditStr.SetFocus;
end;
//------------------------------------------------------------------------------
procedure TfmCategories.FormCreate(Sender: TObject);
var
  i:integer;
  filename:string;
  sl:Tstringlist;

begin
  sl:= Tstringlist.Create;
  filename := ExtractFileDir( Application.ExeName)+ '\Categories.txt';
  if FileExists(filename) then
     sl.LoadFromFile(filename)
     else
     begin
       sl.Add('PLH');
       sl.Add('RCS');
       sl.Add('TRN');
       sl.Add('BLH');
       sl.Add('RLH');
       sl.Add('LOA');
       sl.Add('UT');
       sl.Add('SVY');
       sl.Add('FCC');
       sl.Add('PFL');
       sl.Add('INS');
       sl.SaveToFile(filename);
     end;


  for i := 0 to sl.Count - 1 do
      begin
        listCategories.Items.add (sl[i]);
      end;

  sl.free;
//------------------------------------------------------------------------------
end;
procedure TfmCategories.listCategoriesDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Num1,Num2:Integer;
  Point1,Point2:TPoint;
begin
  Point1.X := NumX;
  Point1.Y := NumY;
  Point2.X := X;
  Point2.Y := Y;
  with source as TListBox do
  begin
    Num2 := listCategories.ItemAtPos(point1,True);
    Num1 := listCategories.ItemAtPos(point2,True);
    listCategories.Items.Move(Num2,Num1);
  end;
end;
//------------------------------------------------------------------------------
procedure TfmCategories.listCategoriesDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Source= listCategories then Accept := true;

end;
//------------------------------------------------------------------------------
procedure TfmCategories.listCategoriesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  NumY:=Y;
  NumX:=X;
end;

//------------------------------------------------------------------------------
end.
