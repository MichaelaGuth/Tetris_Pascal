unit Smer;

interface
type
  TSmer = Class(TObject)
    private
      x,y : Integer;
    public
      constructor Create(x,y : Integer);
      function getX : Integer;
      function getY : Integer;
  End;
  TDolu = Class(TSmer)
    constructor Create();
  End;
  TDoleva = Class(TSmer)
    constructor Create();
  End;
  TDoprava = Class(TSmer)
    constructor Create();
  End;
  TNic = Class(TSmer)
    constructor Create();
  End;
var
  Dolu: TDolu;
implementation

constructor TSmer.Create(x: Integer; y: Integer);
begin
  self.x := x;
  self.y := y;
end;

function TSmer.getX;
begin
  result := x;
end;

function TSmer.getY;
begin
  result := y;
end;

constructor TDolu.Create;
begin
  inherited Create(0,1);
end;

constructor TDoleva.Create;
begin
  inherited Create(-1,0);
end;

constructor TDoprava.Create;
begin
  inherited Create(1,0);
end;

constructor TNic.Create;
begin
  inherited Create(0,0);
end;

end.
