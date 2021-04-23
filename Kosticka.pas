unit Kosticka;

interface

uses Vcl.ExtCtrls;

type
  TKosticka = Class(TObject)
    private
      kosticka : TImage;
    public
      constructor Create(kost : TImage);
      function getKosticka : TImage;
  End;
  TKostickaEnum = (CERVENA, MODRA, ZELENA, ORANZOVA, FIALOVA);

implementation

constructor TKosticka.Create(kost: TImage);
begin
  self.kosticka := kost;
end;

function TKosticka.getKosticka;
begin
  result := kosticka;
end;


end.
