object Form1: TForm1
  Left = 932
  Top = 353
  Width = 444
  Height = 459
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edDB: TEdit
    Left = 40
    Top = 8
    Width = 361
    Height = 21
    TabOrder = 0
    Text = 'localhost:D:\IBBases\Data1\data.gdb'
  end
  object edSQL: TEdit
    Left = 40
    Top = 40
    Width = 361
    Height = 21
    TabOrder = 1
    Text = 'SELECT * FROM EMPLOYEES'
  end
  object mmRes: TMemo
    Left = 24
    Top = 120
    Width = 393
    Height = 289
    TabOrder = 2
  end
  object btnGet: TButton
    Left = 176
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Open'
    TabOrder = 3
    OnClick = btnGetClick
  end
end
