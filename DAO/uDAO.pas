unit uDAO;

interface

uses
  uConexao, System.SysUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, 
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, uFDQueryCustom;

type
  TDAO = class
  protected
    FConexao: TConexao;
    FQuery: TFDQueryCustom;

    constructor Create;
    destructor Destroy; override;
    procedure IniciarQuery();
  end;  
implementation

{ TDAO }

constructor TDAO.Create;
begin
  FConexao := TConexao.GetInstance();
  FQuery := TFDQueryCustom.Create(nil);
  FQuery.Connection := FConexao.Conexao;
end;

destructor TDAO.Destroy;
begin
  FreeAndNil(FQuery);
  inherited;
end;

procedure TDAO.IniciarQuery;
begin
  FQuery.Clear;
end;

end.