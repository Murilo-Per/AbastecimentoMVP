unit uVendaDAO;

interface

uses
  System.SysUtils, uDAO, uConexao, uVenda, uFDQueryCustom;

const 
  TABELA = 'VENDA';
  GEN_ID = 'GEN_VENDA_ID';

type
  TVendaDAO = class(TDAO)
  public
    constructor Create;
    
    function Inserir(poVenda: TVenda; var MsgErr: String): Boolean;
    function Alterar(poVenda: TVenda; var MsgErr: String): Boolean;
    function Deletar(poVenda: TVenda; var MsgErr: String): Boolean;    

    procedure GerarRelatorio(pData1: TDate; pData2: TDate; const pQuery: TFDQueryCustom; var MsgErr: String);
  end;

implementation

constructor TVendaDAO.Create;
begin
  inherited;  
end;

function TVendaDAO.Inserir(poVenda: TVenda; var MsgErr: String): Boolean;
var
  iID: integer;
begin
  result := True;

  try
    IniciarQuery();
    FQuery.TipoQuery := tpInsert;
    FQuery.AddColuna('ID');
    FQuery.AddColuna('DATA_VENDA');
    FQuery.AddColuna('FK_BOMBA');
    FQuery.AddColuna('FK_TANQUE');
    FQuery.AddColuna('QTD_LITROS');
    FQuery.AddColuna('VLR_LITRO');
    FQuery.AddColuna('VLR_ABASTECIDO');
    FQuery.AddColuna('VLR_IMPOSTO');
    FQuery.AddColuna('VLR_LIQUIDO');

    FQuery.AddTabela(TABELA);
    FQuery.Prepare;

    FConexao.Conexao.StartTransaction;

    iID := FConexao.GetID(GEN_ID);
    FQuery.Params[0].AsInteger := iID;
    FQuery.Params[1].AsDate := Date;
    FQuery.Params[2].AsInteger := poVenda.IDBomba;
    FQuery.Params[3].AsInteger := poVenda.IDTanque;
    FQuery.Params[4].AsFloat := poVenda.QtdLitro;
    FQuery.Params[5].asFloat := poVenda.VlrLitro;
    FQuery.Params[6].asFloat := poVenda.VlrAbastecido;
    FQuery.Params[7].asFloat := poVenda.VlrImposto;
    FQuery.Params[8].asFloat := poVenda.VlrLiquido;

    FQuery.Executar;

    poVenda.ID := iID;
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

function TVendaDAO.Alterar(poVenda: TVenda; var MsgErr: String): Boolean;
begin
   result := True;    
end;

function TVendaDAO.Deletar(poVenda: TVenda; var MsgErr: String): Boolean;
begin
   result := True;
end;

procedure TVendaDAO.GerarRelatorio(pData1: TDate; pData2: TDate; const pQuery: TFDQueryCustom; var MsgErr: String);
begin
  try
    pQuery.Connection := FConexao.Conexao;
    pQuery.TipoQuery := tpSelect;
    pQuery.AddColuna('DATA_VENDA');
    pQuery.AddColuna('FK_BOMBA');
    pQuery.AddColuna('FK_TANQUE');
    pQuery.AddColuna('QTD_LITROS');
    pQuery.AddColuna('VLR_LITRO');
    pQuery.AddColuna('VLR_ABASTECIDO');
    pQuery.AddColuna('VLR_IMPOSTO');
    pQuery.AddColuna('VLR_LIQUIDO');

    pQuery.AddTabela(TABELA);

    pQuery.AddCondicao('data_venda between :d1 and :d2');
    pQuery.AddOrder('data_venda, fk_tanque, fk_bomba');

    pQuery.Prepare;

    pQuery.Params[0].AsDate := pData1;
    pQuery.Params[1].AsDate := pData2;

    FConexao.Conexao.StartTransaction;

    pQuery.Executar;

    //pQuery.CopyDataSet(FQuery);
    FConexao.Conexao.Commit;
  except
    on E: Exception do
    begin
      MsgErr := E.Message;
      FConexao.Conexao.Rollback;
    end;
  end;  
end;

end.