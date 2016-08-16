object fmAbout: TfmAbout
  Left = 200
  Top = 108
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 213
  ClientWidth = 298
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 281
    Height = 161
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object ProgramIcon: TImage
      Left = 8
      Top = 8
      Width = 65
      Height = 57
      Picture.Data = {
        055449636F6E0000010001002020100000000000E80200001600000028000000
        2000000040000000010004000000000080020000000000000000000000000000
        0000000000000000000080000080000000808000800000008000800080800000
        C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF004EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEE000EEEEEEEEEEEEEEEEEEEEEEEEEEEE0E0A0EEEEE
        EEEEEEEEEEEEEEEEEEEEE0EE0AA0EEEEEEEEEEEEEEEEEEEEEEEE0EEE0AAA0EEE
        EEEEEEEEEEEEEEEEEEE0EEEE0AAAA0EEEEEEEEEEEEEEEEEEEE0EE0EE0A00AA0E
        EEEEEEEEEEEEEEEEE0EE000E0A0AAAA0EEEEEEEEEEEEEEEE0EEEE0EE0AAA00AA
        0EEEEEEEEEEEEEE0EE0EEEE060AA0AAA0EEEEEEEEEEEEEE0E000EE06660AAA0A
        0EEEEEEEEEEEEEE0EE0EE0666660AA000EEEEEEEEEEEEEE0EEEE066666660AAA
        0EEEEEEEEEEEEEE0EEE06666666660AA0EEEEEEEEEEEEEE0EE0666666666660A
        0EEEEEEEEEEEEEE0E0666660066666600EEEEEEEEEEEEEE00666660000666666
        0EEEEEEEEEEEEEE066666600006666660EEEEEEEEEEEEEEE0666666006666660
        EEEEEEEEEEEEEEEEE06666666666660EEEEEEEEEEEEEEEEEEE066666666660EE
        EEEEEEEEEEEEEEEEEEE0666666660EEEEEEEEEEEEEEEEEEEEEEE06666660EEEE
        EEEEEEEEEEEEEEEEEEEEE066660EEEEEEEEEEEEEEEEEEEEEEEEEEE0660EEEEEE
        EEEEEEEEEEEEEEEEEEEEEEE00EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
        EEEEEEEE00000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000}
      Stretch = True
      IsControl = True
    end
    object ProductName: TLabel
      Left = 88
      Top = 16
      Width = 49
      Height = 13
      Caption = 'Pre Cam II'
      IsControl = True
    end
    object Version: TLabel
      Left = 88
      Top = 40
      Width = 35
      Height = 13
      Caption = 'Version'
      IsControl = True
    end
    object Copyright: TLabel
      Left = 8
      Top = 80
      Width = 155
      Height = 13
      Caption = 'Copyright      Jack O'#39'Toole  2009'
      IsControl = True
    end
    object Comments: TLabel
      Left = 8
      Top = 104
      Width = 133
      Height = 13
      Caption = 'jackotool@optusnet.com.au'
      WordWrap = True
      IsControl = True
    end
  end
  object OKButton: TButton
    Left = 111
    Top = 180
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end