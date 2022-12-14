unit uTanqueDAO;

interface

uses
  System.SysUtils, uDAO, uConexao, uTanque;

const 
  TABELA = 'TANQUE';
  GEN_ID = 'GEN_BOMBA_ID';

type
  TTanqueDAO = class(TDAO)
  public
    constructor Create;
    
    function Inserir(poTanque: TTanque; var MsgErr: String): Boolean;
    function Alterar(poTanque: TTanque; var MsgErr: String): Boolean;
    function Deletar(poTanque: TTanque; var MsgErr: String): Boolean;    
  end;

implementation

uses 
  uFDQueryCustom;

constructor TTanqueDAO.Create;
begin
  inherited;  
end;

function TTanqueDAO.Inserir(poTanque: TTanque; var MsgErr: String): Boolean;
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
    FQuery.Params[1].AsString := poTanque.Descricao;

    FQuery.Executar;

    poTanque.ID := iID;
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

function TTanqueDAO.Alterar(poTanque: TTanque; var MsgErr: String): Boolean;
begin
   result := True;    
end;

function TTanqueDAO.Deletar(poTanque: TTanque; var MsgErr: String): Boolean;
begin
   result := True;
end;

end.