object frmAbout: TfrmAbout
  Left = 443
  Top = 304
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 145
  ClientWidth = 267
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  OnCreate = FormCreate
  DesignSize = (
    267
    145)
  PixelsPerInch = 96
  TextHeight = 13
  object lblHeader: TLabel
    Left = 24
    Top = 24
    Width = 219
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Header'
    ExplicitWidth = 241
  end
  object lblInfo: TLabel
    Left = 24
    Top = 56
    Width = 219
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Info'
    ExplicitWidth = 241
  end
  object lblReadInfos: TLabel
    Left = 24
    Top = 85
    Width = 219
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Read some infos'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblReadInfosClick
  end
  object btnOK: TButton
    Left = 187
    Top = 112
    Width = 72
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = btnOKClick
  end
end
