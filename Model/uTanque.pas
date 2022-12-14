unit uTanque;

interface
 
uses 
  System.SysUtils, System.Classes, Vcl.Dialogs;

type
  TTanque = class
  private 
    FID: Integer;
    FDescricao: String;
    FMsgErro: String;
  public
    function Inserir: Boolean;

    property ID: Integer read FID write FID;
    property Descricao: String read FDescricao write FDescricao;
    property MsgErro: String read FMsgErro write FMsgErro;  
  end;

implementation

uses
  uTanqueCtrl;

function TTanque.Inserir: Boolean;
var 
  sMsgErr: String;
  oTanqueCtrl: TTanqueCtrl;
begin
  oTanqueCtrl := TTanqueCtrl.Create;
  try 
    result := oTanqueCtrl.Inserir(Self, sMsgErr);
    if not result then
    begin
      Self.FMsgErro := sMsgErr;
      ShowMessage('Não foi possivel incluir o registro, Motivo:' + Self.MsgErro);
    end; 
  finally
    FreeAndNil(oTanqueCtrl);   
  end;  
end;

end.