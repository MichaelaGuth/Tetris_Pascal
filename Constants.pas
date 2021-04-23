unit Constants;

interface

Const
  HRA_POCET_RADKU = 24;
  HRA_POCET_VIDITELNYCH_RADKU = 20;
  HRA_POCET_SLOUPCU = 10;
  KOSTICKA_SIZE = 30;
  POCET_KOSTICEK = 7;
  POCATECNI_RYCHLOST = 1000;
  POCATECNI_SOURADNICE = 0;
  POCET_BAREV = 5;

  SCORE_UMAZANI_RADKU = 100;

  SCORE_LEVEL_2 = 2000;
  SCORE_LEVEL_3 = 5000;
  SCORE_LEVEL_4 = 10000;
  SCORE_LEVEL_5 = 20000;

  TIMER_LEVEL_1 = 1;
  TIMER_LEVEL_2 = 2;
  TIMER_LEVEL_3 = 3;
  TIMER_LEVEL_4 = 4;
  TIMER_LEVEL_5 = 5;

var
  Matice_Otoceni : TArray<Integer>;
  function maticeOtoceni : TArray<TArray<Integer>>;

implementation


function maticeOtoceni : TArray<TArray<Integer>>;
begin
  result := TArray<TArray<Integer>>.Create(
          TArray<Integer>.Create(0, -1),
          TArray<Integer>.Create(1, 0)
          );
end;

end.
