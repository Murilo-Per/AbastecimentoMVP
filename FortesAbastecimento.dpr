program FortesAbastecimento;

uses
  Vcl.Forms,
  uAbastecimento in 'View\uAbastecimento.pas' {FrAbastecimento},
  uDadosConexao in 'DAO\uDadosConexao.pas',
  uConexao in 'DAO\uConexao.pas',
  uDAO in 'DAO\uDAO.pas',
  uFDQueryCustom in 'Components\uFDQueryCustom.pas',
  uEditCustom in 'Components\uEditCustom.pas',
  uVenda in 'Model\uVenda.pas',
  uVendaCtrl in 'Controller\uVendaCtrl.pas',
  uVendaDAO in 'DAO\uVendaDAO.pas',
  uTanque in 'Model\uTanque.pas',
  uTanqueCtrl in 'Controller\uTanqueCtrl.pas',
  uTanqueDAO in 'DAO\uTanqueDAO.pas',
  uBomba in 'Model\uBomba.pas',
  uBombaCtrl in 'Controller\uBombaCtrl.pas',
  uBombaDAO in 'DAO\uBombaDAO.pas',
  uRelatorio in 'View\uRelatorio.pas' {FrRelatorio};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrAbastecimento, FrAbastecimento);
  Application.Run;
end.
