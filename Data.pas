unit Data;
// All data from Carmen handled here.
// Diag object

interface
  uses classes,sysutils,Dates,DateUtils,Dialogs,my_strings;
  const {filter}
        Default           = 0;
        PreAllocation     = 1;
        LowLine           = 2;
        TrainingAllocated = 3;
        Unlocked          = 4;

        Version           = '2.20';// mar 2016



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
     Stick,Pre_alloc,Alloc,CarryIn,Status,Unlocked:string;
   end;

  Type TBIDCO =record
    Sn,Bidco,No,DateText,Limit,Points,Achieved,Matches:string;//8
  end;

  Type TBIDCI =record
      Sn,Bidci,No,Plus,Text:string;//5
  end;

  Type TBIDSL =record
    Sn,Bidsl,No,DateText,Limit,Points,Achieved,Matches:string;//8  matches currently blank
  end;

  Type TStatus = class
  // hold a list of status values and resolve if valid for a crew member
  private
    lst:TStringList;
  public
    procedure add(val:string);// add a status
    procedure clear;
    function displayStatus:string;
    procedure remove(val:string);// remove
    function  valid(val:string):boolean;// check for a match within the class for the val passed.
    constructor  create;
    destructor   destroy;
  end;

  Type TTrips = class
    private
      function  GetAvTripDensity: integer; // average trip density
      function  GetAvTripLength: real;     // average trip length
      function  GetActualPG(index:integer):integer;// number of whole days
      Function  GetCount:integer;
      function  GetTotalPoints: integer;// total points for all trips
      function  GetDaysAway(Index:integer):integer;
      function  GetDepDay(Index:integer):integer;
      function  GetLeave: integer;  // 1 ..56 (28)
      function  GetMPG(index:integer):integer;//days
      Procedure Display(sl:Tstringlist;CarryIn,PreallocationMode:boolean);     // output display of combined trips
      Procedure DisplaySecond(sl:Tstringlist;Pats: array of boolean);     // output display of combined trips

      function  TotalCredits:string;

    public
      Allocs:array of TAlloc;
      Property Count:integer Read GetCount;
      Property DaysAway[Index:integer]:integer Read GetDaysAway;
      Property DepDay[Index:integer]:integer read GetDepDay;
      Property Leave:integer read GetLeave;
      Property Points:integer Read GetTotalPoints;
      Property TripDensity:integer read GetAvTripDensity;
      Property TripLength:real Read GetAvTripLength;
      procedure Add(sl:TStringlist);
      procedure Clear;
      Constructor Create;
      Destructor  Destroy;override;
      Function PreallocatedDuty(index:integer):boolean;
      function  TotalDaysAway:integer;
  end;

  Type TCrew = class
  // class to hold the details for each crew members diagnostic
  // TcrewD details,TAlloc allocations stringlist for bidsetc
    private
      Bids:TJOStringlist;
      Gpref:TGpref;
      Rostr,Bidgr:string;
      FNotes:string;
      procedure CalendarHeader(sl:Tstringlist;Bp:TBidperiod);
      function GetCrewName: string;
      function GetCarryIn: boolean;
      function GetLeave: integer;
      function GetBidBlank: boolean;
      function GetPoints: integer;
      function GetCarryInDays:integer;

    public
      Index:integer;
      CrewD:TCrewD;
      Trips:TTrips;
      Property CarryIn:boolean Read GetCarryIn;
      property CarryInDays:integer Read GetCarryInDays;
      Property CrewName:string read GetCrewName;
      Property Leave:integer read GetLeave;
      Property BidBlank:boolean read GetBidBlank;
      Property Notes:string read FNotes;
      Property Pointsachieved:integer read GetPoints;
      procedure Add(sl:TStringlist);
      procedure Clear;
      constructor Create;
      destructor  Destroy;Override;
      function  IdenticalLine(crew:Tcrew;msg:string):boolean;
      function  IdenticalBidgr(crew:Tcrew):boolean;
      function  IdenticalRostr(crew:Tcrew):boolean;
      procedure IdenticalPatterns(crew:Tcrew; var Pats:array of boolean);
      procedure DisplayBids(sl:TStringList);
      procedure DisplayDetails(sl:TStringList);
      procedure DisplayGPRef(sl:Tstringlist);
      function  DisplayRostr(Bidperiod4Week:boolean):string;
      function  DisplayBidgr(Bidperiod4Week:boolean):string;
      procedure DisplayCalendar(sl:Tstringlist);
      function  DisplayNotes(CarryIn:boolean):string;
      procedure DisplayTrips(sl:Tstringlist;CarryIn,PreallocationMode:boolean);
      function  LowLine:boolean;
      function  NumberofWeekends:integer;
      function  NumberDaysOff:integer;
      procedure OrderBids;
      function  PreAllocatedDuties:boolean;
      function  Trainingallocated(var TType:string):boolean;
      function  Unlocked:boolean;
  end;


  Type TDiag = class
    private
      FBidPeriod:TBidperiod;
      FCount:integer;
      FAircraftType: string;
      FFilename: string;
      function GetCrewName(index:integer): string;
      function GetLeaveHours:string;
      procedure StatusNumbers(sl:TStringlist;var nums:array of integer);
      procedure SetAircraftType(const Value: string);
      function GetBidperiod: string;
    public
      Crews: array of TCrew;
      Property Bidperiod:string read GetBidperiod;
      Property Count:integer read Fcount;
      Property Crewname[index:integer]:string Read GetCrewName;
      Property AirCraftType :string Read FAircraftType Write SetAircraftType;
      Property filename:string Read FFilename ;
      Constructor Create;
      Destructor  Destroy;Override;
      Procedure Add(crew_sl:Tstringlist);
      Procedure Awardsfile(Result:TStringlist);
      Procedure Clear;
      Procedure Display(sl:TStringList;Index:integer;PreAllocationMode:boolean);
      Procedure DisplaySplitview(sl:Tstringlist;Index:integer);
      procedure DisplaySplitviewSecond(D1:TDiag;sl: Tstringlist; Index,Index2: integer);
      function  IndextoSn(index:integer):string;
      Procedure LoadFromfile(fn:string);
      Procedure NamesAlpha(namelist,indexlist:tstringlist;Rank:string;Status:TStatus;filter:integer);
      Procedure NamesSeniority(namelist,indexlist:tstringlist;Rank:string;Status:TStatus;filter:integer);
      function  Preallocatedduties(Index:integer):boolean;
      Procedure Routecodes(sl:TStringlist);
      Procedure SetBidperiod(value:string);
      Function  SnToIndex(sn:string):integer;
      procedure StatusCategories(sl:TStringlist);
      Procedure Summary(sl:Tstringlist);
    end;

  type
   TBuckets = class
   private
     FBuckets: array of TBucket;
     FNumBuckets:integer;
     function  GetBucket(index: integer): TBucket;
     procedure SetBucket(index: integer; const Value: TBucket);
   public
     property    Bucket[index:integer]: TBucket read GetBucket write SetBucket;
     property    NumBuckets:integer read FNumBuckets;
     procedure   Add(val:TBucket);
     Procedure   Clear;
     constructor Create;
     Destructor  Destroy; override;
     Function    CheckBuckets(Trips: TTrips;CarryIn:Boolean):boolean;
     Function    CheckBuckets2Bps(Trips,Trips2: TTrips;CarryIn:Boolean):boolean;
 end;
//---------------------------------------------------------------------------

   Function Next(var str:string):string ;

   Var Diag,DiagTwo:TDiag;
       Buckets :TBuckets;
       AddBucket :TBucket;
       Status:TStatus;

// ***********************************************************************

implementation
  function LastValue(line:string):string;
  // last string in a csv line
  var
    a_str:string;
  begin
    if copy(line,length(line),1) <> ',' then
      line:= line + ',';// line must end with a ','
    a_str := next(line);
    result := a_str;
    while (line <> '') do
    begin
      a_str:= next(line);
      result:= a_str;
    end;
  end;
//  *****************************************************************
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
Function Training(pat:string):boolean;
// eps = EPann or EPa
 begin
   result := false;
   if copy(pat,1,3) = 'SFL' then result := true;
   if length(pat) = 5 then
     if copy(pat,1,2) = 'EP' then result := true;
   if length(pat) = 3 then
     if copy(pat,1,2) = 'EP' then result := true;

  end;

 // ********************************************************************
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
function FormatSeniority(a_str:string):string;
var
  len:integer;

begin
  if containsStr('(',a_str) then
  begin  //330
    len := pos('(',a_str) -1;
    result := numbers_only(copy(a_str,1,len));
  end
  else
    result := a_str;
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
  Crews[FCount -1].OrderBids;


end;
//------------------------------------------------------------------------------
Procedure TDiag.SetBidperiod(value: string);
// Set the Fbp record from  filename,'BP2645'
var
  a_bp:string;
begin
  Next(value);
  a_bp := Next(value);
  a_bp := copy(a_bp,3,4);
  FBidperiod := GetTBidPeriod(a_bp);
end;
//------------------------------------------------------------------------------
function TDiag.SnToIndex(sn: string): integer;
var
  i: Integer;
// return the index to a staff number
begin
  result := -1; // default , no match
  for i := 0 to Count - 1 do
    if Crews[i].CrewD.Sn = sn then
    begin
      result := i;
      break;
    end;
end;
//------------------------------------------------------------------------------
procedure TDiag.StatusCategories(sl:TStringlist);
// return a liatof categories available to create the View/Status menu
// unique to each Diag
var
  i:integer;
begin
  sl.Sorted := true;
  sl.Duplicates := dupIgnore;
  for i := 0 to Diag.Count -1 do
  begin
    sl.Add(Diag.Crews[i].Crewd.Status)
  end;
end;
//------------------------------------------------------------------------------
procedure TDiag.Awardsfile(Result: TStringlist);
var
  i,j: Integer;
  line:string;
// generate an awards file from the diagnostic details
begin
  // ?????????????????
  line:= Diag.AirCraftType + ','+
         Diag.Bidperiod + ',' ;
  for i := 0 to Count - 1 do
  begin
     //crew details
     line := Crews[i].CrewD.Sn + ',' +
             Crews[i].CrewD.Name + ',' +
             Crews[i].CrewD.Rank + ',' +
             Crews[i].CrewD.Aircraft + ',' +
             Crews[i].CrewD.Base + ',' +
             Crews[i].CrewD.Seniority + ',' +
             Crews[i].CrewD.Credits + ',' +
             Crews[i].CrewD.Win_Low + ',' +
             Crews[i].CrewD.Win_hi + ',' +
             Crews[i].CrewD.Stick + ',' +
             Crews[i].CrewD.Pre_Alloc + ',' +
             Crews[i].CrewD.Alloc + ',' +
             Crews[i].CrewD.CarryIn + ',' +
             Crews[i].CrewD.Status + ',' +
             Crews[i].CrewD.Unlocked + ',' ;

     result.Add(line);
     // trip details
     for j := 0 to Crews[i].Trips.Count -1 do
     begin
       line := Crews[i].CrewD.Sn;
       line:= Crews[i].Trips.Allocs[j].Sn + ','+
              Crews[i].Trips.Allocs[j].Pattern + ','+
              Crews[i].Trips.Allocs[j].Report + ','+
              Crews[i].Trips.Allocs[j].SignOff + ','+
              Crews[i].Trips.Allocs[j].Days + ','+
              Crews[i].Trips.Allocs[j].Credits + ','+
              Crews[i].Trips.Allocs[j].RouteCode + ','+
              Crews[i].Trips.Allocs[j].Credits_Day + ','+
              Crews[i].Trips.Allocs[j].Prealloc + ','+
              Crews[i].Trips.Allocs[j].Points + ',';
       result.Add(line);
     end;
  end;

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
//------------------------------------------------------------------------------
constructor TDiag.Create();
begin
  inherited Create;
  FCount := 0;

end;
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
procedure TDiag.Display(sl:TStringList;Index:integer;PreAllocationMode:boolean);
// main display for rtDiag , return display via sl, for crew id Index
begin
  sl.Add(rt_info_1);
  sl.Add(rt_info_2);
  sl.Add(rt_info_3);

  sl.Add(nl+ bold + fontsize);
  Crews[index].DisplayDetails(sl);
  sl.Add(nl);

  //Trips
  crews[index].DisplayTrips(sl,crews[index].CarryIn,PreAllocationMode);
  sl.Add(nl);

  //CALENDAR
  Crews[index].displayCalendar(sl);
  sl.add(nl);

  // line
  sl.add(Crews[index].DisplayRostr(FBidperiod.FourWeek));

  // x days
  sl.add(Crews[index].DisplayBidgr(FBidperiod.FourWeek));
  sl.Add(nl);

  //GPREF
  crews[index].DisplayGPRef(sl);
  sl.Add(nl);

  // bids;
  Crews[index].DisplayBids(sl);
  sl.add(end_rt);
  // notes
  Crews[index].FNotes := Crews[index].DisplayNotes(Crews[index].CarryIn);
end;
//------------------------------------------------------------------------------
procedure TDiag.DisplaySplitview(sl: Tstringlist; Index: integer);
// this procedure is always called by Diag
begin
  sl.Add(rt_info_1);
  sl.Add(rt_info_2);
  sl.Add(rt_info_3);

  sl.Add(' Points Achieved:' + RedText(inttostr(Crews[index].Pointsachieved)) + col_black + ' ' );
  Crews[index].DisplayDetails(sl);
  sl.Add(nl);
  //Trips
  crews[index].Trips.Display(sl,crews[index].CarryIn,false);
  sl.Add(nl);
  //CALENDAR
//  Crews[index].displayCalendar(sl);
  sl.add(nl);
   // x days
  sl.add(Crews[index].DisplayRostr(FBidperiod.FourWeek));
  sl.add(Crews[index].DisplayBidgr(FBidperiod.FourWeek));
  sl.Add(nl);
  sl.add(end_rt);
end;
//------------------------------------------------------------------------------
procedure TDiag.DisplaySplitviewSecond(D1:TDiag;sl: Tstringlist; Index,Index2: integer);
// this procedure is always called by Diagtwo
// D1 is diag
var
  result:array of boolean;
begin
  sl.Add(rt_info_1);
  sl.Add(rt_info_2);
  sl.Add(rt_info_3);

  sl.Add(' Points Achieved:' + RedText(inttostr(Crews[Index2].Pointsachieved)));
  Crews[Index2].DisplayDetails(sl);
  sl.Add(nl);
  //Trips
  SetLength(Result,Crews[Index2].Trips.Count);
  Crews[Index2].IdenticalPatterns(D1.Crews[Index],result);
  crews[index2].Trips.DisplaySecond(sl,result);
  sl.Add(nl);
  //CALENDAR
//  Crews[index].displayCalendar(sl);
  sl.add(nl);

   // roster days
  if Crews[index2].IdenticalRostr(D1.crews[index]) then
    sl.add(Crews[index2].DisplayRostr(FBidperiod.FourWeek))
    else
    sl.add(RedText(Crews[index2].DisplayRostr(FBidperiod.FourWeek)));
 // x days
  if Crews[index2].IdenticalBidgr(D1.crews[index]) then
    sl.add(Crews[index2].DisplayBidgr(FBidperiod.FourWeek))
    else
    sl.add(RedText(Crews[index2].DisplayBidgr(FBidperiod.FourWeek)));

  sl.Add(nl);
  sl.add(end_rt);
end;
//------------------------------------------------------------------------------
function TDiag.GetBidperiod: string;
begin
  result := FBidPeriod.Name;
end;
//------------------------------------------------------------------------------
function TDiag.GetCrewName(index:integer): string;
begin
  result := Crews[index].CrewName;
end;
//------------------------------------------------------------------------------
function TDiag.GetLeaveHours: string;
var
  i,cp,fo,so:integer;

begin
  cp:= 0; fo:=0; so:=0;
  for i  := 0 to Count - 1 do
    begin
      if Crews[i].CrewD.Rank = 'CP' then cp := cp + Crews[i].Leave;
      if Crews[i].CrewD.Rank = 'FO' then fo := fo + Crews[i].Leave;
      if Crews[i].CrewD.Rank = 'SO' then so := so + Crews[i].Leave;
    end;
  result := 'Cpt: ' + min_to_hours(cp) + ' ' + tab +
            'F/O: ' + min_to_hours(fo) + ' ' + tab +
            'S/O: ' + min_to_hours(so);
end;
function TDiag.IndextoSn(index: integer): string;
// return staffnumber for an crew index
begin
  if (index < Count) and (index> -1)  then
    result := Crews[index].CrewD.Sn
    else
    result := 'None';
end;

//------------------------------------------------------------------------------
procedure TDiag.LoadFromfile(fn: string);
var
  i:integer;
  filelist:tstringlist;
  sl:tstringlist;
  sn,a_str:string;

begin
 sl:= TStringList.Create;
 filelist := TStringList.Create;
 filelist.LoadFromFile(fn);
 a_str:= filelist[0];
 SetBidperiod(a_str);
 SetAirCraftType(a_str);
 FFilename:= ExtractFileName(fn);
 sn:= filelist[1];sn := Next(sn);
 sl.Add(filelist[1]);

    for i := 2 to filelist.Count -1 do
      begin
        if (sn = copy(filelist[i],1,6)) then
        begin // add to crew
         sl.Add(filelist[i]);
         //Add to diag
        end
         else
        begin//new crew;
          self.Add(sl);
          sl.Clear;
          sn:= filelist[i];sn := Data.Next(sn);
          sl.Add(filelist[i]);
        end;
      end;
      // last man
      if (sl.Count<>0) and (copy(sl[0],8,5) = 'CREWD') then
          self.Add(sl);
    sl.Free;

 end;
//------------------------------------------------------------------------------
procedure TDiag.NamesAlpha(namelist,indexlist: tstringlist;Rank:string;Status:TStatus;filter:integer);
// return an alphabetical list of name and a matching list of indexes
var
 i:integer;
 sl:Tstringlist;
 a_str,a_rank,a_status,ttype:string;
 add:boolean;
begin
  sl:= TStringList.Create;
  sl.Sorted := True;
  //create combined sorted list
  for I := 0 to Count - 1 do // for each crew member in the diag
  begin
    add:= false;
    a_rank := crews[i].CrewD.Rank;
    a_status := crews[i].CrewD.Status;

    case filter of
      0:add := true;//alph only nothing todo
      1:if (crews[i].PreAllocatedDuties) then add:= true;//preallocated
      2:if (crews[i].LowLine) then add := true;// lowlines
      3:if (crews[i].Trainingallocated(ttype)) then add := true;
      4:if (crews[i].Unlocked) then add := true;// unlocked
    end;

    if add then
      begin
      if ((a_rank = Rank)  or (Rank = 'None')) then
        {if ((a_status = Status) or (Status = 'None')) then}
        if (Status.valid(a_status))then
          sl.add(crews[i].CrewD.Name + ',' + inttostr(crews[i].Index)+',')

      end;
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
//------------------------------------------------------------------------------
procedure TDiag.NamesSeniority(namelist, indexlist: tstringlist;Rank:string;Status:TStatus;filter:integer);
// return a seniority sorted list of name and a matching list of indexes
var
 i:integer;
 sl:Tstringlist;
 a_str,sen,a_rank,a_status,ttype:string;
 add:boolean;

begin
  sl:= TStringList.Create;
  sl.Sorted := True;
  //seniority,name,index list
  for I := 0 to Count - 1 do // for each crew member in the diag
  begin
    add:= false;
    sen := FormatSeniority(crews[i].CrewD.seniority);
    a_rank := crews[i].CrewD.Rank;
    a_status := crews[i].CrewD.Status;

    case filter of
      0:add := true;//seniority only nothing todo
      1:begin;//preallocated
          if (crews[i].PreAllocatedDuties) then add:= true;
        end;
      2:if (crews[i].LowLine) then add := true;// lowlines
      3:if (crews[i].Trainingallocated(ttype)) then add := true;
      4:if (crews[i].Unlocked) then add := true;// unlocked
    end;

    if add then
      begin
      if ((a_rank = Rank)  or (Rank = 'None')) then
        //if ((a_status = Status) or (Status = 'None')) then
        if (Status.valid(a_status))then
          sl.Add(pad_Str_left(4,'0',sen) + ',' + crews[i].CrewD.Name + ',' + inttostr(crews[i].Index)+',')
    end;
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
//------------------------------------------------------------------------------
function TDiag.Preallocatedduties(Index:integer): boolean;
// return true if any preallocated duty exists
begin
  result := false;
  result := crews[index].PreAllocatedDuties;
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
//------------------------------------------------------------------------------
procedure TDiag.SetAircraftType(const Value: string);
var
  a_str:string;
begin
  a_str:= value;
  FAircraftType := copy(next(a_str),11,3);// aircraft  FAircraftType := Value;
end;
//------------------------------------------------------------------------------
procedure TDiag.StatusNumbers(sl:TStringlist;var nums: array of integer);
  function total:integer;
   begin
     result := nums[0]+ nums[1]+nums[2]+nums[3]+nums[4]+nums[5]+nums[6]+nums[7]+nums[8]+nums[9]+nums[10];
   end;

  procedure getNums(rank:string);
  var
    i:integer;
  begin
    reset_int_array(nums);
    for i := 0 to Count - 1 do
      if Crews[i].CrewD.Rank = rank then
      begin
        if Crews[i].CrewD.Status = 'PLH' then inc(NUMS[0]);
        if Crews[i].CrewD.Status = 'BLH' then inc(NUMS[1]);
        if Crews[i].CrewD.Status = 'RLH' then inc(NUMS[2]);
        if Crews[i].CrewD.Status = 'LOA' then inc(NUMS[3]);
        if Crews[i].CrewD.Status = 'U/T' then inc(NUMS[4]);
        if Crews[i].CrewD.Status = 'SVY' then inc(NUMS[5]);
        if Crews[i].CrewD.Status = 'TRN' then inc(NUMS[6]);
        if Crews[i].CrewD.Status = 'RCS' then inc(NUMS[7]);
        if Crews[i].CrewD.Status = 'FCC' then inc(NUMS[8]);
        if Crews[i].CrewD.Status = 'PFL' then inc(NUMS[9]);
        if Crews[i].CrewD.Status = 'INS' then inc(NUMS[10]);
      end;
  end;

  function getLine(rank:string):string;
  begin
      result := tab + rank + tab;
      result := result + IntToStr(nums[0]) + tab;
      result := result + IntToStr(nums[7]) + tab;
      result := result + IntToStr(nums[6]) + tab;
      result := result + IntToStr((nums[6] + nums[7] + nums[0]) div 3) + tab;
      result := result + IntToStr(nums[1]) + tab;
      result := result + IntToStr(nums[2]) + tab;
      result := result + IntToStr(nums[3]) + tab;
      result := result + IntToStr(nums[4]) + tab;
      result := result + IntToStr(nums[5]) + tab;
      result := result + IntToStr(nums[8]) + tab;
      result := result + IntToStr(nums[9]) + tab;
      result := result + IntToStr(nums[10]) + tab;
      Result := Result + IntToStr(total);
   end;

  procedure AddRank(rank:string);
  begin
    getNums(rank);
    sl.Add(getLine(rank));
    sl.Add('');
  end;

begin
  sl.Clear;
  sl.Add(tab + tab + 'PLH' + tab + 'RCS' + tab + 'TRN' + tab + 'Blanks' + tab +
         'BLH' + tab + 'RLH' + tab + 'LOA' + tab + 'UT' + tab + 'SVY' + tab + 'FCC' + tab + 'PFL' + tab + 'INS' + tab + 'Totals' );
  sl.Add(tab + tab  + tab +  tab + tab + 'Max');
  sl.Add('');

  AddRank('CP');
  AddRank('FO');
  AddRank('SO');
end;
//------------------------------------------------------------------------------
procedure TDiag.Summary(sl: Tstringlist);
// create a text containing a summary of pertainent values
var
  nums:array[0..10] of integer;
  a_str:string;
  StatusSl:TStringList;
begin
  //Status
  StatusSl := TStringList.Create;
  sl.Add('');
  sl.Add('  Summary Bidperiod: ' + Bidperiod);
  sl.Add('');
  StatusNumbers(StatusSl,nums);
  sl.AddStrings(StatusSl);
  sl.Add('');

  //Leave hours
  a_str := tab + 'Leave: ' + GetLeaveHours;
  sl.Add(a_str);

  StatusSl.Free;
  //
end;

//*****************************************************************************
{ TCrew }

procedure TCrew.Add(sl: TStringlist);
var
  line,a_str:string;
  i:integer;
  allocsSl,prefSL:TStringlist;
begin
   line:= sl[0]+ ',';
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
   CrewD.Status     := next(line);
   CrewD.Unlocked   := next(line);

   allocsSl:= TStringList.Create;
   prefSL  := TStringList.Create;


   for I := 0 to sl.Count - 1 do
     begin
       if copy(sl[i],8,5) = 'ALLOC' then allocsSl.Add(sl[i]);
       if copy(sl[i],8,5) = 'GPREF' then prefSL.Add(sl[i]);

       if (copy(sl[i],8,3) = 'BID') then
         if copy(sl[i],8,5) = 'BIDGR' then Bidgr :=sl[i]
         else
           Bids.Add(sl[i]);
       if (copy(sl[i],8,5) = 'ROSTR') then Rostr := sl[i];

     end;

   //Trips
   Trips:= TTrips.Create;
   Trips.Add(allocsSl);

   //Global Pref
   if prefSL.Count = 7 then
   begin
     a_str:= PrefSl[0]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.LineHourRange := a_str;
     a_str:= PrefSl[1]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.SlideLeave := a_str;
     a_str:= PrefSl[2]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.CarryOutLimit := a_str;
     a_str:= PrefSl[3]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.BlankLine := a_str;
     a_str:= PrefSl[4]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.ProfferLine := a_str;
     a_str:= PrefSl[5]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.MBT := a_str;
     a_str:= PrefSl[6]; Next(a_str); Next(a_str); Next(a_str);
     Gpref.Min36hrsSDO := a_str;
   end;

   prefSL.Free;
   allocsSl.Free;
end;
//------------------------------------------------------------------------------
procedure TCrew.DisplayBids(sl: TStringList);
  Function BidNo(a_str:string):integer;
  begin
    Next(a_str); Next(a_str);
    Result := strtoint(Next(a_str));
  end;

var
  i,numfields: Integer;
  a_bid,line:string;
  bidco:TBIDCO;
  bidsl:TBIDSL;
begin
 sl.Add(nl);
 sl.Add(nl +  ' Bids: Points Achieved ' + RedTExt(pad_str_right(43,' ',inttostr(PointsAchieved))) +  'Matches' + tab + 'Limit' + tab + 'Pts' + tab + 'Total');
 if Bids.Count = 0 then exit;
 sl.add(nl);
 for i := 0 to Bids.Count - 1 do
 begin
   if copy(bids[i],8,5) = 'BIDCO' then
   begin

     line := bids[i]+ ',';
     numfields      := NumberofFields(line);
     bidco.Sn       := next(line);
     bidco.Bidco    := next(line);
     bidco.No       := next(line);
     bidco.DateText := next(line);
     bidco.Limit    := next(line);
     bidco.Points   := next(line);
     bidco.Achieved := next(line);
     bidco.Matches  := next(line);

     if bidco.Matches = '' then bidco.Matches := ' '; 
     if bidco.Limit = '' then bidco.Limit := ' ';
     if bidco.Points = '' then bidco.Points := ' ';
     if bidco.Achieved = '' then bidco.Achieved := ' ';

     a_bid := '  ' + pad_Str_left(2,' ',bidco.No) + '  ';
     a_bid := a_bid + pad_str_right(58,' ',bidco.DateText) + tab;
     a_bid := a_bid + bidco.Matches + tab;
     a_bid := a_bid + bidco.Limit + tab;
     a_bid := a_bid + bidco.Points + tab ;
     a_bid := a_bid + bidco.Achieved ;


     sl.Add(nl + a_bid);
   end;
   if copy(bids[i],8,5) = 'BIDCI' then
   begin
     line := bids[i]+ ',';
     Next(line);Next(line);Next(line);
     a_bid := pad_str_right(7,' ','');
     a_bid := a_bid + Next(line) + ' ';
     a_bid := a_bid + Next(line);
     sl.Add(nl + a_bid);
   end;

   if copy(bids[i],8,5) = 'BIDSL' then
   begin
     line := bids[i]+ ',';
     numfields := NumberofFields(line);
     if (numfields <> 8) then
        a_bid := 'Format error in BIDSL line.'
       else
       begin
         bidsl.Sn := next(line);
         bidsl.Bidsl := next(line);
         bidsl.No := next(line);
         bidsl.DateText := next(line);
         bidsl.Limit := next(line);
         bidsl.Points := next(line);
         bidsl.Achieved := next(line);
         bidsl.Matches := next(line);

         a_bid := '  ' + pad_Str_left(2,' ',bidsl.No) + '  ';
         a_bid := a_bid + pad_str_right(58,' ',bidsl.DateText) + tab;
         a_bid := a_bid + bidsl.Matches + tab;
         a_bid := a_bid + bidsl.Limit + tab;
         a_bid := a_bid + bidsl.Points + tab;
         a_bid := a_bid + bidsl.Achieved;

       end;
     sl.Add(nl + a_bid);
   end;
 end;
 sl.add(nl);

end;
//------------------------------------------------------------------------------
procedure TCrew.CalendarHeader(sl: Tstringlist; Bp: TBidperiod);
var
  a_day:TDateTime;
  ln1,ln2,ln3,day:string;
  i:integer;
begin
   ln1:= tab;
   ln2:= tab;
   ln3:= tab;
   //MONTHS
   if bp.FourWeek then
     Ln1 := ln1 + MonthBpDay(1,bp) + pad_right(50,' ','') + MonthBpDay(28,bp)
   else
     Ln1 := ln1 + MonthBpDay(1,bp) + pad_right(106,' ','') + MonthBpDay(56,bp);

   for i := 1 to Bp.length  do
   begin
      a_day := BpDayToDatetime(i,Bp);
      day := pad_Str_left(2,' ',inttostr(DayOfTheMonth(a_day)));
      ln2 := ln2  + copy(day,1,1) + ' ';
      ln3 := ln3  + copy(day,2,1) + ' ';
   end;
   sl.add(nl + ln1);
   sl.add(nl + ln2);
   sl.add(nl + ln3);
   sl.Add(nl);
end;
//------------------------------------------------------------------------------
procedure TCrew.Clear;
begin
  Trips.Clear;
  Bids.Clear;
end;
//------------------------------------------------------------------------------
constructor TCrew.Create;
begin
  inherited;
  Bids := TJOStringList.Create;
end;
//------------------------------------------------------------------------------
destructor TCrew.Destroy;
begin
  Trips.Destroy;
  Bids.Free;
  inherited;
end;
//------------------------------------------------------------------------------
function TCrew.DisplayBidgr(Bidperiod4Week:boolean): string;
var
  a_str,a_day:string;

  function validBidgr:boolean;
  begin
    if Bidperiod4Week then
      result := (length(a_str) = 56)
      else
      result := (length(a_str) = 112);
  end;

begin
  a_str:= Bidgr + ',';
  next(a_str);next(a_str);next(a_str);next(a_str);

  if true {validBidgr} then
  begin
    a_day :=  Next(a_str);
    if a_day = '' then a_day := ' ';
    result := nl + tab + a_day + ' ';
    while (a_str <> '') do
      begin
        a_day :=  Next(a_str);
        if a_day = '' then a_day := ' ';
        result := result + a_day + ' ';
      end;
    end
    else
    result := nl + tab + tab + 'No valid X day bidding information';
end;
//------------------------------------------------------------------------------
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

  CalendarHeader(sl,Diag.FBidperiod);
   if (Diag.FBidperiod.FourWeek) then
    sl.Add(nl + tab+ 'M T W T F S S M T W T F S S M T W T F S S M T W T F S S')
      else
    sl.Add(nl + tab+ 'M T W T F S S M T W T F S S M T W T F S S M T W T F S S M T W T F S S M T W T F S S M T W T F S S M T W T F S S');
  sl.Add(nl);

  // carry in trip always line 1


  for i := 0 to Length(Trips.Allocs) - 1 do
    begin
      a_date:= StringToDateTime(Trips.allocs[i].Report);
      dep := DatetimeToBpDay(a_date,Diag.FBidperiod);
      if (Self.CarryIn) and (i = 0 )  then dep :=1;// show carry in o day one
      a_str:= Trips.Allocs[i].Pattern;
      a_str:= pad_str_right(4,' ',a_str);
      ln1[dep *2 ] := a_str[1];
      ln2[dep *2 ] := a_str[2];
      ln3[dep *2 ] := a_str[3];
      ln4[dep *2 ] := a_str[4];
    end;

  sl.Add(nl + ln1);
  sl.Add(nl + ln2);
  sl.Add(nl + ln3);
  sl.Add(nl + ln4);
end;
//------------------------------------------------------------------------------
procedure TCrew.DisplayDetails(sl: TStringList);
var
  str:string;
begin

  sl.Add(nl);
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
         'Carry' + tab +
         'Status' + tab +
         'Unlocked';
  sl.Add(nl + str);

  str:=  pad_str_right(30,' ',' ' + CrewD.Name) +
         CrewD.Sn +  tab +
         CrewD.rank +  tab +
         CrewD.Aircraft +  tab +
         CrewD.Base +  tab +
         FormatSeniority(CrewD.Seniority) +  tab +
         CrewD.Credits +  tab +
         CrewD.Win_low +  tab +
         CrewD.Win_hi +  tab +
         CrewD.Stick +  tab +
         CrewD.Pre_alloc +  tab +
         CrewD.Alloc +  tab +
         CrewD.CarryIn + tab +
         CrewD.Status + tab +
         Crewd.Unlocked;
  sl.Add(nl + str);
end;
//------------------------------------------------------------------------------
procedure TCrew.DisplayGPRef(sl: Tstringlist);
var
   line :string;
begin

  sl.Add(nl + 'Line Hour Range' + tab + 'SlideLeave '+ tab + 'CarryOutLimit' + tab
          + tab + 'BlankLine' + tab + 'ProfferLine' + tab + 'MBT' + tab + 'Min36hrsSDO');
  line :=   GPRef.LineHourRange + tab +  tab + tab +
            GPRef.SlideLeave + tab +  tab +
            GPRef.CarryOutLimit + tab +  tab + tab +
            GPRef.BlankLine  + tab + tab +
            GPRef.ProfferLine + tab +  tab +
            GPRef.MBT + tab +
            GPRef.Min36hrsSDO;
  sl.Add(nl + line);
end;
//------------------------------------------------------------------------------
function TCrew.DisplayNotes(CarryIn:boolean):string;
var
  i,first:integer;
  msg,TType:string;

  procedure Add(a_str:string);
  begin
    if msg = '' then
      msg :=  a_str
      else
      msg := msg + ', ' + a_str;

  end;

begin
  msg := '';
  if ((self.BidBlank) and (self.CrewD.Status = 'PLH')) then
    Add('PLH Bid Blank ');

  if ((not self.BidBlank) and (self.CrewD.Status = 'BLH')) then
    add('BLH Bid PLH ');



  if Self.Gpref.MBT = 'No' then
  begin
    if CarryIn then first := 1 else first := 0;
    for i := first to Trips.Count - 2 do
      begin
        if (Trips.GetMPG(i) > Trips.GetActualPG(i)) then
          Add(Trips.allocs[i+1].Pattern + '< MPG ');
      end;
  end;

  if hours_to_min(Self.CrewD.Credits) < hours_to_min(self.CrewD.Win_low) then
    Add('Low Line ');

  if hours_to_min(Self.CrewD.Credits) > hours_to_min(self.CrewD.Win_hi) then
    Add('High Line ');

  if Trainingallocated(TType) then add(TType);

  result := msg;
end;
//------------------------------------------------------------------------------
function TCrew.DisplayRostr(Bidperiod4Week:boolean): string;
var
  a_str,value:string;

  function validrostr:boolean;
  begin
    if Bidperiod4Week then
      result := (length(a_str) = 112)
      else
      result := (length(a_str) = 56);
  end;

begin
  a_str:= Rostr + ',';
  next(a_str);next(a_str);next(a_str);next(a_str);
  if true {validrostr} then
  begin
     value := Next(a_str);
     if value = '' then
       result := tab +  ' ' + Value + ' '
       else
       result := tab +  Value + ' ';

    while (a_str <> '') do
    begin
      value := Next(a_str);
      if value = '' then
          result := result +  ' ' + Value + ' '
          else
          result := result +  Value + ' ';
    end;
    result := nl + result;
  end
  else
    result := nl + tab + tab + 'Incomplete roster Infromation';
end;
//------------------------------------------------------------------------------
procedure TCrew.DisplayTrips(sl: Tstringlist; CarryIn,PreallocationMode: boolean);
begin
  self.Trips.Display(sl,CarryIn,PreAllocationMode);
end;
//------------------------------------------------------------------------------
function TCrew.GetBidBlank: boolean;
begin
  result :=  (Gpref.BlankLine = 'Yes');
end;
//------------------------------------------------------------------------------
function TCrew.GetCarryIn: boolean;
begin
  if CrewD.CarryIn = '0:00' then
    result := false
    else
    result := true;
end;
//------------------------------------------------------------------------------
function TCrew.GetCarryInDays:integer;
var
  line:string;
begin
  line:= rostr;
  result:= 0;
  next(line);next(line);next(line);next(line);
  while (next(line)='>') do
    inc(result);
end;

//------------------------------------------------------------------------------
function TCrew.GetCrewName: string;
begin
  result := CrewD.Name;
end;
//-----------------------------------------------------------------------------
function TCrew.GetLeave: integer;
begin
  Result := Trips.Leave;
end;
//------------------------------------------------------------------------------
function TCrew.GetPoints: integer;
// add the points achievedd for each bid
var
  I,j,fields: Integer;
  bidtype,str:string;
begin
  result := 0;// default
  for I := 0 to bids.count - 1 do
  begin
    str:= bids[i] + ',';next(str);
    bidtype := next(str);
    fields := NumberofFields(str);
    // check for correct number of fields, the last field is normally blank and may be an error in the diagnostic construction
    if (bidtype <> 'BIDCI')then
      if (fields <> 6) then
        begin
          MessageDlg('Format error in diagnostic',mtWarning,[mbCancel],0);
          result := 0;
          break;
        end;

    if bidtype = 'BIDCO' then
       begin
         for j  := 1 to fields -2 do
           next(str);
         result := result + strtoint(next(str));
       end;

    if bidtype = 'BIDSL' then
      begin
        for j  := 1 to fields -2 do
          next(str);
        result := result + strtoint(next(str));
      end;

  end;
end;
//------------------------------------------------------------------------------
function TCrew.IdenticalBidgr(crew: Tcrew): boolean;
begin
  if crew.Bidgr = self.Bidgr then
    result := true
   else
    result := false;
end;
//------------------------------------------------------------------------------
function TCrew.IdenticalLine(crew: Tcrew;msg:string): boolean;
// need to ignore training duties, trips may be out of sequence
var
   i,j:integer;
   match:boolean;

begin
  result := true;
  for i  := 0 to self.Trips.Count - 1 do
  begin
    if Training(self.Trips.Allocs[i].Pattern) then Continue;// ignore ep pattern

    match := false;
    for j := 0 to crew.Trips.Count - 1 do
      if crew.Trips.Allocs[j].Pattern = self.Trips.Allocs[i].Pattern then
        if crew.Trips.Allocs[j].Report = self.Trips.Allocs[i].Report then
          match := true;// matching pattern found

     //once the j loop i complete a match must exist
     if not match then result := false;
  end;

  for i  := 0 to crew.Trips.Count - 1 do
  begin
    if Training(Crew.Trips.Allocs[i].Pattern) then Continue;// ignore eps,training pattern

    match := false;
    for j := 0 to Self.Trips.Count - 1 do
      if crew.Trips.Allocs[i].Pattern = self.Trips.Allocs[j].Pattern then
        if crew.Trips.Allocs[i].Report = self.Trips.Allocs[j].Report then
          match := true;// matching pattern found

    if not match then result := false;
  end;

(*  if not match then
    begin // if any pattern fails to find a match the lines are not identical
      result := false;
      msg:= 'Lines not a match.';
    end;
  *)
  (*if crew.Rostr <> self.Rostr then result := false;
  if crew.Bidgr <> self.Bidgr then result := false;*)
end;
//------------------------------------------------------------------------------
procedure TCrew.IdenticalPatterns(crew:Tcrew; var Pats:array of boolean);
var
  i,j:integer;
  match:boolean;
begin
// crew comes from Diag  self is Diagtwo
  for i  := 0 to self.Trips.Count - 1 do
  begin
    if Training(self.Trips.Allocs[i].Pattern) then
    begin
      Pats[i] := true;//considered matched
      Continue;// ignore ep pattern
    end;

    match := false;
    for j := 0 to crew.Trips.Count - 1 do
      if crew.Trips.Allocs[j].Pattern = self.Trips.Allocs[i].Pattern then
        if crew.Trips.Allocs[j].Report = self.Trips.Allocs[i].Report then
          match := true;// matching pattern found

    if match then pats[i]:= true;;
    // if any pattern fails to find a match the lines are not identical
  end;
end;
//------------------------------------------------------------------------------
function TCrew.IdenticalRostr(crew: Tcrew): boolean;
begin
  if crew.Rostr = self.Rostr then
    result := true
   else
    result := false;
end;
//------------------------------------------------------------------------------
function TCrew.LowLine: boolean;
var
  credits,lowWindow:integer;
begin
  credits := hours_to_min(Self.CrewD.Credits);
  lowWindow := hours_to_min(Self.CrewD.Win_low);
  result := (credits < lowWindow);
end;
//------------------------------------------------------------------------------
function TCrew.NumberDaysOff: integer;
// number of days  off, ie 56- P, _,
// what about leave  or blank lines ???
var
  line,day:string;
  i:integer;
begin
//  168553,ROSTR,04APR2016,29MAY2016,>,>,X,X,A,P,-,-,-,-,-,-,-,-,X,X,X,X,X,X,X,A,A,P,-,-,-,-,-,-,-,-,X,X,X,X,X,X,A,A,P,-,-,-,-,-,-,-,-,X,X,X,A,A,A,P
  result:= 0;
  line := Rostr + ',';
  next(line);next(line);next(line);next(line);
  for i  := 0 to 7  do // for each week
    begin
      next(line);next(line);next(line);next(line);next(line);
      day := next(line);

      if ((day = 'P') or (day = '-'))  then
         inc( result);
    end;
    result := 56 - result;
end;
//------------------------------------------------------------------------------
function  TCrew.NumberofWeekends:integer;
// return the number of whole weekends off , ie X day or A day
var
  line,sat,sun:string;
  i:integer;
begin
//  168553,ROSTR,04APR2016,29MAY2016,>,>,X,X,A,P,-,-,-,-,-,-,-,-,X,X,X,X,X,X,X,A,A,P,-,-,-,-,-,-,-,-,X,X,X,X,X,X,A,A,P,-,-,-,-,-,-,-,-,X,X,X,A,A,A,P
  result:= 0;
  line := Rostr + ',';
  next(line);next(line);next(line);next(line);
  for i  := 0 to 7  do // for each week
    begin
      next(line);next(line);next(line);next(line);next(line);
      sat := next(line);
      sun := next(line);
      if ((sat = 'X') or (sat = 'A')) and ((sun = 'X') or (sun = 'A')) then
         inc( result);
    end;

end;
//------------------------------------------------------------------------------
procedure TCrew.OrderBids;
// final files have bids out of order, so reorder them by points scored
// bids may contain more than one line of info. Create an arry of stringlist, each element
// contains a bid, the points are taken from the first line of the bid.
var
  i,j,a_bidnum,score: Integer;
  sl,order_list:Tstringlist;
  LocalBids:array of Tstringlist;
  a_str,a_line,bidno:string;

  function BidNum(a_bid:string):integer;
  // bid numbers are zero base in the csv, this is a zero base result
  begin
    a_line := a_Bid;
    Next(a_line);Next(a_line);
    bidno := Next(a_line);
    result := strtoint(bidno);
  end;
//-----------------------------------------------------------------------------
  function Points(line:string):string;
  var
    fields,i:integer;
  begin
    fields := NumberofFields(line + ',');
    for i := 1 to fields -2 do
      result := Next(line);
  end;
  //
begin
  sl:= TStringList.Create;
  order_list := TStringList.Create;
  order_list.Sorted := true;
  if Bids.Count > 0 then
     SetLength(LocalBids,BidNum(Bids[Bids.Count -1])+ 1)
    else
     exit;//nothing to do

  //create the array of local bids
  for i := 0 to Length(LocalBids) - 1 do
    LocalBids[i] := TStringList.Create;

  //fill the local bids arrays
  for i := 0 to Bids.Count - 1 do
    LocalBids[BidNum(Bids[i])].Add(Bids[i]);

  // create a list order by points from [0] of the local bids list
  // ie the order the bids should be displayed ie 'pppp,bidnum'
  for I := 0 to Length(LocalBids) - 1 do
    begin
      score  := strtoint(Points(LocalBids[i][0]));
      score  := 1000 - score;// inverts values for sorting
      //points := pad_Str_left(4,'0',inttostr(score));
      bidno  := pad_Str_left(2,'0',inttostr(BidNum(LocalBids[i][0])));
      order_list.Add(pad_Str_left(4,'0',inttostr(score)) + ',' + bidno + ',');
    end;

  // create the new list of bids
  for I := 0 to order_list.Count - 1 do
  begin
    a_line := order_list[i];Next(a_line);
    a_bidnum := strtoint(Next(a_line));
    for j := 0 to Localbids[a_bidnum].Count - 1 do
      sl.Add(LocalBids[a_bidnum][j]);
  end;

  Bids.Assign(sl);

  //clean up
  sl.Free;
  for i := 0 to Length(LocalBids) - 1 do
    LocalBids[i].Free;

end;

//------------------------------------------------------------------------------
function TCrew.PreAllocatedDuties: boolean;
var
  i,j:integer;
begin
  result := false;
  if self.CrewD.CarryIn <> '0:00' then  {carry in exists}
    i := 1 else i := 0;
  for j := i to Trips.Count - 1 do
    if Trips.PreallocatedDuty(j) then
    begin
      result := true;
      exit;
    end;
end;
//------------------------------------------------------------------------------
function TCrew.Trainingallocated(var TType:string): boolean;
// return true if any EPs pattern or SFL pattern exists
var
  i: Integer;
begin
  result := false;
  for i := 0 to Trips.Count - 1 do
    if Training(Trips.Allocs[i].Pattern) then
    begin
      result:= true;
      TType := Trips.Allocs[i].Pattern;
    end;
end;
//------------------------------------------------------------------------------
function TCrew.Unlocked: boolean;
begin
  result := CrewD.Unlocked = 'Y';
end;

//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
procedure TTrips.Clear;
begin
  SetLength(Allocs,0);
end;
//------------------------------------------------------------------------------
constructor TTrips.Create;
begin
   SetLength(Allocs,0);
end;
//------------------------------------------------------------------------------
destructor TTrips.Destroy;
begin
   SetLength(Allocs,0);
   inherited;
end;
//------------------------------------------------------------------------------
procedure TTrips.Display(sl:Tstringlist;carryIn,PreAllocationMode:boolean);
// trip 0 may be carry in trip
var
  str:string;
  i:integer;
begin
  sl.Add(nl + ' ' + pad_str_right(10,' ','Pat') + tab +  pad_str_right(11,' ','Report') + tab  + pad_str_right(11,' ','Signoff') + tab + 'Days' + tab + 'Rest' + tab +
              'Credit' + tab + 'RCode' + tab + 'Cred/D' + tab + 'Pre' + tab + 'Points');

   if self.Count = 0 then exit; // nothing to do

   If (PreAllocationMode) and
      (allocs[0].Prealloc = 'Y') and
      ( not CarryIn) then
         str:= ' ' + BlueText(pad_str_right(10,' ', Allocs[0].Pattern))
       else
         str:= ' ' + pad_str_right(10,' ', Allocs[0].Pattern);
     str:= str + tab +
     ShortReportStr(Allocs[0].Report) + tab +
     ShortReportStr(Allocs[0].SignOff )+ tab +
     Allocs[0].Days + tab +
     Allocs[0].Rest + tab;
     if (PreAllocationMode) and
        (allocs[0].Prealloc = 'Y') then
         str:= str +  BlueText(Allocs[0].Credits)
         else
         str:= str +  Allocs[0].Credits;
     str:= str + tab +
     Allocs[0].RouteCode + tab +
     Allocs[0].Credits_Day + tab +
     Allocs[0].Prealloc + tab +
     Allocs[0].Points;
    sl.Add(nl + str);


  for I := 1 to Self.Count - 1 do
  begin
     If (PreAllocationMode) and
        (allocs[i].Prealloc = 'Y') then
         str:= ' ' + BlueText(pad_str_right(10,' ', Allocs[i].Pattern))
       else
         str:= ' ' + pad_str_right(10,' ', Allocs[i].Pattern);
     str:= str + tab +
     ShortReportStr(Allocs[i].Report) + tab +
     ShortReportStr(Allocs[i].SignOff )+ tab +
     Allocs[i].Days + tab +
     Allocs[i].Rest + tab;
     if (PreAllocationMode) and
        (allocs[i].Prealloc = 'Y') then
         str:= str +  BlueText(Allocs[i].Credits)
         else
         str:= str +  Allocs[i].Credits;
     str:= str + tab +
     Allocs[i].RouteCode + tab +
     Allocs[i].Credits_Day + tab +
     Allocs[i].Prealloc + tab +
     Allocs[i].Points;
    sl.Add(nl + str);
  end;

    sl.Add(nl + ' ' + pad_str_right(10,' ','') + tab + tab + pad_str_right(15,' ','Totals') + tab + IntToStr(TotalDaysAway) +
               tab + tab + TotalCredits + tab + tab + min_to_hours(TripDensity) + tab + tab + RedText(inttostr(Points)));

end;
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure TTrips.DisplaySecond(sl: Tstringlist;Pats:array of boolean);
var
  str:string;
  i:integer;
begin
  sl.Add(nl + ' ' + pad_str_right(10,' ','Pat') + tab +  pad_str_right(11,' ','Report') + tab  + pad_str_right(11,' ','Signoff') + tab + 'Days' + tab + 'Rest' + tab +
              'Credit' + tab + 'RCode' + tab + 'Cred/D' + tab + 'Pre' + tab + 'Points');

  for I := 0 to Self.Count - 1 do
  begin
     if  not pats[i] then
       str := ' ' + Redtext(pad_str_right(10,' ', Allocs[i].Pattern)) + tab
       else
       str:= ' ' + pad_str_right(10,' ', Allocs[i].Pattern)  + tab;
     str:= str +
     ShortReportStr(Allocs[i].Report) + tab +
     ShortReportStr(Allocs[i].SignOff )+ tab +
     Allocs[i].Days + tab +
     Allocs[i].Rest + tab +
     Allocs[i].Credits + tab +
     Allocs[i].RouteCode + tab +
     Allocs[i].Credits_Day + tab +
     Allocs[i].Prealloc + tab +
     Allocs[i].Points;
     sl.Add(nl + str);
  end;


    sl.Add(nl + ' ' + pad_str_right(10,' ','') + tab + tab + pad_str_right(15,' ','Totals') + tab + IntToStr(TotalDaysAway) +
               tab + tab + TotalCredits + tab + tab + min_to_hours(TripDensity) + tab + tab + RedText(inttostr(Points)));

end;
//------------------------------------------------------------------------------
function TTrips.GetCount: integer;
begin
  Result := Length(Allocs);
end;
//------------------------------------------------------------------------------
function TTrips.GetDaysAway(Index:integer):integer;
begin
   result := StrToInt(Allocs[Index].Days);
end;
//------------------------------------------------------------------------------
function TTrips.GetDepDay(Index:integer):integer;
var
  a_date:TDateTime;

begin
  a_date := StrToDate(Allocs[index].Report);
  result := DatetimeToBpDay(a_date,Diag.FBidPeriod.Bp);
end;
//------------------------------------------------------------------------------
function TTrips.GetLeave: integer;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to Count - 1 do
    if self.Allocs[i].Pattern = 'AL' then
      result :=  result + hours_to_min(Self.Allocs[i].credits);
end;
//------------------------------------------------------------------------------
function TTrips.GetMPG(index: integer): integer;
// calculate the minimum pattern gap for a pattern
var
  days:integer;
  a_str:string;
begin
  a_str:= allocs[index].Pattern;
  if containsStr(a_str,'HL,OL,TSPD,AL,LSL,LWOP') then
  begin
    result := 0;
    exit;
  end;

  days := strtoint(allocs[index].Days);
  result := days div 2;
  if result < 1 then result := 1;
end;
//------------------------------------------------------------------------------
function TTrips.GetTotalPoints: integer;
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
//------------------------------------------------------------------------------
function TTrips.PreallocatedDuty(index: integer): boolean;
begin
  result := false;
  if (self.Allocs[index].Prealloc = 'Y') then
   if not(containsStr(self.Allocs[index].Pattern,'AL,LSL,LSL2' ))then // not reviewed as preallocated duties
       result := true;
end;
//------------------------------------------------------------------------------
function TTrips.GetActualPG(index: integer): integer;
var
  standdown,report:TDatetime;
begin
  standdown := StringToDateTime(Allocs[index].SignOff);
  if index < Count -1 then
    begin
      report := StringToDateTime(allocs[index + 1].Report);
      result := (DaysBetween(report, standdown) -1 );
    end
    else
    result := 0;
end;
//------------------------------------------------------------------------------
function TTrips.GetAvTripDensity: integer;
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
function TTrips.GetAvTripLength: real;
var
  i: Integer;
// average trip Length in days
begin
  result := 0;
  for i := 0 to Count - 1 do
   result := result + strtoint(Allocs[i].Days);
  result := result / count;

end;
//------------------------------------------------------------------------------
function TTrips.TotalCredits: string;
var
  I, min: Integer;

begin
  min := 0;
  for I := 0 to Count - 1 do
     min := min + hours_to_min(allocs[i].Credits);
   Result := min_to_hours(min);
end;
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
function TBuckets.CheckBuckets(Trips:TTrips;CarryIn:boolean): boolean;
var
  iBucket,iAwards,iPatterns,AwardsStart:integer;
  tripCount:array of integer;

begin
  result := true;
  if Buckets.NumBuckets = 0 then exit;
  setLength(tripCount,Buckets.NumBuckets);

  {if CarryIn then
    AwardsStart := 1
    else
    AwardsStart := 0;
   }
  for Iawards := 0{AwardsStart} to Trips.Count -1  do
  begin
    for iBucket := 0 to Buckets.NumBuckets -1 do
      for iPatterns := 0 to Buckets.Bucket[iBucket].Patterns.Count -1 do
        if NOT ( Trips.Allocs[iawards].RouteCode = '') then if
           not (Trips.Allocs[iawards].preAlloc = 'Y') then if
             (Trips.Allocs[iawards].RouteCode = Buckets.Bucket[iBucket].Patterns[iPatterns]) then
        begin
          inc(tripCount[iBucket]);
        end;
  end;

  for iBucket := 0 to Buckets.NumBuckets -1 do
    if (tripcount[ibucket] > Buckets.Bucket[iBucket].Limit) then result := False;
end;
// ----------------------------------------------------------------------------  *)
function TBuckets.CheckBuckets2Bps(Trips,Trips2:TTrips;CarryIn:boolean): boolean;
//check buckets applied over 2 bidperiods
var
  iBucket,iAwards,iPatterns,AwardsStart:integer;
  tripCount:array of integer;

begin
  result := true;
  if Buckets.NumBuckets = 0 then exit;
  setLength(tripCount,Buckets.NumBuckets);

  {if CarryIn then
    AwardsStart := 1
    else
    AwardsStart := 0;
   }

  // first bp
  for Iawards := 0{AwardsStart} to Trips.Count -1  do
  begin
    for iBucket := 0 to Buckets.NumBuckets -1 do
      for iPatterns := 0 to Buckets.Bucket[iBucket].Patterns.Count -1 do
        if NOT ( Trips.Allocs[iawards].RouteCode = '') then if
           not (Trips.Allocs[iawards].preAlloc = 'Y') then if
             (Trips.Allocs[iawards].RouteCode = Buckets.Bucket[iBucket].Patterns[iPatterns]) then
        begin
          inc(tripCount[iBucket]);
        end;
  end;

  // second bp
  // for second bp match crew
      // if Diag2 exists
      // if matching crew exist  ie not -1
      // if cbCheckBuckets2Pbs
      //icrew := DiagTwo.SnToIndex(Diag.Crews[index].CrewD.Sn);

  for Iawards := 0{AwardsStart} to Trips2.Count -1  do
  begin
    for iBucket := 0 to Buckets.NumBuckets -1 do
      for iPatterns := 0 to Buckets.Bucket[iBucket].Patterns.Count -1 do
        if NOT ( Trips2.Allocs[iawards].RouteCode = '') then if
           not (Trips2.Allocs[iawards].preAlloc = 'Y') then if
             (Trips2.Allocs[iawards].RouteCode = Buckets.Bucket[iBucket].Patterns[iPatterns]) then
        begin
          inc(tripCount[iBucket]);
        end;
  end;


  for iBucket := 0 to Buckets.NumBuckets -1 do
    if (tripcount[ibucket] > Buckets.Bucket[iBucket].Limit) then result := False;
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
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
function TBuckets.GetBucket(index: integer): TBucket;
begin
  result:= FBuckets[index]
end;
//------------------------------------------------------------------------------
procedure TBuckets.SetBucket(index: integer; const Value: TBucket);
var
  i:integer;
begin
  FBuckets[index].Limit := value.Limit;
  for i := 0 to Value.Patterns.Count -1 do
    FBuckets[index].Patterns.Add(value.Patterns[i]);
    {The add method is necessary because the Value is a pointer, and although its
      contents change each added Bucket will end up pointing to the same address.}
end;
//------------------------------------------------------------------------------
{ TStatus }

procedure TStatus.add(val: string);
begin
  lst.Add(val);
end;

procedure TStatus.clear;
begin
  lst.Clear
end;

constructor TStatus.create;
begin
  lst := tstringlist.create;
end;
//
destructor TStatus.destroy;
begin
  lst.Free;
end;

function TStatus.displayStatus: string;
var
  i: Integer;
begin
  result := '';
  if lst.Count = 0 then exit;

  result := ' / ';
  for i := 0 to Lst.Count - 1 do
  begin
    result := result + lst[i];
    if i < Lst.Count - 1 then
      result := result + '/';
  end;
end;

procedure TStatus.remove(val: string);
begin
  lst.Delete(lst.IndexOf(val));
end;

function TStatus.valid(val: string): boolean;
var
  I: Integer;
begin
  if lst.Count = 0  then
  begin
    result := true;
    exit;
  end;
  
  if lst.IndexOf(val) <> -1 then
  result := true
  else
  result := false;
end;

end.
