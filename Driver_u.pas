unit Driver_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, pngimage, ExtCtrls, ADODB, DB, dmRoutes_u, clsShipments_u;

type
  TfrmDriver = class(TForm)
    dbgMyShipments: TDBGrid;
    btnRefresh: TButton;
    btnMarkDelivered: TButton;
    btnMarkInTransit: TButton;
    Image1: TImage;
    lblTotals: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnMarkInTransitClick(Sender: TObject);
    procedure btnMarkDeliveredClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadMyShipments;
    procedure LoadMyStats;
    function CurrentSelectedShipmentID: Integer;

  public
    { Public declarations }
    dscMine: TDataSource;
    qryMine: TADOQuery;
    procedure InitiliazeDriverScreen ;
  end;

var
  frmDriver: TfrmDriver;

implementation

{$R *.dfm}

procedure TfrmDriver.btnMarkDeliveredClick(Sender: TObject);
var
iShipmentID : integer;
Shipment : TShipment;
begin
iShipmentID := CurrentSelectedShipmentID;
if iShipmentID = 0 then
begin
  ShowMessage('Select a shipment first.');
  Exit;
end;
Shipment := TShipment.Create(iShipmentID);
try
if Shipment.UpdateStatus('Delivered') then
   begin
    LoadMyShipments;
    LoadMyStats;
   end
   else
     ShowMessage('Failed to update status.');
 finally
   Shipment.Free;
end;

end;

procedure TfrmDriver.btnMarkInTransitClick(Sender: TObject);
var
iShipmentID : integer;
Shipment : TShipment;
begin
iShipmentID := CurrentSelectedShipmentID;
if iShipmentID = 0 then
begin
  ShowMessage('Select a shipment first.');
  Exit;
end;
Shipment := TShipment.Create(iShipmentID);
 try
   if Shipment.UpdateStatus('In Transit') then
   begin
    LoadMyShipments;
    LoadMyStats;
   end
   else
     ShowMessage('Failed to update status.');
 finally
   Shipment.Free;
 end;

end;

procedure TfrmDriver.btnRefreshClick(Sender: TObject);
begin
LoadMyShipments;
LoadMyStats;
end;

function TfrmDriver.CurrentSelectedShipmentID: Integer;
begin
result := 0;
 if (qryMine.Active) and ( qryMine.IsEmpty= false) then
Result := qryMine.FieldByName('ShipmentID').AsInteger;
end;


procedure TfrmDriver.FormCreate(Sender: TObject);

begin
qryMine := TADOQuery.Create(Self);
qryMine.Connection := dmRoutes.conRoutes;
dscMine := TDataSource.Create(Self);
dscMine.DataSet := qryMine;

dbgMyShipments.DataSource := dscMine;
dmRoutes.tblVehicles.Open;
dmRoutes.tblRoutes.Open;
dmRoutes.tblShipments.Open;

end;

procedure TfrmDriver.InitiliazeDriverScreen;
begin
LoadMyShipments;
LoadMyStats;
end;

procedure TfrmDriver.LoadMyShipments;
begin

if dmRoutes.iSessionUserID = 0 then
begin
ShowMessage('No logged-in driver.');
Exit;
end;
qrymine.Close;
qryMine.SQL.Clear;
qryMine.SQL.Text :=
    'SELECT ShipmentID, ClientName, Origin, Destination, WeightKg, Status, CreatedAt ' +
    'FROM Shipments WHERE DriverID = ' + IntToStr(dmRoutes.iSessionUserID)+ ' ORDER BY CreatedAt DESC';
qryMine.Open;

end;

procedure TfrmDriver.LoadMyStats;
var
qryDriver : TADOQuery;
vTotal, vMaxWeight : Variant;
begin
if dmRoutes.iSessionUserID = 0 then
Exit;
qryDriver:= TADOQuery.Create(Self);
try
  qryDriver.Connection := dmRoutes.conRoutes;
  // SUM of pending/in-transit weights
  qryDriver.SQL.Text := 'SELECT SUM(WeightKg) AS TotalAssigned ' +
  'FROM Shipments WHERE DriverID =  ' + IntToStr(dmRoutes.iSessionUserID)+ ' AND Status <> ''Delivered''';
  qryDriver.Open;
  vTotal := qryDriver.FieldByName('TotalAssigned').Value;
  qryDriver.Close;
// MAX single shipment weight for this driver
    qryDriver.SQL.Text :=
      'SELECT MAX(WeightKg) AS MaxWeight ' +
      'FROM Shipments WHERE DriverID =  ' + IntToStr(dmRoutes.iSessionUserID);
    qryDriver.Open;
    vMaxWeight := qryDriver.FieldByName('MaxWeight').Value;
    lblTotals.Caption := 'My loads - Total (pending/in transit): ' +
                          VarToStr(vTotal) + ' kg | Heaviest: ' +    VarToStr(vMaxWeight) + ' kg';
  finally
    qryDriver.Free;
  end;
end;

end.
