unit my_strings;

interface

uses windows,sysutils,shellapi,wintypes,classes;
//  Windows,Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
//  StdCtrls, ExtCtrls;//

type
  TJOStringlist = class(TStringlist)
  public
    procedure GetStrings(var alist:Tstringlist;start, finish: integer);
    function Equals(sl:TStringlist):boolean;
  end;

function convert_to_date(var a_date:string):tdatetime;
procedure richtext_header(strlist:tstringlist;a_size:integer);

function executefile (const pfilename:string;showcmd:integer):thandle;

procedure file_remove_ext(var a_file:string);
procedure file_add_ext(var a_file:string;const ext:string);
function get_file_extension(a_filename:string):string;
function is_techcrew_file(a_filename:string):boolean;
function is_patterns_file(a_filename:string):boolean;

function numbers_only(a_str:string):string;
function letters_only(const a_str:string):string;
function remove_letters(const a_str:string):string;
function removeAmpersand(const a_str:string):string;
function no_dupes(const a_str:string):string;
function is_number(a_str:string):boolean;
function alpha_num_only(const a_str:string):string;
function add_spaces(a_len:integer;a_str:string):string;
function pad_left(a_len:integer;a_char:char;a_str:string):string;
function pad_Str_left(a_len:integer;a_char:char;a_str:string):string;
function pad_right(a_len:integer;a_char:char;a_str:string):string;
function pad_str_right(a_len:integer;a_char:char;a_str:string):string;
function containsStr(substr,str:string):boolean;

function RunWithParameters(const fn,params:string):boolean;//32
function hours_to_min(hours :string):longint;//format hhhmm
function min_to_hours(mins:integer):string;
function ShortReportStr(a_str:string):string;

procedure reset_int_array(var arr:array of integer);// zero all elements of the array

function RedText(a_str:string):string;
function BlueText(a_str:string):string;
function GreenText(a_str:string):string;

const

  website = 'http://members.optusnet.com.au/jackotool/' ;
  email   = 'jackotool@optusnet.com.au' ;



//RICH CONTROL CONSTANTS
  rt_info_1 = '{\rtf1\ansi\deff0\deftab720{\fonttbl{\f0\fmodern Courier New;}{\f2\froman\fcharset2 Symbol;}}';
  rt_info_2 = '{\colortbl\red0\green0\blue0;\red255\green0\blue0;\red0\green255\blue0;\red0\green0\blue255;}';
  rt_info_3 = '\deflang1033\pard\plain\f0\fs16';
  col_blue = '\cf3';
  col_red = '\cf1';
  col_green = '\cf2';
  col_black ='\cf0';
  fontsize = '\fO\fs17';
  nl = '\par ';
  end_rt = '\par }';
  bold = '\b';
  ul = '\ul';
  plain = '\plain';


  tab = #9;
  LF = #10;
  CR = #13;
  CRLF = #13 + #10;
  days_of_the_bp =  'MTWTFSSMTWTFSSMTWTFSSMTWTFSSMTWTFSSMTWTFSSMTWTFSSMTWTFSS';
  weeks_of_the_bp = '   1      2      3      4      5      6      7      8   ';

 implementation
//------------------------------------------------------------------------------
function convert_to_date(var a_date:string):tdatetime;
// attempt to convert a user string to a date string
var
 a_len,a_pos:integer;
 a_day,a_month,a_year:string;
 yy,mm,dd:word;

begin
  a_len:=length(a_date);
  decodedate(now,yy,mm,dd);
  a_day:=inttostr(dd);//default values
  a_month:=inttostr(mm);
  a_year:=inttostr(yy);
 //day
 for a_pos:= 1 to a_len do
   if not is_number(copy(a_date,a_pos,1)) then
     begin
     a_day:=copy(a_date,1,a_pos-1);
     dd:=strtoint(a_day);
     break;
     end;

 //month
   if a_len > 2 then
     begin
     a_date:=copy(a_date,a_pos+1,a_len-(a_len-a_pos));
     a_len:=length(a_date);
     for a_pos:= 1 to a_len do
       if not is_number(copy(a_date,a_pos,1)) then
       begin
       a_day:=copy(a_date,1,a_pos-1);
       dd:=strtoint(a_day);
       break;
     end;
     end
    else
     begin
     result:=encodedate(yy,mm,dd);
     exit;
     end;

     result:=encodedate(yy,mm,dd);
end;
 //-----------------------------------------------------------------------------
procedure richtext_header(strlist:tstringlist;a_size:integer);
// procedure to return a stringlist to be used to start any rich text display
var
  a_fontsize:string;
begin
  a_fontsize:='\fs'+inttostr(a_size*2)+' ';
  strlist.add(rt_info_1);
  strlist.add(rt_info_2);
  strlist.add(rt_info_3 + col_blue + a_fontsize);
end;
//-----------------------------------------------------------------------------
function add_spaces(a_len:integer;a_str:string):string;
//add trailing spaces, to set length to a_len
var
  num_spaces,index:integer;
  pad:string;
begin
  pad:='';
  if length(a_str)< a_len then
    begin
      num_spaces:=a_len-length(a_str);
      for index:=1 to num_spaces do pad:=pad+' ';
    end;
  result:=a_str+pad;
end;
//_-----------------------------------------------------------------------------
function pad_left(a_len:integer;a_char:char;a_str:string):string;
//pad a numbers only string with leading spaces to a_len
var
  num_spaces,index:integer;
  pad:string;
begin
  a_str:=numbers_only(a_str);
  pad:='';
  if length(a_str)< a_len then
    begin
      num_spaces:=a_len-length(a_str);
      for index:=1 to num_spaces  do pad:=pad + a_char;// addition of at least one character
    end;
  result:=pad + a_str;
end;

//_-----------------------------------------------------------------------------
function pad_Str_left(a_len:integer;a_char:char;a_str:string):string;
//pad a string with leading spaces to a_len
var
  num_spaces,index:integer;
  pad:string;
begin
  pad:='';
  if length(a_str)< a_len then
    begin
      num_spaces:=a_len-length(a_str);
      for index:=1 to num_spaces  do pad:=pad + a_char;// addition of at least one character
    end;
  result:=pad + a_str;
end;

//_-----------------------------------------------------------------------------

function pad_right(a_len:integer;a_char:char;a_str:string):string;
//pad a string with leading spaces to a_len
var
  num_spaces,index:integer;
  pad:string;
begin
  a_str:=numbers_only(a_str);
  pad:='';
  if length(a_str)< a_len then
    begin
      num_spaces:=a_len-length(a_str);
      for index:=1 to num_spaces  do pad:=pad + a_char;// addition of at least one character
    end;
  result:= a_str + pad;
end;

//_-----------------------------------------------------------------------------
function pad_str_right(a_len:integer;a_char:char;a_str:string):string;
//pad a string with leading spaces to a_len
var
  num_spaces,index:integer;
  pad:string;
begin
  pad:='';
  if length(a_str)< a_len then
    begin
      num_spaces:=a_len-length(a_str);
      for index:=1 to num_spaces  do pad:=pad + a_char;// addition of at least one character
    end;
  result:= a_str + pad;
end;

//_-----------------------------------------------------------------------------


function executefile (const pfilename:string;showcmd:integer):thandle;
var
  filename:array[0..255] of char;
begin
   if length(pfilename)> 255 then
    begin
      result:=0;
      exit;
    end
   else
      Result:=WinExec(strpcopy(filename,pfilename),showcmd);

end;
//-------------------------------------------------------------------------------
procedure file_remove_ext(var a_file:string);
//remove the extension
var
  period:integer;
begin
  period:=pos('.',a_file);
  if period <> 0 then
    a_file:=copy(a_file,1,period-1);
end;
//-------------------------------------------------------------------------------
procedure file_add_ext(var a_file:string; const ext:string);
// add a given extension to a file name
var
  af:string;
begin
  //remove any existing exstension
  af:=a_file;
  file_remove_ext(af);
  a_file:= af + '.'+ ext;
end;
//-------------------------------------------------------------------------------
function get_file_extension(a_filename:string):string;
//return the filename extension excluding the '.'
var
  a_len:integer;
begin
  a_filename:=ExtractFileExt(a_filename);
  a_len:=length(a_filename);
  if a_len >1 then
    result:= copy(a_filename,2,a_len -1)
   else
    result:='';
end;
//-----------------------------------------------------------
function is_techcrew_file(a_filename:string):boolean;
// check filename for 'techcrew'
var
  a_file:string;
begin
  result := false;
  a_file:= UpperCase(ExtractFileName(a_filename));
  if fileexists(a_filename) then
    if pos('TECHCREW',a_file) <> 0 then
     result:=true;
end;
//-----------------------------------------------------------
function is_patterns_file(a_filename:string):boolean;
// check filename for 'patterns'
VAR
  a_file:string;
begin
  result := false;
  a_file:= UpperCase(ExtractFileName(a_filename));
  if fileexists(a_filename) then
    if pos('PATTERNS',a_file) <> 0 then
      result:=true;
end;
//-----------------------------------------------------------
function numbers_only(a_str:string):string;
// take a string and remove any non number characters  'QFA 123.4'='1234
var
  index,a_len:integer;
  a_char:string;
begin
  result:='';
  a_len:=length(a_str);
  for index:= 1 to a_len do
    begin
      a_char:= copy(a_str,index,1);
      if pos(a_char,'0123456789')<>0 then
        result:=result+a_char;
    end;
end;
//------------------------------------------------------------------------------
function is_number(a_str:string):boolean;
//check for single char as a  valid number in a string format
begin
   if (pos(a_str,'0123456789') <> 0 ) then
     result:=true
     else
     result:=false;
end;
//------------------------------------------------------------------------------
function letters_only(const a_str:string):string;
// Return a string that only contains upper or lower case letters
var
  index,a_len:integer;
  a_char:string;
begin
  result:='';
  a_len:=length(a_str);
  for index:= 1 to a_len do
    begin
      a_char:= copy(a_str,index,1);
      if pos(a_char,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')<>0 then
        result:=result+a_char;
    end;
end;
//------------------------------------------------------------------------------
function remove_letters(const a_str:string):string;
// Return a string that only contains numbers or punctutation
var
  index,a_len:integer;
  a_char:string;
begin
  result:='';
  a_len:=length(a_str);
  for index:= 1 to a_len do
    begin
      a_char:= copy(a_str,index,1);
      if pos(a_char,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')=0 then
        result:=result+a_char;
    end;
end;
//------------------------------------------------------------------------------
function removeAmpersand(const a_str:string):string;
// extract '&' character, useful for menu text
var
  index,a_len:integer;
  a_char:string;
begin
  result:='';
  a_len:=length(a_str);
  for index:= 1 to a_len do
    begin
      a_char:= copy(a_str,index,1);
      if not (a_char = '&') then //pos(a_char,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')=0 then
        result:=result+a_char;
    end;
end;

//------------------------------------------------------------------------------
function no_dupes(const a_str:string):string;
// remove duplicate characters from a string
var
  index,a_len:integer;
  a_char:string;
begin
  result:='';
  a_len:=length(a_str);
  for index:= 1 to a_len do
    begin
      a_char:=copy(a_str,index,1);
      if pos(a_char,result)= 0 then result:= result+ a_char;
    end;
end;
// -------------------------------------------------------------------
function alpha_num_only(const a_str:string):string;
// Return a string that only contains number and upper or lower case letters
var
  index,a_len:integer;
  a_char:string;
begin
  result:='';
  a_len:=length(a_str);
  for index:= 1 to a_len do
    begin
      a_char:= copy(a_str,index,1);
      if pos(a_char,'0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')<>0 then
        result:=result+a_char;
    end;
end;
//------------------------------------------------------------------------------




//-------------------------------------------------------------------------------
function RunWithParameters(const fn,params:string):boolean;//32
var
  tsi:tstartupinfo;
  commandline:string;
  tpi:tprocessinformation;
  identifier:integer;//instance handle or process id


begin
  commandline:=fn+' '+params;
  fillchar(tsi,sizeof(tsi),0);//initialise
  tsi.cb:=sizeof(tsi);
  if CreateProcess(pchar(fn),pchar(commandline),nil,nil,false,detached_process or
     normal_priority_class,nil,nil,tsi,tpi) then
     begin
       identifier:=tpi.dwprocessid;
       closehandle(tpi.hthread);
       waitforinputidle(tpi.hprocess,10000);//let process start how?
       result:=true;
     end
    else
     result:=false;
end;
//------------------------------------------------------------------------------
 {returns the number of minutes in an hours and minutes of type hhhmm}
 function hours_to_min(hours :string):integer;
 var
   len,minutes,hrs:integer;
   min,hr:string;

 begin
   //hours passed as hhhmm or hh:mm ie deliminator is removed
   hours:=numbers_only(hours);//remove deliminators
   if hours='' then begin
     result:=0;
     exit;
   end;
   //create a minimum length of 4 characters eg '0030'
   while length(hours) < 4 do
    hours:= '0'+ hours;

   len:=length(hours);// length may be > than 4
   min:=copy(hours,len-1,2);//last 2 characters of hours$
   minutes:=strtoint(min);
   hr:=copy(hours,1,len-2);//hours part of hours$
   hrs:=strtoint(hr);
   hrs:=hrs*60;
   result:=minutes+hrs;

 end;

 {______________________________________________________________________}
function min_to_hours(mins:integer):string;
// return a formatted hh:mm time from minutes
begin
result:=inttostr( mins div 60) +':'+ format('%2.2d',[mins mod 60]);
end;

//------------------------------------------------------------------------------
function ShortReportStr(a_str:string):string;
// convert to 01SEP2009 08:05 to 01 SEP 08:05
begin
  result := copy(a_str,1,5)+copy(a_str,10,6);
end;
//------------------------------------------------------------------------------
procedure reset_int_array(var arr:array of integer);
// zero all elements of the array
var
  index:integer;
begin
  for index:= 0 to high(arr) do
    arr[index]:= 0;
end;
//------------------------------------------------------------------------------
function containsStr(substr,str:string):boolean;
begin
  if pos(substr,str)<> 0 then result := true
   else result := false;
end;
// ----------------------------------------------------------------------------

{ TJOStringlist }

function TJOStringlist.Equals(sl: TStringlist): boolean;
var
  i: Integer;
// compare sl to self
begin
  result := true;
  for i := 0 to self.Count - 1 do
  begin
    if sl[i] <> Self[i] then
    begin
      result := false;
      break;
    end;
  end;
end;
//------------------------------------------------------------------------------
Procedure TJOStringlist.GetStrings(var alist:Tstringlist;start, finish: integer);
// resturn a subset of a Tstringlist based on a start and finish index
var
  index:integer;
begin
  alist.clear;
  for index:= start to finish do
    alist.add(self[index]);
end;

{  --------------------------------------------------------------------------  }
function RedText(a_str:string):string;
begin
  result := col_red + ' '+ a_str + col_black + ' ';
end;
//------------------------------------------------------------------------------
function BlueText(a_str:string):string;
begin
  result := col_blue + ' '+ a_str + col_black + ' ';
end;
//------------------------------------------------------------------------------
function GreenText(a_str:string):string;
begin
  result := col_green + ' '+ a_str + col_black + ' ';
end;
//------------------------------------------------------------------------------
end.


