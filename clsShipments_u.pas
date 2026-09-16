unit clsShipments_u;

interface

uses
SysUtils, ADODB, DB, dmRoutes_u, dialogs;

type
TShipment = class
private
fShipmentID : Integer;

public
Constructor Create(iShipmentID : integer);
function UpdateStatus(sNewStatus:string):Boolean;
function AssignVehicleAndDriver(iVehicleID, iDriverID : integer):Boolean;
property ShipmentID : Integer read FShipmentID;



end;

implementation

{ TShipment }

function TShipment.AssignVehicleAndDriver(iVehicleID,
  iDriverID: integer): Boolean;
begin
result := false;
with dmROutes.qryGeneral do
begin
  Close;
  SQL.Clear;
  SQL.Text := 'UPDATE Shipments SET VehicleID = :vID, DriverID = :dID WHERE ShipmentID = :sID';
  Parameters.ParamByName('vID').Value := iVehicleID;
  Parameters.ParamByName('dID').Value := iDriverID;
  Parameters.ParamByName('sID').Value := FShipmentID;

  try
    ExecSQL;
    Result := true;
  except on E:exception do
  ShowMessage(E.Message);

  end;
end;
end;

constructor TShipment.Create(iShipmentID: integer);
begin
inherited create;
fShipmentID := iShipmentID;

end;

function TShipment.UpdateStatus(sNewStatus: string): Boolean;
begin
Result:= false;
with dmRoutes.qryGeneral do
begin

Close;//Closes query if it's open
SQL.Clear;//Clear any exsisting SQL statements
SQL.Text := 'UPDATE Shipments Set Status = :s WHERE ShipmentID  = :sID';
parameters.ParamByName('s').Value  := sNewStatus;
parameters.ParamByName('sID').Value := FShipmentID;
try
  ExecSQL;      //Execute the SQL command
  result := true // if it's succesful, set result to true
except 
on E:exception do
ShowMessage(E.Message);  //Exception caught, then displays error message

end;
end;
end;

end.
