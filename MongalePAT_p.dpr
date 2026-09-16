program MongalePAT_p;

uses
  Forms,
  MongalePAT_u in 'MongalePAT_u.pas' {frmMain},
  dmRoutes_u in 'dmRoutes_u.pas' {dmRoutes: TDataModule},
  SignUp_u in 'SignUp_u.pas' {frmSignUp},
  Dispatcher_u in 'Dispatcher_u.pas' {frmDispatcher},
  Driver_u in 'Driver_u.pas' {frmDriver},
  Admin_u in 'Admin_u.pas' {frmAdmin},
  clsShipments_u in 'clsShipments_u.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmRoutes, dmRoutes);
  Application.CreateForm(TfrmSignUp, frmSignUp);
  Application.CreateForm(TfrmDispatcher, frmDispatcher);
  Application.CreateForm(TfrmDriver, frmDriver);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.Run;
end.
