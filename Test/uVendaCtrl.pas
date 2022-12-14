unit uVendaCtrl;  //FAKE

interface

uses 
  System.SysUtils, uVenda;

type
  TVendaCtrl = class
  private

  public
    constructor Create;
    destructor Destroy; override;  

    function Inserir(poVenda: TVenda; var MsgErr: String): Boolean;
  end;

implementation

constructor TVendaCtrl.Create;
begin
  //FVendaDAO := TVendaDAO.Create;
end;

destructor TVendaCtrl.Destroy;
begin
  //FreeAndNil(FVendaDAO);
  inherited;
end;

function TVendaCtrl.Inserir(poVenda: TVenda; var MsgErr: String): Boolean;
begin
  //result := FVendaDAO.Inserir(poVenda, MsgErr);
end;

end.