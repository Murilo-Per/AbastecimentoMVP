unit uBomba;

interface
 
uses 
  System.SysUtils, System.Classes, Vcl.Dialogs;

type
  TBomba = class
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
  uBombaCtrl;

function TBomba.Inserir: Boolean;
var 
  sMsgErr: String;
 oBombaCtrl: TBombaCtrl;
begin
 oBombaCtrl := TBombaCtrl.Create;
  try 
    result :=oBombaCtrl.Inserir(Self, sMsgErr);
    if not result then
    begin
      Self.FMsgErro := sMsgErr;
      ShowMessage('Não foi possivel incluir o registro, Motivo:' + Self.MsgErro);
    end; 
  finally
    FreeAndNil(oBombaCtrl);   
  end;  
end;

end.