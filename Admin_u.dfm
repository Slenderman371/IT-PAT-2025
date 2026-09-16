object frmAdmin: TfrmAdmin
  Left = 0
  Top = 0
  Caption = 'Admin'
  ClientHeight = 538
  ClientWidth = 745
  Color = clSkyBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = ConnectDatabase
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 62
    Height = 13
    Caption = 'Vehicle type:'
  end
  object Label2: TLabel
    Left = 376
    Top = 8
    Width = 65
    Height = 13
    Caption = 'Min Capacity:'
  end
  object Label3: TLabel
    Left = 16
    Top = 384
    Width = 105
    Height = 13
    Caption = 'Minimum driver count:'
  end
  object Label4: TLabel
    Left = 18
    Top = 427
    Width = 52
    Height = 13
    Caption = 'Date from:'
  end
  object Label5: TLabel
    Left = 129
    Top = 427
    Width = 16
    Height = 13
    Caption = 'To:'
  end
  object dbgVehicles: TDBGrid
    Left = 16
    Top = 96
    Width = 313
    Height = 120
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object dbgRoutes: TDBGrid
    Left = 376
    Top = 96
    Width = 328
    Height = 120
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object dbgResults: TDBGrid
    Left = 16
    Top = 240
    Width = 688
    Height = 120
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object sedMinCapacity: TSpinEdit
    Left = 376
    Top = 27
    Width = 113
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
  object edtVehicleType: TEdit
    Left = 16
    Top = 27
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object btnSearchVehicles: TButton
    Left = 16
    Top = 54
    Width = 121
    Height = 25
    Caption = 'Search Vehicles'
    TabOrder = 5
    OnClick = btnSearchVehiclesClick
  end
  object btnVehichleCapacityStats: TButton
    Left = 376
    Top = 54
    Width = 113
    Height = 25
    Caption = 'Vehicle capacity stats'
    TabOrder = 6
    OnClick = btnVehichleCapacityStatsClick
  end
  object btnDriverWorkload: TButton
    Left = 258
    Top = 379
    Width = 121
    Height = 25
    Caption = 'Driver workload'
    TabOrder = 7
    OnClick = btnDriverWorkloadClick
  end
  object dtTo: TDateTimePicker
    Left = 127
    Top = 446
    Width = 103
    Height = 21
    Date = 45887.882826157410000000
    Time = 45887.882826157410000000
    TabOrder = 8
  end
  object dtFrom: TDateTimePicker
    Left = 18
    Top = 446
    Width = 103
    Height = 21
    Date = 45887.882826157410000000
    Time = 45887.882826157410000000
    TabOrder = 9
  end
  object btnExportReport: TButton
    Left = 18
    Top = 485
    Width = 103
    Height = 25
    Caption = 'Export Report'
    TabOrder = 10
    OnClick = btnExportReportClick
  end
  object btnShipmentsReport: TButton
    Left = 127
    Top = 485
    Width = 137
    Height = 25
    Caption = 'Generate shipment report'
    TabOrder = 11
    OnClick = btnShipmentsReportClick
  end
  object btnFilterByDate: TButton
    Left = 258
    Top = 442
    Width = 121
    Height = 25
    Caption = 'Filter by date'
    TabOrder = 12
    OnClick = btnFilterByDateClick
  end
  object sedMinCount: TSpinEdit
    Left = 127
    Top = 381
    Width = 103
    Height = 22
    MaxValue = 10000
    MinValue = 0
    TabOrder = 13
    Value = 0
  end
end
