unit Dispatcher_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, DBGrids, Grids,clsShipments_u, dmRoutes_u, DB, ADODB,
  Spin;

type
 TShipmentDraft = record
    ClientName: string;
    VehicleID: Integer;
    DriverID: Integer;
    Origin: string;
    Destination: string;
    WeightKg: Integer;
    end;
  TfrmDispatcher = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtTerm: TEdit;
    edtClientName: TEdit;
    Label6: TLabel;
    btnCommitBatch: TButton;
    btnClearBatch: TButton;
    sgBatch: TStringGrid;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    btnSearchShipments: TButton;
    dbgResults: TDBGrid;

    cbOrigin: TComboBox;
    cbDestination: TComboBox;
    cbVehicleID: TComboBox;
    cbStatusFilter: TComboBox;
    cbDriverAssign: TComboBox;
    cbVehicleAssign: TComboBox;
    cbDriverID: TComboBox;
    btnAddToBatch: TButton;
    btnAssignToShipment: TButton;
    sedWeight: TSpinEdit;
    btnDeleteShipments: TButton;
    sedShipmentIDAssign: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnAddToBatchClick(Sender: TObject);
    procedure btnClearBatchClick(Sender: TObject);
    procedure btnCommitBatchClick(Sender: TObject);
    procedure btnSearchShipmentsClick(Sender: TObject);
    procedure btnAssignToShipmentClick(Sender: TObject);
    procedure btnDeleteShipmentsClick(Sender: TObject);

  private
    { Private declarations }
    arrFDrafts : array of TShipmentDraft;
    procedure InitializeGrid;
    procedure RefreshCombos;
    procedure AppendDraftToGrid(const Draft: TShipmentDraft);
    procedure ClearDraftsAndGrid;
  public
    { Public declarations }
     dscResults : TDataSource;
    qryResults : TADOQuery;
  end;

var
  frmDispatcher: TfrmDispatcher;

implementation

{$R *.dfm}

procedure TfrmDispatcher.AppendDraftToGrid(const Draft: TShipmentDraft);
var
iRow : integer;
begin
 iRow := sgBatch.RowCount;
  sgBatch.RowCount := iRow + 1;    //Adds new row
  sgBatch.Cells[0, iRow] := Draft.ClientName;
  sgBatch.Cells[1, iRow] := Draft.Origin;
  sgBatch.Cells[2, iRow] := Draft.Destination;
  sgBatch.Cells[3,iRow] := IntToStr(Draft.WeightKg);
  sgBatch.Cells[4, iRow] := IntToStr(Draft.VehicleID);
  sgBatch.Cells[5, iRow] := IntToStr(Draft.DriverID);
end;

procedure TfrmDispatcher.btnAddToBatchClick(Sender: TObject);
var
Draft: TShipmentDraft;   //local variable
iSelectedVehicleID, iCapacityKg : Integer;

begin
//Basic Input validation
  if Trim(edtClientName.Text) = '' then
  begin
    ShowMessage('Enter Client Name.');
    Exit;
  end;
  if (cbOrigin.ItemIndex < 0) or (cbDestination.ItemIndex < 0) then
  begin
    ShowMessage('Select Origin and Destination.');
    Exit;
  end;
  if sedWeight.Value <= 0 then
  begin
    ShowMessage('Enter a valid Weight (Kg).');
    Exit;
  end;
   if sedWeight.Value > 15000 then
  begin
    ShowMessage('Weight has exceeded limit.');
    sedWeight.Value := 15000;
    Exit;
  end;
  if (cbVehicleID.ItemIndex < 0) or (cbDriverID.ItemIndex < 0) then
  begin
    ShowMessage('Select VehicleID and DriverID.');
    Exit;
  end;

//Validation to ensure that weight chosen doesn't exceed that of the vehicle's capacitykg
  iSelectedVehicleID := StrToInt(cbVehicleID.Items[cbVehicleID.ItemIndex]);
  with dmRoutes.tblVehicles do
  begin
     if Locate('VehicleID', iSelectedVehicleID, []) then
        iCapacityKg := dmRoutes.tblVehicles['CapacityKg']
        else
        begin
      ShowMessage('Selected vehicle not found.');
      Exit;
    end;
    if sedWeight.Value > iCapacityKg then
  begin
    ShowMessage('Weight exceeds the selected vehicle''s capacity (' + IntToStr(iCapacityKg) + ' Kg).');
    Exit;
  end;
  end;
//Assign fields of draft, from user input
Draft.ClientName  := Trim(edtClientName.Text);
Draft.Origin      := cbOrigin.Items[cbOrigin.ItemIndex];
Draft.Destination := cbDestination.Items[cbDestination.ItemIndex];
Draft.WeightKg    := sedWeight.Value;
Draft.VehicleID   := StrToInt(cbVehicleID.Items[cbVehicleID.ItemIndex]);
Draft.DriverID    := StrToInt(cbDriverID.Items[cbDriverID.ItemIndex]);
// dynamically resizes array to hold one more item
SetLength(arrFDrafts, Length(arrFDrafts) + 1);   //Enables the storage of the new draft at the end

arrFDrafts[High(arrFDrafts)] := Draft;      //Points to last valid index (after resizing)
//Pass Draft to AppendDraftToGRid to populate the grid, without changing the local value of Draft
AppendDraftToGrid(Draft);

end;

procedure TfrmDispatcher.btnAssignToShipmentClick(Sender: TObject);
var
iShipmentID, iVehicleID, iDriverID : Integer;
Shipment : Tshipment;
begin
iShipmentID := sedShipmentIDAssign.Value;
dmRoutes.tblShipments.Sort := 'ShipmentID';
dmRoutes.tblShipments.Last;
if (iShipmentID = 0) or (iShipmentID > dmRoutes.tblShipments['ShipmentID']) then
begin
 ShowMessage('Enter a valid ShipmentID to assign.');
 Exit;
end;
if (cbVehicleAssign.ItemIndex < 0) or (cbDriverAssign.ItemIndex < 0) then
  begin
    ShowMessage('Select VehicleID and DriverID.');
    Exit;
  end;
iVehicleID := StrToInt(cbVehicleAssign.Items[cbVehicleAssign.ItemIndex]);
iDriverID := StrToInt(cbDriverAssign.Items[cbDriverAssign.ItemIndex]);

//Instntiate a TShipment object for the given ShipmentID
Shipment := TShipment.Create(iShipmentID);
try


//Call Method to assign Vehicle and Driver, returns true if succesful
if Shipment.AssignVehicleAndDriver(iVehicleID,iDriverID) then
ShowMessage('Assignment saved.')
else
ShowMessage('Assignment failed.');
finally
Shipment.Free; //free object to save resources
end;

end;

procedure TfrmDispatcher.btnClearBatchClick(Sender: TObject);
begin
ClearDraftsAndGrid;
end;

procedure TfrmDispatcher.btnCommitBatchClick(Sender: TObject);
var
i : integer;
begin
if Length(arrFDrafts) = 0 then
begin
 ShowMessage('No drafts to commit.');
  Exit;
end;
with dmRoutes.qryGeneral do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'INSERT INTO Shipments (ClientName, VehicleID, DriverID, Origin, Destination, WeightKg, Status, CreatedAt) ' +
   'VALUES (:c, :v, :d, :o, :dest, :w, :s, :dt)';
    try
    //Starts a new transaction block. All upcoming SQL operations fall into this transaction
      dmRoutes.conRoutes.BeginTrans;
      for i := 0 to High(arrFDrafts) do
      begin
        Parameters.ParamByName('c').Value   := arrFDrafts[i].ClientName;
        Parameters.ParamByName('v').Value   := arrFDrafts[i].VehicleID;
        Parameters.ParamByName('d').Value   := arrFDrafts[i].DriverID;
        Parameters.ParamByName('o').Value   := arrFDrafts[i].Origin;
        Parameters.ParamByName('dest').Value:= arrFDrafts[i].Destination;
        Parameters.ParamByName('w').Value   := arrFDrafts[i].WeightKg;
        Parameters.ParamByName('s').Value   := 'Pending';
        Parameters.ParamByName('dt').Value  := Date; // CreatedAt
        ExecSQL;
      end;
      //Finalizes transaction, saving all changes made durign transaction to DB permanently
      dmRoutes.conRoutes.CommitTrans;
      ShowMessage('Batch committed: ' + IntToStr(Length(arrFDrafts)) + ' shipments.');
      ClearDraftsAndGrid;
      dmRoutes.tblShipments.Requery([]); // refresh table view if open elsewhere
    except
      on E: Exception do
      begin
      //Cancels all changes made during transaction, reverting DB to it's state before BeginTrans.
        dmRoutes.conRoutes.RollbackTrans;
        ShowMessage('Commit failed: ' + E.Message);
      end;
    end;
  end;
end;

procedure TfrmDispatcher.btnDeleteShipmentsClick(Sender: TObject);
var
iShipmentID : integer;
bFound : boolean;
begin
iShipmentID := sedShipmentIDAssign.Value;
bFound := false;
with dmRoutes do
begin
  tblShipments.First;
  while not tblShipments.Eof do
  begin
  if tblShipments['ShipmentID'] = iShipmentID then
  begin
  bFound := true;
  try
  tblShipments.Delete;
  ShowMessage('Shipment succesfully deleted');
  except
  ShowMessage('Failed to delete Shipment');
  end;
  end
  else
  tblShipments.Next
  end;
  if bFound = false then
  ShowMessage('Shipment ID not found.');

end;
end;

procedure TfrmDispatcher.btnSearchShipmentsClick(Sender: TObject);
var
sTerm, sStatus : String;
begin
if edtTerm.Text = '' then
begin
  ShowMessage('Enter an Origin or Destination.');
  Exit;
end;
//Prepares the search term for Like Comparisons
sTerm := '%' +  Trim(edtTerm.Text) + '%';
// Determine the status filter based on user selection
  if cbStatusFilter.ItemIndex >= 0 then
    sStatus := cbStatusFilter.Items[cbStatusFilter.ItemIndex]
  else
    sStatus := 'Pending'; // Default to 'Pending' if no selection
 qryResults.Close;
  qryResults.SQL.Clear;
  qryResults.SQL.Add('SELECT ShipmentID, ClientName, Origin, Destination, Status, CreatedAt, WeightKg');
  qryResults.SQL.Add('FROM Shipments');
  qryResults.SQL.Add('WHERE (Origin LIKE "'+sTerm+'" OR Destination LIKE "'+sTerm+'" ) AND Status = "'+sStatus+'" ');
  qryResults.Open;
dbgResults.Columns[1].Width := 80;
dbgResults.Columns[2].Width := 90;
dbgResults.Columns[3].Width := 90;
dbgResults.Columns[4].Width := 80;
end;

procedure TfrmDispatcher.ClearDraftsAndGrid;
begin
SetLength(arrFDrafts, 0);
InitializeGrid;
end;

procedure TfrmDispatcher.FormCreate(Sender: TObject);
begin
qryResults := TADOQuery.Create(Self);
qryResults.Connection := dmRoutes.conRoutes;

dscResults := TDataSource.Create(Self);
dscResults.DataSet := qryResults;
dbgResults.DataSource := dscResults;

dmRoutes.tblVehicles.Open;
dmRoutes.tblRoutes.Open;
dmRoutes.tblShipments.Open;

InitializeGrid;
RefreshCombos;
cbStatusFilter.Clear;
//Add specified status options for status filter combobox
cbStatusFilter.Items.Add('Pending');
cbStatusFilter.Items.Add('In Transit');
cbStatusFilter.Items.Add('Delivered');
// Set the default selected items to the 1st one if available
if cbStatusFilter.Items.Count > 0 then
cbStatusFilter.ItemIndex := 0;
end;

procedure TfrmDispatcher.InitializeGrid;
begin
 sgBatch.RowCount := 1;
 sgBatch.ColCount := 6;
 sgBatch.FixedCols := 0;
 sgBatch.Cells[0,0] := 'Client';
 sgBatch.Cells[1,0] := 'Origin';
 sgBatch.Cells[2,0] := 'Destination';
 sgBatch.Cells[3,0] := 'WeightKg';
 sgBatch.Cells[4,0] := 'VehicleID';
 sgBatch.Cells[5,0] := 'DriverID';
 SetLength(arrFDrafts, 0);
end;

procedure TfrmDispatcher.RefreshCombos;
begin
cbOrigin.Clear;
cbDestination.Clear;
dmRoutes.tblRoutes.First;
while not dmRoutes.tblRoutes.Eof do
begin
    // Add to cbOrigin if it's not already present
  if cbOrigin.Items.IndexOf(dmRoutes.tblRoutes['StartLocation']) < 0 then
  cbOrigin.Items.Add(dmRoutes.tblRoutes['StartLocation']) ;
    // Add to cbDestination if it's not already present
  if cbDestination.Items.IndexOf(dmRoutes.tblRoutes['EndLocation']) < 0 then
  cbDestination.Items.Add(dmRoutes.tblRoutes['EndLocation']);
  dmRoutes.tblRoutes.Next;
end;
//Vehicle ID's
cbVehicleID.Clear;
cbVehicleAssign.Clear;
dmRoutes.tblVehicles.First;
while not dmRoutes.tblVehicles.Eof do
begin
cbVehicleID.Items.Add(IntToStr(dmRoutes.tblVehicles['VehicleID']));
cbVehicleAssign.Items.Add(IntToStr(dmRoutes.tblVehicles['VehicleID']));
dmRoutes.tblVehicles.Next;
end;
cbDriverID.Clear;
  cbDriverAssign.Clear;
  with dmRoutes.qryGeneral do
  begin
    Close;
    SQL.Text := 'SELECT UserID FROM Users WHERE Role = ''Driver'' ORDER BY UserID';
    Open;
    First;
    while not Eof do
    begin
    //Add UserID to both driver combo boxes
      cbDriverID.Items.Add(FieldByName('UserID').AsString);
      cbDriverAssign.Items.Add(FieldByName('UserID').AsString);
      Next;
    end;
    Close;
end;
end;

end.
