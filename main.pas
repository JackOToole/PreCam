unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, Grids, Menus, ExtCtrls,
  OleCtrls, my_strings, TeEngine, Series, TeeProcs, Chart, ToolWin,IniFiles;


type
  TfmMain = class(TForm)
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    dlgPrint: TPrintDialog;
    dlgPrinterSetup: TPrinterSetupDialog;
    sb: TStatusBar;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    mnuOpen: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    mnuView: TMenuItem;
    mnuOpen2nd: TMenuItem;
    mnuClose2ndDiag: TMenuItem;
    mnuShowList: TMenuItem;
    mnuHideList: TMenuItem;
    Edit1: TMenuItem;
    ff: TMenuItem;
    N4: TMenuItem;
    mnuEditPaste: TMenuItem;
    mnuEditCopy: TMenuItem;
    mnuEditCut: TMenuItem;
    N5: TMenuItem;
    mnuSelectAll: TMenuItem;
    mnuEditUndo: TMenuItem;
    N3: TMenuItem;
    mnuLoadtoData: TMenuItem;
    N6: TMenuItem;
    mnuAlphabetical: TMenuItem;
    pc: TPageControl;
    tsListview: TTabSheet;
    lblExpiree: TLabel;
    ListNames: TListBox;
    rtDiag: TRichEdit;
    pnlListView: TPanel;
    Label1: TLabel;
    lblGlobalBids: TLabel;
    btnCheckbuckets: TButton;
    editSearch: TEdit;
    btnCheckMBT: TButton;
    btnListFirst: TBitBtn;
    btnListPrev: TBitBtn;
    btnListNext: TBitBtn;
    btnListLast: TBitBtn;
    btnPreAlloc: TButton;
    btnMoveBids: TBitBtn;
    tsBuckets: TTabSheet;
    Label2: TLabel;
    sgBuckets: TStringGrid;
    btnDeleteBucket: TButton;
    GroupBox1: TGroupBox;
    lblLimit: TLabel;
    btnOKBuckets: TButton;
    listTripCodes: TListBox;
    sgPatterns: TStringGrid;
    Button1: TButton;
    tsSplitView: TTabSheet;
    Splitter2: TSplitter;
    ToolBar1: TToolBar;
    btnSplitFirst: TBitBtn;
    bntSplitPrev: TBitBtn;
    btnSplitNext: TBitBtn;
    btnSplitLast: TBitBtn;
    ToolButton1: TToolButton;
    btnCompare: TButton;
    lblSplitCompare: TLabel;
    rtSplit1: TRichEdit;
    rtSplit2: TRichEdit;
    tsCompare: TTabSheet;
    chartLineRating: TChart;
    Series4: TLineSeries;
    Series3: TLineSeries;
    dlgLoad: TOpenDialog;
    FindDialog: TFindDialog;
    mnuViewCaptain: TMenuItem;
    mnuVeiwF_O: TMenuItem;
    mnuViewS_O: TMenuItem;
    btnSelectroutecode: TButton;
    N7: TMenuItem;
    tsSummary: TTabSheet;
    ToolBar2: TToolBar;
    rtSummary: TRichEdit;
    mnuFilters: TMenuItem;
    mnuFiltersPreAlloc: TMenuItem;
    mnuFiltersLowLines: TMenuItem;
    btnMoveTopDiag: TBitBtn;
    btnNextDifference: TButton;
    mnuFileCreateawards: TMenuItem;
    mnuFiltersTrainingAllocated: TMenuItem;
    mnuAbout: TMenuItem;
    mnuFiltersUnlocked: TMenuItem;
    ListLimitValue: TListBox;
    Label3: TLabel;
    cbCheckBuckets2Bps: TCheckBox;
    mnuEditCategories: TMenuItem;
    tsDistribution: TTabSheet;
    chartDistribution: TChart;
    SeriesDistribution: TBarSeries;
    lstRouteCodes: TListBox;
    btnCleaSelectedrRouteCodes: TButton;
    btnWeekendsOff: TButton;
    btnDaysAway: TButton;
    procedure FormCreate(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure ListNamesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDeleteBucketClick(Sender: TObject);
    procedure pcChange(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure btnDiagFirstClick(Sender: TObject);
    procedure btnDiagPrevClick(Sender: TObject);
    procedure btnDiagNextClick(Sender: TObject);
    procedure btnDiafLastClick(Sender: TObject);
    procedure btnCheckbucketsClick(Sender: TObject);
    procedure mnuNameListClick(Sender: TObject);
    procedure editSearchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuOpen2ndClick(Sender: TObject);
    procedure mnuClose2ndDiagClick(Sender: TObject);
    procedure mnuShowListClick(Sender: TObject);
    procedure mnuHideListClick(Sender: TObject);
    procedure mnuEditCopyClick(Sender: TObject);
    procedure mnuEditPasteClick(Sender: TObject);
    procedure mnuEditCutClick(Sender: TObject);
    procedure mnuSelectAllClick(Sender: TObject);
    procedure sbDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure mnuTextBlueClick(Sender: TObject);
    procedure mnuTextGreyClick(Sender: TObject);
    procedure mnuTextWhiteClick(Sender: TObject);
    procedure mnuTextYellowClick(Sender: TObject);
    procedure mnuTextGreenClick(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
    procedure ffClick(Sender: TObject);
    procedure btnPreAllocClick(Sender: TObject);
    procedure btnCompareClick(Sender: TObject);
    procedure mnuAlphabeticalClick(Sender: TObject);
    procedure listTripCodesDblClick(Sender: TObject);
    procedure sgPatternsDblClick(Sender: TObject);
    procedure btnOKBucketsClick(Sender: TObject);
    //procedure rgLimitClick(Sender: TObject);
    procedure btnMoveBidsClick(Sender: TObject);
    procedure btnMoveDiagTopClick(Sender: TObject);
    procedure mnuViewRankClick(Sender: TObject);
    procedure mnuviewPLHClick(Sender: TObject);
    procedure mnuFiltersClick(Sender: TObject);
    procedure btnNextDifferenceClick(Sender: TObject);
    procedure mnuFileCreateawardsClick(Sender: TObject);
    procedure rtSplit2Change(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
//    procedure Label3Click(Sender: TObject);
    procedure ListLimitValueClick(Sender: TObject);
    procedure mnuEditCategoriesClick(Sender: TObject);
    procedure tsCompareContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure lstRouteCodesClick(Sender: TObject);
    procedure btnCleaSelectedrRouteCodesClick(Sender: TObject);
    procedure btnWeekendsOffClick(Sender: TObject);
    procedure btnDaysAwayClick(Sender: TObject);


  private
    App_path,FCrew,FNotes,Rank,{Status,}LineType:String;
    PreAllocationMode,Searching:Boolean;
    Filter:integer;
    DiagView,BidsView,NamePointer:Tstringlist;
    DataFolder:string;
    Procedure DisplayData;
    function  displayRank:string;
    procedure DistributionDaysaway;
    procedure DistributionWeekEndsoff;
    procedure DistributionRouteCodes(sl:Tstringlist);
    Procedure LoadDiag(fn:String);
    Procedure SplitView(index:integer);
    function  GetCrew: string;
    function  GetNotes: string;
    procedure LoadCategories;
    procedure LoadRouteCodes;
    function  ReadFileinUse:string;
    Procedure ResetBuckets;
    Procedure ResetFilters;
    procedure ResetStatusRank;
    procedure SaveFileInUse(fn:string);
    procedure SetCrew(const Value: string);
    procedure SetNotes(const Value: string);
    procedure SetStatusText;

  public
    Property Crew:string read GetCrew Write SetCrew ;
    Property Notes:string read GetNotes Write SetNotes ;

  end;

var
  fmMain: TfmMain;

implementation

uses  Data, ABOUT, categories;

{$R *.dfm}
function ContainsStr(substr,str:string):boolean;
begin
  if pos(substr,str)<> 0 then result := true
   else result := false;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.sgPatternsDblClick(Sender: TObject);
var
  i,arow:integer;
begin
  aRow := sgPatterns.Row;
  for i := arow  to 8 do
    sgPatterns.Cells[0,i] := sgPatterns.Cells[0,i+ 1];

end;
// ----------------------------------------------------------------------------
procedure TfmMain.FormCreate(Sender: TObject);
var
  fn:string;
  I:integer;

begin
  sb.Panels[3].Text    := 'PreCam '+ version + '  by Jack OToole'+ tab ;
  // populate a list with values for the buckets limits
  for I := 1 to 99 do
    ListLimitValue.items.Add(inttostr(I));


  Buckets              := TBuckets.create;
  DiagView             := TStringList.create;
  BidsView             := TStringList.create;
  NamePointer          := TStringList.Create;
  AddBucket.Patterns   := TStringList.create;

  Status := TStatus.create;
  ResetStatusRank;

  dlgOpen.InitialDir   := extractfiledir(application.exename) +'\Data';
  App_path             := extractfiledir(application.exename);
  DataFolder := dlgOpen.InitialDir;


  PreAllocationMode := false;
  Filter := Default;
  fn:= ReadFileinUse;
  if FileExists(fn) then
      begin
        LoadDiag(fn);
        ResetBuckets;
        ResetStatusRank;
        ResetFilters;
      end
    else
     mnuOpenClick(self);  // choose diag file

end;
// ----------------------------------------------------------------------------
procedure TfmMain.mnuOpenClick(Sender: TObject);
{open data file and laod a Diag}
begin

  if dlgOpen.Execute then
  begin
    // extract data for display
    if FileExists(dlgOpen.FileName) then
    begin
      dlgOpen.InitialDir:= extractfiledir(dlgOpen.FileName);
      DataFolder := dlgOpen.InitialDir;
      LoadDiag(dlgOpen.FileName);
      ResetBuckets;
      ResetStatusRank;
      ResetFilters;
    end;
  end;
end;
{  --------------------------------------------------------------------------  }
procedure TfmMain.DisplayData;
// procedure used after loading a new diag or switching ranks to reset the
// name list and update menus,buckets and compare. splitview update ocurrs in
// namelistclick
var
  sl:Tstringlist;
begin
  sl:=TStringList.Create;// temp for names storage
  NamePointer.Clear;
  btnDeleteBucketClick(nil);

  // either alpha or seniority
  with Diag do
  begin
    if mnuAlphabetical.Checked then
      NamesAlpha(sl,NamePointer,Rank,Status,Filter)
    else
      NamesSeniority(sl,NamePointer,Rank,Status,Filter);
    ListNames.Items.Assign(sl);
  end;

  sl.Clear;
  Diag.Summary(sl);
  rtSummary.Lines.Assign(sl);

  sl.Free;
  ListNamesClick(nil);

  //if DiagTwo.Count = Diag.Count then
  btnCompareClick(nil);
  DistributionDaysaway;

end;
//------------------------------------------------------------------------------
function TfmMain.displayRank: string;
begin
  if Rank = 'None' then
    result := 'Any Rank. '
    else
    result := Rank;
end;
//------------------------------------------------------------------------------
procedure TfmMain.DistributionDaysaway;
var i,y,crewNum:integer;

begin
  chartDistribution.Title.Text.Strings[0] := 'Days Away';
  SeriesDistribution.Clear;
  crewNum := 0;
   for i := 0 to ListNames.Items.Count -1 do// continue through list
  begin
    if (Rank = Diag.Crews[strtoint(NamePointer[i])].Crewd.Rank) or (Rank = 'None') then
    begin
      y:= Diag.crews[strtoint(NamePointer[i])].Trips.TotalDaysAway -
          Diag.crews[strtoint(NamePointer[i])].CarryinDays;
      inc(crewNum);
      SeriesDistribution.AddXY(crewNum,y,'',clblue);
    end;
  end;
end;
// -----------------------------------------------------------------------------
procedure TfmMain.DistributionWeekEndsoff;
var i,y,crewNum:integer;
    a_status:string;

begin
    chartDistribution.Title.Text.Strings[0] := 'Week ends Off';
  SeriesDistribution.Clear;
  crewNum := 0;
  for i := 0 to ListNames.Items.Count -1 do// continue through list
  begin
    a_status := Diag.Crews[strtoint(NamePointer[i])].CrewD.status;
    if (Status.valid(a_status)) then
      if (Rank = Diag.Crews[i].Crewd.Rank) or (Rank = 'None')   then
      begin
        y:= Diag.crews[strtoint(NamePointer[i])].NumberofWeekends;
        inc(crewNum);
        SeriesDistribution.AddXY(crewNum,y);
      end;
  end;
end;
// -----------------------------------------------------------------------------
procedure TfmMain.DistributionRouteCodes(sl:Tstringlist);
// sl, passes a list of route codes
// for each crew in Diag, for each allocation in the crew trips, check for a matching
// routecode
var
  i,j,k,result,crewNum:integer;

begin
   //chartDistribution.Title := chartDistribution.Title[2];
   //chartDistribution.Title := rc;
   SeriesDistribution.Clear;
   result:= 0;
   crewNum:= 0;
  for i := 0 to ListNames.Items.Count -1 do
  begin
    if (Rank = Diag.Crews[strtoint(NamePointer[i])].Crewd.Rank) or (Rank = 'None') then
    inc(crewNum);
    for j := 0 to Diag.crews[strtoint(NamePointer[i])].trips.count- 1 do
      begin
        for k := 0 to sl.Count -1 do
        begin
          if sl[k] = Diag.Crews[strtoint(NamePointer[i])].Trips.allocs[j].RouteCode then
            inc(result);
        end;
    end;
    SeriesDistribution.AddXY(crewNum,result,'',clgreen);
    result := 0;
  end;
end;
//------------------------------------------------------------------------------
procedure TfmMain.ListLimitValueClick(Sender: TObject);
begin
    lblLimit.Caption := 'Limit ' + inttostr(ListLimitValue.ItemIndex +1);
end;
//------------------------------------------------------------------------------
procedure TfmMain.ListNamesClick(Sender: TObject);
// use name in list to update displays
// Namepointer is a string list holding indexes to the current list of names.
var
  index:integer;
  sl:tstringlist;
  ms:TMemoryStream;
begin
  Notes := '';
  if ListNames.Count = 0 then
  begin
    rtDiag.Lines.Clear;
    rtDiag.Lines.Add('No crew to display, ' + Displayrank + Status.displayStatus);
   end
   else
   begin
      if ListNames.ItemIndex = -1 then
        ListNames.ItemIndex := 0;
      Index:= strtoint(NamePointer[ListNames.ItemIndex]); //Index points to crews array

       // Diag Display
      sl:= Tstringlist.create;
      ms:= TMemoryStream.Create;
      Diag.Display(sl,Index,PreallocationMode);// todo check for valid index
      sl.SaveToStream(ms);
      ms.Position := 0;
      rtDiag.lines.LoadFromStream(ms);// this does the rich text magic
      rtDiag.lines.Delete(0);rtDiag.lines.Delete(1);// remove lines added to store rich text info in line above
      if DiagTwo.Count > 0{Diag.Count} then// try split for any crew
         SplitView(Index);

      sl.Free;
      ms.Free;

      //Crew and Notes property
      Crew := Diag.CrewName[index] + '  ' + inttostr(ListNames.ItemIndex + 1) + ' of ' +
             inttostr(ListNames.Count);
      if Diag.Crews[index].Notes <> '' then
         Notes := Diag.Crews[index].Notes;
   end;
end;

{  --------------------------------------------------------------------------  }
procedure TfmMain.FormDestroy(Sender: TObject);
begin
  Buckets.free;
  AddBucket.Patterns.Free;
  Diag.free;
  DiagView.free;
  BidsView.free;
  NamePointer.Free;
  Status.Free;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.btnDaysAwayClick(Sender: TObject);
begin
  DistributionDaysaway;
end;
//------------------------------------------------------------------------------
procedure TfmMain.btnDeleteBucketClick(Sender: TObject);
var
  i,j:integer;
begin
  sgBuckets.ColCount := 1;
  for i := 0 to sgBuckets.RowCount - 1 do
    for j := 0 to sgBuckets.RowCount - 1 do
      sgBuckets.Cells[j,i] := '';
  Buckets.Clear;

end;
// ----------------------------------------------------------------------------
procedure TfmMain.pcChange(Sender: TObject);
begin
  case pc.ActivePageIndex of
    0: ListNames.SetFocus;
  //2: btnDiagNext.SetFocus;
    7: btnSplitNext.SetFocus;
  end;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.Exit1Click(Sender: TObject);
begin
  close;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.btnDiagFirstClick(Sender: TObject);
begin
  ListNames.ItemIndex := 0;
  ListNamesClick(self);
end;
// ----------------------------------------------------------------------------
procedure TfmMain.btnDiagPrevClick(Sender: TObject);
begin
  if ListNames.ItemIndex > 0 then
  begin
    ListNames.ItemIndex := ListNames.ItemIndex - 1;
    ListNamesClick(self);
  end;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.btnDiagNextClick(Sender: TObject);
begin
  if ListNames.ItemIndex <> ListNames.Count -1 then
  begin
    ListNames.ItemIndex := ListNames.ItemIndex + 1;
    ListNamesClick(self);
  end;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.btnDiafLastClick(Sender: TObject);
begin
  ListNames.ItemIndex := ListNames.count-1;
  ListNamesClick(self);
end;
// ----------------------------------------------------------------------------
procedure TfmMain.btnCheckbucketsClick(Sender: TObject);
var
  index:integer;
  result,carryin:boolean;
  Trips1,Trips2:TTrips;
  icrew:integer;
begin
 result:=true;
// if n0 buckets exist then nothing to do
  if not Buckets.NumBuckets > 0 then
  begin
      MessageDlg('No buckets Set',mtinformation,[mbok],0);
      exit;
  end;


  if ListNames.Itemindex = ListNames.Count -1 then // end of list, return to start
      ListNames.Itemindex := 0
      else // move to next name on the list
      ListNames.Itemindex := ListNames.Itemindex + 1;

  for index := ListNames.Itemindex to ListNames.Items.Count -1 do// continue through list
    begin

      Carryin := Diag.Crews[index].CarryIn;
      Trips1 := diag.Crews[strtoint(NamePointer[index])].Trips;

      // needs work check valid daig2, trips2 etc

      If (diagTwo.count> 0) then
      begin
        icrew := DiagTwo.SnToIndex(Diag.Crews[strtoint(NamePointer[index])].CrewD.Sn);
        // check for valid icrew, ie crew exists in second
        Trips2 := diagTwo.Crews[icrew].Trips;
      end;

      if cbCheckBuckets2Bps.Checked then
         result :=  Buckets.CheckBuckets2Bps(Trips1,Trips2,CarryIn)
         else
         result := Buckets.CheckBuckets(Trips1,CarryIn);

      if (not result) then // buckets exceeded
         begin
           ListNames.ItemIndex := index;
           ListNamesClick(sender);
           break;
         end;

    end;


  //display result
  if result then
   MessageDlg('Buckets OK',mtinformation,[mbok],0)
  else
   MessageDlg('Buckets Exceeded',mtinformation,[mbok],0);

end;
// ----------------------------------------------------------------------------
procedure TfmMain.mnuNameListClick(Sender: TObject);
begin
  ListNames.SetFocus;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.mnuViewRankClick(Sender: TObject);
begin
  TMenuitem(Sender).Checked := not(TMenuitem(Sender).Checked);
  if not TMenuitem(Sender).Checked then  // item has been unchecked
    begin
      rank := 'None';
      mnuViewCaptain.Checked := False;
      mnuVeiwF_O.Checked     := False;
      mnuViewS_O.Checked     := False;
    end
    else
    begin
      // set rank
      case TMenuitem(Sender).Tag of
        1: rank := 'CP';
        2: rank := 'FO';
        3: rank := 'SO';
      end;
    end;

  SetStatusText;

   // uncheck existing checked item
  if (TMenuitem(Sender).tag <> mnuViewCaptain.Tag) then mnuViewCaptain.Checked := false;
  if (TMenuitem(Sender).tag <> mnuVeiwF_O.Tag) then mnuVeiwF_O.Checked := false;
  if (TMenuitem(Sender).tag <> mnuViewS_O.Tag) then mnuViewS_O.Checked := false;

  Displaydata;
end;
//------------------------------------------------------------------------------
procedure TfmMain.mnuviewPLHClick(Sender: TObject);
var
  StatusVal:string;
begin
with Sender as TMenuItem do
  begin
    StatusVal :=  removeAmpersand(TMenuitem(Sender).Caption);
    TMenuitem(Sender).Checked := not(TMenuitem(Sender).Checked);// revers checked state
    if (not(TMenuitem(Sender).Checked)) then
       Status.remove(StatusVal)
       else
       Status.add(StatusVal);
  end;
  DisplayData;
  SetStatusText;
end;

//------------------------------------------------------------------------------
procedure TfmMain.editSearchChange(Sender: TObject);
var buf:array[0..255] of char;
begin
 strpcopy(buf,editSearch.text);
 with listnames do
  begin
  itemindex:=perform(lb_selectstring,itemindex{0},longint(@buf));
  if itemindex <> -1 then
   listnamesclick(sender);
  end;
 end;
// ----------------------------------------------------------------------------
procedure TfmMain.FormShow(Sender: TObject);
begin
  pc.ActivePageIndex := 0
end;
// ----------------------------------------------------------------------------
procedure TfmMain.mnuOpen2ndClick(Sender: TObject);
// load second diag, compare against cuurent name list
begin
  if Diag.Count  = 0 then exit;
  if diagTwo = nil then exit;

  if dlgOpen.Execute then
  begin
    // extract data for display
    if FileExists(dlgOpen.FileName) then
    begin
      mnuClose2ndDiagClick(self);
      dlgOpen.InitialDir:= extractfiledir(dlgOpen.FileName);
      DataFolder := dlgOpen.InitialDir;
      caption := Diag.filename + '  .. // ..  ' + ExtractFileName(dlgOpen.FileName);
      DiagTwo.LoadFromfile(dlgOpen.FileName);
    end
    else
    begin
      messagedlg('No file selected ??',mtWarning,[mbOk],0);
      exit;
    end;
  ListNamesClick(self);
  btnCompareClick(self);
  end;
end;
// -----------------------------------------------------------------------------
procedure TfmMain.SplitView(index:integer);
var
  sl:Tstringlist;
  ms:TMemoryStream;
  sn,msg:string;
  Index2:integer;
begin

  sl:=Tstringlist.create;
  ms:=TMemoryStream.Create;
  Diag.DisplaySplitview(sl,Index);
  sl.SaveToStream(ms);
  ms.Position := 0;
  rtSplit1.Lines.LoadFromStream(ms);
  rtSplit1.SelStart := 0;

  sl.Clear;
  ms.Clear;

  sn:= Diag.IndextoSn(Index);
  Index2:= DiagTwo.SnToIndex(sn);
  if Index2 <> -1 then
  begin
    DiagTwo.DisplaySplitviewSecond(Diag,sl,Index,Index2);
    // Diag for comparison, both indexes also required
    sl.SaveToStream(ms);
    ms.Position := 0;
    rtSplit2.Lines.LoadFromStream(ms);
    if Diag.Crews[index].IdenticalLine(DiagTwo.Crews[index2],msg) then
       Notes := ' Identical Lines, '
       else
       Notes := ' Lines not a match, ';

  end
  else
  begin
    rtSplit2.Lines.Clear;
    rtSplit2.Lines.Add('No details for ' + Diag.Crews[Index].CrewName);
  end;

  rtSplit2.SelStart := 0;
  rtSplit2.SelLength := 0;

  sl.Free;
  ms.Free;


end;
procedure TfmMain.tsCompareContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

// ----------------------------------------------------------------------------
procedure TfmMain.mnuClose2ndDiagClick(Sender: TObject);
begin
  Diagtwo.Clear;
  rtSplit1.Clear;
  rtSplit2.Clear;
  Series4.Clear;
  Series3.Clear;
  Caption := Diag.filename;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.mnuShowListClick(Sender: TObject);
begin
  ListNames.Width := 150;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.mnuHideListClick(Sender: TObject);
begin
  ListNames.Width := 0;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.mnuEditCategoriesClick(Sender: TObject);
var
  i:integer;
begin
   i:= MessageDlg('called inError',mtWarning,[mbOK],0);
  {
    fmCategories.showmodal;
    for i :=  mnuView.count - 1 downto 8 do
       mnuView.Delete(i);
    LoadCategories;  }
end;
//------------------------------------------------------------------------------
procedure TfmMain.mnuEditCopyClick(Sender: TObject);
begin
  case pc.ActivePageIndex of
    0: rtDiag.CopyToClipboard;
   // 1: rtBids.CopyToClipboard;
   // 2: rtText.CopyToClipboard;
//    3: rtMbt.CopyToClipboard;
    end;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.mnuEditPasteClick(Sender: TObject);
begin
case pc.ActivePageIndex of
    0: rtDiag.PasteFromClipboard;
    //1: rtBids.PasteFromClipboard;
    //2: rtText.PasteFromClipboard;
 //   3: rtMbt.PasteFromClipboard;
    end;

end;
//---------------------------------------------------------------------------
procedure TfmMain.mnuFileCreateawardsClick(Sender: TObject);
//create awards file
var
  result:Tstringlist;
  fn:string;

begin
  result:=  Tstringlist.Create;
  diag.Awardsfile(Result);
  fn:= '\' + Diag.AirCraftType + '_' +Diag.Bidperiod + '_' + 'Awards.txt';
  result.SaveToFile(Datafolder + fn);
  result.Free;
end;
//------------------------------------------------------------------------------
procedure TfmMain.mnuFiltersClick(Sender: TObject);
var
  sl:Tstringlist;
begin
  Tmenuitem(sender).Checked := not Tmenuitem(sender).Checked;
  if Tmenuitem(sender).tag = 0 then
    Filter := 0
    else
    begin
    if Tmenuitem(sender).Checked then
      Filter:= Tmenuitem(sender).tag
      else
      Filter := 0;
     end;

  PreAllocationMode := (Filter = 1);

  with Diag do
  begin
    NamePointer.clear;
    sl:=TStringList.Create;
    NamesSeniority(sl,NamePointer,Rank,Status,Filter);
    //NamesPreAlloc(sl,NamePointer,Rank,Status);
    ListNames.Items.Assign(sl);
    sl.Free;
    ListNamesClick(nil);
  end;
  SetStatusText;
  // uncheck existing checked item
  if (TMenuitem(Sender).tag <> mnuFiltersPreAlloc.Tag) then mnuFiltersPreAlloc.Checked := false;
  if (TMenuitem(Sender).tag <> mnuFiltersLowLines.Tag) then mnuFiltersLowLines.Checked := false;
  if (TMenuitem(Sender).tag <> mnuFiltersUnlocked.Tag) then mnuFiltersUnlocked.Checked := false;
  if (TMenuitem(Sender).tag <> mnuFiltersTrainingAllocated.Tag) then mnuFiltersTrainingAllocated.Checked := false;
end;

//------------------------------------------------------------------------------
procedure TfmMain.mnuEditCutClick(Sender: TObject);
begin
case pc.ActivePageIndex of
    0: rtDiag.CutToClipboard;
    //1: rtBids.CutToClipboard;
    //2: rtTExt.CutToClipboard;
//    3: rtMbt.CutToClipboard;
    end;

end;
// ----------------------------------------------------------------------------
procedure TfmMain.mnuSelectAllClick(Sender: TObject);
var
  rt:TRichEdit;
begin
case pc.ActivePageIndex of
    0: rt:= rtDiag;
    //1: rt:= rtBids;
    //2: rt:= rtTExt;
//    3: rt:= rtMbt;
    end;
    rt.SetFocus;
    rt.SelectAll;
end;
// ----------------------------------------------------------------------------
function TfmMain.GetCrew: string;
begin
  Result := FCrew;
end;
// ----------------------------------------------------------------------------
function TfmMain.GetNotes: string;
begin
  Result := FNotes;
end;
//------------------------------------------------------------------------------
procedure TfmMain.SetCrew(const Value: string);
begin
  sb.panels[0].Text := ' ' + Value;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.SetNotes(const Value: string);
begin
  if Value = '' then
    FNotes := '' else FNotes:= FNotes + Value;
  sb.panels[2].Text := FNotes;

end;
//------------------------------------------------------------------------------
procedure TfmMain.SetStatusText;
var
  a_str,a_filter:string;
begin
  if Diag <> nil then
    a_str := Diag.AirCraftType
    else
    a_str:= '';

  if rank <> 'None' then a_str:= a_str + ' ' + rank;

  case filter of
    0:a_filter := '';
    1:a_filter:=  ' Preallocations';
    2:a_filter:=  ' Low Lines';
    3:a_filter:=  ' Training Allocated';
  end;
  if True then

(*  if ((a_str <> '') and ( Status <> 'None' )) then a_str := a_str + ' ; ' + Status
    else
      if ( Status <> 'None' ) then a_str := a_str + ' '+ Status;
  *)
  if ((a_str <> '') and ( a_filter <> '' )) then a_str:= a_str + ' ; ' + a_filter
    else
      if ( a_filter <> '' ) then a_str:= a_str + ' ' + a_filter;

  a_str := a_str + ' ' + Status.displayStatus;

  sb.Panels[1].Text := a_str;
end;

// ----------------------------------------------------------------------------
procedure TfmMain.sbDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
  const Rect: TRect);
begin
  with StatusBar.Canvas do
  begin
    Font.Color := clred;
    TextOut(rect.Left+10,rect.top+5,Notes)
  end;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.LoadDiag(fn: String);
begin
  if diag = nil then
    diag := TDiag.create
    else
     begin
       Diag.clear;
       listNames.Clear;
       Status.clear;
     end;
  if diagTwo = nil then
    diagTwo := Tdiag.create
    else
    begin
      DiagTwo.clear;
      rtSplit1.Lines.Clear;
      rtSplit2.Lines.Clear;
    end;

  if FileExists(fn) then
  begin
    Caption := 'PreCam II ' + ExtractFileName(fn);
    SaveFileInUse(fn);
    Diag.LoadFromfile(fn);
  end
  else
  begin
    messagedlg('No file selected ??',mtWarning,[mbOk],0);
    exit;
  end;
  // if successful the allow 2nd diag
  if (( Diag <> nil ) and (Diag.Count <> 0 )) then
     mnuOpen2nd.Enabled := True
     else
     mnuOpen2nd.Enabled := False;

  LoadCategories;// retrieve categories to build the View / Status menu
  LoadRouteCodes;// routes codes for distribution page
  DistributionDaysAway;
  DisplayData;//apply dat to sgView
  SetStatusText;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.mnuTextBlueClick(Sender: TObject);
begin
//  rtText.color := clinactiveCaptionText;
  rtDiag.color := clinactiveCaptionText;
//  rtBids.color := clinactiveCaptionText;
//  rtMbt.color := clinactiveCaptionText;
  rtSplit1.color := clinactiveCaptionText;
  rtSplit2.color := clinactiveCaptionText;
  ListNames.color := clinactiveCaptionText;
end;
//------------------------------------------------------------------------------
procedure TfmMain.mnuTextGreyClick(Sender: TObject);
begin
  //rtText.color := clltgray;
  rtDiag.color := clltgray;
  //rtBids.color := clltgray;
//  rtMbt.color := clltgray;
  rtSplit1.color := clltgray;
  rtSplit2.color := clltgray;
  ListNames.color := clltgray;
end;
//------------------------------------------------------------------------------
procedure TfmMain.mnuTextWhiteClick(Sender: TObject);
begin
  //rtText.color := clwhite;
  rtDiag.color := clwhite;
  //rtBids.color := clwhite;
//  rtMbt.color := clwhite;
  rtSplit1.color := clwhite;
  rtSplit2.color := clwhite;
  ListNames.color := clwhite;
end;
//------------------------------------------------------------------------------
procedure TfmMain.mnuTextYellowClick(Sender: TObject);
begin
  //rtText.color := clinfoBk;
  rtDiag.color := clinfoBk;
  //rtBids.color := clinfoBk;
//  rtMbt.color := clinfoBk;
  rtSplit1.color := clinfoBk;
  rtSplit2.color := clinfoBk;
  ListNames.color := clinfoBk;
end;
//------------------------------------------------------------------------------
procedure TfmMain.mnuTextGreenClick(Sender: TObject);
begin
  //rtText.color := clMoneyGreen;
  rtDiag.color := clMoneyGreen;
  //rtBids.color := clMoneyGreen;
//  rtMbt.color := clMoneyGreen;
  rtSplit1.color := clMoneyGreen;
  rtSplit2.color := clMoneyGreen;
  ListNames.color := clMoneyGreen;
end;

// ----------------------------------------------------------------------------

procedure TfmMain.FindDialogFind(Sender: TObject);
// find an awarded pattern
var
  i,j,k,np,pos,start:integer;
  target,aNAme:string;

begin
  //if FindDialog.Options. then
  if searching then start  := 1 else start := 0;
  searching := true;// allows search to start at existing crew member for the first pass, then increment for additional passes
  target := FindDialog.FindText;
  target := Uppercase(target);
  FindDialog.FindText := target;
  pos := 0;

  for i := ListNames.ItemIndex + start to ListNames.Count -1 do
  begin
    np := strtoint(NamePointer[i]);
    for j := 0 to diag.Crews[np].Trips.Count -1 do
    begin
      if (ContainsStr(target,diag.Crews[np].Trips.allocs[j].Pattern)) or
         (ContainsStr(target,diag.Crews[np].Trips.allocs[j].RouteCode)) then
      begin
        ListNames.ItemIndex := i;//k;
        ListNamesClick(self);
        pos := 0;
        while pos <> -1 do
        begin
          pos:= rtDiag.FindText(target,pos,length(rtdiag.Text),[]);
          if pos <> -1 then
          begin
            rtDiag.SelStart:= pos;
            rtDiag.SelLength := length(target);
            rtDiag.SelAttributes.Color := clRed;
            pos := pos + 1;
          end;
        end;
        rtDiag.SetFocus;
        exit;
      end;
    end;
  end;
  MessageDlg(target + ' not Found.', mtInformation,[mbok],0);
  Searching := false;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.ffClick(Sender: TObject);
begin
  Searching := false;
   FindDialog.Execute;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.btnPreAllocClick(Sender: TObject);
var
  index:integer;
  result:boolean;
  str:string;
begin
  PreAllocationMode := true;
  result:=true;
  if ListNames.Itemindex = ListNames.Count -1 then
    ListNames.Itemindex := 0
   else
    ListNames.Itemindex := ListNames.Itemindex + 1;

  for index := ListNames.Itemindex to ListNames.Items.Count -1 do// iterate through list
  begin
    if (diag.PreAllocatedDuties(strtoint(NamePointer[index]))) then
    begin
      result := false;
      ListNames.ItemIndex := index;
      ListNamesClick(sender);
      Notes := str;
      exit;
    end;
  end;

  if result then
    begin
      MessageDlg('No Pre Allocated Duties.',mtinformation,[mbok],0);
      ListNames.ItemIndex := 0;
      ListNamesClick(sender);
    end;
  PreAllocationMode := False;
end;
//------------------------------------------------------------------------------
procedure TfmMain.btnWeekendsOffClick(Sender: TObject);
begin
   DistributionWeekEndsoff;
end;

//------------------------------------------------------------------------------
procedure TfmMain.btnCleaSelectedrRouteCodesClick(Sender: TObject);
var
  i:integer;
begin
  for i := 0 to lstRouteCodes.Count - 1 do
    lstRouteCodes.Selected[i] := false;
end;
//------------------------------------------------------------------------------
procedure TfmMain.btnCompareClick(Sender: TObject);
// compare Daig and daigTwo after load or change to rank, status or filter
var
 i,index1,index2,c1,c2:integer;
 result1,result2:real;
 sn1,sn2:string;

 function valid :boolean;
begin
  result := false;
  if sn1 = sn2 then result := true;
  if index1 = -1 then result := false;
  if index2 = -1 then result := false;
end;

begin
  if DiagTwo = nil then exit;

  result1:=0; result2:=0;
  c1:= 0; c2:= 0;
  series3.Clear;
  series4.Clear;


 for i := 0 to ListNames.Count -1 do
   begin
     Index1:= strtoint(NamePointer[i]);//NP list references the current name list displayed

     sn1 := Diag.IndextoSn(Index1);
     Index2:= DiagTwo.SnToIndex(sn1);
     sn2:=    DiagTwo.IndextoSn(Index2);

     if valid then
     begin
       result1:= result1 + Diag.Crews[index1].Pointsachieved;
         Series4.Add(diag.Crews[index1].Pointsachieved);
         inc(c1);
         result2:= result2 + DiagTwo.Crews[Index2].Pointsachieved;
         Series3.Add(diagTwo.Crews[Index2].Pointsachieved);
         inc(c2);
     end;
   end;
     (*
     result1:= result1 + Diag.Crews[index].Pointsachieved;
     //if ( diag.Crews[index].Trips.Points > 0 ) then
       begin
         Series4.Add(diag.Crews[index].Pointsachieved);
         inc(c1);
       end;

     sn := Diag.IndextoSn(Index);
     Index2:= DiagTwo.SnToIndex(sn);
     result2:= result2 + DiagTwo.Crews[Index2].Pointsachieved;
     //if ( DiagTwo.Crews[index].Trips.Points > 0 ) then
       begin
         Series3.Add(diag.Crews[Index2].Pointsachieved);
         inc(c2);
       end;
    end;
       *)
  if c1 = 0 then result1 := 0 else result1:= (result1 / c1) ;
  if c1 = 0 then result2 := 0 else result2:= (result2 / c2);
  lblSplitCompare.Caption := '     ' + format('%f / %f ',[result1,result2]);

end;
//------------------------------------------------------------------------------
procedure TfmMain.mnuAboutClick(Sender: TObject);
begin
 fmAbout.ShowModal;
end;
//------------------------------------------------------------------------------

procedure TfmMain.mnuAlphabeticalClick(Sender: TObject);
// name pointer is a four digit string '0001'
var
  sl:TStringList;
begin
  sl:=TStringList.Create;
  NamePointer.Clear;
  if mnuAlphabetical.tag = 0  then  //Caption = 'Alphabetical'
  begin
    mnuAlphabetical.Caption := 'Seniority';
    mnuAlphabetical.tag     := 1;
    // alphabetical sort
    Diag.NamesAlpha(sl,NamePointer,Rank,Status,Filter);
    ListNames.Items.Assign(sl);
  end
  else
  begin
    // sort by seniorirty
    mnuAlphabetical.Caption := 'Alphabetical';
    mnuAlphabetical.tag     := 0;
    Diag.NamesSeniority(sl,NamePointer,Rank,Status,0);
    ListNames.Items.Assign(sl);
   end;
  sl.free;

  if ListNames.Count > 0 then ListNames.ItemIndex := 0;
  ListNamesClick(self);
end;
//------------------------------------------------------------------------------
function TfmMain.ReadFileinUse: string;
var
  inifile:TIniFile;
  app_dir:string;
begin
  app_dir:=application.ExeName;
  app_dir:=extractfiledir(app_dir);
  inifile := TIniFile.Create(app_dir + '\' + 'Precam.ini');
  result := inifile.ReadString('Files','Last File','None');
  inifile.Free;
end;
//-----------------------------------------------------------------------------
procedure TfmMain.ResetBuckets;
var
  sl:Tstringlist;
begin
  sl:=Tstringlist.create;
  Diag.Routecodes(sl);
  listTripCodes.items.Assign(sl);
 // rgLimit.ItemIndex := 0;
  Buckets.Clear;
  sgBuckets.ColCount := 0;
  sl.free;
end;
//------------------------------------------------------------------------------
procedure TfmMain.ResetFilters;
begin
  Filter := Default;
  mnuFiltersPreAlloc.Checked := false;
  mnuFiltersLowLines.Checked := false;
end;
//------------------------------------------------------------------------------
procedure TfmMain.ResetStatusRank;
var
  i:integer;
begin
   Status.clear;// := 'None';
   Rank   := 'None';
   for i := 8 to mnuView.Count - 1 do
       mnuView.Items[i].Checked := false;

   mnuViewCaptain.Checked := False;
   mnuViewS_O.Checked     := False;
   mnuVeiwF_O.Checked     := False;

   SetStatusText;
end;

// -----------------------------------------------------------------------------
procedure TfmMain.listTripCodesDblClick(Sender: TObject);
{add trip to bucket}
var
  i:integer;
begin
  for i := 0 to 29 do
    if sgPatterns.cells[0,i] = '' then
    begin
      sgPatterns.Cells[0,i] := listTripCodes.items[listTripCodes.itemindex];
      break;
    end;
end;
// ----------------------------------------------------------------------------
procedure TfmMain.btnOKBucketsClick(Sender: TObject);
var
  index,j,c,r:integer;

begin

  addBucket.Patterns.Clear;
//  aCol:= Buckets.NumBuckets;


  for index := 0 to 29 do
  begin
    sgPatterns.cells[0,index] := uppercase(sgPatterns.cells[0,index]);
    if sgPatterns.cells[0,index] <> '' then  // don't add empty pattern values
      addBucket.Patterns.add(sgPatterns.cells[0,index]);
  end;
  addBucket.Limit    := ListLimitValue.ItemIndex + 1;
  Buckets.Add(AddBucket);

  for c := 0 to sgBuckets.Colcount -1 do
    sgbuckets.Cols[c].Clear;

  sgBuckets.ColCount := Buckets.NumBuckets;
  for index := 0 to Buckets.NumBuckets -1 do
  begin
    sgBuckets.cells[index,0] := 'Limit' + inttostr(Buckets.Bucket[index].Limit);
    for j := 0 to Buckets.Bucket[index].Patterns.count-1 do
      sgBuckets.Cells[index,j+1] := Buckets.Bucket[index].Patterns[j];
  end;

  for index := 0 to 29 do
    sgPatterns.cells[0,index] := '';

end;

// -----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
procedure TfmMain.rtSplit2Change(Sender: TObject);
begin

end;

//-----------------------------------------------------------------------------
procedure TfmMain.SaveFileInUse(fn: string);
var
  inifile:TIniFile;
   app_dir:string;

begin
  app_dir:=application.ExeName;
  app_dir:=extractfiledir(app_dir);
  inifile := TIniFile.Create(app_dir + '\'+ 'Precam.ini');
  inifile.WriteString('Files','Last File',fn);
  inifile.Free;
end;
//-----------------------------------------------------------------------------
procedure TfmMain.btnMoveBidsClick(Sender: TObject);
begin
  rtDiag.SetFocus;
  rtDiag.SelStart := length(rtDiag.Text);
  rtDiag.Perform(EM_SCROLLCARET, 0, 0);

  rtDiag.SelStart := rtDiag.FindText('Bids',0,length(rtDiag.Text),[]);
  rtDiag.SelLength := 4;
  rtDiag.Perform(EM_SCROLLCARET, 0, 0);
end;
//------------------------------------------------------------------------------
procedure TfmMain.btnMoveDiagTopClick(Sender: TObject);
begin
  rtDiag.SetFocus;
  rtDiag.SelStart := 0;//length(rtDiag.Text);
  rtDiag.Perform(EM_SCROLLCARET, 0, 0);
end;
//------------------------------------------------------------------------------
procedure TfmMain.btnNextDifferenceClick(Sender: TObject);
// move list ot the next crew member with differences
var
  i,index1,index2:integer;
  sn1,sn2,msg:string;
begin
  for i  := ListNames.ItemIndex + 1 to ListNames.Count - 1 do
    begin
       Index1:= strtoint(NamePointer[i]); //Index points to crews array
       sn1   :=Diag.IndextoSn(Index1);
       Index2:= DiagTwo.SnToIndex(sn1);
       sn2   := DiagTwo.IndextoSn(Index2);
       if sn1 = sn2 then
       if not Diag.Crews[index1].IdenticalLine(DiagTwo.crews[Index2],msg) then
       begin
         ListNames.ItemIndex := i;
         ListNamesClick(self);
         exit;
       end
    end;
    MessageDlg('No different Lines found',mtInformation,[mbok],0);
end;

//------------------------------------------------------------------------------
procedure TfmMain.LoadCategories;
var
  i:integer;
  sl:Tstringlist;
  mnuitem:Tmenuitem;
begin
  // Diag.Statuscategories returns a sorted list of categories available in the Diag to
  // create the View / Status menu items
  sl:=Tstringlist.create;
  Diag.StatusCategories(sl);

  if sl.Count > 0 then
  for i :=  0 to sl.Count - 1  do
    begin
      mnuItem := TMenuItem.Create(self);
      mnuItem.OnClick  := mnuviewPLHClick;
      mnuItem.Caption := sl[i];
      mnuView.Add(mnuItem);
    end;

  sl.Free;

end;
//------------------------------------------------------------------------------
procedure TfmMain.LoadRouteCodes;
var
  sl:Tstringlist;
begin
  sl:=Tstringlist.create;
  Diag.Routecodes(sl);
  LstRouteCodes.items.Assign(sl);
  sl.free;
end;
//------------------------------------------------------------------------------
procedure TfmMain.lstRouteCodesClick(Sender: TObject);
var
  sl:Tstringlist;
  i:integer;
begin
  sl:=TStringList.Create;
  for i := 0 to lstRouteCodes.Count - 1 do
    if (lstRouteCodes.selected[i]) then
    begin
      sl.Add(lstRouteCodes.Items[i]);
    end;
  DistributionRouteCodes(sl);
  sl.free;
end;

end.

