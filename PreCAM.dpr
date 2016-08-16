program PreCAM;

uses
  Forms,
  main in 'main.pas' {fmMain},
  GetData in 'GetData.pas',
  crew_pf1 in 'crew_pf1.pas',
  pat_pf2 in 'pat_pf2.pas',
  dates in 'dates.PAS',
  my_strings in 'my_strings.pas';

{$R *.res}
{$R ZipMsgUS.res}
begin
  Application.Initialize;
  Application.Title := 'Pre Cam';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
