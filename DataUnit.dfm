object DM: TDM
  OldCreateOrder = False
  Left = 752
  Top = 340
  Height = 389
  Width = 320
  object DataSetProvider1: TDataSetProvider
    DataSet = qry
    Left = 64
    Top = 144
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 136
    Top = 144
  end
  object qry: TIBQuery
    Database = db
    Transaction = IBTransaction1
    Left = 192
    Top = 48
  end
  object db: TIBDatabase
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey')
    LoginPrompt = False
    AllowStreamedConnected = False
    Left = 64
    Top = 48
  end
  object IBTransaction1: TIBTransaction
    DefaultDatabase = db
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 128
    Top = 48
  end
end
