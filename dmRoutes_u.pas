unit dmRoutes_u;


interface

uses
  SysUtils, Classes, ADODB, DB,dialogs; //Add  ADODB, dialogs(for showmessage etc.) and DB

type
  TdmRoutes = class(TDataModule)
    procedure DataModuleSetup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    // Declare my objects
    conRoutes : TADOConnection ; //Connect to the database
    qryGeneral : TADOQuery; //General purpose query

    tblRoutes : TADOTable ; //Conect to the table in the database
    tblUsers : TADOTable ;
    tblShipments : TADOTable;
    tblVehicles : TaDOTable;

    dscRoutes : TDataSource  ;  //Connect to any other components that we want to interact with TADOTable
    dscUsers : TDataSource ;
    dscShipments : TDataSource;
    dscVehicles : TDataSource;

    //Simple session state (current logged-in user)
    iSessionUserID : integer;
    sSessionUsername : String;
    sSessionRole : String;

    function AuthenticateUser(const sUsername, sPassword : string):Boolean;
    function UsernameExists(const sUsername :string): Boolean;
    function CreateUser(const sUsername:string ;const sPassword:string; sRole: string = 'Driver'):Boolean;

  end;

var
  dmRoutes: TdmRoutes;

implementation

{$R *.dfm}

function TdmRoutes.AuthenticateUser(const sUsername,
  sPassword: string): Boolean;
begin
result := false;
//if the username or password is empty process stops
if (trim(sUsername) = '') or (trim(sPassword) = '') then   //Trim function removes any whiteSpace characters  like ' ' or tab #9 etc.
Exit;
qryGeneral.Close;
qryGeneral.SQL.Clear;

// Assign a new SQL query to select user details based on username and password
qryGeneral.SQL.Text := 'SELECT UserID,Role,Username from Users WHERE  Username = :u AND Password = :p';

//Set paramater values username and password
qryGeneral.Parameters.ParamByName('u').Value := sUsername;
qryGeneral.Parameters.ParamByName('p').Value := sPassword;

try
qryGeneral.Open ;
if qryGeneral.IsEmpty = false then
begin
//if a match is found retrieve and store user details from the result
  iSessionUserID := qryGeneral.FieldByName('UserID').AsInteger;
  sSessionUsername :=qryGeneral.FieldByName('Username').AsString;
  sSessionRole := qryGeneral.FieldByName('Role').AsString ;
  result := true;
end
else
begin
// if no match is found, clear session variable
iSessionUserID := 0;
sSessionUsername :='';
sSessionRole :='' ;
end;
finally
 qryGeneral.Close;
end;


end;

function TdmRoutes.CreateUser(const sUsername:string ;const sPassword:string; sRole: string = 'Driver'):Boolean;
begin
result := false;
//Basic validation, username should not be empty
if trim(sUsername) = '' then
begin
  ShowMessage('Username cannot be empty.');
  Exit;
end;

//Basic validation, password should not be empty
if trim(sPassword) = '' then
begin
  ShowMessage('Password cannot be empty.');
  Exit;
end;

//Check if username exists
if UsernameExists(sUsername) = true then
begin
  ShowMessage('Username already exists, please select another one.');
  Exit;
end;

try
tblUsers.Insert;
tblUsers['Username'] := sUsername;
tblUsers['Password'] := sPassword;
tblUsers['Role'] := sRole; //Assign role (default role is driver).
tblUsers.Post;
result := true;  //User creation was succesful
except
on E : Exception do
 begin
  ShowMessage('Error creating user: ' + E.Message);
  result :=false;
  // if tblUsers in insert/edit mode, cancel the changes
  if tblUsers.State  in [dsInsert, dsEdit] then
  tblUsers.Cancel;
 end;
end;

end;

procedure TdmRoutes.DataModuleSetup(Sender: TObject);
begin
//instantiate our objects
conRoutes := TADOConnection.Create(dmRoutes);
tblRoutes := TADOTable.Create(dmRoutes);
dscRoutes := TDataSource.Create(dmRoutes);

tblUsers := TADOTable.Create(dmRoutes);
dscUsers := TDataSource.Create(dmRoutes);

tblShipments := TADOTable.Create(dmRoutes);
dscShipments := TDataSource.Create(dmRoutes);

tblVehicles := TADOTable.Create(dmRoutes);
dscVehicles := TDataSource.Create(dmRoutes);


//instantiate our query
qryGeneral:= TADOQuery.Create(dmRoutes);
qryGeneral.Connection := conRoutes;



//setup our connection
conRoutes.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=db_Routes.mdb;Mode=ReadWrite;Persist Security Info=False';
conRoutes.LoginPrompt := False ;
try
conRoutes.Open; // Attempts to open the DB connection
except
 on E: exception do
 begin
   ShowMessage('Database connection failed: ' + E.Message);//show error if connection fails
   raise;// reraise the exception for further handling if needed
 end;

end;

//setup our tables
tblRoutes.Connection := conRoutes;
tblRoutes.TableName := 'Routes';

tblUsers.Connection := conRoutes;
tblUsers.TableName := 'Users';

tblShipments.Connection := conRoutes;
tblShipments.TableName := 'Shipments';

tblVehicles.Connection := conRoutes;
tblVehicles.TableName := 'Vehicles';

//setup data source
dscRoutes.DataSet := tblRoutes ;
tblRoutes.Open;

dscUsers.DataSet := tblUsers ;
tblUsers.Open;

dscShipments.DataSet := tblShipments;
tblShipments.Open;

dscVehicles.DataSet := tblVehicles;
tblVehicles.Open;


//Clear session
iSessionUserID := 0;
sSessionUsername :='';
sSessionRole :='' ;

end;

function TdmRoutes.UsernameExists(const sUsername: string): Boolean;
begin
if Trim(sUsername) = ''  then
Exit;

qryGeneral.Close;
qryGeneral.SQL.Clear;

 qryGeneral.SQL.Text := 'Select UserID FROM Users where Username = :u';
 qryGeneral.Parameters.ParamByName('u').Value := sUsername;

 try
   qryGeneral.Open;
   //if the query returns any records, the username exists
   result := (qryGeneral.IsEmpty = false) ;
 finally
 qryGeneral.Close;
 end;



end;

end.
