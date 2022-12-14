unit uFDQueryCustom;

interface

uses
  System.SysUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, 
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.DApt;


type
  TTipoQuery = (tpIndefinido, tpSelect, tpInsert, tpUpdate, tpDelete);

  TFDQueryCustom = class(TFDQuery)
  protected
    FColunas: String;
    FTabelas: String;
    FCondicao: String;
    FOrder: String;
    FParametros: String;
    FSqlPronta: Boolean;
    FTipoQuery: TTipoQuery;
  public
    property TipoQuery: TTipoQuery read FTipoQuery write FTipoQuery; 
    property SqlPronta: Boolean write FSqlPronta;
  end;

  TFDQueryHelper = class helper for TFDQueryCustom
  private
    function ValidarCondicao: Boolean;
    function GetSQLTipo(const pTipoQuery: TTipoQuery): String;
    procedure ValidarTipoQuery;
    procedure AddColunaInterno(const FTipoQuery: TTipoQuery; pColuna: String); overload;
    procedure MontaSql;
  public
    procedure Clear;
    procedure AddColuna(pColuna: String);
    procedure AddTabela(pTabela: String);
    procedure AddCondicao(pCondicao: String);
    procedure AddOrder(pOrder: String);
    procedure Prepare;

    procedure Executar;
  end;

implementation

{ TFDQueryHelper }

procedure TFDQueryHelper.AddColuna(pColuna: String);
var 
  sSqlTipo: String;  
begin
  if pColuna = EmptyStr then
    exit;

  ValidarTipoQuery;
  AddColunaInterno(FTipoQuery, pColuna);
end;

procedure TFDQueryHelper.AddTabela(pTabela: String);
const 
  sFROM = ' FROM ';
begin
  if pTabela = EmptyStr then
    exit;  

  if FTipoQuery in [tpInsert, tpUpdate]  then
  begin
    FColunas := Format((FColunas + FParametros), [pTabela])
  end;

  if FTipoQuery in [tpSelect, tpDelete]  then
  begin
    if FTabelas = EmptyStr then
    begin
      FTabelas := sFROM + pTabela;
    end  
    else 
      FTabelas := FTabelas + ', ' + pTabela;
  end;    
end;

procedure TFDQueryHelper.AddCondicao(pCondicao: String);
const 
  sWHERE = ' WHERE ';
begin
  if pCondicao = EmptyStr then
    exit;

  if FCondicao = EmptyStr then
  begin
    FCondicao := sWHERE + pCondicao;
  end  
  else 
    FCondicao := FCondicao + ' and ' + pCondicao;
end;

procedure TFDQueryHelper.AddOrder(pOrder: String);
const 
  sORDER = ' ORDER BY ';
begin
  if pOrder = EmptyStr then
    exit;

  if FOrder = EmptyStr then
  begin
    FOrder := sORDER + pOrder;
  end  
  else 
    FOrder := FOrder + ', ' + pOrder;
end;

procedure TFDQueryHelper.Executar;
begin
  Prepare;

  case FTipoQuery of
    tpSelect:
      begin
        Self.Open;
      end;
    tpInsert:
      begin
        Self.ExecSQL;
      end;
    tpUpdate, tpDelete:
      begin
        if ValidarCondicao then
        begin
          Self.ExecSQL;
        end;  
      end;
  end;
end;

function TFDQueryHelper.ValidarCondicao: Boolean;
begin
  if FCondicao <> '' then
    raise Exception.Create('Declare uma condição para executar esse comando.');
end;

function TFDQueryHelper.GetSQLTipo(const pTipoQuery: TTipoQuery): String;
const 
  sSELECT = 'SELECT ';
  sINSERT = 'INSERT INTO %s ';
  sUPDATE = 'UPDATE %s SET'; 
  sDELETE = 'DELETE ';
begin
  case pTipoQuery of
    tpSelect: result := sSELECT;
    tpInsert: result := sINSERT;
    tpUpdate: result := sUPDATE;
    tpDelete: result := sDELETE;
  end; 
end;

procedure TFDQueryHelper.ValidarTipoQuery;
begin
  if FTipoQuery = tpIndefinido then
    raise Exception.Create('Tipo da query não foi definido.');
end;

procedure TFDQueryHelper.AddColunaInterno(const FTipoQuery: TTipoQuery; pColuna: String);
begin
  case FTipoQuery of
    tpSelect, tpDelete:
      begin
        if FColunas = EmptyStr then
          FColunas := GetSQLTipo(FTipoQuery) + pColuna
        else 
          FColunas := FColunas + ', ' + pColuna;
    end;
    tpInsert:
      begin
        if FColunas = '' then
        begin
          FColunas := GetSQLTipo(FTipoQuery) + '(' + pColuna + ')';
          FParametros := ' VALUES(' + ':' + pColuna + ')';
        end
        else
        begin 
          FColunas := copy(FColunas, 0, Length(FColunas)-1) + ', ' + pColuna + ')';
          FParametros := copy(FParametros, 0, Length(FParametros)-1) + ', :' + pColuna + ')';
        end;  
      end;
    tpUpdate:
      begin
        if FColunas = EmptyStr then
          FColunas := GetSQLTipo(FTipoQuery) + pColuna + '=' + ' :' + pColuna
        else
          FColunas := FColunas + ', ' + pColuna + '=' + ' :' + pColuna;
      end;
  end;
end;

procedure TFDQueryHelper.MontaSql;
begin
  if FSqlPronta then
    Exit;

  Self.SQL.Append(FColunas);
  
  if FTipoQuery = tpUpdate then
    Self.SQL.Text := Format(Self.SQL.Text, [FTabelas])
  else
    Self.SQL.Append(FTabelas);

  Self.SQl.Append(FCondicao);

  if FOrder <> EmptyStr then
    Self.SQL.Append(FOrder);
end;

procedure TFDQueryHelper.Prepare;
begin
  Self.MontaSql;
  Self.SqlPronta := True;
end;

procedure TFDQueryHelper.Clear;
begin
  Self.Close;
  Self.SQL.Clear;
  Self.Params.Clear;
  Self.SqlPronta := False;
end;

end.