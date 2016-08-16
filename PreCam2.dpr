program PreCam2;

uses
  Forms,
  main in 'main.pas' {fmMain},
  my_strings in 'my_strings.pas',
  Data in 'Data.pas',
  dates in 'dates.PAS',
  Search in 'Search.pas' {fmSearch},
  ABOUT in 'ABOUT.pas' {fmAbout};

{$R *.res}
{$R ZipMsgUS.res}
begin
  Application.Initialize;
  Application.Title := 'Pre Cam II';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmSearch, fmSearch);
  Application.CreateForm(TfmAbout, fmAbout);
  Application.Run;
end.
