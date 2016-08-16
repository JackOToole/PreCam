object fmCategories: TfmCategories
  Left = 0
  Top = 0
  Caption = 'Edit Categories'
  ClientHeight = 298
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnClose: TButton
    Left = 221
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object EditStr: TEdit
    Left = 48
    Top = 24
    Width = 61
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 0
  end
  object btnAdd: TButton
    Left = 173
    Top = 24
    Width = 73
    Height = 31
    Caption = 'Add'
    Default = True
    TabOrder = 2
    OnClick = btnAddClick
  end
  object btnDelete: TButton
    Left = 173
    Top = 61
    Width = 73
    Height = 31
    Caption = 'Delete'
    TabOrder = 3
    OnClick = btnDeleteClick
  end
  object listCategories: TListBox
    Left = 48
    Top = 72
    Width = 61
    Height = 193
    DragMode = dmAutomatic
    ItemHeight = 13
    TabOrder = 4
    OnDragDrop = listCategoriesDragDrop
    OnDragOver = listCategoriesDragOver
    OnMouseDown = listCategoriesMouseDown
  end
end
