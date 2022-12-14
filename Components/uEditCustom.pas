unit uEditCustom;

interface
uses 
  System.SysUtils, Vcl.StdCtrls;

type
  TEditCustom = class helper for TEdit
    public 
      procedure Limpar;
      function GetValor: Double;
  end;

implementation

procedure TEditCustom.Limpar;
begin
  case Self.Tag of
    0: Self.Text := '0,00';
    1: Self.Text := '0,000';
  end;
end;

function TEditCustom.GetValor: Double;
begin
  result := StrToFloatDef(Self.Text, 0);
end;

end.