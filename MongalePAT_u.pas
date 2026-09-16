unit MongalePAT_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Grids, DBGrids, dmRoutes_u, SignUp_u,
  pngimage, Admin_u, Dispatcher_u, Driver_u;

type
  TfrmMain = class(TForm)
    btnLogin: TButton;
    Panel1: TPanel;
    Image1: TImage;
    edtPassword: TLabeledEdit;
    edtUsername: TLabeledEdit;
    ImgEye: TImage;
    procedure btnLoginClick(Sender: TObject);
    procedure ImgEyeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgEyeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnLoginClick(Sender: TObject);
var
sPassword, sUsername : string;
begin
with dmRoutes.qryGeneral do
begin
 sUsername := trim(edtUsername.Text);
 sPassword :=  trim(edtPassword.Text);

 if sUsername = '' then
 begin
   ShowMessage('Enter your Username.');
   Exit;
 end;

 if sPassword = '' then
 begin
   ShowMessage('Enter your Password.');
   Exit;
 end;

 //Authenticate the user with provided Username and password
 if dmRoutes.AuthenticateUser(sUsername,sPassword) then
 begin

  if LowerCase(dmRoutes.sSessionRole) = LowerCase('Admin') then
  begin
    frmAdmin.Show;
    frmMain.Hide;
  end

 else if LowerCase(dmRoutes.sSessionRole) = LowerCase('Dispatcher') then
  begin
    frmDispatcher.Show;
    frmMain.Hide;
  end

  else if LowerCase(dmRoutes.sSessionRole) = LowerCase('Driver') then
  begin
    frmDriver.Show;
    frmDriver.InitiliazeDriverScreen;
    frmMain.Hide;
  end

  else begin
    ShowMessage(dmRoutes.sSessionRole + ' is an invalid role, please select a valid role.');
  end ;
  end

  else
  ShowMessage('Login failed. Username or password is incorrect.');  //Authentication failed

end;

end;

procedure TfrmMain.ImgEyeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
edtPassword.PasswordChar := #0;
imgEye.picture.LoadFromFile('Screenshoteyeslash.png');
end;

procedure TfrmMain.ImgEyeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
edtPassword.PasswordChar := '*';
imgEye.picture.LoadFromFile('Screenshoteye.png');
end;

procedure TfrmMain.Panel1Click(Sender: TObject);
begin
//Hide log in form and make sign up form interactable
frmSignUp.Show;
frmMain.Hide;
end;

end.
