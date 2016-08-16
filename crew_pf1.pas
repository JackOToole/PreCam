unit crew_pf1;

interface

uses
  sysutils,classes,dialogs,{awards_pf1}pat_pf2,dates,{sorting,}
  {Crewdata,}my_strings{,user};


//   procedure get_patterns_for_port(port:string;a_date:tdatetime;var search_patterns:tstringlist);
//   procedure get_pattern_for_flight(fltno,from:string;a_date:tdatetime;var result:string);
//   procedure get_awards_ex_syd(search_patterns,search_awards:tstringlist);
//   procedure get_patterns_ex_syd(a_date:tdatetime ;var search_patterns:tstringlist);
//   procedure get_crew_ex_syd(search_awards,search_crews:Tstringlist);
//   procedure format_ex_syd_crew(var a_crew:string);
//   function get_award_fltno(const a_pattern,a_week:string):string;
//   function get_award_pattern(const a_pattern,a_week:string):string;

//   procedure get_pattern_line(const index,a_size:integer;var a_filename:string;var patternline:tstringlist);
//   function on_duty(day_number:integer;a_seniority,a_rank:string):boolean;
//   function get_crew(const award,my_rank:string):string;
//   procedure pattern_line_header(line_list:tstringlist;const index,a_size:integer;var my_rank,a_filename:string);
   procedure sort_awards_by_date(awards_list:tstringlist);
   procedure get_pattern_data(pattern_name:string;pattern_data,stick_data:tstringlist);
   procedure get_short_pattern_data(pattern_name:string;var pattern_data:string);
//   procedure pattern_display(pattern_data,stick_data:tstringlist;const week,a_size:integer);
//   procedure pattern_line(awards_list,unlisted_patterns,line_list:tstringlist;const my_rank:string;a_size:integer);
//   procedure get_awards(const index:integer;awards_list,unlisted_patterns:tstringlist);
//   function patternline_holder(a_rank,a_sen:string):boolean;
   procedure load_awards_file(const bidperiod,data_path:string;var result:boolean);
   procedure crew_startup;//(const techcrew_file,a_bidperiod:string);
   procedure crew_shutdown;
   procedure crew_refresh;
   // functions not using patterns data
//  procedure format_crew(a_crew,times:string;var pat_crew:tstringlist);
//  procedure  strlist_to_richtext(astringlist:tstringlist;var a_stream:tmemorystream;a_size:integer);
//  procedure  file_to_stream(astringlist:tstringlist;var a_stream:tmemorystream);
 {*********************************************************************}
var //exported variables to crew main etc

  crew_bp:string;//string value for a bid period
  crewbp:integer;// integer value for the current bid period

implementation

var
  list,list_index,seniority_index:tstringlist;
  awards,awards_index,patterns,stick:tstringlist;


//------------------------------------------------------------------------

// *************  INTERNAL FUNCTIONS  ****************************
// valid pattern(a_pattern)boolean check for an existing pattern
//function initialise_calendar(cal_list);fill calendar dates for current bp
//procedure calendar_add_trip(pattern_data,cal_list:tstringlist); calendar info for each trip
//function depart_day(const first,last:integer):integer; for a given slipport
//function slip_port_arr_day(const first,last:integer):integer;return the arrival day at a slip port ie days into a pattern.
//function port_dep_day(first,last:integer):integer;return the number of days away into a pattern which is the represented
{----------------------------------------------------------------------}
function valid_pattern(a_Pattern:string):boolean;
//to help identifyremove invalid patterns found in the awards file
var
index:integer;
begin
  result:=false;
  for index:=0 to patterns.count-1 do begin
    if copy(patterns[index],1,4) = a_pattern then begin
      result:=true;
      break;
    end;
  end;
end;
//-----------------------------------------------------------------------------
procedure initialise_calendar(cal_list:tstringlist);
// set initial values for calendar dd/mm d

var
   year,month,day:word;
   index,a_day,depart_day,week:integer;//
   a_date:string;
   a_bp_day:tdatetime;

begin
{
  //[0] is a place holder only and not read into final calendar display
  cal_list.add(nl);

  //initialise calendar
  a_bp_day:=bp_day_to_datetime(1,crewbp)-1;
  for index:= 0 to 55 do begin
    a_bp_day:=a_bp_day+1;
    a_day:=dayofweek(a_bp_day-1);
    decodedate(a_bp_day,year,month,day);
    a_date:=format('%2.2d/%2.2d',[day,month]);
    a_date:= a_date+ '  '+ copy('MTWTFSS',a_Day,1);
    cal_list.add(nl + a_date );
    end;
 }
end;
//       ******************************************

procedure calendar_add_trip(pattern_data,cal_list:tstringlist;week:integer);
//add trip info to pattern ie pattern name days away
var
  index,days,first_day,last_day,overlap_days:integer;
  a_pattern,a_line:string;

begin
  overlap_days:=0;//default value

  days:=strtoint(days_away(pattern_data[0]));
  a_pattern:=name(pattern_data[0]);
  first_day:=departure_day_as_number(pattern_data[0]);
  first_day:=first_day+(week-1)*7;
  last_day:=first_day + days -1;
  if last_day > 56 then begin
   overlap_days:=last_day-56;
   last_day:= 56;//overlap
   end;
  for index:= first_day to last_day do begin
   a_line:=cal_list[index];
   a_line:=a_line+' ' +a_pattern;
   cal_list[index]:=a_line;
   end;
  if overlap_days > 0 then begin
    a_line:=copy(cal_list[56],1,13);
    a_line:=a_line + ' '+  a_pattern;//inttostr(overlap)+'  ';
    cal_list[56]:=a_line;
    a_line:='\par ';
    a_line:=a_line + '  Carry Out ' + inttostr(overlap_days) + ' Days   MCO Credits '+
              overlap_hours(week,pattern_data[0]);
    cal_list.add(a_line);
    end;
end;

//        *******************************************
procedure format_calendar(cal_list:tstringlist);
// format calendar for display
var
  index,row:integer;
  a_list:tstringlist;
  a_line,a_day:string;
begin
  a_list:=tstringlist.create;
  a_list.add(nl);
  a_list.add(nl+ '  Date     Duty    Date     Duty    Date     Duty    Date     Duty');

  //read cal info and re write lines for calendar display
  for index:= 1 to 14 do begin
    a_line:=nl + '  ';//'\par ';
    for row:= 0 to 3 do begin
      if length(cal_list[(row * 14) + index ]) = 13 then// no pattern
      a_day:=copy(cal_list[(row * 14) + index ],6,8)+ '         '
      else
      a_day:=copy(cal_list[(row * 14) + index ],6,14)+ '    ';
      a_line:=a_line + a_day;
    end;
    a_list.add(a_line);
  end;
  if cal_list.count = 58 then a_list.add(cal_list[57]);//overlap info
  cal_list.assign(a_list);
  a_list.free;
end;
//  ******************************************

function slip_port_transit(const last:integer):integer;
//transit days, arrival and departure inclusive, minimum must be 1

var
  e_minutes,e_days,before_mn,after_mn:integer;
begin
  e_minutes:=0;e_days:=1;before_mn:=0;after_mn:=0;
  // to initialise e_minutes to represent transit
  e_minutes:= hours_to_min(transit_time(patterns[last]))+ 90;//consider transit to departure time not report time

   //   before midnight | transit days | after midnight

  before_mn:= (24*60)-  hours_to_min(arrival_time(patterns[last]));//arrival time + standown 30min
  after_mn:= hours_to_min(departure_time(patterns[last+1]));//arrival time + standown 30min

  if before_mn < e_minutes then
    begin
     e_minutes:=e_minutes - before_mn;// transit beyond midnight day one
     if after_mn <= e_minutes then
       begin
       e_minutes:= e_minutes - after_mn;// departure day compoment of departure day
       e_days:= 2 + e_minutes div (60 * 24);
       end;
    end;

   result:=e_days;
end;

//    ***********************************************

function slip_port_arr_day(const first,last:integer):integer;
//return the arrival day at a slip port ie days into a pattern.
//first = start of pattern ; last = arrival at slip port
// slip in syd would produce an error todo

var
  num_days,first_day,count,transit,dep_day,arr_day:integer;

  begin
   num_days:=0;transit:=0;
   first_day:=departure_day_as_number(patterns[first]) ;
   for count:= first  to last  do
     begin
       if transit <> 0 then num_days:=(num_days+transit-1);//add days from the transit
       transit:= slip_port_transit(count);//inclusive days in transit
       dep_day:= departure_day_as_number(patterns[count + 1]);// day of departue for next line of pattern
       if dep_day < transit then//== ???
         arr_day:= (dep_day + 7) - (transit - 1 )
        else
         arr_day:= (dep_day) - (transit - 1 );

       if (arr_day < first_day) and ( abs(arr_day - first_day) > 2) then// trip moves into next week
         num_days:= num_days + (arr_day + 7 - first_day)
        else
         num_days:= num_days + (arr_day - first_day);
         //days in the pattern as a result of the flight

       first_day:=dep_day; //allows for Int DateLine and time change
     end;
   result:=num_days;
end;

//    ******************************************

function port_dep_day(first,last:integer):integer;
//return the number of days away into a pattern which is the represented
// by the departure sector @ last in the patterns stringlist;
//first day of pattern is day 1, result ok with 7 day slips
var
  num_days,first_day,count,transit,dep_day,arr_day:integer;

  begin
   num_days:=1;transit:=0;
   first_day:=departure_day_as_number(patterns[first]) ;
   for count:=first  to (last -1)  do
     begin
       transit:= slip_port_transit(count);//days in transit

       // day of departue for next line of pattern
       dep_day:= departure_day_as_number(patterns[count + 1]);
       if dep_day < transit then//transit moves into next week
         arr_day:= (dep_day + 7) - (transit - 1 )
        else
         arr_day:= (dep_day) - (transit - 1 );
       //arr day day pattern arrived regardless of dateline midnight

       //num_days is the number of days a line adds to the trip lenght
       //ie operating day plus transit
       if arr_day < first_day then// trip moves into next week from dep day
         num_days:= num_days + (arr_day + 7 - first_day)
        else
         num_days:= num_days + (arr_day - first_day);


       num_days:=num_days+(transit - 1);//next departure
       first_day:=dep_day; //reset to view next line of pattern
     end;
   result:=num_days;
end;
//----------------------------------------------------------------------------------------

function fe_award(awards_data:string):string;
//uses awards_index to look up pattern , reduce pattern number by 1
//add pilot seniority numbers to the fe award data
var
  pattern,crew:string;
  index,number:integer;
begin
  pattern:=copy(awards_data,1,2);
  number:=strtoint(copy(awards_data,3,2))-1;
  pattern:=pattern + format('%2.2d',[number]) + copy(awards_data,5,1);//pattern and week

   index:=awards_index.indexof(pattern);
   if index= -1 then
     result:=awards_data
    else
     result:=copy(awards_data,1,6)+copy(awards[index],7,12)+
           copy(awards_data,19,11);

end;
//------------------------------------------------------------------------------
function pilot_award(awards_data:string):string;
// required for 747 to add engineer  to crew
var
  pattern,crew:string;
  index,number:integer;
begin
    pattern:=copy(awards_data,1,2);
    number:=strtoint(copy(awards_data,3,2))+1;//+1 to move to engineer pattern
    pattern:=pattern + format('%2.2d',[number]) + copy(awards_data,5,1);// pattern and week

   index:=awards_index.indexof(pattern);
   if index= -1 then
     result:= awards_data
    else
     result:=copy(awards_data,1,18)+copy(awards[index],19,11);



end;
//------------------------------------------------------------------------------

function cpt(const award:string):string;
var
 index:integer;
 sen:string;

begin
{
 sen:=copy(award,7,4);
 if sen = '   0' then
    result:=''
   else
    begin
    sen:=sen+'CPT';//rank redundant as it has been included in the techcrew file
    index:=index_to_seniority(sen);
    if index=-1 then
     begin
       // todo message invalid seniority
       result:='';
       exit;
     end;

    result:= crew_name(index);
    end;
    }
end;

{----------------------------------------------------------------------}

function fo(const award:string):string;
var
 index:integer;
 sen,a_crew:string;

begin
{
 sen:=copy(award,11,4);
 if sen = '   0' then
    result:=''
   else
    begin
    sen:=sen+'F/O';
    index:=index_to_seniority(sen);
    if index=-1 then
      begin
        result:='';
        exit;
      end;
    a_crew:=get_name_data(index);
    result:= crew_name(index);
    end;
}
end;

{----------------------------------------------------------------------}

function so(const award:string):string;
var
 index:integer;
 sen,a_crew:string;

begin
{
 sen:=copy(award,15,4);
 if sen = '   0' then
    result:=''
   else
    begin
    sen:=sen+'S/O';
    index:=index_to_seniority(sen);
    if index=-1 then
    begin
      result:='';
      exit;
    end;
    a_crew:=get_name_data(index);
    result:= crew_name(index);
    end;
   }
end;

{----------------------------------------------------------------------}

function fe(const award:string):string;
var
 index:integer;
 sen,a_crew:string;

begin
{
 sen:=copy(award,19,4);
 if sen = '   0' then
    result:=''
   else
    begin
    sen:=sen+'F/E';
    index:=index_to_seniority(sen);
    if index=-1 then
        begin
          result:='';
          exit;
        end;
    a_crew:= get_name_data(index);
    result:= crew_name(index);
    end;
 }
end;

//-----------------------------------------------------------------------------
//      *********** EXTERNAL FUNCTIONS  ******************
//-----------------------------------------------------------------------------
function on_duty(day_number:integer;a_seniority,a_rank:string):boolean;
//determine if a crew member is on duty on a given bp day
var
  pattern_name,pattern_data:string;
  index,week,days,first,last:integer;
begin
{
  result:=false;
  for index:= 0 to awards.count-1 do begin
    // check for rank and seniority for a mate
    if my_trip(awards[index],a_rank,a_seniority) then //true if a trip for that rank and seniority
       begin
        pattern_name:=copy(awards[index],1,4);
        week:=strtoint(copy(awards[index],5,1));
        get_short_pattern_data(pattern_name,pattern_data);
        if pattern_data <> '' then // NOT A PUBLISHED pattern
        begin
          days:=strtoint(days_away(pattern_data));
          first:=departure_day_as_number(pattern_data);
          first:=first + (week-1) * 7;
          last:= first + days -1;
          if (first <= day_number) and (day_number <= last) then result :=true;
        end;
       end;
  end;
}
end;
//-----------------------------------------------------------------------------
{
procedure  get_patterns_for_port(port:string;a_date:tdatetime;var search_patterns:tstringlist);
//fill a list of patterns that match slip in the values for port and a_date
 var
   index,first,count,week,search_day,a_len,a_bp:integer;
   a_weeks,search_result,arr_date,dep_date:string  ;
   arrival,departure,depart_weekday:integer;
   arr,dep:tdatetime;

 begin
 search_day:=datetime_to_bp_day(a_date,crewbp);//1..56 of search
 if search_day > 56  then
  search_patterns.add('This date shows only overlap trips, see current bidperiod for more names.');

 first:=0;//start of first pattern must be 0
 arrival:=0;departure:=0;


  for index:= 0 to patterns.count-1 do
    begin
      if (index<>0) and (name(patterns[index])<>name(patterns[index-1])) then
        first:=index;//track start of each pattern
      if (slip_Port(patterns[index]) = port) then //matching port transit >8:00
        begin
          //deparure_date
          depart_weekday:=departure_day_as_number(patterns[first]);//mon=1 tue=2 wed=3 etc
          arrival:= slip_port_arr_day(first,index)  ;//day for arrival at slip port 0 based
          departure:= arrival + slip_port_transit(index)-1;// arrival day of pattern at slip port


          //check weeks operating for a match
          a_weeks:=weeks(patterns[index]);
          a_weeks:=numbers_only(a_weeks);
          a_len:=length(a_weeks);
          for count:= 1 to a_len do
            begin
              week:=strtoint(copy(a_weeks,count,1));
              week:=(week-1)*7; //ie days
              week:=week+depart_weekday;//mon=1 tue=2 wed=3 etc
              week:=week;//day 0
              if ((week+arrival) <= search_day ) and
                 ((week+departure) >= search_day) then
                   begin
                     arr:=bp_day_to_datetime(week+arrival,crewbp);
                     dep:=bp_day_to_datetime(week+departure,crewbp);
                     arr_date:=datetostr(arr);
                     dep_date:=datetostr(dep);
                     search_result:=name(patterns[index])+ copy(a_weeks,count,1);
                     search_result:=search_result+ alpha_num_only(flt_number(patterns[index]))
                                     + ' ' + arr_date+' '+arrival_time(patterns[index])+chr(9);
                     search_result:=search_result+ alpha_num_only(flt_number(patterns[index+1]))
                                     + ' ' + dep_date+' '+departure_time(patterns[index+1]);
                     search_patterns.add(search_result);
                   end;
            end;
        end;
    end;
  end;
//-----------------------------------------------------------------------------
procedure get_patterns_ex_syd(a_date:tdatetime ;var search_patterns:tstringlist);

//fill a list of patterns that depart syd on a given date
 var
   index,a_day,day_number:integer;
   a_week:string;



begin
// read date as a bidperiod day
  day_number := datetime_to_bp_day(a_date,crewbp);//1..56 of search
  a_day := day_number mod 7;
   if a_day = 0 then
   begin
     a_day := 7;
     a_week:= copy('12345678',(day_number div 7) ,1);
   end
   else
     a_week:= copy('12345678',(day_number div 7) + 1,1);

  for index:= 1 to patterns.count-1 do
    begin
      if (name(patterns[index])<>name(patterns[index-1])) then
        if not fe_pattern(patterns[index]) then// fe patterns are picked up with the pilots
          if departure_day_as_number(patterns[index]) = a_day then // week day
            if pos(a_week,weeks(patterns[index])) <> 0 then //check weeks operating for a match
              search_patterns.add(name(patterns[index])+ a_week);
    end;
end;
//-----------------------------------------------------------------------------
 procedure get_pattern_for_flight(fltno,from:string;a_date:tdatetime;var result:string);
// may be more than one pattern or overlap trip??
 var
   index,first,count,num_of_day,week,
     search_day,a_len:integer;
   a_sector,from_port:string  ;
 begin
 first:=0;
 result:='';

 //check for valid bidperiod
  if crewbp > datetime_to_bp(a_date) then begin //previous bp
    // a warning would be more useful here
    result:='';
    messagedlg('Dates precedes current Bid Period data.',mtinformation,[mbok],0);
    exit;
    end;

 //   pattern_for_flight(fltno,from,a_date)
  for index:= 0 to patterns.count-1 do
    begin
      if (index<>0) and (name(patterns[index])<>name(patterns[index-1])) then
        first:=index;//track start of each pattern
      if numbers_only(flt_number(patterns[index])) = fltno then //matching fltno
        begin
          // to pick up transit sectors from port = sydbne from sydbnesin
          // that is remove space and last three letters
          from_port:= sectors(patterns[index]);//
          from_port:=letters_only(from_port);
          a_len:=length(from_port);
          if a_len > 3 then
            from_port:=copy(from_port,1,a_len-3);

          if pos(from,from_port)<> 0  then //matches departure port
            begin
              num_of_day:=port_dep_day(first,index);//  todo fix this mess  !!!!!+ slip_port_transit(index) -1;//how far into pattern fltno occurrs
              search_day:=datetime_to_bp_day(a_date,crewbp);//1..56 57 58 etc of search
              search_day:=(search_day - (num_of_day-1));//1..56 departure day for pattern
              week:=((search_day-1) div 7);
              search_day:=search_day-(week *7);
              week:=week+1;
              if (departure_day_as_number(patterns[first])= search_day) and
                (pos( inttostr(week) , weeks(patterns[first]) )<>0 ) then
                  begin
                    result:=result+name(patterns[index])+'.'+inttostr(week);
                    //may be more than one crew
                  end;
            end;
        end;
    end;
 end;
//-----------------------------------------------------------------------------
function get_award_pattern(const a_pattern,a_week:string):string;
// finds a pattern and week combination
// for 747 combines pilot engineer into a single award
var
  an_award:string;
  index:integer;
begin
    index:=awards_index.indexof(a_pattern+a_week);
    if index=-1 then// unable to match pattern and week request
      begin
       result:='';
       exit;
      end
     else
      an_award:=awards[index];

  if copy(an_award,27,3)='747' then//combine pilot and fe award
    begin
     if copy(an_award,23,4)='0001' then    //    my_rank ='F/E' then
       result:=fe_award(an_award)
      else
       result:=pilot_award(an_award);
     end
    else
     result:=awards[index];
end;
//------------------------------------------------------------------------------
function get_award_fltno(const a_pattern,a_week:string):string;
// finds the award for a pattern and week
var
  an_award:string;
  index:integer;
begin
    index:=awards_index.indexof(a_pattern+a_week);
    if index=-1 then// unable to match pattern and week request
      begin
       result:='';
       exit;
      end
     else
      result:=awards[index];

end;
//---------------------------------------------------------------
procedure get_pattern_line(const index,a_size:integer;var a_filename:string;var patternline:tstringlist);
// this is the  main procedure for building a pattern line
//  using an index to the crewlist to find a pattern line
var
  awards_list,line_list,unlisted_patterns:tstringlist;
  msg,crew_data,my_rank:string;

begin
  my_rank:='None';
  awards_list:=tstringlist.create;
  line_list:=tstringlist.create;
  unlisted_patterns:=tstringlist.create;
  unlisted_patterns.Sorted := true;

   //add name and BP details to pattern line
  pattern_line_header(line_list,index,a_size,my_rank,a_filename);

  if my_rank = 'None' then//check for valid rank info
    begin
    messagedlg('Error finding rank. ',mtinformation,[mbok],0);
    exit;
    end;
  patternline.addstrings(line_list);
  line_list.clear;


  //locate patterns awarded to the index
  get_awards(index,awards_list,unlisted_patterns);//retrieve line from the awards files for each awarded pattern
  if(awards_list.count = 0 ) and (unlisted_patterns.Count = 0 )then
   begin
     crew_data:=get_name_data(index);
     msg:=initials(crew_data)+' '+surname(crew_data);
     msg:='No patterns allocated to '+ msg;

     messagedlg(msg,mtinformation,[mbok],0);
     patternline.clear;
     awards_list.free;
     line_list.free;
     unlisted_patterns.Free;
     exit;
   end;

  sort_awards_by_date(awards_list);//list by date

  pattern_line(awards_list,unlisted_patterns,line_list,my_rank,a_size);//create display
  patternline.addstrings(line_list);//add to memo

  //clean up
  awards_list.free;
  line_list.free;
  unlisted_patterns.Free;
end;

//----------------------------------------------------------------------


 function get_crew(const award,my_rank:string):string;

//use a line from awards fileto extract crew names except for my_rank
var
 a_line:string ;


begin
 if my_rank='CPT' then
    a_line:=' '+fo(award)+so(award)+fe(award);
 if my_rank='F/O' then
    a_line:=' '+cpt(award)+so(award)+fe(award);
 if my_rank='S/O' then
    a_line:=' '+cpt(award)+fo(award)+fe(award);
 if my_rank='F/E' then
    a_line:=' '+cpt(award)+fo(award)+so(award);
 if my_rank='None' then
    a_line:=' '+cpt(award)+ fo(award)+ so(award) + fe(award);
 result:= a_line;
end;
{----------------------------------------------------------------------}
{
 procedure pattern_line_header(line_list:tstringlist;const index,a_size:integer;var my_rank,a_filename:string);
//index is an index to the crewlist
 var
  a_line:string;
  crew_data,my_sen,a_fontsize:string;

  begin
    crew_data:=get_name_data(index);
    my_sen:=seniority(crew_data);
    my_rank:=rank(crew_data);
    a_fontsize:='\fs'+inttostr(a_size*2)+' ';

    a_filename:='Pattern Line '+initials(crew_data)+' '+surname(crew_data)+' '+ crew_bp;
    line_list.add(nl + bold + col_blue + ' ' + crew_bp);
    a_line:=nl + my_rank +' '+ christian_name(crew_data)+' '+ surname(crew_data);
    line_list.add(a_line +col_black);

 end;
//------------------------------------------------------------------------
 }
 procedure sort_awards_by_date(awards_list:tstringlist);

 var
  sorted_awards:tstringlist ;
  a_date:tdatetime;
  index,week,day,first,count,a_len,award_order:integer;
  pattern_name,pattern_date:string;

 begin
  sorted_awards:=tstringlist.create;
  sorted_awards.sorted:=true;
  for index:= 0 to awards_list.count-1 do
  begin

    begin
      pattern_name:=copy(awards_list[index],1,4);
      week:=strtoint(copy(awards_list[index],6,1));
      award_order:=index;
      //day
      first:=0;
      for count:= patterns.count-1 downto 0 do
      begin
        if copy(patterns.strings[count],1,4) = pattern_name then
        begin
          first:=count;
          day:= departure_day_as_number(patterns[first]);
          pattern_date:=format('%2.2d',[day_of_bp(week,day)]);
          sorted_awards.add(pattern_date + awards_list[award_order]);
          break;
        end;
      end;
    end;
  end;
  //remove dates
  a_len:=length(sorted_awards[0]);
  sorted_awards.sorted:=false;

  for index:= 0 to sorted_awards.count-1 do
   begin
    sorted_awards[index]:=copy(sorted_awards[index],3,a_len-2);
   end;

   //assign to awards_list
   awards_list.clear;
   awards_list.assign(sorted_awards) ;
 end;
//------------------------------------------------------------------------
{
procedure pattern_display(pattern_data,stick_data:tstringlist;const week,a_size:integer);
 // builds text for the patterns in a pattern line
var
  num_lines,index,first,last:integer;
  depart_day,arr_day:integer;
  a_line,heading1,heading2,summary,pat_line,
    departure_date,arrival_date,fs:string;
  result:tstringlist;

begin
  result:=tstringlist.create;
  num_lines:=pattern_data.count;
  index:=0;
  first:=0;last:=num_lines-1;
  fs:='\fs'+inttostr(a_size*2)+' ';

  //get depature date
  depart_day:=departure_day_as_number(pattern_data[first]);
  departure_date:=day_as_datetime(week,depart_day,crewbp);
  // add days away to get arrival date
  arr_day:=depart_day + strtoint(days_away(pattern_data[first]))-1;
  arrival_date:=day_as_datetime(week,arr_day,crewbp);

  {heading}
//may need a blank line
 {   result.add(nl+'\plain' + fs);
    a_line:=(nl +ul+col_blue + '  '+ copy(pattern_data.strings[first],1,4) + '  '+ departure_date + '   Report '+report_time(pattern_data[first])+'      Arrive '+ arrival_date +
             '  at '+ arrival_time(pattern_data[last]));
    result.add(a_line);
    if sort_transport(pattern_data) then
      result.add(nl + '\plain'+ fs + col_black + '  Home Transport')
     else
      result.add(nl + '\plain' + fs + col_black);

    result.add(nl +'  Flt No   Sectors            Depart  Arr   Duty  Stick  ADP  Transit');




    num_lines:=pattern_data.count;
    for index:=first to  last do
       begin
       pat_line:=nl+'  '+flt_number(pattern_data.strings[index]);{fltno function formats result}
  (*     pat_line:=pat_line +' '+format_sectors(pattern_data[index]);{sectors}
       pat_line:=pat_line +' '+ departure_day(pattern_data.strings[index]);{departure day}
       pat_line:=pat_line +' '+ departure_time(pattern_data.strings[index]);{departure time}
       pat_line:=pat_line +' '+ arrival_time(pattern_data.strings[index]);{arrival time}
       pat_line:=pat_line +' '+ duty_time(pattern_data.strings[index]);
       pat_line:=pat_line +' '+ stick_day(stick_data.strings[index]);
       pat_line:=pat_line +' '+ adp_day(stick_data.strings[index]);
       pat_line:=pat_line +' '+ transit_time(pattern_data.strings[index]);
       result.add(pat_line);
       end;
     result.add(nl);

    {summary}
    summary:=nl+ '  Credits '+credits_time(pattern_data.strings[first]);
    //crew,adp,transport
    if adp_trip(stick_data[first])<>'  :  ' then
       summary:=summary+'   ADP: '+adp_trip(stick_data[first]);
    summary:=summary+'   Stick Hours: '+stick_trip(stick_data[first]);
//    summary:=summary+'   MBT: '+mbt(pattern_data,stick_data);
    result.add(summary);
    //MCO credits
    if overlap(week,pattern_data[first]) then
      result.add(nl + '  MCO Credits: '+ overlap_hours(week,pattern_data[first]));

    pattern_data.assign(result);
    result.free;
 end;
 {_________________________________________________________________________}
    *)
 procedure get_pattern_data(pattern_name:string;pattern_data,stick_data:tstringlist);

 var
  index,first,last:integer ;
  a_pattern,next_pattern:string;

 begin
   first:=0;
   for index:= patterns.count-1 downto 0 do
     begin
     if copy(patterns.strings[index],1,4) = pattern_name then
       begin
        first:=index;
        break;
       end;
     end;

   if first = 0 then exit; // no matcihing pattern found;

   a_pattern:=copy(patterns[first],1,4);
   next_pattern:=a_pattern;
   index:=first;

   while ( a_pattern=next_pattern) and (  index > 0 {< patterns.count} ) do
     begin
     pattern_data.Insert(0,patterns[index]);
     stick_data.Insert(0,stick[index]);
     index:=index -1;
     if index > 0 {< patterns.count} then
        begin
        a_pattern:=next_pattern;
        next_pattern:=copy(patterns[index],1,4);
        end;

     end;
  end;
//-----------------------------------------------------------------------
procedure get_short_pattern_data(pattern_name:string;var pattern_data:string);
//return the pattern data for the first line of a pattern
 var
  index,first,last:integer ;
  a_pattern,next_pattern:string;

 begin
   for index:= 0 to patterns.count-1  do begin
     if copy(patterns.strings[index],1,4) = pattern_name then begin
        pattern_data:=patterns[index];
        break;
        end;
   end;
 end;
//-------------------------------------------------------------------------
(*
procedure pattern_line(awards_list,unlisted_patterns,line_list:tstringlist;const my_rank:string;a_size:integer);

// pass awards list and then generate pattern line for those awards
// awards list = name then blank line then awarded patterns
// line_list contains the resulting pattern line info
// bj o'toole
//
//fg01.1
//fg02.2 etc
var
 index,week:integer;
 pattern,fs:string;
 pattern_data,stick_data,cal_list:tstringlist;

begin
   pattern_data:=tstringlist.create;
   stick_data:=tstringlist.create;
   cal_list:=tstringlist.create;
   fs:='\fs'+inttostr(a_size*2)+' ';

   //initialise caledar
   initialise_calendar(cal_list);

   for index:=0 to awards_list.count-1 do
      begin
      pattern:=copy(awards_list[index],1,4);
      week:=strtoint(copy(awards_list[index],5,1));
      get_pattern_data(pattern,pattern_data,stick_data);
      calendar_add_trip(pattern_data,cal_list,week);
      pattern_display(pattern_data,stick_data,week,a_size);
      line_list.addstrings(pattern_data);
      line_list.add(nl + ' '+ get_crew(awards_list[index],my_rank));
      line_list.add(nl + '\plain' + fs + '                        .............');
      pattern_data.clear;
      stick_data.clear;
      end;

   line_list.add('\par }');
   format_calendar(cal_list);
   if unlisted_patterns.Count <> 0 then
     for index  := 0 to unlisted_patterns.count - 1 do
       cal_list.add(nl + '  Pattern '+ unlisted_patterns[0] + ' is awarded on this line but no details are published in the Pattern Book. ');

   cal_list.addstrings(line_list);
   line_list.assign(cal_list);
   pattern_data.free;
   stick_data.free;
   cal_list.free;
end;

//-----------------------------------------------------------------------

procedure get_awards(const index:integer;awards_list,unlisted_patterns:tstringlist);
// uses the index from the crew list to locate crew
// search for sen no to find alloacted patterns

var
  count:integer;
  crew_data,a_line,a_sen,my_rank,an_award,
    award_data,a_pattern:string;

begin
  crew_data:=get_name_data(index);
  a_sen:=seniority(crew_data);
  my_rank:=rank(crew_data);

  //treat 747 seperately
  if aircraft(crew_data)= '747' then begin
    for count:=0 to awards.count-1 do begin
      if my_trip(awards[count],my_rank,a_sen) then begin
        a_pattern:=copy(awards[count],1,4);
        if valid_pattern(a_pattern) then begin
          if my_rank ='F/E' then
            an_award:=fe_award(awards[count])
            else
            an_award:=pilot_award(awards[count]);
          awards_list.add(an_award);
          end
          else
             unlisted_patterns.add(copy(awards[count],1,4) + '.' + copy(awards[count],5,1));
      end;
    end;
  end;
  //if not a 747
  if aircraft(crew_data)<> '747' then begin
      for count:=0 to awards.count-1 do begin
         if my_trip(awards[count],my_rank,a_sen) then begin
           a_pattern:=copy(awards[count],1,4);
           if valid_pattern(a_pattern) then
             awards_list.add(awards[count])
             else
             unlisted_patterns.add(copy(awards[count],1,4) + '.' + copy(awards[count],5,1));//             unlisted_patterns.add(awards[count]);
         end;
       end;
   end;
    if unlisted_patterns.Count > 0 then
    messagedlg(' An invalid pattern designator exists in the awards file. '+
     ' This may represent a pattern on your line which BidBook is unable to display.',
       mtwarning,[mbok],0);
end;
 //-----------------------------------------------------------------------------
 function patternline_holder(a_rank,a_sen:string):boolean;
var
  count:integer;
begin
  result:=false;
  for count:=0 to awards.count-1 do begin
    if my_trip(awards.strings[count],a_rank,a_sen) then begin
      result:=true;
      exit;
    end;
  end;
end;

 //-----------------------------------------------------------------------------
 *)
 procedure load_awards_file(const bidperiod,data_path:string;var result:boolean);
// use bp to check for an awards file and load into awards (stringlist)
//'ADD012   0   0   0   01110744'
// bp= '.184'
var
  awards_file,patterns_file,stick_file,a_dir,a_file:string;
  bp,index:integer;
  sl:Tstringlist;
begin
  bp:=strtoint(bidperiod);
  result:=true;
  sl := tStringlist.create;

  patterns_file:=data_path + '\patterns.'+ bidperiod;
  stick_file   :=data_path + '\stick.'+bidperiod;

  if ( fileexists(patterns_file) and fileexists(stick_file) )then
  begin
    patterns.loadfromfile(patterns_file);
    stick.loadfromfile(stick_file);
    if fileexists(patterns_file + '1') then
      begin
        patterns_file := Patterns_file + '1';
        stick_file   := Stick_file   + '1';
      end;
      if fileexists(patterns_file + '5') then
      begin
        patterns_file := Patterns_file + '5';
        stick_file   := Stick_file   + '5';
      end;
      sl.LoadFromFile(patterns_file);
      patterns.AddStrings(sl);
      sl.LoadFromFile(stick_file);
      stick.AddStrings(sl);
   end
   else
    result := false; //messagedlg('No '+patterns_file+' found.',mtinformation,[mbok],0);
  sl.Free;
end;
//---------------------------------------------------------------------------
{-------------------------------------------------------------------------}
procedure crew_startup;//(const techcrew_file,a_bidperiod:string);
//'None is passed when no file or an invalid file name is passed this allows the creation
// of the data stringlists, otherwise a fatal error occurs when a valid file is selected.
begin
   stick:=tstringlist.create;
   awards:=tstringlist.create;
   awards_index:=tstringlist.create;
   patterns:=tstringlist.create;

{   crewdata_startup(techcrew_file,crew_bp);
   if techcrew_file <>'None' then begin
      crew_bp:=copy(a_bidperiod,2,4);
      crewbp:=strtoint(crew_bp);
     end;
 }
end;

{------------------------------------------------------------------------}
procedure crew_shutdown;
begin
  stick.free;
  awards.free;
  awards_index.free;
  patterns.free;
//  crewdata_shutdown;
end;
{------------------------------------------------------------------------}

//todo this should be a class function
procedure crew_refresh;
begin
awards.clear;
awards_index.clear;
patterns.clear;
stick.clear;
end;
//------------------------------------------------------------------------------
{
procedure format_crew(a_crew,times:string;var pat_crew:tstringlist);
// add spaces to line up crew
var
  a_len,a_pos,start,finish:integer;
  a_rank:string;

begin
  a_len:=length(a_crew);
  start:=1;
  for a_pos:=1 to a_len do
    begin
      if copy(a_crew,a_pos,2)='  ' then// end of a rank
        begin
          finish:=a_pos;
          a_rank:=add_spaces(31,copy(a_crew,start,finish-start));
          pat_crew.add(a_rank+times);
          start:=a_pos+1;
        end;
    end;
end;
}
  {------------------------------------------------------------------------}
(*
procedure  strlist_to_richtext(astringlist:tstringlist;var a_stream:tmemorystream;a_size:integer);
// used to load a  plain file ie no carriage return
var
  index:integer;
  strlist:tstringlist;
begin
  strlist:=tstringlist.create;

// header to rich text
  richtext_header(strlist,a_size);
  strlist.add('\par ');
  for index:= 0 to astringlist.count-1 do
    strlist.add('\par '+ astringlist[index]);//
  strlist.add('\par }');

  strlist.savetostream(a_stream);
  a_stream.Position:=0;
  strlist.free;
end;

//------------------------------------------------------------------------------
procedure  file_to_stream(astringlist:tstringlist;var a_stream:tmemorystream);
// load a file saved by bidbook
// create a rt file  in a stream

begin
  astringlist.savetostream(a_stream);
  a_stream.Position:=0;
end;

//------------------------------------------------------------------------------
procedure get_awards_ex_syd(search_patterns,search_awards:tstringlist);
var
  i:integer;
  a_award:string;
begin
  for i := 0 to search_patterns.count - 1 do
    begin
      a_award := get_award_pattern(copy(search_patterns[i],1,4),copy(search_patterns[i],5,1));
      if (copy(a_award,26,1)= '1') then
        a_award:=a_award+'fe';
      search_awards.add(a_award);
    end;
end;

(*          *****************************          *)
(*
procedure get_crew_ex_syd(search_awards,search_crews:Tstringlist);
var
 i:integer;
 pattern_data,Pattern_name,report,a_crew:string;
begin
  for i := 0 to search_awards.count - 1 do
    begin
      Pattern_name := copy(search_awards[i],1,4);
      get_short_pattern_data(Pattern_name,Pattern_data);
      Report := Report_time(pattern_data);
      a_crew := ( report + get_crew(search_awards[i],'None'));
      format_ex_syd_crew(a_crew);
      search_crews.add(a_crew);
    end;
end;
//               ********************
procedure format_ex_syd_crew(var a_crew:string);
var
  a_len,a_pos,start,finish:integer;
  a_rank,result:string;

begin
  a_len:=length(a_crew);
  result := copy(a_crew,1,5) +'  ';
  a_crew := copy(a_crew,6,length(a_crew) - 5);
  start:=1;
  for a_pos:=1 to a_len do
    begin
      if copy(a_crew,a_pos,2)='  ' then// end of a rank
        begin
          finish := a_pos;
          a_rank := add_spaces(21,copy(a_crew,start,finish-start));
          result := result + a_rank + ' ';
          start  := a_pos+1;
        end;
    end;
  a_crew := result;
end;

(*          *****************************          *)

end.
