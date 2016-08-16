unit oldData;
// All data from Carmen handled here.
// Diag object

interface
  uses classes,sysutils;

 // Type TBid = (BIDCO,BIDCI,BIDSL);

  Type TAlloc = record
     Sn,Alloc,Pattern,Blank,Report,SignOff,Days,Rest,Credits,RouteCode,
     Credits_Day,Prealloc,Points:string;
   end;

  Type TGpref = record
    LineHourRange,SlideLeave,CarryOutLimit,BlankLine,ProfferLine,
    MBT,Min36hrsSDO:string;
  end;

  type TBucket = record
    Patterns:Tstringlist;
    Limit:integer;
  end;


  Type TCrewD = record
     Sn,CrewD,Name,Rank,Aircraft,Base,Seniority,Credits,Win_low,Win_hi,
     Stick,Pre_alloc,Alloc,CarryIn:string;
   end;

  Type TBIDCO =record
    Sn,Bidco,No,DateText,Available,Limit,Points,Achieved:string;
  end;

  Type TBIDCI =record
      Sn,Bidci,No,Plus,Text:string;
  end;

  Type TBIDSL =record
    Sn,Bidsl,Text,Available,Limit,Points,Achieved:string;
  end;

  Type TTrips = class
    private
      Function GetCount:integer;
      function GetPoints: integer;
      function GetTripDensity: integer;
      function GetTripLength: real;
      Function Display:Tstringlist;
      function TotalDaysAway:integer;
      function TotalCredits:string;
      function GetDaysAway(Index:integer):integer;
      function GetDepDay(Index:integer):integer;

    public
      Allocs:array of TAlloc;
      Property Count:integer Read GetCount;
      Property DaysAway[Index:integer]:integer Read GetDaysAway;
      Property DepDay[Index:integer]:integer read GetDepDay;
      Property Points:integer Read GetPoints;
      Property TripDensity:integer read GetTripDensity;
      Property TripLength:real Read GetTripLength;
      procedure Add(sl:TStringlist);
      procedure Clear;
      Constructor Create;
      Destructor Destroy;override;

  end;

(*  Type TCrewBids = class
    private
    function Getcount: integer;
    public
      Bids:Tstringlist;
      Property Count:integer Read Getcount;
      constructor Create;
      Destructor Destroy;
      Procedure DisplayBid(sl:Tstringlist);
  end;
  *)
  Type TCrew = class
  // class to hold the details for each crew members diagnostic
  // TcrewD details,TAlloc allocations stringlist for bidsetc
    private
      Bids:Tstringlist;
      Gpref:TGpref;
      Rostr,Bidgr:string;
      procedure CalendarHeader(sl:Tstringlist;Bp:String);
      function GetCrewName: string;
    function GetCarryIn: boolean;
    public
      Index:integer;
      CrewD:TCrewD;
      Trips:TTrips;
      Property CarryIn:boolean Read GetCarryIn;
      Property CrewName:string read GetCrewName;
      procedure BidDisplay(sl:TStringList);
      procedure Add(sl:TStringlist);
      procedure Clear;
      constructor Create;
      procedure DisplayDetails(sl:TStringList);
      procedure DisplayGPRef(sl:Tstringlist);
      function DisplayRostr:string;
      function DisplayBidgr:string;
      procedure DisplayCalendar(sl:Tstringlist);
      destructor Destroy;Override;
  end;

  Type TDiag = class
    private
      FCount:integer;
      FBp:string;
      function GetCrewName(index:integer): string;
    procedure SetBP(const Value: string);

    public
      Crews: array of TCrew;
      //Routecodes:Tstringlist;
      Property Count:integer read Fcount;
      Property Crewname[index:integer]:string Read GetCrewName;
      Property Bidperiod :string read FBp write SetBP;
      Constructor Create;
      Destructor Destroy;Override;
      Procedure Add(crew_sl:Tstringlist);
      Procedure clear;
      Procedure Display(sl:TStringList;Index:integer);
      Procedure DisplaySpiltview(sl:Tstringlist;Index:integer);
      Procedure NamesAlpha(namelist,indexlist:tstringlist;Rank:string);
      Procedure NamesSeniority(namelist,indexlist:tstringlist;Rank:string);
      function Preallocatedduties(Index:integer):boolean;
      Procedure Routecodes(sl:TStringlist);
    end;

  type
   TBuckets = class
   private
     FBuckets: array of TBucket;
     FNumBuckets:integer;
     function GetBucket(index: integer): TBucket;
     procedure SetBucket(index: integer; const Value: TBucket);
   public
     property Bucket[index:integer]: TBucket read GetBucket write SetBucket;
     property NumBuckets:integer read FNumBuckets;
     procedure   Add(val:TBucket);
     Procedure   Clear;
     constructor Create;
     Destructor  Destroy; override;
     Function CheckBuckets(Trips: TTrips;CarryIn:Boolean):boolean;
 end;

// ***********************************************************************
   Function Next(var str:string):string ;

   Var Diag,DiagTwo:TDiag;
       Buckets :TBuckets;
       AddBucket :TBucket;

// ***********************************************************************
implementation

uses my_strings, dates;

Function Next(var str:string):string ;
// Internal function
// read the next value in a csv line and reduce the string by that value
var
  comaAt:integer;
begin
  comaAt := pos(',',str);
  result := copy(str,1,comaAt-1);
  str    := copy(str,comaAt+1,length(str)- comaAt);
end;
//  ******************************************************************
Function NumberofFields(line:string):integer;
var
  i:integer;
begin
  result := 0;
  for i := 0 to length(line) do
    if copy(line,i,1) = ','  then
      inc(Result);
end;
//------------------------------------------------------------------------------
{ TDiag }

procedure TDiag.Add(crew_sl: Tstringlist);
begin
  Inc(FCount);
  setlength(Crews,FCount);
  Crews[FCount -1] := TCrew.Create;
  Crews[FCount -1].Index:= FCount-1;
  Crews[FCount -1].Add(crew_sl);

end;

procedure TDiag.clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Crews[i].Clear;
  SetLength(Crews,0);
  FCount := 0;
end;

constructor TDiag.Create();
// Open a csv file and fill Diag structure
begin
  inherited Create;
  FCount := 0;

end;
destructor TDiag.Destroy;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Crews[i].Destroy;
  SetLength(Crews,0);
  FCount := 0;
  inherited;
end;

procedure TDiag.Display(sl: TStringList;Index:integer);
// main display for rtDiag , return display vai sl, for crew id Index
var
 i:integer;
 temp:TStringlist;
 str:string;
begin
  sl.Clear;
  temp :=Tstringlist.create;
  Crews[index].DisplayDetails(sl);
  sl.Add('');

  //Trips
  temp := crews[index].Trips.Display;
  sl.AddStrings(temp);
  sl.Add('');

  //CALENDAR
  Crews[index].displayCalendar(temp);
  sl.AddStrings(temp);
  sl.add('');

  // line
  sl.add(Crews[index].DisplayRostr);

  // x days
  sl.add(Crews[index].DisplayBidgr);
  sl.Add('');

  //GPREF
  crews[index].DisplayGPRef(temp);
  sl.AddStrings(temp);
  sl.Add('');

  // bids;
  temp.Clear;
  Crews[index].BidDisplay(temp);
  sl.AddStrings(temp);
  temp.Free;
end;

procedure TDiag.DisplaySpiltview(sl: Tstringlist; Index: integer);
var
 i:integer;
 temp:TStringlist;
 str:string;
begin
  temp :=Tstringlist.create;
  Crews[index].DisplayDetails(sl);
  sl.Add('');
  //Trips
  temp := crews[index].Trips.Display;
  sl.AddStrings(temp);
  sl.Add('');
  // line
  sl.add(Crews[index].DisplayRostr);
  // x days
  sl.add(Crews[index].DisplayBidgr);
  sl.Add('');
end;


function TDiag.GetCrewName(index:integer): string;
begin
  result := Crews[index].CrewName;
end;

procedure TDiag.NamesAlpha(namelist,indexlist: tstringlist;Rank:string);
// return an alphabetical list of name and a matching list of indexes
var
 i:integer;
 sl:Tstringlist;
 a_str:string;
begin
  sl:= TStringList.Create;
  sl.Sorted := True;
  //create combined sorted list
  for I := 0 to Count - 1 do // for each crew member in the diag
  begin
    if crews[i].CrewD.Rank = Rank then
        sl.Add(crews[i].CrewD.Name + ',' + inttostr(crews[i].Index)+',')
      else
        if Rank = 'None' then
          sl.Add(crews[i].CrewD.Name + ',' + inttostr(crews[i].Index)+',');

  end;
  // create seperate lists
  for I := 0 to sl.Count - 1 do
    begin
      a_str:= sl[i];
      namelist.Add(next(a_str));
      indexlist.Add(Next(a_str));
    end;
  sl.Free;
end;

procedure TDiag.NamesSeniority(namelist, indexlist: tstringlist;Rank:string);
// return a seniority sorted list of name and a matching list of indexes
var
 i:integer;
 sl:Tstringlist;
 a_str:string;
begin
  sl:= TStringList.Create;
  sl.Sorted := True;
  //create combined sorted list
  for I := 0 to Count - 1 do // for each crew member in the diag
  begin
    if crews[i].CrewD.Rank = Rank then
      sl.Add(pad_Str_left(4,'0',crews[i].CrewD.seniority) + ',' + crews[i].CrewD.Name + ',' + inttostr(crews[i].Index)+',')
      else
        if Rank = 'None' then
          sl.Add(pad_Str_left(4,'0',crews[i].CrewD.seniority) + ',' + crews[i].CrewD.Name + ',' + inttostr(crews[i].Index)+',');
  end;
  // create seperate lists
  for I := 0 to sl.Count - 1 do
    begin
      a_str:= sl[i];
      next(a_str);
      namelist.Add(next(a_str));
      indexlist.Add(Next(a_str));

    end;
  sl.Free;
end;

function TDiag.Preallocatedduties(Index:integer): boolean;
var
  j,first: Integer;
  a_str:string;
begin
  result := false;

  if Crews[index].CarryIn then first := 1 else first := 0;
  for j := first to Crews[Index].Trips.count - 1 do
     if Crews[Index].Trips.Allocs[j].Prealloc <> '' then
     begin
       a_str:= Crews[Index].Trips.Allocs[j].Pattern;
       if containsStr(a_str,'AL,LSL,LSL2' )then
         result := false
         else
         begin
           result := true;
           break;
         end;
     end;
end;
//------------------------------------------------------------------------------
procedure TDiag.Routecodes(sl: TStringlist);
// return a sorted list of route codes
var  i,j:integer;

begin
  sl.Sorted := true;
  for I := 0 to Count - 1 do
    for j := 0 to crews[i].Trips.Count - 1 do
      if  (crews[i].Trips.Allocs[j].RouteCode) <> '' then
        sl.Add(crews[i].Trips.Allocs[j].RouteCode);
end;


procedure TDiag.SetBP(const Value: string);
// extract abp value from first line of diag
// base could be set here???
var
  a_pos:integer;
  a_str:string;
begin
  a_str:= value; Next(a_str);
  a_str:=  Next(a_str);
    a_str := numbers_only(copy(a_str,3,4));
  FBp := a_str;
end;

//*****************************************************************************
{ TCrew }

procedure TCrew.Add(sl: TStringlist);
var
  line,a_str:string;
  i,j,size:integer;
  allocsSl:TStringlist;
begin
   i:= 0;
   line:= sl[i]+ ',';
   CrewD.Sn         := next(line);
   CrewD.CrewD      := next(line);
   CrewD.Name       := next(line);
   CrewD.rank       := next(line);
   CrewD.Aircraft   := next(line);
   CrewD.Base       := next(line);
   CrewD.Seniority  := next(line);
   CrewD.Credits    := next(line);
   CrewD.Win_low    := next(line);
   CrewD.Win_hi     := next(line);
   CrewD.Stick      := next(line);
   CrewD.Pre_alloc  := next(line);
   CrewD.Alloc      := next(line);
   CrewD.CarryIn    := next(line);

   inc(i);
   allocsSl:= TStringList.Create;
   while copy(sl[i],8,5) = 'ALLOC' do
     begin
       allocsSl.Add(sl[i]);
        inc(i);
     end;
   Trips:= TTrips.Create;
   Trips.Add(allocsSl);

   //Global Pref
   allocsSl.Clear;
   while copy(sl[i],8,5) = 'GPREF' do
     begin
       allocsSl.Add(sl[i]);
        inc(i);
     end;
   if allocsSl.Count = 7 then
   begin
     a_str:= allocsSl[0]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.LineHourRange := a_str;
     a_str:= allocsSl[1]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.SlideLeave := a_str;
     a_str:= allocsSl[2]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.CarryOutLimit := a_str;
     a_str:= allocsSl[3]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.BlankLine := a_str;
     a_str:= allocsSl[4]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.ProfferLine := a_str;
     a_str:= allocsSl[5]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.MBT := a_str;
     a_str:= allocsSl[6]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.Min36hrsSDO := a_str;
   end;


   //Bids
   if (i < sl.Count -1) then
   while copy(sl[i],8,3) = 'BID' do
     begin
        Bids.Add(sl[i]);
        inc(i);
    end;
    //ROSTR
   if (i < sl.Count -1) then
   if copy(sl[i],8,5) = 'ROSTR' then
     begin
        Rostr := sl[i];
        inc(i);
    end;
   //BIDGR
   if (i < sl.Count ) then
   if copy(sl[i],8,5) = 'BIDGR' then
     begin
        Bidgr :=sl[i];

    end;


end;

procedure TCrew.BidDisplay(sl: TStringList);
  Function BidNo(a_str:string):integer;
  begin
    Next(a_str); Next(a_str);
    Result := strtoint(Next(a_str));
  end;

var
  i,bn,numfields: Integer;
  a_bid,line:string;

begin
  sl.Add('');
  sl.Add(' Bids:' + pad_str_right(51,' ','')+ tab + tab+ ' ' + tab + 'Points' + tab + 'Achieved');
  if Bids.Count = 0 then exit;

 for i := 0 to Bids.Count - 1 do
 begin
   if copy(bids[i],8,5) = 'BIDCO' then
   begin
     line := bids[i]+ ',';
     numfields := NumberofFields(line);
     Next(line);Next(line);
     a_bid := pad_Str_left(2,' ',Next(line)) + '  ';
     a_bid := a_bid + pad_str_right(25,' ',Next(line))+ '  ';
     if numfields = 9 then
        a_bid := a_bid + pad_str_right(25,' ',Next(line))+ tab
        else
        a_bid := a_bid + pad_str_right(25,' ','')+ tab;
     a_bid := a_bid + Next(line) + tab;
//     a_bid := a_bid + Next(line) + tab;
     a_bid := a_bid + Next(line) + tab;
     a_bid := a_bid + Next(line);
     sl.Add(a_bid);
   end;
   if copy(bids[i],8,5) = 'BIDCI' then
   begin
     line := bids[i]+ ',';
     Next(line);Next(line);Next(line);
     a_bid := pad_str_right(29,' ','');
     a_bid := a_bid + Next(line) + tab;
     a_bid := a_bid + Next(line);
     sl.Add(a_bid);
   end;

   if copy(bids[i],8,5) = 'BIDSL' then
   begin
     line := bids[i]+ ',';
     numfields := NumberofFields(line);
     Next(line);Next(line);
     a_bid := pad_Str_left(2,' ',Next(line)) + '  ';
     a_bid := a_bid + pad_str_right(25,' ',Next(line))+ '  ';
     if numfields = 9 then
        a_bid := a_bid + pad_str_right(25,' ',Next(line))+ tab
        else
        a_bid := a_bid + pad_str_right(25,' ','')+ tab;
     a_bid := a_bid + Next(line) + tab;
     a_bid := a_bid + Next(line) + tab;
     a_bid := a_bid + Next(line) + tab;
     a_bid := a_bid + Next(line);
     sl.Add(a_bid);
   end;
 end;


  (*
  bn := -1;
  a_bid :='';
  for i := 0 to Bids.Count - 1 do
  begin
    if BidNo(Bids[i]) = bn then
    begin
      line := Bids[i]+ ',';
      Next(line);Next(line);Next(line);
      while line <>'' do
        a_bid := a_bid + tab + next(line);
      sl.Add(tab + tab + a_bid);
      a_bid :='';
    end
    else
    begin
      bn := Bidno(Bids[i]);
      line := Bids[i] + ',';
      Next(line);Next(line);
      while line <>'' do
        a_bid := a_bid + tab + next(line);
      sl.Add(a_bid);
      a_bid:='';
    end;
  end;
  sl.Add(a_bid);
  *)
end;

procedure TCrew.CalendarHeader(sl: Tstringlist; Bp: String);
var
  day1:TDateTime;
begin
  day1:= bp_day_to_datetime(1,strtoint(Bp));
end;

procedure TCrew.Clear;
begin
  Trips.Clear;
  Bids.Clear;
end;

constructor TCrew.Create;
begin
  inherited;
  Bids := TStringList.Create;
end;

destructor TCrew.Destroy;
begin
  Trips.Destroy;
  Bids.Free;
  inherited;
end;

function TCrew.DisplayBidgr: string;
var
  a_str,a_day:string;
begin
  a_str:= Bidgr + ',';
  next(a_str);next(a_str);next(a_str);next(a_str);

  a_day :=  Next(a_str);
  if a_day = '' then a_day := ' ';
  result := tab + a_day + ' ' ;
  while (a_str <> '') do
    begin
      a_day :=  Next(a_str);
      if a_day = '' then a_day := ' ';
      result := result + a_day + ' ';
    end;


end;

procedure TCrew.displayCalendar(sl: Tstringlist);
// produce  formatted view of the allocations
var
  ln1,ln2,ln3,ln4,a_str:string;
  i,dep:integer;
  a_date:TDateTime;
begin
  ln1 := tab + pad_str_right(128,' ','');
  ln2 := tab + pad_str_right(128,' ','');
  ln3 := tab + pad_str_right(128,' ','');
  ln4 := tab + pad_str_right(128,' ','');
  sl.Clear;
   if (length(diag.Bidperiod) = 3) then
    sl.Add(tab+ 'M T W T F S S M T W T F S S M T W T F S S M T W T F S S M T W T F S S M T W T F S S M T W T F S S M T W T F S S')
      else
      sl.Add(tab+ 'M T W T F S S M T W T F S S M T W T F S S M T W T F S S');
  sl.Add('');

  for i := 0 to Length(Trips.Allocs) - 1 do
    begin
      a_date:= StringToDateTime(Trips.allocs[i].Report);
      dep := datetime_to_bp_day(a_date,Diag.Bidperiod);
      if dep < 1  then dep :=1;// show carry in o day one
      a_str:= Trips.Allocs[i].Pattern;
      a_str:= pad_str_right(4,' ',a_str);
      ln1[dep *2 ] := a_str[1];
      ln2[dep *2 ] := a_str[2];
      ln3[dep *2 ] := a_str[3];
      ln4[dep *2 ] := a_str[4];
    end;
  sl.Add(ln1);
  sl.Add(ln2);
  sl.Add(ln3);
  sl.Add(ln4);



end;

procedure TCrew.DisplayDetails(sl: TStringList);
var
  str:string;
begin
  //sl.Add(' '+ CrewD.Name );
  sl.Add('');
  str:=  pad_str_right(30,' ',' Name') +
         'Staff No' + tab +
         'Rank' + tab +
         'A/C' + tab +
         'Base' + tab +
         'Sen' + tab +
         'Credit' + tab +
         'Low' + tab +
         'Hi' + tab +
         'Stick' + tab +
         'Pre Al' + tab +
         'Alloc' + tab +
         'Carry' ;
  sl.Add(str);

  str:=  pad_str_right(30,' ',' ' + CrewD.Name) +
         CrewD.Sn +  tab +
         CrewD.rank +  tab +
         CrewD.Aircraft +  tab +
         CrewD.Base +  tab +
         CrewD.Seniority +  tab +
         CrewD.Credits +  tab +
         CrewD.Win_low +  tab +
         CrewD.Win_hi +  tab +
         CrewD.Stick +  tab +
         CrewD.Pre_alloc +  tab +
         CrewD.Alloc +  tab +
         CrewD.CarryIn;
  sl.Add(str);

end;

procedure TCrew.DisplayGPRef(sl: Tstringlist);
var
   line :string;
begin
  sl.Clear;
  sl.Add( 'Line Hour Range' + tab + 'SlideLeave '+ tab + 'CarryOutLimit' + tab
          + tab + 'BlankLine' + tab + 'ProfferLine' + tab + 'MBT' + tab + 'Min36hrsSDO');
  line :=   GPRef.LineHourRange + tab +  tab + tab +
            GPRef.SlideLeave + tab +  tab +
            GPRef.CarryOutLimit + tab +  tab + tab +
            GPRef.BlankLine  + tab + tab +
            GPRef.ProfferLine + tab +  tab +
            GPRef.MBT + tab +
            GPRef.Min36hrsSDO;
  sl.Add(line);
end;

function TCrew.DisplayRostr: string;
var
  a_str:string;
begin
  a_str:= Rostr + ',';
  next(a_str);next(a_str);next(a_str);next(a_str);
  result :=  tab + Next(a_str)+ ' ';
  while (a_str <> '') do
    result := result +  Next(a_str)+ ' ';

end;


function TCrew.GetCarryIn: boolean;
begin
  if CrewD.CarryIn = '0:00' then
    result := false
    else
    result := true;
end;

function TCrew.GetCrewName: string;
begin
  result := CrewD.Name;
end;

{ TTrip }
procedure TTrips.Add(sl: TStringlist);
var
  i:integer;
  line:string;

begin
     for I := 0 to sl.Count - 1 do
     begin
        SetLength(Allocs,i+1);
        line := sl[i]+ ',';
        Allocs[i].Sn          := Next(line);
        Allocs[i].Alloc       := Next(line);
        Allocs[i].Pattern     := Next(line);
        Allocs[i].Blank       := Next(line);
        Allocs[i].Report      := Next(line);
        Allocs[i].SignOff     := Next(line);
        Allocs[i].Days        := Next(line);
        Allocs[i].Rest        := Next(line);
        Allocs[i].Credits     := Next(line);
        Allocs[i].RouteCode   := Next(line);
        Allocs[i].Credits_Day := Next(line);
        Allocs[i].Prealloc    := Next(line);
        Allocs[i].Points      := Next(line);
      end;
end;

procedure TTrips.Clear;
begin
  SetLength(Allocs,0);
end;

constructor TTrips.Create;
begin
   SetLength(Allocs,0);
end;

destructor TTrips.Destroy;
begin
   SetLength(Allocs,0);
   inherited;
end;

function TTrips.Display: Tstringlist;
var
  str:string;
  i:integer;
begin
  result := Tstringlist.Create;
  result.Add(' ' + pad_str_right(10,' ','Pat') + tab +  'Report' + tab + tab + tab  + 'Signoff' + tab + tab + 'Days' + tab + 'Rest' + tab +
              'Credit' + tab + 'RCode' + tab + 'Cred/D' + tab + 'Pre' + tab + 'Points');
  for I := 0 to Self.Count - 1 do
  begin
    str:= ' ' + pad_str_right(10,' ', Allocs[i].Pattern) + tab +
     Allocs[i].Report + tab +
     Allocs[i].SignOff + tab +
     Allocs[i].Days + tab +
     Allocs[i].Rest + tab +
     Allocs[i].Credits + tab +
     Allocs[i].RouteCode + tab +
     Allocs[i].Credits_Day + tab +
     Allocs[i].Prealloc + tab +
     Allocs[i].Points;
    result.Add(str);
  end;

    result.Add(tab + tab +tab +tab +tab +tab +'Totals'+ tab + tab + IntToStr(TotalDaysAway) +
               tab + tab + TotalCredits + tab + tab + min_to_hours(TripDensity) + tab + tab + inttostr(Points));


end;

function TTrips.GetCount: integer;
begin
  Result := Length(Allocs);
end;
 function TTrips.GetDaysAway(Index:integer):integer;
begin
   result := StrToInt(Allocs[Index].Days);
end;

function TTrips.GetDepDay(Index:integer):integer;
var
  a_date:TDateTime;
          
begin
  a_date := StrToDate(Allocs[index].Report);
  result := datetime_to_bp_day(a_date,Diag.Bidperiod);
end;

function TTrips.GetPoints: integer;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to Count - 1 do
    begin
      if Allocs[i].Points <> '' then
        result := result + strtoint(Allocs[i].Points)
    end;
end;
function TTrips.GetTripDensity: integer;
var
  i: Integer;
// average trip Densities  ie mins/day
begin
  result := 0;
  for i := 0 to Count - 1 do
   result := result + hours_to_min(Allocs[i].Credits_Day);
  if Count = 0 then
    result := 0
    else
    result := result div count;

end;
// ----------------------------------------------------------------------------
function TTrips.GetTripLength: real;
var
  i: Integer;
// average trip Length in days
begin
  for i := 0 to Count - 1 do
   result := result + strtoint(Allocs[i].Days);
  result := result / count;

end;

function TTrips.TotalCredits: string;
var
  I, min: Integer;

begin
  min := 0;
  for I := 0 to Count - 1 do
     min := min + hours_to_min(allocs[i].Credits);
   Result := min_to_hours(min);
end;

function TTrips.TotalDaysAway: integer;
var
  i: Integer;
begin
  result:=0;
  for i := 0 to Count - 1 do
    result  := result + strtoint(allocs[i].Days);
end;

//******************************************************************************
{ TBuckets }

procedure TBuckets.Add(val:TBucket);
begin
  inc(FNumBuckets);
  SetLength(FBuckets,FNumBuckets);
  FBuckets[FNumBuckets-1].Patterns := Tstringlist.Create;
  SetBucket(FNumBuckets-1,val);
end;

function TBuckets.CheckBuckets(Trips:TTrips;CarryIn:boolean): boolean;
var
  iBucket,iAwards,iPatterns,AwardsStart:integer;
  tripCount:array of integer;
  OK:boolean;

begin
  result := true;
  if Buckets.NumBuckets = 0 then exit;
  setLength(tripCount,Buckets.NumBuckets);

  if CarryIn then
    AwardsStart := 1
    else
    AwardsStart := 0;

  for Iawards := AwardsStart to Trips.Count -1  do
  begin
    for iBucket := 0 to Buckets.NumBuckets -1 do
      for iPatterns := 0 to Buckets.Bucket[iBucket].Patterns.Count -1 do
        if NOT ( Trips.Allocs[iawards].RouteCode = '') and
         (Trips.Allocs[iawards].RouteCode = Buckets.Bucket[iBucket].Patterns[iPatterns]) then
        begin
          inc(tripCount[iBucket]);
        end;
  end;

  for iBucket := 0 to Buckets.NumBuckets -1 do
    if (tripcount[ibucket] > Buckets.Bucket[iBucket].Limit) then result := False;

  (*  old version
  for iBucket := 0 to high(tripCount) do
    tripcount[iBucket] := 0;
  for iAwards := 0 to high(awards) do
    for iBucket := 0 to Buckets.NumBuckets -1 do
      for iPatterns := 0 to Buckets.Bucket[iBucket].Patterns.Count -1 do
        if NOT ( awards[iAwards].Route = '') and
         (awards[iAwards].Route = Buckets.Bucket[iBucket].Patterns[iPatterns]) then
        begin
          inc(tripCount[iBucket]);
        end;     *)

end;
// ----------------------------------------------------------------------------  *)
procedure TBuckets.Clear;
var
  index:integer;
begin
  for index := 0 to FNumBuckets -1 do
    FBuckets[index].Patterns.free;
  SetLength(FBuckets,0);
  FNumBuckets := 0;

end;
// ----------------------------------------------------------------------------
constructor TBuckets.Create;
begin
  inherited;
  FNumBuckets:= 0;
end;

destructor TBuckets.Destroy;
var
  index:integer;
begin
  for index := 0 to FNumBuckets -1 do
    FBuckets[index].Patterns.Free;
  SetLength(FBuckets,0);
  FNumBuckets := 0;
  inherited;
end;

function TBuckets.GetBucket(index: integer): TBucket;
begin
  result:= FBuckets[index]
end;

procedure TBuckets.SetBucket(index: integer; const Value: TBucket);
var
  i:integer;
begin
  FBuckets[index].Limit := value.Limit;
  for i := 0 to Value.Patterns.Count -1 do  // Value.Patterns.Count was 9 and caused errors ????
    FBuckets[index].Patterns.Add(value.Patterns[i]);
    {The add method is necessary because the Value is a pointer, and although its
      contents change each added Bucket will end up pointing to the same address.
      This repeated the last value for each bucket but could end up undefined.}

end;

{ TCrewBids }
(*
constructor TCrewBids.Create;
begin

end;

destructor TCrewBids.Destroy;
begin

end;

procedure TCrewBids.DisplayBid(sl: Tstringlist);
begin

end;

function TCrewBids.Getcount: integer;
begin

end;
  *)
end.
