unit uBombaDAO;

interface

uses
  System.SysUtils, uDAO, uConexao, uBomba;

const 
  TABELA = 'Bomba';
  GEN_ID = 'GEN_BOMBA_ID';

type
  TBombaDAO = class(TDAO)
  public
    constructor Create;
    
    function Inserir(poBomba: TBomba; var MsgErr: String): Boolean;
    function Alterar(poBomba: TBomba; var MsgErr: String): Boolean;
    function Deletar(poBomba: TBomba; var MsgErr: String): Boolean;    
  end;

implementation

uses 
  uFDQueryCustom;

constructor TBombaDAO.Create;
begin
  inherited;  
end;

function TBombaDAO.Inserir(poBomba: TBomba; var MsgErr: String): Boolean;
var
  iID: integer;
begin
  result := True;

  try
    IniciarQuery();
    FQuery.TipoQuery := tpInsert;
    FQuery.AddColuna('ID');
    FQuery.AddColuna('DESCRICAO');
    FQuery.AddTabela(TABELA);
    FQuery.Prepare;

    FConexao.Conexao.StartTransaction;

    iID := FConexao.GetID(GEN_ID);
    FQuery.Params[0].AsInteger := iID;
    FQuery.Params[1].AsString := poBomba.Descricao;

    FQuery.Executar;

    poBomba.ID := iID;
    FConexao.Conexao.Commit;
  except
    on E: Exception do
    begin
      MsgErr := E.Message;
      Result := False;
      FConexao.Conexao.Rollback;
    end;
  end;  
end;

function TBombaDAO.Alterar(poBomba: TBomba; var MsgErr: String): Boolean;
begin
  result := True;    
end;

function TBombaDAO.Deletar(poBomba: TBomba; var MsgErr: String): Boolean;
begin
  result := True;
end;

end.