unit uConexao;

interface

uses
  System.SysUtils, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, uDadosConexao;

type
  TConexao = class
    private
      class var FConexao: TFDConnection;
      class var FBase: String; 
      class var FLogin: String;
      class var FSenha: String;
      class var FMsgErro: String;
      class var FInstancia: TConexao;
      class var FDadosConexao: TDadosConexao;

      constructor Create;
      constructor CreatePrivado;
      
      class function Conectar: Boolean;
      class procedure ReleaseInstance();
    public
      class function GetID(pGenID: String): Integer;
      class function GetInstance():TConexao;
      
      class property Conexao: TFDConnection read FConexao write FConexao;
      class property Base: String read FBase write FBase;
      class property Login: String read FLogin write FLogin;
      class property Senha: String read FSenha write FSenha;
      class property MsgErro: String read FMsgErro write FMsgErro;
  end;

implementation

constructor TConexao.Create;
begin
  raise Exception.Create('Para obter uma instância de TUsuario utilize TConexao.GetInstance !');
end;

constructor TConexao.CreatePrivado;
begin
  inherited Create;
  FDadosConexao := TDadosConexao.Create;
  FBase := FDadosConexao.CONST_BASE;
  FLogin := FDadosConexao.CONST_LOGIN;
  FSenha := FDadosConexao.CONST_SENHA;
  FConexao := TFDConnection.Create(nil);
  Conectar;  
end;

class function TConexao.GetInstance: TConexao;
begin
  if not Assigned(Self.FInstancia) then
    Self.FInstancia := TConexao.CreatePrivado;

  result := Self.FInstancia;
end;

class procedure TConexao.ReleaseInstance;
begin
  if Assigned(Self.FInstancia) then
    Self.FInstancia.Free;
end;

class function TConexao.Conectar: Boolean;
begin
  result := True;
  
  FConexao.Params.Clear;
  FConexao.Params.DriverID := 'FB';
  FConexao.params.Database := FBase;
  FConexao.Params.UserName := FLogin;
  FConexao.Params.Password := FSenha;
  FConexao.LoginPrompt := False;

  try
    FConexao.Connected := True;
  except
    on E: Exception do
    begin 
      FMsgErro := E.message;
      Result := False;
    end;
  end;  
end;

class function TConexao.GetID(pGenID: String): Integer;
var  
  vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FConexao;
    vQuery.SQL.Text := Format('select gen_id(%s, 1) from rdb$database',[pGenID]);
    vQuery.Open;

    result := vQuery.Fields[0].AsInteger;
  finally
    FreeAndNil(vQuery);
  end;
end;

initialization
finalization
  TConexao.ReleaseInstance();
end.