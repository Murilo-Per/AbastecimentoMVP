unit uAbastecimento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uConexao, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.Imaging.pngimage, uEditCustom, uVenda, Vcl.ComCtrls;

type
  TBombaSelect = Record
    FPathImgFile: String;
    FBombaActive: Integer;
  end;


  TFrAbastecimento = class(TForm)
    edtQtdLitro: TEdit;
    edtVlrTotal: TEdit;
    pnlDisplay: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    pnlTop: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    grpValores: TGroupBox;
    imgGBomba1: TImage;
    Panel1: TPanel;
    Label8: TLabel;
    Panel2: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Panel3: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Panel4: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label7: TLabel;
    imgGBomba2: TImage;
    imgDBomba1: TImage;
    imgDBomba2: TImage;
    lblValorPagar: TLabel;
    lblLitros: TLabel;
    Image1: TImage;
    edtVlrGas: TEdit;
    edtVlrDiesel: TEdit;
    Panel5: TPanel;
    btnConfirmarVenda: TButton;
    Label17: TLabel;
    Label18: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure imgGBomba1Click(Sender: TObject);
    procedure edtVlrTotalKeyPress(Sender: TObject; var Key: Char);
    procedure edtVlrTotalEnter(Sender: TObject);
    procedure edtVlrDieselExit(Sender: TObject);
    procedure edtVlrTotalExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnConfirmarVendaClick(Sender: TObject);
    procedure edtQtdLitroKeyPress(Sender: TObject; var Key: Char);
    procedure edtVlrDieselKeyPress(Sender: TObject; var Key: Char);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
    BombaCtrl: TBombaSelect;
    oVenda: TVenda;
    procedure SetupBomba(pImgPath: String);
    procedure SelecionarBomba(pSender: TObject);
    function GetImgFile:String;
    procedure LimparEdits;
    procedure IniciarEdits;
    procedure FiltrarCaracteres(pSender: TObject;var Key: Char);
    procedure FormatarEdits(const pSender: TObject);
    procedure IniciarVenda;
  public
    { Public declarations }
  end;

var
  FrAbastecimento: TFrAbastecimento;

implementation

uses
  uTanque, uDadosConexao, uRelatorio;

{$R *.dfm}

procedure TFrAbastecimento.btnConfirmarVendaClick(Sender: TObject);
begin
  if not oVenda.Inserir then
  begin
    if oVenda.MsgErro <> '' then
      ShowMessage(oVenda.MsgErro);
  end
  else
  begin
    LimparEdits;
    if edtQtdLitro.CanFocus then
      edtQtdLitro.SetFocus;
  end;
end;

procedure TFrAbastecimento.edtQtdLitroKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    FormatarEdits(Sender);
    IniciarVenda;
    edtQtdLitro.Limpar;
    edtVlrTotal.Limpar;
    if btnConfirmarVenda.CanFocus then
      btnConfirmarVenda.SetFocus;
  end;

  FiltrarCaracteres(Sender, Key);
end;

procedure TFrAbastecimento.edtVlrDieselExit(Sender: TObject);
begin
  FormatarEdits(Sender);
end;

procedure TFrAbastecimento.edtVlrDieselKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
   SelectNext(Sender as tWinControl, True, True);

  FiltrarCaracteres(Sender, Key);
end;

procedure TFrAbastecimento.edtVlrTotalEnter(Sender: TObject);
begin
  if TEdit(Sender).CanFocus then
  begin
    TEdit(Sender).SetFocus;
    TEdit(Sender).SelectAll;
  end;
end;

procedure TFrAbastecimento.edtVlrTotalExit(Sender: TObject);
begin
  FormatarEdits(Sender);
end;

procedure TFrAbastecimento.edtVlrTotalKeyPress(Sender: TObject; var Key: Char);
begin
  FiltrarCaracteres(Sender, Key);
end;

procedure TFrAbastecimento.FormatarEdits(const pSender: TObject);
begin
  if (TEdit(pSender).Text = EmptyStr) or (TEdit(pSender).Text = '0') then
    TEdit(pSender).Limpar
  else
  try
    if ((TEdit(pSender).Text = '0,00') or (TEdit(pSender).Text = '0,000')) then
      exit
    else
      if (TEdit(pSender).Tag = 0) then
        TEdit(pSender).Text := FormatFloat('##0.00',StrtoFloat(TEdit(pSender).Text))
      else
        TEdit(pSender).Text := FormatFloat('##0.000',StrtoFloat(TEdit(pSender).Text));
  except
    on econverterror do
    begin
      TEdit(pSender).Limpar;
    end;
  end;
end;

procedure TFrAbastecimento.FormCreate(Sender: TObject);
begin
  BombaCtrl.FPathImgFile := GetImgFile();
  SelecionarBomba(nil);
  IniciarEdits;
  oVenda := TVenda.Create;
end;

procedure TFrAbastecimento.FormDestroy(Sender: TObject);
begin
  FreeAndNil(oVenda);
end;

function TFrAbastecimento.GetImgFile: String;
var
  oDadosConexao: TDadosConexao;
begin
  oDadosConexao := TDadosConexao.Create;
  try
    result := oDadosConexao.GetImgFilePath;
  finally
    FreeAndNil(oDadosConexao);
  end;
end;

procedure TFrAbastecimento.Image1Click(Sender: TObject);
var
  FrRelatorio: TFrRelatorio;
begin
  FrRelatorio := TFrRelatorio.Create(Self);
  FrRelatorio.ShowModal;
  FreeAndNil(FrRelatorio);
end;

procedure TFrAbastecimento.imgGBomba1Click(Sender: TObject);
begin
  SelecionarBomba(Sender);
end;

procedure TFrAbastecimento.LimparEdits;
begin
  edtQtdLitro.Limpar;
  edtVlrTotal.Limpar;
  lblValorPagar.Caption := '0,00';
  lblLitros.Caption := '0,000';
  oVenda.Clear;
end;

procedure TFrAbastecimento.IniciarEdits;
begin
  edtQtdLitro.Limpar;
  edtVlrTotal.Limpar;
  edtVlrDiesel.Limpar;
  edtVlrGas.Limpar;
  lblValorPagar.Caption := '0,00';
  lblLitros.Caption := '0,000';
end;

procedure TFrAbastecimento.SelecionarBomba(pSender: TObject);
const
  ImgSelect = 'Gas_Select.PNG';
  ImgUnSelect = 'Gas_unSelect.PNG';
begin
  SetupBomba(BombaCtrl.FPathImgFile + ImgUnSelect);
  if pSender is TImage then
  begin
    TImage(pSender).Picture.LoadFromFile(BombaCtrl.FPathImgFile + ImgSelect);
    BombaCtrl.FBombaActive := TImage(pSender).Tag;
    LimparEdits;
    if edtQtdLitro.CanFocus then
      edtQtdLitro.SetFocus;
  end;
end;

procedure TFrAbastecimento.SetupBomba(pImgPath: String);
begin
  imgGBomba1.Picture.LoadFromFile(pImgPath);
  imgGBomba2.Picture.LoadFromFile(pImgPath);
  imgDBomba1.Picture.LoadFromFile(pImgPath);
  imgDBomba2.Picture.LoadFromFile(pImgPath);
  BombaCtrl.FBombaActive := -1;
end;

procedure TFrAbastecimento.FiltrarCaracteres(pSender: TObject; var Key: Char);
begin
  if pSender is TEdit then
  begin
    if not(Key in ['0'..'9', ',', #8]) then
    begin
      Key := #0;
      exit
    end;
  end;
end;

procedure TFrAbastecimento.IniciarVenda;
var 
  sQtLitro: String;
  sValorPg: String;
begin
  oVenda.IDBomba := BombaCtrl.FBombaActive;
  
  case BombaCtrl.FBombaActive of
    1,2:
      begin 
        oVenda.VlrLitro := edtVlrGas.GetValor;
        oVenda.IDTanque := 1;
      end;
    3,4:
      begin        
        oVenda.VlrLitro := edtVlrDiesel.GetValor;
        oVenda.IDTanque := 2;
      end;
  end;

  oVenda.QtdLitro := edtQtdLitro.GetValor();
  oVenda.VlrAbastecido := edtVlrTotal.GetValor();

  oVenda.CalcularVenda(sQtLitro, sValorPg);
  
  lblLitros.Caption := sQtLitro;
  lblValorPagar.Caption := sValorPg;
end;

end.