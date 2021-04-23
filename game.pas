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



/// procedura, která se vykoná po naètìní okna s hrou
procedure TGameForm.FormShow(Sender: TObject);
var
  bg : TPicture;
begin
  Control.Picture.LoadFromFile(gameModeSelection);                  /// nalouduje nápovìdu

  bg := TPicture.Create;                                            /// nalouduje background do hracího pole
  try
    bg.LoadFromFile('obrazky\Pole.png');
    pole.Canvas.Draw(0,0,bg.Graphic);
  finally
    bg.Free;
  end;

  score := 0;                                                       /// nastaví skóre na 0
  ScoreNumber.Caption := IntToStr(score);

  kostickyImages := TDictionary<TKostickaEnum, TImage>.Create;      /// vytvoøení mapy

  image := TImage.Create(Self);
  image.Picture.LoadFromFile('obrazky/CervenaKosticka.png');        /// naètení èervené kostièky
  kostickyImages.Add(TKostickaEnum.CERVENA,image);

  image := TImage.Create(Self);
  image.Picture.LoadFromFile('obrazky/ModraKosticka.png');          /// naètení modré kostièky
  kostickyImages.Add(TKostickaEnum.MODRA,image);

  image := TImage.Create(Self);
  image.Picture.LoadFromFile('obrazky/ZelenaKosticka.png');         /// naètení zelené kostièky
  kostickyImages.Add(TKostickaEnum.ZELENA,image);

  image := TImage.Create(Self);
  image.Picture.LoadFromFile('obrazky/OranzovaKosticka.png');       /// naètení oranžové kostièky
  kostickyImages.Add(TKostickaEnum.ORANZOVA,image);

  image := TImage.Create(Self);
  image.Picture.LoadFromFile('obrazky/FialovaKosticka.png');        /// naètení fialové kostièky
  kostickyImages.Add(TKostickaEnum.FIALOVA,image);

  gameInit(nasledujKosticka);   /// zahájí hru
end;



/// procedura, která nastaví poèátek hry
procedure TGameForm.gameInit(pole : TImage);
begin
  aktualKosticka := nahodnaKosticka(kostickyImages);                                /// vygeneruje náhodnou kostièku jako aktuální kostièku
  nasledujiciKosticka := nahodnaKosticka(kostickyImages);                           /// vygeneruje náhodnou kostièku jako následující kostièku
  SetLength(hraciPole, Constants.HRA_POCET_RADKU, Constants.HRA_POCET_SLOUPCU);     /// nastaví velikost hracího pole

  vykresleniNK(pole, nasledujiciKosticka.getTvar);                                  /// vykreslí následující kostièku do urèeného pole

  Casovac.Interval := Constants.POCATECNI_RYCHLOST;                                 /// nastaví èasovaè na poèáteèní rychlost tikù
  Casovac.Enabled := true;                                                          /// zapne èasovaè

  scorelvl := 1;                                                                    /// nastaví level na 1
end;



/// po stisknutí køížku vpravo nahoøe se celí aplikace vypne
procedure TGameForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;



/// nastavení ovládání hry
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



/// procedura, ktará se vykoná pøi každém tiku
procedure TGameForm.gameLoop(Sender: TObject);
var
  smer : TSmer;
  kontrola : boolean;
begin
  kontrola := GameUtils.kontrolaGameOver(hraciPole);                /// kontrola jestli nemá nastat Game Over
  if kontrola then gameOver;

  smer := TDolu.Create;
  posun(smer, pole);                                                /// posun aktuální kostièky dolù

  vykresleniNK(nasledujKosticka, nasledujiciKosticka.getTvar);      /// vykreslení následující kostièky

  vymazZaplneneRadky(pole);                                         /// vymazání zaplnìných øádkù
  ScoreNumber.Caption := IntToStr(score);                           /// vypsání skóre

  scorelvl := timerUp(levelUp(score));                              /// pokud je tøeba, tak zvýší úroveò obtížnosti
end;




/// zmìna barvy tlaèítka pøi najetí kurzoru na tlaèítko
procedure TGameForm.RetryButtonMouseEnter(Sender: TObject);
begin
  RetryButton.Picture.LoadFromFile('obrazky\RetryClickButton.png');
end;

/// zmìna barvy tlaèítka pøi vyjetí kurzoru z tlaèítka
procedure TGameForm.RetryButtonMouseLeave(Sender: TObject);
begin
  RetryButton.Picture.LoadFromFile('obrazky\RetryButton.png');
end;

/// vytvoøí ikonku na dolní lištì
procedure TGameForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;

/// po stisknutí tlaèítka EXIT se uživatel vrací do hlavního menu
procedure TGameForm.ExitButtonClick(Sender: TObject);
begin
  MenuForm.Show;
  Hide;
end;

/// zmìna barvy tlaèítka pøi najetí kurzoru na tlaèítko
procedure TGameForm.ExitButtonMouseEnter(Sender: TObject);
begin
  ExitButton.Picture.LoadFromFile('obrazky\ExitClickButton.png');
end;

/// zmìna barvy tlaèítka pøi vyjetí kurzoru z tlaèítka
procedure TGameForm.ExitButtonMouseLeave(Sender: TObject);
begin
  ExitButton.Picture.LoadFromFile('obrazky\ExitButton.png');
end;



/// procedura, která vykresluje následující kostièku
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



/// procedura, která vykresluje aktuální kostièku a herní pole
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



/// funkce, která posune aktuální kostièku daným smìrem a vrací true, pokud se kostièka posunula
function TGameForm.posun(smer : TSmer; pole : TImage) : boolean;
var
  x,y : Integer;
  copyPole : TArray<TArray<TKosticka>>;
  status : VlozeniKostkyStatus;
begin
  x := aktualKosticka.getX + smer.getX;               /// vypoèítá novou souøadnici x aktuání kostièky
  y := aktualKosticka.getY + smer.getY;               /// vypoèítá novou souøadnici y aktuání kostièky

  copyPole := GameUtils.copy(hraciPole);                                     /// zkopíruje hrácí pole do nového pole
  status := vlozeniKosticky(aktualKosticka,hraciPole,copyPole,smer);         /// pokusí se vložit aktuální kostièku s novými souøadnicemi do nového pole

  case status of
    OK:                             /// kostièka se mùže posunout
      begin
        vykresleni(pole, copyPole, Constants.HRA_POCET_VIDITELNYCH_RADKU);        /// vykreslí nové pole
        aktualKosticka.setX(x);                                                   /// nastaví novou souøadnici x aktuální kostièky
        aktualKosticka.setY(y);                                                   /// nastaví novou souøadnici y aktuální kostièky
        result := true;
      end;
    KOLIZE_S_KOSTKOU_ZE_STRANY:     /// kostièka narazila do kostky ze strany
      begin
        copyPole := copy(hraciPole);                                                    /// pole zùstane takové jaké bylo
        GameUtils.vlozeniKosticky(aktualKosticka, hraciPole, copyPole, TNic.Create);    /// nikam se neposune
        vykresleni(pole, copyPole, Constants.HRA_POCET_VIDITELNYCH_RADKU);              /// vykreslení
        result := true;
      end;
    KOLIZE_SE_STENOU:               /// kostièka narazila do boèní stìny
      begin
        copyPole := copy(hraciPole);                                                    /// pole zùstane takové jaké bylo
        GameUtils.vlozeniKosticky(aktualKosticka, hraciPole, copyPole, TNic.Create);    /// nikam se neposune
        vykresleni(pole, copyPole, Constants.HRA_POCET_VIDITELNYCH_RADKU);              /// vykreslení
        result := true;
      end;
    KOLIZE_S_KONCEM:                /// kostièka narazila na dno hracího pole
      begin
        copyPole := copy(hraciPole);                                                    /// pole zùstane takové jaké bylo
        GameUtils.vlozeniKosticky(aktualKosticka, hraciPole, copyPole, TNic.Create);    /// nikam se neposune
        hraciPole := copyPole;                                                          /// vloží aktuální kostièku do hracího pole
        aktualKosticka := nasledujiciKosticka;                                          /// nastaví následující kostièku na aktuální
        nasledujiciKosticka := GameUtils.nahodnaKosticka(kostickyImages);               /// vygeneruje novou náhodnou následující kostièku
        result := false;
      end;
  end;
end;



/// procedura, která otoèí požadovaný tvar o 90°
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

  aktualKosticka.setTvar(tmp); // možná nebude potøeba
  posun(smer, pole);
end;



/// procedura, která vymaže zaplnìné øádky a posune zbytek dolù
procedure TGameForm.vymazZaplneneRadky(pole : TImage);
var
  scoreCounter,radek,sloupec : Integer;
  kontrola : Boolean;
begin
  scoreCounter := 0;
  for radek := 0 to (Length(hraciPole)-1) do begin            /// projde všechny øádky hracího pole
    kontrola := true;

    for sloupec := 0 to (Length(hraciPole[0])-1) do begin            /// projde celý øádek po sloupcích

      if (hraciPole[radek][sloupec] = nil) then begin                /// pokud narazází na prázné pole, nastaví kontrolu na false a pøejde na další øádek
        kontrola := false;
        break;
      end;

    end;

    if kontrola then begin                                           /// pokud se kontrola = true, tak vykonej:

      GameUtils.umazRadek(radek, hraciPole);                                       /// umaž daný øádek
      hraciPole := GameUtils.posunZbytekDolu(radek, hraciPole);                    /// posuò zbytek pole dolù
      vykresleni(pole, hraciPole, Constants.HRA_POCET_VIDITELNYCH_RADKU);          /// vykresli hrací pole

      scoreCounter := scoreCounter + 1;
    end;
  end;

  case scoreCounter of                                                            /// pøiète odpovídající skóre, podle toho, kolik øádkù se smazalo
    1: score := score + Constants.SCORE_UMAZANI_RADKU * scorelvl;
    2: score := score + Constants.SCORE_UMAZANI_RADKU * scorelvl * 3;
    3: score := score + Constants.SCORE_UMAZANI_RADKU * scorelvl * 5;
  end;
end;




/// funkce která zrychluje èasovaè podle levelu
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




/// funkce která zvýší level podle skóre
function TGameForm.levelUp(score : Integer) : Integer;
begin
  if (score >= Constants.SCORE_LEVEL_5) then result:= 5
  else if (score >= Constants.SCORE_LEVEL_4) then result := 4
  else if (score >= Constants.SCORE_LEVEL_3) then result := 3
  else if (score >= Constants.SCORE_LEVEL_2) then result := 2
  else result := 1;
end;




/// procedura, ktrá zahájí Game Over
procedure TGameForm.gameOver;
begin
  Casovac.Enabled := false;     /// vypnutí èasovaèe

  Dialog.GameOver.ShowModal;    /// vyskoèí dialog pro uložení skóre
end;


end.
