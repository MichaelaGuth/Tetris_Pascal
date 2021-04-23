unit score;

interface
uses System.SysUtils, Classes;

function nactiSoubor(nazevSouboru : String) : TStringList;
function rozdeleni(radek : String) : TArray<String>;
function seradScore(ulozeneScore : TStringList; index1, index2 : Integer) : Integer;

implementation
uses Highscore;

function rozdeleni(radek : String) : TArray<String>;
var chararray : Array[0..1] of Char;
begin
  chararray[0] := ':';
  chararray[1] := ' ';
  SetLength(result, 2);
  result[0] := radek.Split(chararray)[0];
  result[1] := radek.Split(chararray)[2];
end;

function nactiSoubor(nazevSouboru : String) : TStringList;
var   score : TStringList;
begin
  score := TStringList.Create;
  score.LoadFromFile(nazevSouboru);
  result := score;
end;

function seradScore(ulozeneScore : TStringList; index1, index2 : Integer) : Integer;
var
  radek1, radek2 : String;
  s1,s2 : TArray<String>;
begin
  radek1 := ulozeneScore[index1];
  s1 := rozdeleni(radek1);

  radek2 := ulozeneScore[index2];
  s2 := rozdeleni(radek2);

  result := StrToInt(s2[1]) - StrToInt(s1[1]);
end;

end.
