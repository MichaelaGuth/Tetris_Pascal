unit GameUtils;

interface

uses
  Kosticka, Tvar, Smer, System.Generics.Collections, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Constants;

type
  VlozeniKostkyStatus = (OK, KOLIZE_SE_STENOU, KOLIZE_S_KONCEM, KOLIZE_S_KOSTKOU_ZE_STRANY);   //enum
  function copy(src : TArray<TArray<TKosticka>>) : TArray<TArray<TKosticka>>;
  function vlozeniKosticky(kostka : TTvar; zdroj,novePole : TArray<TArray<TKosticka>>; smer : TSmer) : VlozeniKostkyStatus;
  function nasobeniMatic(pole1,pole2 : TArray<TArray<Integer>>) : TArray<TArray<Integer>>;
  procedure umazRadek(radek : Integer; hraciPole : TArray<TArray<TKosticka>>);
  function posunZbytekDolu(prazdnyRadek : Integer; hraciPole : TArray<TArray<TKosticka>>) : TArray<TArray<TKosticka>>;
  function kontrolaGameOver(hraciPole : TArray<TArray<TKosticka>>) : boolean;
  function nahodnaKosticka(kostickyImages : TDictionary<TKostickaEnum,TImage>) : TTvar;
  function nahodnaBarva(kostickyImages : TDictionary<TKostickaEnum,TImage>) : TImage;

implementation

// zkopíruje pole kostièek
function copy(src : TArray<TArray<TKosticka>>) : TArray<TArray<TKosticka>>;
var
  copy : TArray<TArray<TKosticka>>;
  i,j : Integer;
begin
  SetLength(copy,Length(src),Length(src[0]));
  for i := 0 to (Length(src)-1) do begin
    for j := 0 to (Length(src[0])-1) do begin
      copy[i][j] := src[i][j];
    end;
  end;
  result := copy;
end;

// pokusi se vlozit kostku do hraciho pole
function vlozeniKosticky(kostka : TTvar; zdroj,novePole : TArray<TArray<TKosticka>>; smer : TSmer) : VlozeniKostkyStatus;
var
  x,y,radek,sloupec : Integer;
  status : VlozeniKostkyStatus;
  smer2 : TSmer;
  label
    loop;
begin

  x := kostka.getX() + smer.getX(); //zmìna souøednic
  y := kostka.getY() + smer.getY();

  status := VlozeniKostkyStatus.OK;

  for radek := 0 to (Length(kostka.getTvar)-1) do begin
    for sloupec := 0 to (Length(kostka.getTvar[0])-1) do begin

      if (kostka.getTvar[radek][sloupec] = nil) then continue;

      if (((sloupec + x) >= Length(zdroj[0])) or ((sloupec + x) < 0)) then begin    //kontrola jestli kostka nenarazila na levou nebo pravou stìnou
        status := VlozeniKostkyStatus.KOLIZE_SE_STENOU;
        GoTo loop;
      end;

      if ((radek + y) = Length(zdroj)) then begin     //kontrola jestli kostka nedopadla ke spodní hranì
        status := VlozeniKostkyStatus.KOLIZE_S_KONCEM;
        GoTo loop;
      end;

      if (zdroj[radek + y][sloupec + x] = nil) then
        novePole[radek + y][sloupec + x] := kostka.getTvar()[radek][sloupec]
      else begin
        smer2 := TDolu.Create;
        if ((smer.getX <> smer2.getX) and (smer.getY <> smer2.getY)) then
          status := VlozeniKostkyStatus.KOLIZE_S_KOSTKOU_ZE_STRANY
        else
          status := VlozeniKostkyStatus.KOLIZE_S_KONCEM;
        GoTo loop;
      end;
    end;
    loop:
  end;

  result := status;
end;

// vynásobí 2 matice
function nasobeniMatic(pole1,pole2 : TArray<TArray<Integer>>) : TArray<TArray<Integer>>;
var
  novaMatice : TArray<TArray<Integer>>;
  j,i,sloupec,radek : Integer;
begin
  SetLength(novaMatice, Length(pole1), Length(pole2[0]));
  j := 0;
  for radek := 0 to (Length(novaMatice)-1) do begin
    for sloupec := 0 to (Length(novaMatice[0])-1) do begin
      for i := 0 to (Length(pole1[0])-1) do begin
        j := j + pole1[radek][i] * pole2[i][sloupec];
      end;
      novaMatice[radek][sloupec] := j;
      j := 0;
    end;
  end;
  result := novaMatice;
end;

// vynuluje hodnoty v daném øádku
procedure umazRadek(radek : Integer; hraciPole : TArray<TArray<TKosticka>>);
var
  sloupec : Integer;
begin
  for sloupec := 0 to (Length(hraciPole[0])-1) do hraciPole[radek][sloupec] := nil;
end;

// posune zbylé kostky dolù, aby zaplnili prázdný øádek
function posunZbytekDolu(prazdnyRadek : Integer; hraciPole : TArray<TArray<TKosticka>>) : TArray<TArray<TKosticka>>;
var
  copy : TArray<TArray<TKosticka>>;
  radek,sloupec : Integer;
begin
  copy := GameUtils.copy(hracipole);

  for radek := (prazdnyRadek) downto 1 do begin
    for sloupec := 0 to (Length(hraciPole[0])-1) do copy[radek][sloupec] := hraciPole[radek-1][sloupec];
  end;

  result := copy;
end;

// kontroluje jestli již nenastal GameOver
function kontrolaGameOver(hraciPole : TArray<TArray<TKosticka>>) : boolean;
var
  sloupec : Integer;
  label
    hop;
begin
  for sloupec := 0 to (Length(hraciPole[0])-1) do begin
    if (hraciPole[4][sloupec] <> nil) then begin
      result := true;
      GoTo hop;
    end;
  end;
  result := false;
  hop:
end;

// vygeneruje náhodnou barvu kosticky
function nahodnaBarva(kostickyImages : TDictionary<TKostickaEnum,TImage>) : TImage;
var
  vals: TArray<TKostickaEnum>;
begin
  vals := TArray<TKostickaEnum>.Create(CERVENA, MODRA, ZELENA, ORANZOVA, FIALOVA);
  Randomize;
  result := kostickyImages.Items[vals[Random(Length(vals))]];
end;

// vygeneruje náhodnou kosticku
function nahodnaKosticka(kostickyImages : TDictionary<TKostickaEnum,TImage>) : TTvar;
var
  randomindex : Integer;
  image : TImage;
begin
  Randomize;
  randomindex := Random(7);
  image := nahodnaBarva(kostickyImages);

  case randomindex of
    0 : result := TZkoNormal.Create(image);
    1 : result := TZkoMirror.Create(image);
    2 : result := TCtverec.Create(image);
    3 : result := TTrubka.Create(image);
    4 : result := TTkoKosticka.Create(image);
    5 : result := TLkoNormal.Create(image);
    6 : result := TLkoMirror.Create(image);
    else result := TLkoMirror.Create(image);
  end;
end;


end.
