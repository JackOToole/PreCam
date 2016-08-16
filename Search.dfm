object fmSearch: TfmSearch
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Find'
  ClientHeight = 179
  ClientWidth = 384
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 281
    Height = 153
    Shape = bsFrame
  end
  object lblfindText: TLabel
    Left = 40
    Top = 32
    Width = 106
    Height = 13
    Caption = 'Pattern or route Code'
  end
  object Lblmsg: TLabel
    Left = 40
    Top = 112
    Width = 6
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnFind: TButton
    Left = 300
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Find Next'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 300
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Edit: TEdit
    Left = 40
    Top = 51
    Width = 121
    Height = 31
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
end
