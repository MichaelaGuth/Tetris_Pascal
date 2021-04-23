unit game;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, System.Generics.Collections,
  Vcl.ExtCtrls, System.UITypes,
  Menu, GameUtils, Kosticka, Constants, Tvar, Smer, Dialog;

type
  TGameForm = class(TForm)
    Background: TImage;
    ScoreText: TLabel;
    ScoreNumber: TLabel;
    nasledujKosticka: TImage;
    RetryButton: TImage;
    Control: TImage;
    okraje: TImage;
    ExitButton: TImage;
    Casovac: TTimer;
    pole: TImage;
    procedure ExitButtonClick(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure ExitButtonMouseEnter(Sender: TObject);
    procedure ExitButtonMouseLeave(Sender: TObject);
    procedure RetryButtonMouseEnter(Sender: TObject);
    procedure RetryButtonMouseLeave(Sender: TObject);
    procedure gameLoop(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure gameInit(pole : TImage);
    procedure gameOver;
    procedure vykresleni(pole : TImage; hraciPole : TArray<TArray<TKosticka>>; pocetViditelnychRadku : Integer);
    function posun(smer : TSmer; pole : TImage) : boolean;
    procedure vykresleniNK(pole : TImage; poleKosticky : TArray<TArray<TKosticka>>);
    procedure rotace(aktual : TTvar; pole : TImage; hraciPole : TArray<TArray<TKosticka>>);
    procedure vymazZaplneneRadky(pole : TImage);
    function timerUp(lvl : Integer) : Integer;
    function levelUp(score : Integer) : Integer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    kostickyImages : TDictionary<TKostickaEnum, TImage>;
    image : TImage;

    aktualKosticka,nasledujiciKosticka : TTvar;
    hraciPole : TArray<TArray<TKosticka>>;

    scorelvl : Integer;
  public
    GameForm: TGameForm;
    score : Integer;
  end;

var
  GameForm: TGameForm;

implementation

{$R *.dfm}



/// procedura, kter� se vykon� po na�t�n� okna s hrou
procedure TGameForm.FormShow(Sender: TObject);
var
  bg : TPicture;
begin
  Control.Picture.LoadFromFile(gameModeSelection);                  /// nalouduje n�pov�du

  bg := TPicture.Create;                                            /// nalouduje background do hrac�ho pole
  try
    bg.LoadFromFile('obrazky\Pole.png');
    pole.Canvas.Draw(0,0,bg.Graphic);
  finally
    bg.Free;
  end;

  score := 0;                                                       /// nastav� sk�re na 0
  ScoreNumber.Caption := IntToStr(score);

  kostickyImages := TDictionary<TKostickaEnum, TImage>.Create;      /// vytvo�en� mapy

  image := TImage.Create(Self);
  image.Picture.LoadFromFile('obrazky/CervenaKosticka.png');        /// na�ten� �erven� kosti�ky
  kostickyImages.Add(TKostickaEnum.CERVENA,image);

  image := TImage.Create(Self);
  image.Picture.LoadFromFile('obrazky/ModraKosticka.png');          /// na�ten� modr� kosti�ky
  kostickyImages.Add(TKostickaEnum.MODRA,image);

  image := TImage.Create(Self);
  image.Picture.LoadFromFile('obrazky/ZelenaKosticka.png');         /// na�ten� zelen� kosti�ky
  kostickyImages.Add(TKostickaEnum.ZELENA,image);

  image := TImage.Create(Self);
  image.Picture.LoadFromFile('obrazky/OranzovaKosticka.png');       /// na�ten� oran�ov� kosti�ky
  kostickyImages.Add(TKostickaEnum.ORANZOVA,image);

  image := TImage.Create(Self);
  image.Picture.LoadFromFile('obrazky/FialovaKosticka.png');        /// na�ten� fialov� kosti�ky
  kostickyImages.Add(TKostickaEnum.FIALOVA,image);

  gameInit(nasledujKosticka);   /// zah�j� hru
end;



/// procedura, kter� nastav� po��tek hry
procedure TGameForm.gameInit(pole : TImage);
begin
  aktualKosticka := nahodnaKosticka(kostickyImages);                                /// vygeneruje n�hodnou kosti�ku jako aktu�ln� kosti�ku
  nasledujiciKosticka := nahodnaKosticka(kostickyImages);                           /// vygeneruje n�hodnou kosti�ku jako n�sleduj�c� kosti�ku
  SetLength(hraciPole, Constants.HRA_POCET_RADKU, Constants.HRA_POCET_SLOUPCU);     /// nastav� velikost hrac�ho pole

  vykresleniNK(pole, nasledujiciKosticka.getTvar);                                  /// vykresl� n�sleduj�c� kosti�ku do ur�en�ho pole

  Casovac.Interval := Constants.POCATECNI_RYCHLOST;                                 /// nastav� �asova� na po��te�n� rychlost tik�
  Casovac.Enabled := true;                                                          /// zapne �asova�

  scorelvl := 1;                                                                    /// nastav� level na 1
end;



/// po stisknut� k��ku vpravo naho�e se cel� aplikace vypne
procedure TGameForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;



/// nastaven� ovl�d�n� hry
procedure TGameForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  smer : TSmer;
begin
  case Key of
    vkUP: rotace(aktualKosticka, pole, hraciPole);
    vkDOWN: begin
      smer := TDolu.Create;
      posun(smer,pole);
    end;
    vkRIGHT: begin
      smer := TDoprava.Create;
      posun(smer, pole);
    end;
    vkLEFT: begin
      smer := TDoleva.Create;
      posun(smer, pole);
    end;
    vkSPACE: begin
      smer := TDolu.Create;
      while posun(smer, pole) do score := score + 2*scorelvl;
    end;
  end;

  if (gamemode = 2) then begin
    case Key of
      vk1: nasledujiciKosticka := TCtverec.Create(nahodnabarva(kostickyImages));
      vk2: nasledujiciKosticka := TLkoNormal.Create(nahodnabarva(kostickyImages));
      vk3: nasledujiciKosticka := TLkoMirror.Create(nahodnabarva(kostickyImages));
      vk4: nasledujiciKosticka := TTkoKosticka.Create(nahodnabarva(kostickyImages));
      vk5: nasledujiciKosticka := TZkoNormal.Create(nahodnabarva(kostickyImages));
      vk6: nasledujiciKosticka := TZkoMirror.Create(nahodnabarva(kostickyImages));
      vk7: nasledujiciKosticka := TTrubka.Create(nahodnabarva(kostickyImages));

      vkNumpad1: nasledujiciKosticka := TCtverec.Create(nahodnabarva(kostickyImages));
      vkNumpad2: nasledujiciKosticka := TLkoNormal.Create(nahodnabarva(kostickyImages));
      vkNumpad3: nasledujiciKosticka := TLkoMirror.Create(nahodnabarva(kostickyImages));
      vkNumpad4: nasledujiciKosticka := TTkoKosticka.Create(nahodnabarva(kostickyImages));
      vkNumpad5: nasledujiciKosticka := TZkoNormal.Create(nahodnabarva(kostickyImages));
      vkNumpad6: nasledujiciKosticka := TZkoMirror.Create(nahodnabarva(kostickyImages));
      vkNumpad7: nasledujiciKosticka := TTrubka.Create(nahodnabarva(kostickyImages));
    end;
  end;
end;



/// procedura, ktar� se vykon� p�i ka�d�m tiku
procedure TGameForm.gameLoop(Sender: TObject);
var
  smer : TSmer;
  kontrola : boolean;
begin
  kontrola := GameUtils.kontrolaGameOver(hraciPole);                /// kontrola jestli nem� nastat Game Over
  if kontrola then gameOver;

  smer := TDolu.Create;
  posun(smer, pole);                                                /// posun aktu�ln� kosti�ky dol�

  vykresleniNK(nasledujKosticka, nasledujiciKosticka.getTvar);      /// vykreslen� n�sleduj�c� kosti�ky

  vymazZaplneneRadky(pole);                                         /// vymaz�n� zapln�n�ch ��dk�
  ScoreNumber.Caption := IntToStr(score);                           /// vyps�n� sk�re

  scorelvl := timerUp(levelUp(score));                              /// pokud je t�eba, tak zv��� �rove� obt�nosti
end;




/// zm�na barvy tla��tka p�i najet� kurzoru na tla��tko
procedure TGameForm.RetryButtonMouseEnter(Sender: TObject);
begin
  RetryButton.Picture.LoadFromFile('obrazky\RetryClickButton.png');
end;

/// zm�na barvy tla��tka p�i vyjet� kurzoru z tla��tka
procedure TGameForm.RetryButtonMouseLeave(Sender: TObject);
begin
  RetryButton.Picture.LoadFromFile('obrazky\RetryButton.png');
end;

/// vytvo�� ikonku na doln� li�t�
procedure TGameForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;

/// po stisknut� tla��tka EXIT se u�ivatel vrac� do hlavn�ho menu
procedure TGameForm.ExitButtonClick(Sender: TObject);
begin
  MenuForm.Show;
  Hide;
end;

/// zm�na barvy tla��tka p�i najet� kurzoru na tla��tko
procedure TGameForm.ExitButtonMouseEnter(Sender: TObject);
begin
  ExitButton.Picture.LoadFromFile('obrazky\ExitClickButton.png');
end;

/// zm�na barvy tla��tka p�i vyjet� kurzoru z tla��tka
procedure TGameForm.ExitButtonMouseLeave(Sender: TObject);
begin
  ExitButton.Picture.LoadFromFile('obrazky\ExitButton.png');
end;



/// procedura, kter� vykresluje n�sleduj�c� kosti�ku
procedure TGameForm.vykresleniNK(pole : TImage; poleKosticky : TArray<TArray<TKosticka>>);
var
  sloupec, radek : Integer;
  bg : TPicture;
begin
  bg := TPicture.Create;
  try
    bg.LoadFromFile('obrazky\NasledujiciKosticka.png');
    pole.Canvas.Draw(0,0,bg.Graphic);
    for radek := 0 to (Length(poleKosticky)-1) do begin
      for sloupec := 0 to (Length(poleKosticky[0])-1) do begin
        if (poleKosticky[radek][sloupec] <> nil) then begin
          pole.Canvas.Draw((sloupec)*Constants.KOSTICKA_SIZE, (radek)*Constants.KOSTICKA_SIZE, poleKosticky[radek][sloupec].getKosticka.Picture.Graphic);
        end;
      end;
    end;
  finally
    bg.Free;
  end;
end;



/// procedura, kter� vykresluje aktu�ln� kosti�ku a hern� pole
procedure TGameForm.vykresleni(pole : TImage; hraciPole : TArray<TArray<TKosticka>>; pocetViditelnychRadku : Integer);
var
  offset,radek,sloupec : Integer;
  background : TPicture;
begin
  background := TPicture.Create;
  offset := Length(hraciPole) - pocetViditelnychRadku;
  try
    background.LoadFromFile('obrazky\Pole.png');
    pole.Canvas.Draw(0,0,background.Graphic);
    for radek := 0 to (Length(hraciPole)-offset-1) do begin
      for sloupec := 0 to (Length(hraciPole[0])-1) do begin
        if (hraciPole[radek + offset][sloupec] <> nil) then begin
          pole.Canvas.Draw((sloupec)*Constants.KOSTICKA_SIZE, (radek)*Constants.KOSTICKA_SIZE, hraciPole[radek + offset][sloupec].getKosticka.Picture.Graphic);
        end;
      end;
    end;
  finally
    background.Free;
  end;
end;



/// funkce, kter� posune aktu�ln� kosti�ku dan�m sm�rem a vrac� true, pokud se kosti�ka posunula
function TGameForm.posun(smer : TSmer; pole : TImage) : boolean;
var
  x,y : Integer;
  copyPole : TArray<TArray<TKosticka>>;
  status : VlozeniKostkyStatus;
begin
  x := aktualKosticka.getX + smer.getX;               /// vypo��t� novou sou�adnici x aktu�n� kosti�ky
  y := aktualKosticka.getY + smer.getY;               /// vypo��t� novou sou�adnici y aktu�n� kosti�ky

  copyPole := GameUtils.copy(hraciPole);                                     /// zkop�ruje hr�c� pole do nov�ho pole
  status := vlozeniKosticky(aktualKosticka,hraciPole,copyPole,smer);         /// pokus� se vlo�it aktu�ln� kosti�ku s nov�mi sou�adnicemi do nov�ho pole

  case status of
    OK:                             /// kosti�ka se m��e posunout
      begin
        vykresleni(pole, copyPole, Constants.HRA_POCET_VIDITELNYCH_RADKU);        /// vykresl� nov� pole
        aktualKosticka.setX(x);                                                   /// nastav� novou sou�adnici x aktu�ln� kosti�ky
        aktualKosticka.setY(y);                                                   /// nastav� novou sou�adnici y aktu�ln� kosti�ky
        result := true;
      end;
    KOLIZE_S_KOSTKOU_ZE_STRANY:     /// kosti�ka narazila do kostky ze strany
      begin
        copyPole := copy(hraciPole);                                                    /// pole z�stane takov� jak� bylo
        GameUtils.vlozeniKosticky(aktualKosticka, hraciPole, copyPole, TNic.Create);    /// nikam se neposune
        vykresleni(pole, copyPole, Constants.HRA_POCET_VIDITELNYCH_RADKU);              /// vykreslen�
        result := true;
      end;
    KOLIZE_SE_STENOU:               /// kosti�ka narazila do bo�n� st�ny
      begin
        copyPole := copy(hraciPole);                                                    /// pole z�stane takov� jak� bylo
        GameUtils.vlozeniKosticky(aktualKosticka, hraciPole, copyPole, TNic.Create);    /// nikam se neposune
        vykresleni(pole, copyPole, Constants.HRA_POCET_VIDITELNYCH_RADKU);              /// vykreslen�
        result := true;
      end;
    KOLIZE_S_KONCEM:                /// kosti�ka narazila na dno hrac�ho pole
      begin
        copyPole := copy(hraciPole);                                                    /// pole z�stane takov� jak� bylo
        GameUtils.vlozeniKosticky(aktualKosticka, hraciPole, copyPole, TNic.Create);    /// nikam se neposune
        hraciPole := copyPole;                                                          /// vlo�� aktu�ln� kosti�ku do hrac�ho pole
        aktualKosticka := nasledujiciKosticka;                                          /// nastav� n�sleduj�c� kosti�ku na aktu�ln�
        nasledujiciKosticka := GameUtils.nahodnaKosticka(kostickyImages);               /// vygeneruje novou n�hodnou n�sleduj�c� kosti�ku
        result := false;
      end;
  end;
end;



/// procedura, kter� oto�� po�adovan� tvar o 90�
procedure TGameForm.rotace(aktual : TTvar; pole : TImage; hraciPole : TArray<TArray<TKosticka>>);
var
  otoceni : TArray<TArray<Integer>>;
  min,i : Integer;
  tmp : TArray<TArray<TKosticka>>;
  image : TImage;
  j: Integer;
  smer : TSmer;
  //status : VlozeniKostkyStatus;
  //copyPole : TArray<TArray<TKosticka>>;
begin
  SetLength(otoceni,2,4);
  otoceni := GameUtils.nasobeniMatic(Constants.maticeOtoceni,aktual.getBody);
  min := Integer.MaxValue;

  for i := 0 to (Length(otoceni[0])-1) do begin
    if (otoceni[0][i] < min) then  min := otoceni[0][i];
  end;

  min := Abs(min);

  for i := 0 to (Length(otoceni[0])-1) do begin
    otoceni[0][i] := otoceni[0][i] + min;
  end;

  smer := TNic.Create;
  image := aktual.getImage;
  tmp := aktual.createTvar(otoceni, image);

  {copyPole := GameUtils.copy(hraciPole);
  status := vlozeniKosticky(aktualKosticka,hraciPole,copyPole,smer);}


 { case status of
    OK: aktualKosticka.setTvar(tmp);
    KOLIZE_S_KOSTKOU_ZE_STRANY: aktualKosticka.setTvar(aktualKosticka.getTvar);
    KOLIZE_SE_STENOU: aktualKosticka.setTvar(aktualKosticka.getTvar);
    KOLIZE_S_KONCEM: aktualKosticka.setTvar(aktualKosticka.getTvar);
  end;}

  aktualKosticka.setTvar(tmp); // mo�n� nebude pot�eba
  posun(smer, pole);
end;



/// procedura, kter� vyma�e zapln�n� ��dky a posune zbytek dol�
procedure TGameForm.vymazZaplneneRadky(pole : TImage);
var
  scoreCounter,radek,sloupec : Integer;
  kontrola : Boolean;
begin
  scoreCounter := 0;
  for radek := 0 to (Length(hraciPole)-1) do begin            /// projde v�echny ��dky hrac�ho pole
    kontrola := true;

    for sloupec := 0 to (Length(hraciPole[0])-1) do begin            /// projde cel� ��dek po sloupc�ch

      if (hraciPole[radek][sloupec] = nil) then begin                /// pokud naraz�z� na pr�zn� pole, nastav� kontrolu na false a p�ejde na dal�� ��dek
        kontrola := false;
        break;
      end;

    end;

    if kontrola then begin                                           /// pokud se kontrola = true, tak vykonej:

      GameUtils.umazRadek(radek, hraciPole);                                       /// uma� dan� ��dek
      hraciPole := GameUtils.posunZbytekDolu(radek, hraciPole);                    /// posu� zbytek pole dol�
      vykresleni(pole, hraciPole, Constants.HRA_POCET_VIDITELNYCH_RADKU);          /// vykresli hrac� pole

      scoreCounter := scoreCounter + 1;
    end;
  end;

  case scoreCounter of                                                            /// p�i�te odpov�daj�c� sk�re, podle toho, kolik ��dk� se smazalo
    1: score := score + Constants.SCORE_UMAZANI_RADKU * scorelvl;
    2: score := score + Constants.SCORE_UMAZANI_RADKU * scorelvl * 3;
    3: score := score + Constants.SCORE_UMAZANI_RADKU * scorelvl * 5;
  end;
end;




/// funkce kter� zrychluje �asova� podle levelu
function TGameForm.timerUp(lvl : Integer) : Integer;
begin
  case lvl of
    1: begin
      Casovac.Interval := Constants.POCATECNI_RYCHLOST div Constants.TIMER_LEVEL_1;
      result := 1;
    end;
    2: begin
      Casovac.Interval := Constants.POCATECNI_RYCHLOST div Constants.TIMER_LEVEL_2;
      result := 10;
    end;
    3: begin
      Casovac.Interval := Constants.POCATECNI_RYCHLOST div Constants.TIMER_LEVEL_3;
      result := 50;
    end;
    4: begin
      Casovac.Interval := Constants.POCATECNI_RYCHLOST div Constants.TIMER_LEVEL_4;
      result := 100;
    end;
    5: begin
      Casovac.Interval := Constants.POCATECNI_RYCHLOST div Constants.TIMER_LEVEL_5;
      result := 1000;
    end;
    else result := 1;
  end;
end;




/// funkce kter� zv��� level podle sk�re
function TGameForm.levelUp(score : Integer) : Integer;
begin
  if (score >= Constants.SCORE_LEVEL_5) then result:= 5
  else if (score >= Constants.SCORE_LEVEL_4) then result := 4
  else if (score >= Constants.SCORE_LEVEL_3) then result := 3
  else if (score >= Constants.SCORE_LEVEL_2) then result := 2
  else result := 1;
end;




/// procedura, ktr� zah�j� Game Over
procedure TGameForm.gameOver;
begin
  Casovac.Enabled := false;     /// vypnut� �asova�e

  Dialog.GameOver.ShowModal;    /// vysko�� dialog pro ulo�en� sk�re
end;


end.
