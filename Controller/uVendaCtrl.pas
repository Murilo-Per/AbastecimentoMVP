unit uVendaCtrl;

interface

uses 
  System.SysUtils, uConexao, uVenda, uVendaDAO, uFDQueryCustom;

type
  TVendaCtrl = class
  private
    FVendaDAO: TVendaDAO;
  public
    constructor Create;
    destructor Destroy; override;  

    function Inserir(poVenda: TVenda; var MsgErr: String): Boolean;
    procedure GerarRelatorio(pData1: TDate; pData2: TDate; const pQuery: TFDQueryCustom; var MsgErr: String);
  end;

implementation

constructor TVendaCtrl.Create;
begin
  FVendaDAO := TVendaDAO.Create;
end;

destructor TVendaCtrl.Destroy;
begin
  FreeAndNil(FVendaDAO);
  inherited;
end;

function TVendaCtrl.Inserir(poVenda: TVenda; var MsgErr: String): Boolean;
begin
  
  result := FVendaDAO.Inserir(poVenda, MsgErr);
end;

procedure TVendaCtrl.GerarRelatorio(pData1: TDate; pData2: TDate; const pQuery: TFDQueryCustom; var MsgErr: String);
begin
  FVendaDAO.GerarRelatorio(pData1, pData2, pQuery,MsgErr);
end;

end.