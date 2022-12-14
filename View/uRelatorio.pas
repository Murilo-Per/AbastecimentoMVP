unit uRelatorio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, RLReport, FireDAC.Comp.Client,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrRelatorio = class(TForm)
    RLReport1: TRLReport;
    RLBand1: TRLBand;
    RLLabel1: TRLLabel;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLGroup1: TRLGroup;
    dsRelatorio: TDataSource;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Image1: TImage;
    RLBand3: TRLBand;
    RLLabel10: TRLLabel;
    RLDBResult5: TRLDBResult;
    RLDBResult6: TRLDBResult;
    RLDBResult7: TRLDBResult;
    RLDBResult8: TRLDBResult;
    lblPeriodo: TRLLabel;
    RLGroup2: TRLGroup;
    RLBand2: TRLBand;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    RLDBText7: TRLDBText;
    RLDBText1: TRLDBText;
    RLBand4: TRLBand;
    RLLabel9: TRLLabel;
    RLDBResult1: TRLDBResult;
    RLDBResult2: TRLDBResult;
    RLDBResult3: TRLDBResult;
    RLDBResult4: TRLDBResult;
    RLBand5: TRLBand;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    procedure Image1Click(Sender: TObject);
    procedure DateTimePicker1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure MontarRelatorio;
  end;

var
  FrRelatorio: TFrRelatorio;

implementation

{$R *.dfm}
uses 
 uVenda, uFDQueryCustom;

procedure TFrRelatorio.DateTimePicker1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key= #13 then
    MontarRelatorio;
end;

procedure TFrRelatorio.Image1Click(Sender: TObject);
begin
  MontarRelatorio;
end;

procedure TFrRelatorio.MontarRelatorio;
var
  vQuery: TFDQueryCustom;
  oVenda: TVenda;
  data1: TDate;
  data2: TDate;
begin
  vQuery := TFDQueryCustom.Create(nil);
  oVenda := TVenda.Create;
  data1 := DateTimePicker1.Date;
  data2 := DateTimePicker2.Date;

  oVenda.GerarRelatorio(data1, data2, vQuery);

  dsRelatorio.DataSet := vQuery;
  lblPeriodo.Caption := 'Periodo de ' + FormatDateTime('dd/mm/yyyy', data1) + ' a ' +
                        FormatDateTime('dd/mm/yyyy', data2);

  RLReport1.Preview;
end;

end.
