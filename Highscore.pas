unit Highscore;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  ThighScoreForm = class(TForm)
    Image1: TImage;
    tabulka: TStringGrid;
    backButton: TImage;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure backButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure backButtonMouseLeave(Sender: TObject);
    procedure backButtonMouseEnter(Sender: TObject);
  private
    { Private declarations }
  public
    highScoreForm: ThighScoreForm;
    { Public declarations }
  end;

var
  highScoreForm: ThighScoreForm;

implementation
uses Menu, score;
{$R *.dfm}




/// jakmile se spustí okno s High Score tak se naètou uložená skóre a zobrazí se v tabulce
procedure ThighScoreForm.FormShow(Sender: TObject);
var
  skore : TStringList;
  radek : TArray<String>;
  r,s : Integer;
begin
  tabulka.Cells[1,0] := 'Player';             /// nastaví záhlaví tabulky
  tabulka.Cells[2,0] := 'Score';

  for r := 1 to (tabulka.RowCount-1) do tabulka.Cells[0,r] := IntToStr(r);               /// naète do tabulky poøadí (1....)

  skore := nactiSoubor('HighScore.txt');                          /// naète uložené skóre
  for r := 0 to skore.Count-1 do begin
    radek := rozdeleni(skore[r]);
    for s := 0 to 1 do tabulka.Cells[s+1,r+1] := radek[s];
  end;
end;



/// vytvoøí ikonku na dolní lištì
procedure ThighScoreForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;


/// po stisknutí køížku v pravo nahoøe se celí aplikace vypne
procedure ThighScoreForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;




/// po stisknutí tlaèítka backButton se uživatel vrátí do menu
procedure ThighScoreForm.backButtonClick(Sender: TObject);
begin
  MenuForm.Show;
  Hide;
end;


/// zmìna barvy tlaèítka pøi najetí kurzoru na tlaèítko
procedure ThighScoreForm.backButtonMouseEnter(Sender: TObject);
begin
  backButton.Picture.LoadFromFile('obrazky\BackClickButton.png');
end;


/// zmìna barvy tlaèítka pøi vyjetí kurzoru z tlaèítka
procedure ThighScoreForm.backButtonMouseLeave(Sender: TObject);
begin
  backButton.Picture.LoadFromFile('obrazky\BackButton.png');
end;



end.
