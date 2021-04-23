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




/// pøi stisku tlaèítka Singleplayer se hlavní okno pøepne na game s módem pro jednoho hráèe
procedure TMenuForm.singleplayerButtonClick(Sender: TObject);
begin
  gameMode := 1;

  Application.CreateForm(TGameForm, GameForm);
  GameForm.Show;
  Self.Hide;
end;


/// zmìna barvy tlaèítka pøi najetí kurzoru na tlaèítko
procedure TMenuForm.singleplayerButtonMouseEnter(Sender: TObject);
begin
  SingleplayerButton.Picture.LoadFromFile('obrazky\SingleplayerClickButton.png');
end;


/// zmìna barvy tlaèítka pøi vyjetí kurzoru z tlaèítka
procedure TMenuForm.singleplayerButtonMouseLeave(Sender: TObject);
begin
  SingleplayerButton.Picture.LoadFromFile('obrazky\SingleplayerButton.png');
end;




/// pøi stisku tlaèítka Multiplayer se hlavní okno pøepne na game s módem pro více hráèù
procedure TMenuForm.multiplayerButtonClick(Sender: TObject);
begin
  gameMode := 2;

  Application.CreateForm(TGameForm, GameForm);
  GameForm.Show;
  Self.Hide;
end;


/// zmìna barvy tlaèítka pøi najetí kurzoru na tlaèítko
procedure TMenuForm.multiplayerButtonMouseEnter(Sender: TObject);
begin
  multiplayerButton.Picture.LoadFromFile('obrazky\MultiplayerClickButton.png');
end;


/// zmìna barvy tlaèítka pøi vyjetí kurzoru z tlaèítka
procedure TMenuForm.multiplayerButtonMouseLeave(Sender: TObject);
begin
  multiplayerButton.Picture.LoadFromFile('obrazky\MultiplayerButton.png');
end;




/// funkce, která vrací cestu k správnému obrázku s návodem ke høe - používá se v game.pas
function gameModeSelection : String;
begin
  if gameMode = 1 then result := 'obrazky\HowToPlaySingleplayer.png'
  else result := 'obrazky\HowToPlayMultiplayer.png';
end;




/// pøi stisku tlaèítka High Score se pøepne hlavní okno na okno s high score
procedure TMenuForm.highScoreButtonClick(Sender: TObject);
begin
  Application.CreateForm(ThighScoreForm, highScoreForm);
  highScoreForm.Show;
  Self.Hide;
end;


/// zmìna barvy tlaèítka pøi najetí kurzoru na tlaèítko
procedure TMenuForm.highScoreButtonMouseEnter(Sender: TObject);
begin
  highScoreButton.Picture.LoadFromFile('obrazky\HighScoreClickButton.png');
end;


/// zmìna barvy tlaèítka pøi vyjetí kurzoru z tlaèítka
procedure TMenuForm.highScoreButtonMouseLeave(Sender: TObject);
begin
  highScoreButton.Picture.LoadFromFile('obrazky\HighScoreButton.png');
end;




/// pøi stisku tlaèítka Exit se celá aplikace vypne
procedure TMenuForm.exitButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;


/// zmìna barvy tlaèítka pøi najetí kurzoru na tlaèítko
procedure TMenuForm.exitButtonMouseEnter(Sender: TObject);
begin
  ExitButton.Picture.LoadFromFile('obrazky\ExitClickButton.png');
end;


/// zmìna barvy tlaèítka pøi vyjetí kurzoru z tlaèítka
procedure TMenuForm.exitButtonMouseLeave(Sender: TObject);
begin
  ExitButton.Picture.LoadFromFile('obrazky\ExitButton.png')
end;

end.
