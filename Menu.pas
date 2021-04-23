unit Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

function gameModeSelection : String;

type
  TMenuForm = class(TForm)
    Background: TImage;
    singleplayerButton: TImage;
    highScoreButton: TImage;
    multiplayerButton: TImage;
    exitButton: TImage;
    procedure exitButtonClick(Sender: TObject);
    procedure highScoreButtonClick(Sender: TObject);
    procedure singleplayerButtonClick(Sender: TObject);
    procedure multiplayerButtonClick(Sender: TObject);
    procedure singleplayerButtonMouseEnter(Sender: TObject);
    procedure singleplayerButtonMouseLeave(Sender: TObject);
    procedure multiplayerButtonMouseEnter(Sender: TObject);
    procedure multiplayerButtonMouseLeave(Sender: TObject);
    procedure highScoreButtonMouseLeave(Sender: TObject);
    procedure highScoreButtonMouseEnter(Sender: TObject);
    procedure exitButtonMouseEnter(Sender: TObject);
    procedure exitButtonMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  MenuForm: TMenuForm;
  gameMode : Integer;

implementation
uses Highscore, game;
{$R *.dfm}




/// p�i stisku tla��tka Singleplayer se hlavn� okno p�epne na game s m�dem pro jednoho hr��e
procedure TMenuForm.singleplayerButtonClick(Sender: TObject);
begin
  gameMode := 1;

  Application.CreateForm(TGameForm, GameForm);
  GameForm.Show;
  Self.Hide;
end;


/// zm�na barvy tla��tka p�i najet� kurzoru na tla��tko
procedure TMenuForm.singleplayerButtonMouseEnter(Sender: TObject);
begin
  SingleplayerButton.Picture.LoadFromFile('obrazky\SingleplayerClickButton.png');
end;


/// zm�na barvy tla��tka p�i vyjet� kurzoru z tla��tka
procedure TMenuForm.singleplayerButtonMouseLeave(Sender: TObject);
begin
  SingleplayerButton.Picture.LoadFromFile('obrazky\SingleplayerButton.png');
end;




/// p�i stisku tla��tka Multiplayer se hlavn� okno p�epne na game s m�dem pro v�ce hr���
procedure TMenuForm.multiplayerButtonClick(Sender: TObject);
begin
  gameMode := 2;

  Application.CreateForm(TGameForm, GameForm);
  GameForm.Show;
  Self.Hide;
end;


/// zm�na barvy tla��tka p�i najet� kurzoru na tla��tko
procedure TMenuForm.multiplayerButtonMouseEnter(Sender: TObject);
begin
  multiplayerButton.Picture.LoadFromFile('obrazky\MultiplayerClickButton.png');
end;


/// zm�na barvy tla��tka p�i vyjet� kurzoru z tla��tka
procedure TMenuForm.multiplayerButtonMouseLeave(Sender: TObject);
begin
  multiplayerButton.Picture.LoadFromFile('obrazky\MultiplayerButton.png');
end;




/// funkce, kter� vrac� cestu k spr�vn�mu obr�zku s n�vodem ke h�e - pou��v� se v game.pas
function gameModeSelection : String;
begin
  if gameMode = 1 then result := 'obrazky\HowToPlaySingleplayer.png'
  else result := 'obrazky\HowToPlayMultiplayer.png';
end;




/// p�i stisku tla��tka High Score se p�epne hlavn� okno na okno s high score
procedure TMenuForm.highScoreButtonClick(Sender: TObject);
begin
  Application.CreateForm(ThighScoreForm, highScoreForm);
  highScoreForm.Show;
  Self.Hide;
end;


/// zm�na barvy tla��tka p�i najet� kurzoru na tla��tko
procedure TMenuForm.highScoreButtonMouseEnter(Sender: TObject);
begin
  highScoreButton.Picture.LoadFromFile('obrazky\HighScoreClickButton.png');
end;


/// zm�na barvy tla��tka p�i vyjet� kurzoru z tla��tka
procedure TMenuForm.highScoreButtonMouseLeave(Sender: TObject);
begin
  highScoreButton.Picture.LoadFromFile('obrazky\HighScoreButton.png');
end;




/// p�i stisku tla��tka Exit se cel� aplikace vypne
procedure TMenuForm.exitButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;


/// zm�na barvy tla��tka p�i najet� kurzoru na tla��tko
procedure TMenuForm.exitButtonMouseEnter(Sender: TObject);
begin
  ExitButton.Picture.LoadFromFile('obrazky\ExitClickButton.png');
end;


/// zm�na barvy tla��tka p�i vyjet� kurzoru z tla��tka
procedure TMenuForm.exitButtonMouseLeave(Sender: TObject);
begin
  ExitButton.Picture.LoadFromFile('obrazky\ExitButton.png')
end;

end.
