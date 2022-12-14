unit uVenda;

interface
 
uses 
  System.SysUtils, System.Classes, System.Generics.Collections,Vcl.Dialogs,uFDQueryCustom;

const  
  PERCENTUAL_IMPOSTO = 13;

type
  TTipoValor = (tpValorVenda, tpQtdLitro);

  TVenda = class
  private 
    FID: Integer;
    FDataVenda: TDate;
    FIDBomba: integer;
    FIDTanque: integer;
    FQtdLitro: double;
    FVlrLitro: double;
    FVlrAbastecido: double;
    FVlrImposto: double;
    FVlrLiquido: double;
    FMsgErro: String;
    function ValidaVenda: boolean;
  public
    procedure Clear;
    function Inserir: Boolean;
    procedure CalcularVenda(var pQtdLt: String; var pVlrAbastecido: String);
    procedure GerarRelatorio(pData1: TDate; pData2: TDate; const pQuery: TFDQueryCustom);

    property ID: Integer read FID write FID;
    property DataVenda: TDate read FDataVenda write FDataVenda;
    property IDBomba: Integer read FIDBomba write FIDBomba;
    property IDTanque: integer read FIDTanque write FIDTanque;
    property QtdLitro: Double read FQtdLitro write FQtdLitro;
    property VlrLitro: double read FVlrLitro write FVlrLitro;
    property VlrAbastecido: double read FVlrAbastecido write FVlrAbastecido;
    property VlrImposto: double read FVlrImposto write FVlrImposto;
    property VlrLiquido: Double read FVlrLiquido write FVlrLiquido;
    property MsgErro: String read FMsgErro write FMsgErro;  
  end;

implementation

uses
  uVendaCtrl;

function TVenda.Inserir: Boolean;
var
  sMsgErr: String;
  oVendaCtrl: TVendaCtrl;
begin
  oVendaCtrl := TVendaCtrl.Create;
  try
    if not ValidaVenda then
      exit;

    result := oVendaCtrl.Inserir(Self, sMsgErr);
    if not result then
    begin
      Self.FMsgErro := 'Não foi possivel incluir o registro, Motivo:' + sMsgErr;
    end;
  finally
    FreeAndNil(oVendaCtrl);
  end;
end;

procedure TVenda.CalcularVenda(var pQtdLt: String; var pVlrAbastecido: String);
var 
  dValorVenda: double;
  dQtdLitro: double;
  dValorImposto: double;
  enuTipoValor: TTipoValor;
begin
  if not ValidaVenda then
    exit;

  if Self.FVlrAbastecido > 0 then
    enuTipoValor := tpValorVenda;
    
  if Self.FQtdLitro > 0 then
    enuTipoValor := tpQtdLitro;

  case enuTipoValor of
    tpValorVenda:
      begin
        dValorVenda :=  Self.FVlrAbastecido;
        dQtdLitro := Self.FVlrAbastecido / Self.FVlrLitro;
      end; 
    tpQtdLitro:
      begin
        dQtdLitro := Self.FQtdLitro;
        dValorVenda := Self.FQtdLitro * Self.FVlrLitro;
      end;   
  end;
  dValorImposto := dValorVenda * (PERCENTUAL_IMPOSTO / 100);

  pQtdLt := FormatFloat('##0.000', dQtdLitro);
  pVlrAbastecido := FormatFloat('##0.00', dValorVenda);

  Self.FQtdLitro := dQtdLitro;
  Self.FVlrAbastecido := dValorVenda;
  Self.FVlrImposto := dValorImposto;
  Self.VlrLiquido := dValorVenda - dValorImposto;
end;

procedure TVenda.Clear;
begin
  FIDBomba := 0;
  FIDTanque := 0;
  FQtdLitro := 0;
  FVlrLitro := 0;
  FVlrAbastecido := 0;
  FVlrImposto := 0;
  FVlrLiquido := 0;
  FMsgErro := ''; 
end;

function TVenda.ValidaVenda: boolean;
begin
  result := True;

  result := not(Self.FIDBomba <= 0);
  if not result then
  begin
    raise Exception.Create('Selecione a bomba do abastecimento.');
    exit;
  end; 

  result := not((Self.FVlrLitro <= 0) and (Self.FVlrAbastecido <= 0));
  if not result then
  begin
    raise Exception.Create('Informe o valor ou a quantidade vendida.');
    exit;
  end; 
end;

procedure TVenda.GerarRelatorio(pData1: TDate; pData2: TDate; const pQuery: TFDQueryCustom);
var
  sMsgErr: String;
  oVendaCtrl: TVendaCtrl;
begin
  oVendaCtrl := TVendaCtrl.Create;
  try
    oVendaCtrl.GerarRelatorio(pData1,pData2, pQuery, sMsgErr);
    if sMsgErr <> EmptyStr then
    begin
      Self.FMsgErro := 'Não foi possivel incluir o registro, Motivo:' + sMsgErr;
      raise Exception.Create(Self.FMsgErro);
    end;
  finally
    FreeAndNil(oVendaCtrl);
  end;  
end;

end.