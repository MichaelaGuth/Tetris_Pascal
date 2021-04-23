unit Dialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TGameOver = class(TForm)
    Popis: TLabel;
    Username: TEdit;
    SaveHighScoreButton: TButton;
    Image1: TImage;
    procedure SaveHighScoreButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GameOver: TGameOver;


implementation

{$R *.dfm}
uses
    game,score;


procedure TGameOver.SaveHighScoreButtonClick(Sender: TObject);
var
  ulozeni : String;
  ulozeneScore : TStringlist;
begin
  if (Username.Text <> '') then ulozeni := Username.Text + ': ' + IntToStr(game.GameForm.score)
  else ulozeni := 'Randomák: ' + IntToStr(game.GameForm.score);

  ulozeneScore := TStringlist.Create;
  try
    ulozeneScore.LoadFromFile('HighScore.txt');
    ulozeneScore.Add(ulozeni);

    ulozeneScore.CustomSort(score.seradScore);
    //ulozeneScore.Sorted := true;

    ulozeneScore.SaveToFile('HighScore.txt');
  finally
    ulozeneScore.Free;
  end;

  GameOver.Close;
end;

end.
