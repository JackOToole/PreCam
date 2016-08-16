unit Dates;

interface
uses
 classes,sysutils,dialogs,my_strings,dateutils;

  Type TBidperiod = record
    Bp,Length:integer;
    Name:string;//_4week,_8week can be 'none'
    FourWeek,Week5:Boolean; //week5 =  A fourweek bidperiod starting week 5 of the full cycle,
  end;

  type TBpDays = 1..56;
  type TWeeks  = 1..8;
  type TDays   = 1..7;

  Type TBpDay = class(TObject)
  (* New class to encapsulate a single day. /to provide referwnce to its bp, day number, date time, week day values*)
//    constructor Create(aDate:TdateTime);overload;  needs more info bp
    constructor Create(BP:TBidperiod;aDayNumber:integer);overload;
    destructor  Destroy;override;
  private
    FDate:TDateTime;
    FDayNumber:TBpDays;
    FBp:TBidperiod;
    FWeek:TWeeks;
    FDay:TDays;
  public
    Property Date:TDateTime read FDate;
    Property DayNumber:TBpDays read FDayNumber;
    Property Bp:TBidPeriod read FBp;
    Property Week:TWeeks read FWeek;
    Property Day:TDays read Fday;
  end;

function GetTBidPeriod(Bp:string):TBidperiod;

function BpDayToDatetime(const day:integer;bidperiod:integer):tdatetime;overload;
function BpDayToDatetime(const day:integer;Bidperiod:TBidperiod):tdatetime;overload;

//function BpYear(bidperiod:integer):integer;overload;
function BpYear(Bidperiod:TBidperiod):integer;overload;

//function BpMonth(bidperiod:integer):integer;overload;
function BpMonth(Bidperiod:TBidperiod):integer;overload;
function MonthBpDay(a_day:integer;Bidperiod:TBidperiod):string;

//function BpMonthLastDay(bidperiod:integer):integer;overload;
function BpMonthLastDay(Bidperiod:TBidperiod):integer;overload;

function DatetimeToBpDay(a_date:tdatetime;bp:integer):integer;overload;
function DatetimeToBpDay(a_date:tdatetime;Bidperiod:TBidperiod):integer;overload;

function DatetimeToBp(a_date:tdatetime):integer;overload;
// never used dec 2006 function DatetimeToBp(a_date:tdatetime;Bidperiod:TBidperiod):integer;overload;

//function BpDateRange(bp:integer):string;overload;
function BpDateRange(Bidperiod:TBidperiod):string;overload;

function DayAsDatetime(const week,day,bidperiod:integer):string;overload;
function DayAsDatetime(const week,day:integer;Bidperiod:TBidperiod):string;overload;

function DateToBp(a_date:tdatetime):string;overload;// return the bp 191
function DateToBp(a_date:tdatetime;Bidperiod:TBidperiod):string;overload;// return the bp 191

function DateToBpWeek(a_date:tdatetime):string;overload;//        week  1..8
function DateToBpWeek(a_date:tdatetime;Bidperiod:TBidperiod):string;overload;//        week  1..8

function DateToBpday(a_date:tdatetime):string;overload;//    and  day   1..56
function DateToBpday(a_date:tdatetime;Bidperiod:TBidperiod):string;overload;//    and  day   1..56

//function InitCalendar(const bp:integer):tdatetime;overload;
function InitCalendar(Bidperiod:TBidperiod):tdatetime;overload;

//function DayOfBp(const week,day:integer):integer;overload;
function DayOfBp(const week,day:integer;Bidperiod:TBidperiod):integer;overload;

//function DaysToBidsClose:integer;overload;
function DaysToBidsClose(Bidperiod:TBidperiod):integer;overload;

function Previous_bp(Bidperiod:TBidperiod):string;overload;  // Used in demand charts
function Previous_bp(Bidperiod:Integer):integer;overload;    // May not be applied to the current bp

function DDMMDate(date:TDatetime):string;
function HHMMToDateTime(hhmm:string):TDateTime;

function StringToDateTime(a_date:string):TDateTime;
{________________________________________________________________________}
implementation
const
   dayone=35352;//first day of 182 14/oct 96
   init_bp=182;

// datetime routines used internally by this unit


{________________________________________________________________________}

function ShortBp(bp:string):integer;
begin
  result := strtoint(copy(bp,1,3));
end;

function Week5(bp:string):boolean;
begin
  result := false;
  if length(bp) = 4 then
   if copy(bp,4,1) = '5' then
     result := true;
end;
//------------------------------------------------------------------------------
function DatetimeToBp(a_date:tdatetime):integer;overload;
var
  a_bp:integer;

begin
  a_bp:=trunc(a_date-dayone);//{num of days since dayone 183}
  result:=(a_bp div 56)+182;{BP}
end;
//--------------------------------------------------------------------------
function BpDayToDatetime(const day:integer;bidperiod:integer):tdatetime;overload;
// return a day in a bidperiod as tdate time
//input an integer 1..56 ,bidperiod
begin
  result := dayone + (( bidperiod - init_bp )*56)+ day -1;
end;
//-------------------------------------------------------------------------------

{*************************************************************************}

//   **********   External Functions  ************
//
//*************************************************************************

function GetTBidPeriod(bp:string):TBidperiod;

begin
//remove leading zero
  if copy(bp,1,1) = '0' then
    bp := copy(bp,2,3);
// remove _
  bp := numbers_only(bp);
  if length(bp) = 4 then
  begin
    result.Name     := bp;
    result.FourWeek := True;
    result.Length   := 28;
    result.Bp       := strtoint(copy(bp,1,3));// nnn only
    result.Week5    := Week5(bp);
    //result._4Week   := ext;
    //result._8Week   := inttostr(result.Bp);
  end;

  if length(bp) =3 then
  begin
    result.Name     := bp;
    result.FourWeek := False;
    result.Length   := 56;
    result.Bp       := strtoint(result.Name);
    result.Week5    := False;
    //result._8Week   := ext;
    //result._4Week   := latestAwards(filename);
  end;

end;
//------------------------------------------------------------------------------
(*
function BpYear(bidperiod:integer):integer;overload;
//year for day one of the bidperiod
var
  a_date :tdatetime;
  a_year:string;

begin
  a_date:= BpDayToDatetime(1,bidperiod);
  datetimetostring(a_year,'yyyy',a_date);
  result:=strtoint(a_year);
end;
//--------------------------------------------------------------------------
function BpMonth(bidperiod:integer):integer;overload;
//month for day one of the bidperiod
var
  a_date :tdatetime;
  a_month:string;
begin
  a_date:= BpDayToDatetime(1,bidperiod);
  datetimetostring(a_month,'mm',a_date);
  result:=strtoint(a_month);
end;
//--------------------------------------------------------------------------
function BpMonthLastDay(bidperiod:integer):integer;overload;
//month for day one of the bidperiod
var
  a_date :tdatetime;
  a_month:string;
begin
  a_date:= BpDayToDatetime(56,bidperiod);
  datetimetostring(a_month,'mm',a_date);
  result:=strtoint(a_month);
end;
//--------------------------------------------------------------------------
*)
function DatetimeToBpDay(a_date:tdatetime;bp:integer):integer;overload;
// return a day number 1..56 from a datetime
// now considers overlap problems ?ie refers to actual bp
// dates prior to the commencement of the bp need to be trapped before thids function ?????
var
  a_bp,days:integer;

begin
  days:=trunc(a_date-dayone);{num of days since dayone 183}
  days:=(days mod 56)+1;{num of days into the BP}
  a_bp:= DatetimeToBp(a_date);
  result:=days + (a_bp - bp)*56;
  if a_bp < bp then result := -1;//date precedes bp
end;
(*
//-------------------------------------------------------------------------------
function BpDateRange(bp:integer):string;overload;
// return a string containing a date range for the bp
var
  first_day,last_day:tdatetime;
  from,too:string;
begin
  result:='';// default incase of errors
  first_day:= BpDayToDatetime(1,bp); //first day of bp
  last_day:= BpDayToDatetime(56,bp);// last  "    "
  datetimetostring(from,'ddd dd mmm',first_day);// format for display
  datetimetostring(too,'ddd dd mmm',last_day);// combine for display
  result:= from + '  to  '+ too;
end;
//-------------------------------------------------------------------------------
function DayOfBp(const week,day:integer):integer;overload;
//used by crewinfo to convert the start day to a number 1..56
// input a week,

begin
 if day <1 then// day can be more thna 56 for overlap
   result:=0
  else
   result:=((week-1)*7)+ day;//mon=1 tue 2 etc
end;

//--------------------------------------------------------------------------
*)
function DayAsDatetime(const week,day,bidperiod:integer):string;overload;
//used by crewinfo to convert the start day of a trip to tdatetime number
// input a week day and bidperiod
// *** This is necessary when using week 1.. 8 in every case, 767 awards and patterns are
//     always treated as weeeks 1..8.
var
 day_num:integer;
 a_date:tdatetime;

begin
 day_num:=((week-1)*7)+ day;//mon=1 tue 2 etc
 a_date:=dayone+((bidperiod-init_bp)*56)+day_num -1;
 datetimetostring(result,'ddd dd mmm',a_date);

end;
(*
//-------------------------------------------------------------------------

function InitCalendar(const bp:integer):tdatetime;overload;
//var
// a_date:tdatetime;

 begin
  result:=dayone+((bp - init_bp)* 56);
end;
{------------------------------------------------------------------------------}
*)
function DateToBp(a_date:tdatetime):string;overload;
//return bp for a datetime
var
   a_bp:integer;
begin
   a_bp:=trunc(a_date-dayone);//num of days since dayone 183
   a_bp:=(a_bp div 56)+init_bp;
   result:= inttostr(a_bp);
end;

//------------------------------------------------------------------------------
function DateToBpWeek(a_date:tdatetime):string;overload;
//return the bp week for a date time
var
   a_bp,a_week,a_day:integer;
begin
   a_bp:=trunc(a_date-dayone);//num of days since dayone 183
   a_day:=(a_bp mod 56)+1;{num of days into the BP}
   a_week:=((a_day-1) div 7)+1;{num of days into the week}
   result:=inttostr(a_week);
end;
//------------------------------------------------------------------------------
function DateToBpday(a_date:tdatetime):string;overload;
var
  a_bp,a_day:integer;
begin
  a_bp:=trunc(a_date-dayone);//num of days since dayone 183
  a_day:=(a_bp mod 56)+1;{num of days into the BP}
  result:=inttostr(a_day);
end;
//------------------------------------------------------------------------------
(*
function DaysToBidsClose:integer;overload;
var
   convert:string ;
   a_bp,a_week,a_day,a_pos:integer;


begin
   convert:=floattostr(now-dayone);
   a_pos:=pos('.',convert);
   convert:=copy(convert,1,a_pos-1);   // this works where just strtoint did not ???

   a_bp:=strtoint(convert);{num of days since dayone 183}
   a_day:=(a_bp mod 56)+1;{num of days into the BP}
   if a_day > 0 then
     result:=(43-a_day)
    else
     result:=0;
end;

*)
//------------------------------------------------------------------------------
//      Overloaded Versions
//------------------------------------------------------------------------------

function BpDayToDatetime(const day:integer;Bidperiod:TBidperiod):tdatetime;overload;
// return a day in a bidperiod as tdate time
//input an integer 1..56 ,bidperiod
begin
  With Bidperiod do
  begin
    result:=dayone+((Bidperiod.Bp - init_bp )* 56)+ day -1;// default good for 4  or 8 week
    if  FourWeek then
      if Week5 then
       result:=dayone + 28 +((Bidperiod.bp - init_bp )* 56)+ day-1;
  end;
end;
//--------------------------------------------------------------------------
function BpYear(Bidperiod:TBidperiod):integer;overload;
//year for day one of the bidperiod
var
  a_date :tdatetime;
  a_year:string;
begin
  With Bidperiod do
  begin
    a_date:= BpDayToDatetime(1,bp);
    if FourWeek then  // modify day one for week 5
      if Week5 then a_date := a_date + 28;
    datetimetostring(a_year,'yyyy',a_date);
    result:=strtoint(a_year);
  end;
end;
//--------------------------------------------------------------------------
function BpMonth(Bidperiod:TBidperiod):integer;overload;
//month for day one of the bidperiod
var
  a_date :tdatetime;
  a_month:string;
begin
  With Bidperiod do
  begin
    a_date:= BpDayToDatetime(1,bp);
    if FourWeek then
      if Week5 then a_date := a_date + 28;
    datetimetostring(a_month,'mm',a_date);
    result:=strtoint(a_month);
  end;
end;
//--------------------------------------------------------------------------
function MonthBpDay(a_day:integer;Bidperiod:TBidperiod):string;
var
  a_date :tdatetime;
begin
  a_date:= BpDayToDatetime(a_day,Bidperiod);
  datetimetostring(result,'mmm',a_date);
end;
//---------------------------------------------------------------------------
function BpMonthLastDay(Bidperiod:TBidperiod):integer;overload;
//month for day one of the bidperiod
var
  a_date :tdatetime;
  a_month:string;
begin
  With Bidperiod do
  begin
    a_date:= BpDayToDatetime(56,bp);
    if FourWeek then
      if Week5 then a_date := a_date + 28;
    datetimetostring(a_month,'mm',a_date);
    result:=strtoint(a_month);
  end;
end;
//--------------------------------------------------------------------------

function DatetimeToBpDay(a_date:tdatetime;Bidperiod:TBidperiod):integer;overload;
// return a day number 1..56 from a datetime
// now considers overlap problems ?ie refers to actual bp
// dates prior to the commencement of the bp need to be trapped before thids function ?????
var
  a_bp,days:integer;

begin
  With Bidperiod do
  begin
    days:=trunc(a_date-dayone);{num of days since dayone 183}
    days:=(days mod 56)+1;{num of days into the BP}
    a_bp:= DatetimeToBp(a_date);

    result:=days ;//(a_bp - Bidperiod.Bp) * 56;
    if Bidperiod.FourWeek then
      if result > 28 then result := result - 28;

    if a_bp < Bidperiod.Bp then result := -1;//date precedes bp
  end;
end;
//-------------------------------------------------------------------------------
function DatetimeToBp(a_date:tdatetime;Bidperiod:TBidperiod):integer;overload;

var
  a_bp:integer;

begin
  With Bidperiod do
  begin
   a_bp :=trunc(a_date-dayone);//{num of days since dayone 183}
   result:=(a_bp div 56)+182;{BP}

   { for present numerical bp values can only refer to an 8 week bidperiod
     as in TBidperiod
    if FourWeek then
     if ( days > 28 ) then
       result := (result * 10) + 5
       else
       result := result * 10;}
   end;
end;
//-------------------------------------------------------------------------------
function BpDateRange(Bidperiod:TBidperiod):string;overload;
// return a string containing a date range for the bp
var
  first_day,last_day:tdatetime;
  from,too:string;
begin
  With Bidperiod do
  begin
   last_day:= BpDayToDatetime(56,bp);// last  "    "
   if FourWeek then
     if not Week5 then
      last_day:= BpDayToDatetime(28,bp);

    result:='';// default incase of errors
    first_day:= BpDayToDatetime(1,Bidperiod); //first day of bp
    datetimetostring(from,'ddd dd mmm',first_day);// format for display
    datetimetostring(too,'ddd dd mmm',last_day);// combine for display
    result:= from + '  to  '+ too;
  end
end;
//-------------------------------------------------------------------------------
function DayOfBp(const week,day:integer;Bidperiod:TBidperiod):integer;overload;
//used by crewinfo to convert the start day to a number 1..56
// input a week,
// overloaded version might never be called
begin
  if day <1 then// day can be more thna 56 for overlap
    result:=0
   else
    result:=((week-1)*7)+ day;//mon=1 tue 2 etc
end;

//--------------------------------------------------------------------------

function DayAsDatetime(const week,day:integer;Bidperiod:TBidperiod):string;overload;
//used by crewinfo to convert the start day of a trip to tdatetime number
// input a week day and bidperiod
var
 day_num:integer;
 a_date:tdatetime;
begin
  With Bidperiod do
  begin
    day_num:=((week-1)*7)+ day;//mon=1 tue 2 etc
    a_date := dayone +((bp - init_bp)*56) + day_num -1;
    if FourWeek then
      if Week5 then a_date := a_date + 28;
    datetimetostring(result,'ddd dd mmm',a_date);
  end;
end;

//-------------------------------------------------------------------------

function InitCalendar(Bidperiod:TBidperiod):tdatetime;overload;

begin
  With Bidperiod do
  begin
    result    := dayone + ((bp - init_bp)* 56);
    if FourWeek then
      if Week5 then
        result:= 28 + dayone+((bp - init_bp)* 56);
   end;
end;
{------------------------------------------------------------------------------}
function DateToBp(a_date:tdatetime;Bidperiod:TBidperiod):string;overload;
//return bp for a datetime
var
  a_bp,a_day:integer;

begin
  a_bp:=trunc(a_date-dayone);//num of days since dayone 183
  a_day:=(a_bp mod 56)+1;{num of days into the BP}
  a_bp:=(a_bp div 56)+init_bp;
  result:= inttostr(a_bp);

  if Bidperiod.FourWeek then
    if a_day > 28 then
     result:= result + '5'
   else
     result:= result + '1';

end;
//------------------------------------------------------------------------------
function DateToBpWeek(a_date:tdatetime;Bidperiod:TBidperiod):string;overload;
//return the bp week for a date time
var
  a_bp,a_week,a_day:integer;


begin
  a_bp:=trunc(a_date-dayone);//num of days since dayone 183
  a_day:=(a_bp mod 56)+1;{num of days into the BP}
  a_week:=((a_day-1) div 7)+1;{num of days into the week}
  if Bidperiod.FourWeek then
    if a_week > 4 then a_week := a_week - 4;

  result:=inttostr(a_week);
end;
//------------------------------------------------------------------------------
function DateToBpday(a_date:tdatetime;Bidperiod:TBidperiod):string;overload;
var
  a_bp,a_day:integer;

begin
  a_bp  := trunc(a_date-dayone);//num of days since dayone 183
  a_day := (a_bp mod 56)+1;{num of days into the BP}

  if Bidperiod.FourWeek then
   if a_day > 28 then  a_day := a_day -28;

  result := inttostr(a_day);
end;
//------------------------------------------------------------------------------
function DaysToBidsClose(Bidperiod:TBidperiod):integer;overload;
var
   convert:string ;
   a_bp,a_day,a_pos:integer;
begin

  convert:=floattostr(now-dayone);
  a_pos:=pos('.',convert);
  convert:=copy(convert,1,a_pos-1);   // this works where just strtoint did not ???

  a_bp := strtoint(convert);{num of days since dayone 183}
  a_day:= (a_bp mod 56)+1;  {num of days into the BP}

  With Bidperiod do
  begin
    if FourWeek then
    begin
      if a_day > 28 then a_day := a_day - 28;
      if a_day > 0 then
        result:=(17 - a_day)
      else
        result := 0;
    end
    else
    begin
      if a_day > 0 then
       result := 43 - a_day
       else
        result := 0;
    end;
  end;
end;
//-------------------------------------------------------------------------------
function Previous_bp(Bidperiod:TBidperiod):string;
begin
  if Bidperiod.FourWeek then
  begin
    if (copy(Bidperiod.Name,4,1) = '5') then
      result := copy(Bidperiod.Name,1,3) + '1'
      else
      result := inttostr(Bidperiod.bp -1) + '5';
  end
  else // 8 week
  begin
    result := inttostr(Bidperiod.bp -1)
  end;
end;
// -----------------------------------------------------------------------------
function Previous_bp(Bidperiod:integer):integer;
var
 bp_str:string;

 begin
  bp_str := inttostr(Bidperiod);
  if length(bp_str) = 4 then
  begin
    if copy(Bp_str,4,1) = '5' then
      result := strtoint(copy(Bp_str,1,3) + '1')
      else
      result := strtoint(inttostr(Bidperiod -1) + '5');
  end
  else // 8 week
  begin
    result := (Bidperiod -1)
  end;
end;

// -----------------------------------------------------------------------------
function DDMMDate(date:TDatetime):string;
var
  day,mth:string;
begin
  day := format('%2d',[  dayof(date)]);
  mth := format('%2d',[Monthof(date)]);
  result := day + '\' + mth;
end;
// -----------------------------------------------------------------------------
function HHMMToDateTime(hhmm:string):TDateTime;
var
  Hour,Min,Sec,MSec:word;
begin
  Hour := strtoint(copy(hhmm,1,2));
  Min  := strtoint(copy(hhmm,3,2));
  Sec  := 0;
  MSec := 0;
  result := EncodeTime(Hour,Min,Sec,MSec);
end;
// -----------------------------------------------------------------------------

(*function Next_bp(aBidperiod:string):string;
var
  bp_num:integer;
begin
  bp_num := strtoint(aBidperiod);
  if length(aBidperiod) = 4 then
  begin
    if copy(aBidperiod,1,4) = '1' then
      result := copy(aBidperiod,1,3) + '5'
      else
      result := inttostr(bp_num + 1) + '1';
  end
  else // 8 week
  begin
    result := inttostr(bp_num + 1)
  end;
end;
*)
// -----------------------------------------------------------------------------

{ TBpDay }
//This class reads initial values to fill the fields required to define a day ina a bp

(*
constructor TBpDay.Create(aDate: TdateTime);
var
  len:integer;
begin
  inherited create;
  FDate:= ADate;

  FBp.Bp := DatetimeToBp(FDate);
  FBp.Name := inttostr(FBp.Bp);
  leFBp.Length := length(FBp.Name);
  FBp.FourWeek := ( FBp.Length = 4);
  FBp.Week5 := Week5(FBp.Name);

  FDayNumber := DatetimeToBpDay(FDate,FBp);
  FWeek      := strtoint(DateToBpWeek(Fdate,Fbp));
  FDay       := FDayNumber mod 7;
   if FDay = 0 then Fday := 7;

end;
*)

constructor TBpDay.Create(BP: TBidperiod; aDayNumber: integer);
begin
  inherited create;
  FBp := BP;
  FDayNumber := aDayNumber;
  FDate:= BpDayToDatetime(FDayNumber,FBp);
  FWeek:= strtoint(DateToBpWeek(Fdate,Fbp));
  FDay       := FDayNumber mod 7;
   if FDay = 0 then Fday := 7;
end;

destructor TBpDay.destroy;
begin
  free;
end;
//------------------------------------------------------------------------------
function StringToDateTime(a_date:string):TDateTime;
//08JUN2009 14:00 to datetime
var
  day,month,year:integer;
  mth:string;
begin
  day := strtoint(copy(a_date,1,2));
  year := strtoint(copy(a_date,6,4));
  mth := copy(a_date,3,3);
  if mth = 'JAN' then month :=  1;
  if mth = 'FEB' then month :=  2;
  if mth = 'MAR' then month :=  3;
  if mth = 'APR' then month :=  4;
  if mth = 'MAY' then month :=  5;
  if mth = 'JUN' then month :=  6;
  if mth = 'JUL' then month :=  7;
  if mth = 'AUG' then month :=  8;
  if mth = 'SEP' then month :=  9;
  if mth = 'OCT' then month :=  10;
  if mth = 'NOV' then month :=  11;
  if mth = 'DEC' then month :=  12;
  Result := EncodeDateTime(year,month,day,0,0,0,0);
end;
//------------------------------------------------------------------------------
end.
