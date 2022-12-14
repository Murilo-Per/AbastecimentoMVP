unit uTanqueCtrl;

interface

uses 
  System.SysUtils, uConexao, uTanque, uTanqueDAO;

type
  TTanqueCtrl = class
  private
    FTanqueDAO: TTanqueDAO;
  public
    constructor Create;
    destructor Destroy; override;  

    function Inserir(poTanque: TTanque; var MsgErr: String): Boolean;
  end;

implementation

constructor TTanqueCtrl.Create;
begin
  FTanqueDAO := TTanqueDAO.Create;
end;

destructor TTanqueCtrl.Destroy;
begin
  FreeAndNil(FTanqueDAO);
  inherited;
end;

function TTanqueCtrl.Inserir(poTanque: TTanque; var MsgErr: String): Boolean;
begin
  result := FTanqueDAO.Inserir(poTanque, MsgErr);
end;

end.