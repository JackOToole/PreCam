unit Pat_pf2;
//support functions  ,  for pat_fp1
{PATTERNS.nnn - 76 Bytes.

1        10        20        30        40        50        60        70
1234567890123456789012345678901234567890123456789012345678901234567890123456
^--^^------^^^-----^^----------^^--^^-^^^^--^^--^^--^^--^^---^^--^^---^^---^
A   B       CD      E           F   G  H I   J   K   L   M    N   O    P

A Pattern Number                  J Engineer Report Time
B Weeks Operating                 K Local Departure Time
C Day of the Week (Note 1)        L Local Arrival Time
D Service Number (Note 2)         M Port Transit Time
E Sectors                         N Duty Period
F Crew Complement (Note 3)        O Pilot Credits
G Aircraft Type (Note 4)          P Engineer Credits
H Days Away
I Pilot Report Time

NOTE 1:  1=Mon, 2=Tue, 3=Wed etc.
NOTE 2:  QFAnnnn
NOTE 3:  1120 = 1xCpt,1xF/O,2xS/O,0xF/E.  0100 = 0xCpt,1xF/O,0xS/O,0xF/E etc.
NOTE 4:  744, 747, 767.
様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様
STICK.nnn - 66 Bytes.

1        10        20        30        40        50        60
123456789012345678901234567890123456789012345678901234567890123456
^--^^------^^^-----^^----------^^--^^-^^^^--^^---^^--^^--^^--^^--^
A   B       CD      E           F   G  H I   J    K   L   M   N

A Pattern Number                  J Pilot Credits
B Weeks Operating                 K Sector Stick Hours
C Day of the Week (Note 9)        L Sector Overtime
D Service Number (Note 10)        M Pattern Stick
E Sectors                         N Pattern Overtime
F Crew Complement (Note 11)
G Aircraft Type (Note 12)
H Days Away
I Sector Duty Time

NOTE 9 :  1=Mon, 2=Tue, 3=Wed etc.
NOTE 10:  QFAnnnn
NOTE 11:  1120 = 1xCpt,1xF/O,2xS/O,0xF/E.  0100 = 0xCpt,1xF/O,0xS/O,0xF/E etc.
NOTE 12:  744, 747, 767.
様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様
 }


interface

 uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
   Dialogs,MY_STRINGS;//,dates;

 procedure GetPatternDisplay(pattern_data,stick_data:tstringlist);

 function stick_day(stick_data:string):string;
 function stick(stick_data:string):string;// day value only
 function stick_trip(stick_data:string):string;
 function adp_day(stick_data:string):string;
 function adp_trip(stick_data:string):string;

 function name(a_pattern:string):string;
 function report_time(a_pattern:string):string;
 function days_away(a_pattern:string):string;
 function format_credits_day(credits:string;elt:integer):string;
 function format_cols_credits_day(credits:string;a_days:integer):string;
 function crew_complement(a_pattern :string):string;
 function rank_as_str(a_rank:integer):string;
 function weeks(a_pattern:string):string;
 function flt_number(a_pattern :string):string;
 function flt_number_as_number(a_pattern :string):integer;
 function format_sectors(a_pattern :string):string;
 function sectors(a_pattern:string):string;
 function departure_day(a_pattern:string):string;
 function departure_day_as_number(a_pattern:string):integer;
 function departure_time(a_pattern:string):string;
 function departure(a_pattern:string):string;
 function arrival_time(a_pattern:string):string;
 function arrival(a_pattern:string):string;
 function transit_time(a_pattern:string):string;
 function transit(a_pattern:string):string;
 function duty(a_pattern:string):string;
 function duty_time(a_pattern:string):string;
 function credits_time(a_pattern:string):string;
 function credits(a_pattern:string):string;
 function flight_credits(pattern_data,stick_data:tstringlist):integer;
 function trip_code(a_pattern:string):string;
 function fe_pattern(a_pattern:string):boolean;
 function mbt(pattern_data,stick_data:tstringlist):string;//calculate and display mbt
 function mbt_num(a_pattern:string):integer;//calculate and display mbt
 function thg( first,last:string):string;
 function elapsed_time_display( first,last:string):string;
 function elapsed_time( first,last:string):integer;
 function number_to_time(a_time:integer):string;// 1530 -> 15:30
 function slip_port(a_pattern:string):string;
 function arrival_day(depart_day:integer;a_pattern:string):integer;//1.. of trip
 function international_sector(a_pattern:string):boolean;//operating international sector
 function summary(pattern_data,stick_data:tstringlist;mdc:integer):tstringlist;
 function paxing_sector(a_pattern:string):boolean;// any paxing stage
 function pattern_gap(a_pattern:string):integer;// line building pattern gap

 function overlap_weeks(pattern_data:string):string;//string containing weeks for overlap ie '78' etc
 function overlap(const a_week:integer;pattern_data:string):boolean;//true for an overlap pattern
 function overlap_hours(const a_week:integer;pattern_data:string):string;//break down of hours for mco
 procedure overlap_credits_as_min(const a_week:integer;pattern_data:string;var min_in,min_out:integer);//value of overlap credits in min

 function dta(pattern_data:tstringlist):string;
 function get_route_code_patterns(rc_data:string):string;//a route code plus related patterns
 function density(a_pattern:string):integer;

 {*****************************************************}
implementation
//USES
 //SORTING;
//            ********* PRIVATE FUNCTIONS *************
// function hours_to_min(const hours :string):longint; minutes in hhhmm

// function departure(a_pattern):string; plain departure time
//------------------------------------------------------------------------------

 function minutes_to_hours(const minutes :longint):string;

 var
   hours,min:integer;
   a_min:string;
 begin

   hours:=minutes div 60;
   min:=minutes mod 60;

   if min=0 then
      a_min:=':00'
     else
      if min <10 then
        a_min:=':0'+inttostr(min)
       else
        a_min:=':'+inttostr(min);



   result:=format('%d',[hours])+a_min;
 end;
 //------------------------------------------------------------------------------
  {insert':' }
 procedure as_time( var a_time:string);
 var
   len,index:integer;

 begin
  insert(':',a_time,length(a_time)-1);
  if a_time = '00:00' then a_time:='     ';
 end;
 //------------------------------------------------------------------------------
{insert':' and remove leading zeros for transits and duty periods}
procedure as_short_time( var a_time:string);
 var
   len,index:integer;

 begin
   len:=length(a_time);
   index:=1;
   while copy(a_time,index,1)='0' do
     begin
      insert(' ',a_time,index);
      delete(a_time,index+1,1);
      index:=index+1;
     end;
  insert(':',a_time,length(a_time)-1);
 end;
 //------------------------------------------------------------------------------
function transit(a_pattern:string):string;
begin
  result:=copy(a_pattern,58 ,5);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
 //              ********  Public Functions  *********

 //-------------------------------------------------------------------------------
function name(a_pattern:string):string;
begin
  result:=copy(a_pattern,1,4);
end;
 //------------------------------------------------------------------------------
 function report_time(a_pattern:string):string;
var
 a_time:string;
begin
  a_time:=copy(a_pattern,42 ,4);
  as_time(a_time);
  result:=a_time;
end;
//------------------------------------------------------------------------------
 function stick_day(stick_data:string):string;
  var
    a_time:string;
  begin
    a_time:=stick(stick_data);
    as_short_time(a_time);
    if a_time='  :  'then a_time:='     ';
    result:=a_time;
  end;
//------------------------------------------------------------------------------
function stick(stick_data:string):string;
begin
  result:= copy(stick_data,51,4);
end;
//-----------------------------------------------------------------------------
 function stick_trip(stick_data:string):string;
 var
    a_time:string;

  begin
    a_time:=copy(stick_data,59,4);
    as_short_time(a_time);
    result:=a_time;
  end;
//------------------------------------------------------------------------------
 function adp_trip(stick_data:string):string;
  var
    a_time:string;
  begin
    a_time:=copy(stick_data,63,4);
    as_short_time(a_time);
    result:=a_time;
  end;
//------------------------------------------------------------------------------
  function adp_day(stick_data:string):string;
  var
    a_time:string;

  begin
    a_time:=copy(stick_data,55,4);
    as_short_time(a_time);
    if a_time='  :  'then a_time:='     ';
    result:=a_time;
  end;

 {______________________________________________________________________}

function days_away(a_pattern:string):string;
begin
 result:= (copy(a_pattern,40,2));
end;
 {----------------------------------------------------------------------}
 function format_credits_day(credits:string;elt:integer):string;
 //provides a work rate ie credits as a percentage of thg
 var
  credits_day:single;
  num_credits:integer;

begin

  num_credits:=hours_to_min(credits);
  credits_day:= 24 *(num_credits /elt)*100/6;
  result:=format('%5.1f',[credits_day]);
 //formated to nn.nn
end;
//------------------------------------------------------------------------------
 function format_cols_credits_day(credits:string;a_days:integer):string;
 //provides a work rate ie credits as a percentage of thg
 var
  credits_day:single;
  num_credits:integer;

begin

  num_credits:=hours_to_min(credits);
  credits_day:= num_credits /a_days;
  result:=format('%5.1f',[credits_day]);
 //formated to nn.nn
end;


//------------------------------------------------------------------------------

 function mbt(pattern_data,stick_data:tstringlist):string;//calculate and display mbt
//provide a display version of mbt
// flight credits removed due errors
var
  days,credits,mbt_days,mbt_credits,index:integer;
begin
  days:=strtoint(days_away(pattern_data[0]));
//  credits:=flight_credits(pattern_data,stick_data);
//  strtoint(numbers_only(credits_time(a_pattern)));

  //days away
  if days = 1 then begin
    result:='12 Hrs';
    exit;
    end;
  mbt_days:=1;// up to 4 days
  if days > 4 then mbt_days:=2;
  if days > 8 then mbt_days:=3;
  if days > 12 then mbt_days:=4;

  //credits
  {mbt_credits:=0;
  if credits > 1200 then mbt_credits :=2;
  if credits > 2400 then mbt_credits :=3;
  if credits > 3600 then mbt_credits :=4;}

  // result
//  if mbt_days > mbt_credits then
    if mbt_days = 1 then
      result:=inttostr(mbt_days)+' Night'//days away
     else
      result:=inttostr(mbt_days)+' Nights'

  // else
    {if mbt_credits = 1 then
      result:=inttostr(mbt_credits)+' Night'//credits
     else
      result:=inttostr(mbt_credits)+' Nights';}

  end;

 //-----------------------------------------------------------------------------
function mbt_num(a_pattern:string):integer;//calculate mbt
//provide mbt  as a number  flight credits removed due errors
var
  days,credits,mbt_days,mbt_credits:integer;
begin
  days:=strtoint(days_away(a_pattern));
//  credits:=strtoint(numbers_only(credits_time(a_pattern)));

  //days away
  if days = 1 then begin
    result:=0;// no full days ie'12 Hrs';
    exit;
    end;

  mbt_days:=1;// up to 4 days
  if days > 4 then mbt_days:=2;
  if days > 8 then mbt_days:=3;
  if days > 12 then mbt_days:=4;

  //credits
  {mbt_credits:=0;
  if credits > 2000 then mbt_credits :=2;
  if credits > 4000 then mbt_credits :=3;
  if credits > 6000 then mbt_credits :=4;
   }
  // result
//  if mbt_days > mbt_credits then
    result:=mbt_days
//   else
//    result:=mbt_credits;

  end;

 //-----------------------------------------------------------------------------

 function thg(first,last:string):string;

 var
   days,depart,arrive,elt:integer;

 begin
   days:=strtoint(copy(first,40,2));
   days:=days-1;
   depart:=hours_to_min(copy(first,42 ,4));
   arrive:=hours_to_min(copy(last,54 ,4))+30;
   elt:=days*24*60;
   if arrive > depart then
      elt:=elt+(arrive-depart)
     else
      elt:=elt-(depart-arrive);


   result:=minutes_to_hours(elt div 4);

 end;
 {________________________________________________________________________}

 function elapsed_time_display(first,last:string):string;
 begin
   result:=minutes_to_hours(elapsed_time(first,last));
 end;
 {________________________________________________________________________}
 function elapsed_time(first,last:string):integer;
 var
   days,depart,arrive,elt:integer;

 begin
   days:=strtoint(copy(first,40,2));
   days:=days-1;
   depart:=hours_to_min(copy(first,42 ,4));
   arrive:=hours_to_min(copy(last,54 ,4))+30;
   elt:=days*24*60;
   if arrive > depart then
      elt:=elt+(arrive-depart)
     else
      elt:=elt-(depart-arrive);
   result:=elt;
 end;
 {________________________________________________________________________}

 function transit_time(a_pattern:string):string;
var
 a_time:string;
begin
  a_time:=transit(a_pattern);
  as_short_time(a_time);
  result:=a_time;
 end;
 {________________________________________________________________________}
 function duty_time(a_pattern:string):string;
var
 a_time:string;
 begin
  a_time:=copy(a_pattern,63,4);
  as_short_time(a_time);
  result:=a_time;
 end;
 {________________________________________________________________________}
function duty(a_pattern:string):string;
begin
  result:=copy(a_pattern,63,4);
end;
//------------------------------------------------------------------------------
 function credits_time(a_pattern:string):string;
var
  a_time:string;
 begin
  a_time:=credits(a_pattern);
  as_short_time(a_time);
  result:=a_time;
 end;
 {________________________________________________________________________}
 function credits(a_pattern:string):string;
 begin
  result:=copy(a_pattern,67 ,5);
 end;
 {________________________________________________________________________}
function flight_credits(pattern_data,stick_data:tstringlist):integer;
// return the flight credits for a pattern in minutes
// 8:00 am = 480      8:00 pm = 1200  8 to midnight = 240
var
 index,flt_time,ngt,dep,day,credits:integer;

 function act_time:integer;
 // choose the correct pattern data line to use for dep info
 var
   num:integer;
 begin
   num:=index;

   // normal case
   if (hours_to_min(stick(stick_data[index])) <> 0 )  then num:=index;

   //op then pax
   if (hours_to_min(stick(stick_data[index])) = 0) then
      while (hours_to_min(stick(stick_data[num])) = 0) do inc(num);

   result:=hours_to_min(stick(stick_data[num]));
end;
 //         ****************************************
begin
 credits:=0;
 for index := 0  to pattern_data.count-1  do  begin
   ngt:=0; day:=0;ngt:=0;
   if paxing_sector(pattern_data[index]) then
    day:= hours_to_min(duty(pattern_data[index])) - 90//credits + 0
    else begin
    flt_time:=act_time;
    dep:=hours_to_min(departure(pattern_data[index]));

    // nite flights
    if (flt_time + dep) > 1440  then begin
       ngt:=(flt_time + dep) - 1200;
       if ngt > 720 then ngt := 720;
       end;
    // early
    if dep < 480 then
      if (flt_time + dep) > 1200 then begin
        ngt:= (flt_time + dep - 1200) + (480 - dep);
        end
        else begin
        ngt:=480 -dep;
        end
      else if (flt_time + dep) > 1200 then begin   // late
        ngt:= (flt_time + dep - 1200);
        end;
    day :=flt_time - ngt;
    ngt:=(ngt * 4) div 3;
    credits:= credits + day + ((ngt * 4) div 3);
   end;
 end;
  result:=credits;
end;
//------------------------------------------------------------------------------
function trip_code(a_pattern:string):string;
begin
  result:=copy(a_pattern,72,5);
  if result = '00000' then result:='';
end;
//------------------------------------------------------------------------------
 function arrival_time(a_pattern:string):string;
var
  a_time:string;
 begin
  a_time:=arrival(a_pattern);
  as_time(a_time);
  result:=a_time;
end;
 {___________________________________________________________________}
 function arrival(a_pattern:string):string;
 begin
  result:=copy(a_pattern,54 ,4);
 end;
 {___________________________________________________________________}

 function departure_day(a_pattern:string):string;
 var
   a_day,day_list:string;
   day_num:integer;

 begin
  a_day:=copy(a_pattern,13,1);
  day_list:='MonTueWedThuFriSatSun';
  day_num:=strtoint(a_day);
  day_num:=((day_num-1)*3)+1;
  result:=copy(day_list,day_num,3);

 end;

 {___________________________________________________________________}

function departure_day_as_number(a_pattern:string):integer;

//extract departure day ie mon=1 tue=2 as string and return integer
var
  a_day:string;
begin
 a_day:=copy(a_pattern,13,1);
 result:=strtoint(a_day);
end;

//-------------------------------------------------------------------------
function departure_time(a_pattern:string):string;
var
 a_time:string;
begin
  a_time:=departure(a_pattern);
  as_time(a_time);
  result:=a_time;

end;
//------------------------------------------------------------------------------
 function departure(a_pattern:string):string;
 begin
  result:=copy(a_pattern,50 ,4);
 end;
{_______________________________________________________________________}
 function format_sectors(a_pattern :string):string;
 var
    index,posn :integer;
    //a_sector:string;
 begin
    a_pattern:=copy(a_pattern,21,12);//extract sectors info
    index:=0;
    result:='';
    for index:= 0 to 3 do
       begin
       posn:=1+(index * 3);
       result:=result+' '+copy(a_pattern,posn,3);
       end;
 end;
//------------------------------------------------------------------------------
 function sectors(a_pattern:string):string;
begin
  result:=copy(a_pattern,21,12);

end;
 {____________________________________________________________________}

 function flt_number(a_pattern :string):string;
 var
   index:integer;
   a_fltno:string;
 begin
    index:=1;
    a_fltno:=copy(a_pattern,14,7);
    result:=copy(a_fltno,1,3);
    a_fltno:=copy(a_fltno,4,7);

    while copy(a_fltno,1,1)='0' do
       begin {remove leading zeros}
       index:=length(a_fltno);
       a_fltno:=copy(a_fltno,2,index-1);
       end;
       {pad out zeros}
       while length(a_fltno)< 4 do
          a_fltno:= ' '+a_fltno;

    result:=result+' '+a_fltno;
 end;
{_______________________________________________________________________}
 function flt_number_as_number(a_pattern :string):integer;
 begin
   result:=strtoint(numbers_only(flt_number(a_pattern)));
 end;
 //-----------------------------------------------------------------------------
function crew_complement(a_pattern :string):string;

{function exports the crew make up to pat_pf1
format is cfse as 1111 includes a leading space}
var
   index:integer;
   a_crew,crews:string;

begin
   a_crew:=copy(a_pattern,33,4);
   crews:='CptF/OS/OF/E';
   result:=' ';
   for index :=1 to 4 do
   begin
   if copy(a_crew,index,1)<>'0' then
      begin
      result:=result+copy(crews,((index-1)*3)+1,3)+',';
      end;
   end;
   {remove last ','}
   result:=copy(result,1,length(result)-1);
end;
{______________________________________________________________________}
 function rank_as_str(a_rank:integer):string;
 begin
 if a_rank = 0 then result:= 'CPT' ;
 if a_rank = 1 then result:= 'F/O';
 if a_rank = 2 then result:=  'S/O';
 if a_rank = 3 then result:=  'F/E';
 end;
 //-----------------------------------------------------------------------------
function weeks(a_pattern:string):string;
begin
  result:=copy(a_pattern,5,8);
end;
//----------------------------------------------------------------------------
function number_to_time(a_time:integer):string;
// take an integer time from patterns info and conver to a string
// 1530 = 15:30
var
  times:string;
begin
  times:=inttostr(a_time);
  as_time(times);
  result:=times;

end;
//-----------------------------------------------------------------------------
 function slip_port(a_pattern:string):string;
 //return the slip port for a line in pat_list
 // return '' if less than 8 hours
 var
   a_len,a_transit:integer;
   ports:string;
 begin
   ports:=letters_only(sectors(a_pattern));//ports no spaces
   a_len:=length(ports);
   if a_len>2 then
     begin
      slip_port:=copy(ports,a_len-2,3);
      a_transit:=strtoint(transit(a_pattern));
      if a_transit < 800 then slip_port:='';
     end
    else
     slip_port:='';
   end;
 //-----------------------------------------------------------------------------
function arrival_day(depart_day:integer;a_pattern:string):integer;
// how far into pattern arrival at slip port
var
  a_transit,a_departure:longint;
  days:integer;

begin
  a_transit:=hours_to_min(transit(a_pattern));
  a_departure:=hours_to_min(departure(a_pattern));//ie min after midnight
  a_transit:=a_transit-a_departure;
  days:=a_transit div (24*60);//whole days
  if a_transit mod (24*60) <> 0 then days:=days+1;//add a day for part day
  arrival_day:=depart_day-days;// days inclusive

end;
//------------------------------------------------------------------------------
 function international_sector(a_pattern:string):boolean;
// checks a line of data to a fltnumber <400 and not from a domestic port
 var
   oz_ports,a_sector,departure_port:string;

begin
  oz_ports:= 'MEL,SYD,BNE,CNS,TSV,DRW,PER,ADL,PAX';
  a_sector:=sectors(a_pattern);
  departure_port:=copy(a_sector,1,3);
  if (pos(departure_port,oz_ports) = 0) and //not paxing or domestic
    (strtoint(numbers_only(flt_number(a_pattern))) < 400) then
     result:=true
    else
     result:=false;
end;
//------------------------------------------------------------------------------
function summary(pattern_data,stick_data:tstringlist;mdc:integer):tstringlist;
// use pattern data and stick data to return the pattern summary info
// this function creates an instance of the summary $list
// the calling procedure must free the created object
// neat hey!
var
  pattern_first,pattern_last,stick_first,a_line,a_tab,overlaps,work_rate,a_credit:string;
  len,index,week,elt:integer;
  a_space:char;

begin
  summary:=tstringlist.create;
  a_tab:=#9;
  a_space:=' ';
  pattern_first:=pattern_data[0];
  pattern_last:=pattern_data[pattern_data.count-1];
  stick_first:=stick_data[0];

(*  // line 0
  if sort_transport(pattern_data) then
      a_Line:=a_Line + a_tab + ' Home Transport';
   summary.add(a_line);
  *)

  //first line elt, stick, adp
  a_line:='\par  '+ pad_str_right(13,a_space,'Elapsed Time')  +   pad_str_left(10,a_space,elapsed_time_display(pattern_first,pattern_last));
  a_line:= a_line + a_tab + pad_str_right(11,a_space,'Stick Hours') + a_tab + pad_str_left(11,a_space,stick_trip(stick_first));
  if adp_trip(stick_first)<>'  :  ' then
     a_line:=a_line + '   ' + pad_str_right(8,a_space,'ADP')+   pad_str_left(6,a_space,adp_trip(stick_first));
  summary.add(a_line);

  //second line thg credits, MDC, Credits
  a_line :='\par  '+ pad_str_right(13,a_space,'T.H.G.') +   pad_str_left(10,a_space,THG(pattern_first,pattern_last));
  a_line := a_line +  a_tab + pad_str_right(11,a_space,'MDC (' + min_to_hours(mdc) + ')');
  a_line := a_line +  a_tab + pad_str_left(11,a_space,min_to_hours( mdc *  strtoint(days_away(pattern_first))));
  a_line :=a_line + '   ' +  pad_str_right(8,a_space,'Credits ') + pad_str_left(6,a_space,credits_time(pattern_first));

  summary.add(a_line);

  //density, work rate
  a_line:='\par  '+ pad_str_right(13,a_space,'Density')  +   pad_str_left(10,a_space,min_to_hours(density(pattern_first)));
  //work rate info
  elt:=elapsed_time(pattern_first,pattern_last);
  a_credit:=credits(pattern_first);
  work_rate:=format_credits_day(a_credit,elt);//result hh.hh
  work_rate:=copy(work_rate,1,length(work_rate)-2);
  a_line:=  a_line + a_tab + pad_str_right(11,a_space,'WorkRate') + a_tab + pad_str_left(11,a_space,work_rate + '% THG');
  summary.add(a_line);

  // overlap MCO credits
  overlaps:= overlap_weeks(pattern_first);
  if (overlaps <> '' ) then begin
    summary.add('\par  ');
    len:=length(overlaps);
    for index:= 1 to len do begin//for each week that an overlap occurs
      a_line:='\par  MCO Credits    ' + a_tab {+ a_tab};
      week:= strtoint(copy(overlaps,index,1));
      a_line:=a_line + 'Week ' + copy(overlaps,index,1) + '  '
              + overlap_hours(week,pattern_first);
      summary.add(a_line);
      end;
    end;


 end;
//------------------------------------------------------------------------------
 function paxing_sector(a_pattern:string):boolean;// any paxing stage
// reports true if the line of a pattern contains "PAX"
var
 a_sectors:string;
begin
 a_sectors:=sectors(a_pattern);
 if pos('PAX',a_sectors)<> 0 then// contains a pax sector
   result:=true
  else
   result:=false;
 end;
 //____________________________________________________________________
function pattern_gap(a_pattern:string):integer;// line building pattern gap
var
  a_mbt:integer;
begin
 result:=strtoint(days_away(a_pattern)) div 2;
 a_mbt:=mbt_num(a_pattern);
 if result = 0 then result := 1;
 if result < a_mbt then result:= a_mbt;
end;
//----------------------------------------------------------------------------
function overlap_weeks(pattern_data:string):string;
//determine weeks for overlaps
var
 a_week,dep_day,a_days_away,len,index:integer;
 a_weeks:string;
begin
 result:='';
 a_days_away:=strtoint(days_away(pattern_data));
 dep_day:=departure_day_as_number(pattern_data);

 a_weeks:=numbers_only(weeks(pattern_data));
 len:=length(a_weeks);
 for index:= 1 to len do begin //check each week for an overlap
   a_week:=strtoint(copy(a_weeks,index,1));
   if ( a_week - 1 )*7 + dep_day -1  + a_days_away > 56 then
     result:=result + inttostr(a_week);
   end;
 result:=numbers_only(result);

end;
//_____________________________________________________________________
function overlap(const a_week:integer;pattern_data:string):boolean;
//returns true if the trip incurs an overlap
var
 dep_day,a_days_away,len,index:integer;

begin
 result:=false;
 a_days_away:=strtoint(days_away(pattern_data));
 dep_day:=departure_day_as_number(pattern_data);

 //check for an overlap
 if ( a_week - 1 )* 7 + dep_day -1  + a_days_away > 56 then
     result:=true;

end;
//_____________________________________________________________________
function overlap_hours(const a_week:integer;pattern_data:string):string;
  //return a brake down of the MCO hours for an overlap trip
  var
   min_before,min_after,mins:longint;
   days,days_before,days_after,dep_day:integer;
   hours_before,hours_after:string;
  begin
   mins:=hours_to_min(credits(pattern_data));//total credits in minutes
   days:=strtoint(days_away(pattern_data));//days in pattern
   dep_day:=departure_day_as_number(pattern_data);//departure weekday mon = 1
   days_before:= 57 - ((a_week - 1) * 7) - dep_day;//or 56 and departure -1
   days_after:= days - days_before;
   min_before:=( mins * days_before )div  days;
   if (( mins * days_before ) mod  days) * 2  >= days then//decide wether to run up or not
     min_before:=min_before + 1;// nice routine for round up
   min_after:= mins - min_before;
   hours_before:=min_to_hours(min_before);//convert to hh:mm format
   hours_after:=min_to_hours(min_after);
   result:=hours_before +' (' + hours_after  + ')';

  end;
//--------------------------------------------------------------------------
 procedure overlap_credits_as_min(const a_week:integer;pattern_data:string;var min_in,min_out:integer);
 //value of overlap credits in min
   var
   mins:longint;
   days,days_before,days_after,dep_day:integer;
   hours_before,hours_after:string;
  begin
   mins:=hours_to_min(credits(pattern_data));//total credits in minutes
   days:=strtoint(days_away(pattern_data));//days in pattern
   dep_day:=departure_day_as_number(pattern_data);//departure weekday mon = 1
   days_before:= 57 - ((a_week - 1) * 7) - dep_day;//or 56 and departure -1
   days_after:= days - days_before;
   min_in:=( mins * days_before )div  days;
   if (( mins * days_before ) mod  days) * 2  >= days then//decide weather to round up or not
     min_in:=min_in + 1;// nice routine for round up
   min_out:= mins - min_in;
  end;
//--------------------------------------------------------------------------
function dta(pattern_data:tstringlist):string;
//function not inuse until rules can be established
// a display string containing odta and adta info
{   function domestic_port(a_port:string):boolean;
   begin
     if pos(a_port,'SYD,MEL,BNE,OOL,TSV,CNS,DRW,PER,ADL,HBA') = 0 THEN
     result := false
     else result:= true;
   end;

   function slipport(a_pattern:string):string;
   var
     a_port:string;
   begin
     a_port:='';
     a_port:=letters_only(sectors(a_pattern));
     slipport:=copy(a_port,length(a_port)-2,3);
   end;

   function transit_days(a_pattern:string):integer;
   var
     num_days:integer;
   begin
     if duty(a_pattern)= '0000' then begin
       result:=0;
       exit;
       end
       else begin
       num_days := hours_to_min(transit(a_pattern)) div (60*24);
       if num_days > 1 then
        result:= 1 + num_days
        else
        result:=1;
       end;
     end;

var
  index,odta,adta,num_days:integer;}


begin
{  adta:=0;odta:=0;
  if days_away(pattern_data[0])<> '01' then begin
     num_days:=strtoint(days_away(pattern_data[0]));
     for index:= 0 to pattern_data.count-2 do
       if domestic_port(slipport(pattern_data[index])) then
          adta:=adta + transit_days(pattern_data[index]);
     odta:=(num_days-1)-adta;
     end
    else  begin
     dta:='';
     exit;
     end;

  result:='ODTA: '+inttostr(odta) + '   ADTA: '+inttostr(adta)}
end;
//--------------------------------------------------------------------------
function get_route_code_patterns(rc_data:string):string;
//CPT-B747SIN05KS01     0000265859KS03     0000265861KS05     0000265863KS07     0000265865KS09     0000265867
// result CNS01AE01AE02AE03AE04
VAR
  rc,pat:string;
  len,index:integer;
begin
  rc:= copy(rc_data,13,5);
  result:=rc;
  pat:=copy(rc_data,18,length(rc_data)-13);
  len:=length(pat);
  for index:= 0 to ((len div 19 )-1) do begin
    result:=result + copy(pat,(index*19)+1,4)
    end;
end;
//------------------------------------------------------------------------------
function density(a_pattern:string):integer;
// density for a pattern in minutes
var
  Pdays_away,count, d_hours,d_days,P_gap:integer;


begin
   Pdays_away := strtoint(days_away(a_pattern));
   P_gap :=  pattern_gap(a_pattern);
   d_hours := hours_to_min(credits(a_pattern));
   d_days := Pdays_away + P_gap;
   result:= d_hours  div d_days;
end;
//    ******************************************
function fe_pattern(a_pattern:string):boolean;

begin
  result := (copy(a_pattern,36,1) = '1');
end;

(*          *****************************          *)

procedure getpatterndisplay(pattern_data,stick_data:tstringlist);

var
  num_lines,index,first,last:integer;
  a_line,pat_line,a_fontsize,a_rating:string;
  result,a_summary:tstringlist;

 begin
    result:=tstringlist.create;
    num_lines:=pattern_data.count;
    first:=0;last:=num_lines-1;


    a_line:=' '+ name(pattern_data[first]); {pattern name}
    a_line:=a_line+'  Weeks:'+ weeks(pattern_data[first]);
    a_line:=a_line+'  Crew:'+ crew_complement(pattern_data.strings[first]);{crew complement}
    a_line:=a_line+'  Days Away:'+days_away(pattern_data.strings[first]);
    result.add(a_line);
//    result.add('');
    result.add('  Flt No   Sectors            Depart  Arr   Stick  ADP  Duty Transit');

//    num_lines:=pattern_data.count;
    for index:=first to  last do
       begin
       pat_line:='  '+ flt_number(pattern_data.strings[index]);{fltno function formats result}
       pat_line:=pat_line + format_sectors(pattern_data[index]);{sectors}
       pat_line:=pat_line +' '+ departure_day(pattern_data.strings[index]);{departure day}
       pat_line:=pat_line +' '+ departure_time(pattern_data.strings[index]);{departure time}
       pat_line:=pat_line +' '+ arrival_time(pattern_data.strings[index]);{arrival time}
       pat_line:=pat_line +' '+ stick_day(stick_data[index]);//stick hours
       pat_line:=pat_line +' '+ adp_day(stick_data[index]); //adp
       pat_line:=pat_line +' '+ duty_time(pattern_data.strings[index]);
       pat_line:=pat_line +' '+ transit_time(pattern_data.strings[index]);
       result.add(pat_line );
       end;



    {summary}
{    a_summary:=summary(pattern_data,stick_data);
    result.addstrings(a_summary);
    a_summary.free;//will this work??
 }
    result.add('');
    pattern_data.assign(result);
    result.free;


 end;
//------------------------------------------------------------------------------

 end.
