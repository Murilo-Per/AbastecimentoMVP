unit uDadosConexao;

interface 

// CONST_BASE = 'D:\Murilo\Projeto\Dados\BASE.FDB'; 
// CONST_LOGIN = 'SYSDBA'; 
// CONST_SENHA = 'masterkey'; 
// CONST_MSGERRO = '';  
uses 
  System.SysUtils, System.IniFiles;

type
  TDadosConexao = class
    FBASE: String;
    FLOGIN: String;
    FSENHA: String;
    FPATHIMG: String;
    function GetImgFilePath: string;
  public

    constructor Create;
    procedure GetIniData;


    property CONST_BASE: String read FBASE;
    property CONST_LOGIN: String read FLOGIN;
    property CONST_SENHA: String read FSENHA;
    property CONST_FPATHIMG: string read GetImgFilePath;

end;


implementation

function TDadosConexao.GetImgFilePath: string;
begin
  Result := FPATHIMG;
end;

procedure TDadosConexao.GetIniData;
var
  vIniConf: TIniFile;
begin
  try
    if not (FileExists(ExtractFilePath(ParamStr(0)) + 'IniConf.INI')) then
    begin
      vIniConf := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'IniConf.INI');
      vIniConf.WriteString('BANCO_DADOS', 'BASE', (ExtractFilePath(ParamStr(0))+'DADOS\BASE.FDB'));
      vIniConf.WriteString('BANCO_DADOS', 'LOGIN', 'SYSDBA');
      vIniConf.WriteString('BANCO_DADOS', 'SENHA', 'masterkey');
      vIniConf.WriteString('ASSETS', 'IMGBOMBA',ExtractFilePath(ParamStr(0)) + 'ASSETS\');
    end;

    if not Assigned(vIniConf) then
      vIniConf := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'IniConf.INI');

    FBASE := vIniConf.ReadString('BANCO_DADOS', 'BASE', '');
    FLOGIN := vIniConf.ReadString('BANCO_DADOS', 'LOGIN','' );
    FSENHA := vIniConf.ReadString('BANCO_DADOS', 'SENHA', '');
    FPATHIMG := vIniConf.ReadString('ASSETS', 'IMGBOMBA','');
  finally
    FreeAndNil(vIniConf);
  end;
end;

constructor TDadosConexao.Create;
begin
  inherited;
  GetIniData();
end;

end.