unit SignUp_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, dmRoutes_u, pngimage;

type
  TfrmSignUp = class(TForm)
    pnl1: TPanel;
    btnCreate: TButton;
    Image1: TImage;
    edtUsername: TLabeledEdit;
    edtPassword: TLabeledEdit;
    edtConfirm: TLabeledEdit;
    ImgEye: TImage;
    ImgEye1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure ImgEyeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgEyeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgEye1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgEye1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnl1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSignUp: TfrmSignUp;

implementation

Uses MongalePAT_u;

{$R *.dfm}

procedure TfrmSignUp.btnCreateClick(Sender: TObject);
var
sUsername, sPassword, sConfirm : string;
begin
sUsername := trim(edtUsername.Text);
sPassword := trim(edtPassword.Text);
sConfirm := trim(edtConfirm.Text);

if sUsername = '' then
begin
  ShowMessage('Enter a username.');
  Exit;
end;

if sPassword = '' then
begin
  ShowMessage('Enter a password.');
  Exit;
end;

if sPassword <> sConfirm then
begin
  ShowMessage('Passwords do not match.');
  Exit;
end;

//Ensure no duplicate users
if dmRoutes.UsernameExists(sUsername) = true then
begin
  ShowMessage('Username already exists, choose another one.');
  Exit;
end;

if dmRoutes.CreateUser(sUsername,sPassword,'Driver') then
begin
  ShowMessage('Signup was successful. You can now login.');
  //return to login
  frmMain.Show;
  frmSignup.Hide;
end
else
begin
  ShowMessage('Failed to create account. Please try again later.');
end;
end;

procedure TfrmSignUp.FormCreate(Sender: TObject);
begin
//ensure signup fields are blank
edtUsername.Text := '';
edtPassword.Text := '';
edtConfirm.Text := '';
edtPassword.PasswordChar:= '*';
edtConfirm.PasswordChar := '*';
end;

procedure TfrmSignUp.ImgEye1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
edtConfirm.PasswordChar := #0;
imgEye1.picture.LoadFromFile('Screenshoteyeslash.png');
end;

procedure TfrmSignUp.ImgEye1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
edtConfirm.PasswordChar := '*';
imgEye1.picture.LoadFromFile('Screenshoteye.png');
end;

procedure TfrmSignUp.ImgEyeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
edtPassword.PasswordChar := #0;
imgEye.picture.LoadFromFile('Screenshoteyeslash.png');
end;


procedure TfrmSignUp.ImgEyeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
edtPassword.PasswordChar := '*';
imgEye.picture.LoadFromFile('Screenshoteye.png');
end;

procedure TfrmSignUp.pnl1Click(Sender: TObject);
begin
// Hide sign up form and make login form interactable
frmMain.Show;
self.close;
end;

end.
