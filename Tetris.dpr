program Tetris;

uses
  Vcl.Forms,
  Menu in 'Menu.pas' {MenuForm},
  Highscore in 'Highscore.pas' {highScoreForm},
  game in 'game.pas' {GameForm},
  score in 'score.pas',
  Constants in 'Constants.pas',
  Kosticka in 'Kosticka.pas',
  Smer in 'Smer.pas',
  Tvar in 'Tvar.pas',
  GameUtils in 'GameUtils.pas',
  Dialog in 'Dialog.pas' {GameOver};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMenuForm, MenuForm);
  Application.CreateForm(TGameOver, GameOver);
  Application.Run;
end.
