object frmTarefas: TfrmTarefas
  Left = 0
  Top = 0
  Caption = 'Tarefas'
  ClientHeight = 610
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 610
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 994
      Height = 40
      Align = alTop
      Caption = 'Lista de Tarefas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 40
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 212
    end
    object Panel1: TPanel
      Left = 0
      Top = 569
      Width = 1000
      Height = 41
      Align = alBottom
      TabOrder = 0
      object btnEstatísticas: TButton
        AlignWithMargins = True
        Left = 919
        Top = 4
        Width = 75
        Height = 31
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        Caption = 'Estat'#237'sticas'
        TabOrder = 0
        OnClick = btnEstatísticasClick
      end
      object btnExcluir: TButton
        AlignWithMargins = True
        Left = 834
        Top = 4
        Width = 75
        Height = 31
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        Caption = 'Excluir'
        TabOrder = 1
        OnClick = btnExcluirClick
      end
      object btnConcluir: TButton
        AlignWithMargins = True
        Left = 749
        Top = 4
        Width = 75
        Height = 31
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        Caption = 'Concluir'
        DisabledImageName = 'Button3'
        TabOrder = 2
        OnClick = btnConcluirClick
      end
      object btnAdicionar: TButton
        AlignWithMargins = True
        Left = 664
        Top = 4
        Width = 75
        Height = 31
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        Caption = 'Adicionar'
        TabOrder = 3
        OnClick = btnAdicionarClick
      end
      object btnCarregar: TButton
        AlignWithMargins = True
        Left = 579
        Top = 4
        Width = 75
        Height = 31
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        Caption = 'Carregar'
        TabOrder = 4
        OnClick = btnCarregarClick
      end
    end
    object GridTarefas: TStringGrid
      AlignWithMargins = True
      Left = 3
      Top = 49
      Width = 994
      Height = 517
      Align = alClient
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goRowSelect, goThumbTracking, goFixedRowDefAlign]
      TabOrder = 1
      ColWidths = (
        64
        106
        120
        138
        64)
    end
  end
  object RESTClient: TRESTClient
    Accept = 'application/json'
    BaseURL = 'http://localhost:9000'
    ContentType = 'application/json'
    Params = <>
    SynchronizedEvents = False
    Left = 728
    Top = 16
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 816
    Top = 16
  end
  object RESTResponse: TRESTResponse
    Left = 912
    Top = 16
  end
end
