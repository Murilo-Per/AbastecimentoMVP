unit uBombaCtrl;

interface

uses 
  System.SysUtils, uConexao, uBomba, uBombaDAO;

type
  TBombaCtrl = class
  private
    FBombaDAO: TBombaDAO;
  public
    constructor Create;
    destructor Destroy; override;  

    function Inserir(poBomba: TBomba; var MsgErr: String): Boolean;
  end;

implementation

constructor TBombaCtrl.Create;
begin
  FBombaDAO := TBombaDAO.Create;
end;

destructor TBombaCtrl.Destroy;
begin
  FreeAndNil(FBombaDAO);
  inherited;
end;

function TBombaCtrl.Inserir(poBomba: TBomba; var MsgErr: String): Boolean;
begin
  result := FBombaDAO.Inserir(poBomba, MsgErr);
end;

end.