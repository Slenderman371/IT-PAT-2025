unit Admin_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DB, Grids, DBGrids, dmRoutes_u, Spin, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmAdmin = class(TForm)
    dbgVehicles: TDBGrid;
    dbgRoutes: TDBGrid;
    dbgResults: TDBGrid;
    sedMinCapacity: TSpinEdit;
    Label1: TLabel;
    edtVehicleType: TEdit;
    Label2: TLabel;
    btnSearchVehicles: TButton;
    btnVehichleCapacityStats: TButton;
    Label3: TLabel;
    btnDriverWorkload: TButton;
    dtTo: TDateTimePicker;
    dtFrom: TDateTimePicker;
    Label4: TLabel;
    Label5: TLabel;
    btnExportReport: TButton;
    btnShipmentsReport: TButton;
    btnFilterByDate: TButton;
    sedMinCount: TSpinEdit;
    procedure ConnectDatabase(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSearchVehiclesClick(Sender: TObject);
    procedure btnVehichleCapacityStatsClick(Sender: TObject);
    procedure btnDriverWorkloadClick(Sender: TObject);
    procedure btnShipmentsReportClick(Sender: TObject);
    procedure btnExportReportClick(Sender: TObject);
    procedure btnFilterByDateClick(Sender: TObject);
  private
    { Private declarations }


  public
    { Public declarations }
dscResults: TDataSource;
qryResults: TADOQuery;
procedure BindRoutesAndVehicles;
  end;

var
  frmAdmin: TfrmAdmin;

implementation

{$R *.dfm}

procedure TfrmAdmin.BindRoutesAndVehicles;
begin
dbgVehicles.DataSource :=  dmRoutes.dscVehicles;
dbgRoutes.DataSource := dmRoutes.dscRoutes;
dbgResults.DataSource := dscResults;

end;

procedure TfrmAdmin.btnDriverWorkloadClick(Sender: TObject);
var
iMinCount : integer;
begin
iMinCount := sedMinCount.Value;
qryResults.Close;
qryResults.SQL.Clear;
qryResults.SQL.Add('SELECT DriverID, COUNT(*) AS ShipmentCount');
qryResults.SQL.Add('From Shipments');
qryResults.SQL.Add('GROUP BY DriverID');
qryResults.SQL.Add('HAVING COUNT(*) >= ' + IntToStr(iMinCount));
qryResults.Open;

end;

procedure TfrmAdmin.btnExportReportClick(Sender: TObject);
var
F: Textfile;
i: Integer;
sLine : String;
begin
 if qryResults.Active = False then
 begin
   ShowMessage('Run a query first(e.g. Join Report) before exporting');
   Exit;
 end;
AssignFile(F,'ShipmentsReport.txt');
ReWrite(F);
try
//headline
sLine := 'Shipment Report - Generated: ' + DateToStr(Date);
Writeln(F,sLine);
Writeln(F, StringOfChar('-',Length(sLine)));
//Collum headers
sLine := '';
for I := 0 to qryResults.Fields.Count -1 do
begin
  if i > 0  then
  sLine := sLine + ' | ';
  sLine := sLine + qryResults.Fields[i].FieldName;
end;
Writeln(F,sLine);
Writeln(F,StringOfChar('-',Length(sLine)));
//Rows
qryResults.First;
while not qryResults.Eof do
begin
  sLine := '';
  for i := 0 to qryResults.Fields.Count - 1 do
  begin
  if i > 0  then
  sLine := sLine + ' | ';
  sLine := sLine + qryResults.Fields[i].AsString;
  end;
  Writeln(f,sLine);
  qryResults.Next;
  end;
  ShowMessage('Exported to ShipmentReports.txt')
finally
Closefile(F);

end;
end;

procedure TfrmAdmin.btnFilterByDateClick(Sender: TObject);
var
sTo, sFrom : string;
begin
sTo := DateToStr(dtTo.Date);
sFrom := DateToStr(dtFrom.Date);
qryResults.Close;
  qryResults.SQL.Clear;
  qryResults.SQL.Text :=
    'SELECT ShipmentID, ClientName, Origin, Destination, WeightKg, Status, CreatedAt ' +
    'FROM Shipments ' +
    'WHERE CreatedAt BETWEEN #'+sFrom+'# AND #'+sTo+'#' +
    'ORDER BY CreatedAt DESC';
  qryResults.Open;

dbgResults.Columns[1].Width := 80;
dbgResults.Columns[2].Width := 80;
dbgResults.Columns[3].Width := 90;
dbgResults.Columns[4].Width := 80;
dbgResults.Columns[5].Width := 80;
end;

procedure TfrmAdmin.btnSearchVehiclesClick(Sender: TObject);
var
sType : String;
iMinCap : integer;
begin
sType := edtVehicleType.Text;
if sType = '' then
begin
  ShowMessage('Enter a Vehicle type, for eg. Truck, Van etc.');
  Exit;
end;
iMinCap := sedMinCapacity.Value;
qryResults.Close;
qryResults.SQL.Clear;
qryResults.SQL.Add('SELECT VehicleID, RegNo, [Type], CapacityKg');
qryResults.SQL.Add('FROM Vehicles');
qryResults.SQL.Add('WHERE ([Type] LIKE "%'+sType+'%") AND (CapacityKg >= ' + IntToStr(iMinCap)+')');
qryResults.Open;

dbgResults.Columns[1].Width := 80;
dbgResults.Columns[2].Width := 60;
dbgResults.Columns[3].Width := 80;



end;

procedure TfrmAdmin.btnShipmentsReportClick(Sender: TObject);
begin
qryResults.Close;
qryResults.SQL.Clear;
qryResults.SQL.Text := 'SELECT s.ShipmentID, s.ClientName, v.RegNo, u.Username AS DriverName, ' +
' s.Origin, s.Destination, s.WeightKg, s.Status, s.CreatedAt ' +
'FROM Shipments AS s, Vehicles AS v, Users AS u ' +
'WHERE s.VehicleID = v.VehicleID AND s.DriverID = u.UserID '  +
'ORDER BY s.CreatedAT DESC ';
qryResults.Open;


end;

procedure TfrmAdmin.btnVehichleCapacityStatsClick(Sender: TObject);
var
iMinCap, iMaxCap : integer;
rAvgCap : real;
begin
if sedMinCapacity.Text = '' then
begin
  ShowMessage('Enter a valid capacity.');
  Exit;
end;
iMinCap := sedMinCapacity.Value;
qryResults.Close;
qryResults.SQL.Clear;
qryResults.SQL.Text := 'Select MIN(Capacitykg) AS MinCap, MAX(CapacityKG) AS Maxcap, '+
'FORMAT(AVG(CapacityKG), "Fixed") AS AvgCap  FROM Vehicles WHERE CapacityKG >=' +IntToStr(iMinCap); ;
qryResults.Open;
if not qryResults.Fields[0].IsNull then
  begin
    iMinCap := qryResults.FieldByName('MinCap').AsInteger;
    iMaxCap := qryResults.FieldByName('MaxCap').AsInteger;
   rAvgCap := qryResults.FieldByName('AvgCap').AsFloat;

    ShowMessage('Min Capacity: ' + IntToStr(iMinCap) +
                #13 + 'Max Capacity: ' + IntToStr(iMaxCap) +
                #13 + 'Average Capacity: ' + FloatToStrF(rAvgCap,ffFixed,10,2));
  end
  else
    ShowMessage('No vehicles match that minimum capacity.');
end;

procedure TfrmAdmin.ConnectDatabase(Sender: TObject);
begin
dbgVehicles.DataSource := dmRoutes.dscVehicles;
dbgRoutes.DataSource := dmRoutes.dscRoutes;
end;

procedure TfrmAdmin.FormCreate(Sender: TObject);
begin
qryResults := TADOQuery.Create(Self);
qryResults.Connection := dmRoutes.conRoutes;
dscResults := TDataSource.Create(Self);
dscResults.DataSet := qryResults;
qryResults.Connection := dmRoutes.conRoutes;
BindRoutesAndVehicles;
dbgVehicles.Columns[1].Width := 80;
dbgVehicles.Columns[2].Width := 80;
dbgVehicles.Columns[3].Width := 80;

dbgRoutes.Columns[1].Width := 80;
dbgRoutes.Columns[2].Width := 85;
dbgRoutes.Columns[3].Width := 80;

//logical default dates
dtFrom.Date := date-30;
dtTo.Date:= Date;   //Returns the current date
end;

end.
