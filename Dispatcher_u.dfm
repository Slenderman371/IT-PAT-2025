object frmDispatcher: TfrmDispatcher
  Left = 0
  Top = 0
  Caption = 'Dispatcher'
  ClientHeight = 401
  ClientWidth = 737
  Color = clMoneyGreen
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 25
    Top = 48
    Width = 61
    Height = 13
    Caption = 'Client Name:'
  end
  object Label2: TLabel
    Left = 25
    Top = 94
    Width = 32
    Height = 13
    Caption = 'Origin:'
  end
  object Label3: TLabel
    Left = 148
    Top = 97
    Width = 58
    Height = 13
    Caption = 'Destination:'
  end
  object Label4: TLabel
    Left = 24
    Top = 155
    Width = 60
    Height = 13
    Caption = 'Weight (kg):'
  end
  object Label5: TLabel
    Left = 146
    Top = 155
    Width = 37
    Height = 13
    Caption = 'Vehicle:'
  end
  object Label6: TLabel
    Left = 261
    Top = 155
    Width = 33
    Height = 13
    Caption = 'Driver:'
  end
  object Label7: TLabel
    Left = 396
    Top = 48
    Width = 62
    Height = 13
    Caption = 'Shipment ID:'
  end
  object Label8: TLabel
    Left = 25
    Top = 201
    Width = 72
    Height = 13
    Caption = 'Batch Preview:'
  end
  object Label9: TLabel
    Left = 396
    Top = 94
    Width = 37
    Height = 13
    Caption = 'Vehicle:'
  end
  object Label10: TLabel
    Left = 554
    Top = 94
    Width = 33
    Height = 13
    Caption = 'Driver:'
  end
  object Label11: TLabel
    Left = 551
    Top = 155
    Width = 84
    Height = 13
    Caption = 'Search Shipment:'
  end
  object Label12: TLabel
    Left = 396
    Top = 155
    Width = 35
    Height = 13
    Caption = 'Status:'
  end
  object edtTerm: TEdit
    Left = 551
    Top = 174
    Width = 84
    Height = 21
    TabOrder = 0
  end
  object edtClientName: TEdit
    Left = 25
    Top = 67
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object btnCommitBatch: TButton
    Left = 146
    Top = 346
    Width = 75
    Height = 25
    Caption = 'Commit Batch'
    TabOrder = 2
    OnClick = btnCommitBatchClick
  end
  object btnClearBatch: TButton
    Left = 259
    Top = 346
    Width = 75
    Height = 25
    Caption = 'Clear Batch'
    TabOrder = 3
    OnClick = btnClearBatchClick
  end
  object sgBatch: TStringGrid
    Left = 24
    Top = 220
    Width = 320
    Height = 120
    TabOrder = 4
  end
  object btnSearchShipments: TButton
    Left = 620
    Top = 346
    Width = 109
    Height = 25
    Caption = 'Search Shipments'
    TabOrder = 5
    OnClick = btnSearchShipmentsClick
  end
  object dbgResults: TDBGrid
    Left = 394
    Top = 220
    Width = 335
    Height = 120
    TabOrder = 6
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object cbOrigin: TComboBox
    Left = 24
    Top = 113
    Width = 73
    Height = 21
    TabOrder = 7
    Text = 'cbOrigin'
  end
  object cbDestination: TComboBox
    Left = 148
    Top = 113
    Width = 73
    Height = 21
    TabOrder = 8
    Text = 'ComboBox1'
  end
  object cbVehicleID: TComboBox
    Left = 146
    Top = 174
    Width = 75
    Height = 21
    TabOrder = 9
    Text = 'cbVehicleID'
  end
  object cbStatusFilter: TComboBox
    Left = 394
    Top = 174
    Width = 73
    Height = 21
    TabOrder = 10
    Text = 'ComboBox1'
  end
  object cbDriverAssign: TComboBox
    Left = 551
    Top = 113
    Width = 84
    Height = 21
    TabOrder = 11
    Text = 'ComboBox1'
  end
  object cbVehicleAssign: TComboBox
    Left = 394
    Top = 113
    Width = 73
    Height = 21
    TabOrder = 12
    Text = 'ComboBox1'
  end
  object cbDriverID: TComboBox
    Left = 261
    Top = 174
    Width = 73
    Height = 21
    TabOrder = 13
    Text = 'ComboBox1'
  end
  object btnAddToBatch: TButton
    Left = 25
    Top = 346
    Width = 75
    Height = 25
    Caption = 'Add to Batch'
    TabOrder = 14
    OnClick = btnAddToBatchClick
  end
  object btnAssignToShipment: TButton
    Left = 394
    Top = 346
    Width = 109
    Height = 25
    Caption = 'Assign to Shipment'
    TabOrder = 15
    OnClick = btnAssignToShipmentClick
  end
  object sedWeight: TSpinEdit
    Left = 24
    Top = 174
    Width = 72
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 16
    Value = 0
  end
  object btnDeleteShipments: TButton
    Left = 509
    Top = 346
    Width = 105
    Height = 25
    Caption = 'Delete Shipments'
    TabOrder = 17
    OnClick = btnDeleteShipmentsClick
  end
  object sedShipmentIDAssign: TSpinEdit
    Left = 394
    Top = 66
    Width = 70
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 18
    Value = 0
  end
end
