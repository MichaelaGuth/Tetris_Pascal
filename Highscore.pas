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




/// jakmile se spust� okno s High Score tak se na�tou ulo�en� sk�re a zobraz� se v tabulce
procedure ThighScoreForm.FormShow(Sender: TObject);
var
  skore : TStringList;
  radek : TArray<String>;
  r,s : Integer;
begin
  tabulka.Cells[1,0] := 'Player';             /// nastav� z�hlav� tabulky
  tabulka.Cells[2,0] := 'Score';

  for r := 1 to (tabulka.RowCount-1) do tabulka.Cells[0,r] := IntToStr(r);               /// na�te do tabulky po�ad� (1....)

  skore := nactiSoubor('HighScore.txt');                          /// na�te ulo�en� sk�re
  for r := 0 to skore.Count-1 do begin
    radek := rozdeleni(skore[r]);
    for s := 0 to 1 do tabulka.Cells[s+1,r+1] := radek[s];
  end;
end;



/// vytvo�� ikonku na doln� li�t�
procedure ThighScoreForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;


/// po stisknut� k��ku v pravo naho�e se cel� aplikace vypne
procedure ThighScoreForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;




/// po stisknut� tla��tka backButton se u�ivatel vr�t� do menu
procedure ThighScoreForm.backButtonClick(Sender: TObject);
begin
  MenuForm.Show;
  Hide;
end;


/// zm�na barvy tla��tka p�i najet� kurzoru na tla��tko
procedure ThighScoreForm.backButtonMouseEnter(Sender: TObject);
begin
  backButton.Picture.LoadFromFile('obrazky\BackClickButton.png');
end;


/// zm�na barvy tla��tka p�i vyjet� kurzoru z tla��tka
procedure ThighScoreForm.backButtonMouseLeave(Sender: TObject);
begin
  backButton.Picture.LoadFromFile('obrazky\BackButton.png');
end;



end.
