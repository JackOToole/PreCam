object fmMain: TfmMain
  Left = 2
  Top = 15
  Caption = 'Pre Cam II'
  ClientHeight = 726
  ClientWidth = 1239
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sb: TStatusBar
    Left = 0
    Top = 696
    Width = 1239
    Height = 30
    Panels = <
      item
        Text = 'Crew'
        Width = 200
      end
      item
        Text = 'View'
        Width = 200
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Text = 'Notes'
        Width = 550
      end
      item
        Alignment = taRightJustify
        Text = 'PRE CAM II a Program by Jack O'#39'Toole          '
        Width = 50
      end>
    OnDrawPanel = sbDrawPanel
    ExplicitWidth = 1016
  end
  object pc: TPageControl
    Left = 0
    Top = 0
    Width = 1239
    Height = 696
    ActivePage = tsDistribution
    Align = alClient
    TabOrder = 1
    OnChange = pcChange
    ExplicitWidth = 1016
    object tsListview: TTabSheet
      Caption = 'List View'
      ImageIndex = 2
      ExplicitWidth = 1008
      object lblExpiree: TLabel
        Left = 481
        Top = 591
        Width = 56
        Height = 15
        Caption = 'Expiree'
        Font.Charset = ANSI_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
      end
      object ListNames: TListBox
        Left = 0
        Top = 0
        Width = 129
        Height = 635
        Align = alLeft
        ItemHeight = 13
        TabOrder = 1
        OnClick = ListNamesClick
      end
      object rtDiag: TRichEdit
        Left = 129
        Top = 0
        Width = 1102
        Height = 635
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          '')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 2
        WantReturns = False
        WordWrap = False
        ExplicitWidth = 879
      end
      object pnlListView: TPanel
        Left = 0
        Top = 635
        Width = 1231
        Height = 33
        Align = alBottom
        TabOrder = 0
        ExplicitWidth = 1008
        object Label1: TLabel
          Left = 303
          Top = 10
          Width = 34
          Height = 13
          Caption = 'Search'
        end
        object lblGlobalBids: TLabel
          Left = 18
          Top = -18
          Width = 88
          Height = 16
          Caption = 'Global Bids'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
        end
        object btnCheckbuckets: TButton
          Left = 2
          Top = 6
          Width = 87
          Height = 25
          Caption = 'Check Buckets'
          TabOrder = 2
          OnClick = btnCheckbucketsClick
        end
        object editSearch: TEdit
          Left = 352
          Top = 5
          Width = 88
          Height = 21
          TabOrder = 5
          OnChange = editSearchChange
        end
        object btnCheckMBT: TButton
          Left = 118
          Top = 6
          Width = 80
          Height = 25
          Caption = 'Check MBT'
          TabOrder = 4
        end
        object btnListFirst: TBitBtn
          Left = 770
          Top = 6
          Width = 60
          Height = 25
          Caption = 'First'
          TabOrder = 6
          OnClick = btnDiagFirstClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888888088888808888888808888800888888880888800088
            8888880888000088888888088000008888888808000000888888880000000088
            8888880800000088888888088000008888888808880000888888880888800088
            8888880888880088888888088888808888888888888888888888}
        end
        object btnListPrev: TBitBtn
          Left = 831
          Top = 6
          Width = 60
          Height = 25
          Caption = 'Prev'
          TabOrder = 0
          OnClick = btnDiagPrevClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888888888888808888888888888800888888888888800088
            8888888888000088888888888000008888888888000000888888888000000088
            8888888800000088888888888000008888888888880000888888888888800088
            8888888888880088888888888888808888888888888888888888}
        end
        object btnListNext: TBitBtn
          Left = 892
          Top = 6
          Width = 60
          Height = 25
          Caption = 'Next'
          TabOrder = 1
          OnClick = btnDiagNextClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888888888808888888888888880088888888888888000888
            8888888888000088888888888800000888888888880000008888888888000000
            0888888888000000888888888800000888888888880000888888888888000888
            8888888888008888888888888808888888888888888888888888}
          Layout = blGlyphRight
        end
        object btnListLast: TBitBtn
          Left = 955
          Top = 6
          Width = 60
          Height = 25
          Caption = 'Last'
          TabOrder = 3
          OnClick = btnDiafLastClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888888888808888880888888880088888088888888000888
            8088888888000088808888888800000880888888880000008088888888000000
            0088888888000000808888888800000880888888880000888088888888000888
            8088888888008888808888888808888880888888888888888888}
          Layout = blGlyphRight
        end
        object btnPreAlloc: TButton
          Left = 201
          Top = 7
          Width = 80
          Height = 24
          Caption = 'Pre Alloc'
          TabOrder = 7
          OnClick = btnPreAllocClick
        end
        object btnMoveBids: TBitBtn
          Left = 607
          Top = 6
          Width = 98
          Height = 25
          Caption = 'Move To Bids'
          TabOrder = 8
          OnClick = btnMoveBidsClick
        end
        object btnMoveTopDiag: TBitBtn
          Left = 512
          Top = 6
          Width = 97
          Height = 25
          Caption = 'Top of Diag'
          TabOrder = 9
          OnClick = btnMoveDiagTopClick
        end
        object cbCheckBuckets2Bps: TCheckBox
          Left = 93
          Top = 8
          Width = 19
          Height = 17
          Caption = 'cbCheckBuckets2Bps'
          TabOrder = 10
        end
      end
    end
    object tsBuckets: TTabSheet
      Caption = 'Buckets'
      ImageIndex = 3
      ExplicitWidth = 1008
      object Label2: TLabel
        Left = 144
        Top = 40
        Width = 72
        Height = 13
        Caption = 'Buckets in Use'
      end
      object sgBuckets: TStringGrid
        Left = 12
        Top = 64
        Width = 319
        Height = 259
        ColCount = 1
        FixedCols = 0
        RowCount = 31
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs]
        ParentFont = False
        TabOrder = 0
      end
      object btnDeleteBucket: TButton
        Left = 186
        Top = 412
        Width = 145
        Height = 25
        Caption = 'Clear Buckets'
        TabOrder = 1
        OnClick = btnDeleteBucketClick
      end
      object GroupBox1: TGroupBox
        Left = 457
        Top = 64
        Width = 417
        Height = 377
        Caption = 'Create a Bucket'
        TabOrder = 2
        object lblLimit: TLabel
          Left = 23
          Top = 49
          Width = 37
          Height = 16
          Caption = 'Limit 1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 330
          Top = 44
          Width = 27
          Height = 16
          Caption = 'Limit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object btnOKBuckets: TButton
          Left = 236
          Top = 329
          Width = 145
          Height = 25
          Caption = 'Add to Buckets'
          Default = True
          ModalResult = 1
          TabOrder = 0
          OnClick = btnOKBucketsClick
        end
        object listTripCodes: TListBox
          Left = 110
          Top = 47
          Width = 200
          Height = 242
          Columns = 3
          ItemHeight = 13
          TabOrder = 1
          OnDblClick = listTripCodesDblClick
        end
        object sgPatterns: TStringGrid
          Left = 16
          Top = 69
          Width = 82
          Height = 221
          ColCount = 1
          FixedCols = 0
          RowCount = 30
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
          ScrollBars = ssVertical
          TabOrder = 2
          OnDblClick = sgPatternsDblClick
        end
        object btnSelectroutecode: TButton
          Left = 17
          Top = 329
          Width = 124
          Height = 25
          Caption = 'Select Route Code'
          TabOrder = 3
          OnClick = listTripCodesDblClick
        end
        object ListLimitValue: TListBox
          Left = 328
          Top = 63
          Width = 41
          Height = 223
          ItemHeight = 13
          TabOrder = 4
          OnClick = ListLimitValueClick
        end
      end
      object Button1: TButton
        Left = 3
        Top = 346
        Width = 319
        Height = 25
        Caption = 'Check Buckets'
        TabOrder = 3
        OnClick = btnCheckbucketsClick
      end
    end
    object tsSplitView: TTabSheet
      Caption = 'Split View'
      ImageIndex = 7
      ExplicitWidth = 1008
      object Splitter2: TSplitter
        Left = 0
        Top = 300
        Width = 1231
        Height = 5
        Cursor = crVSplit
        Align = alTop
        ExplicitWidth = 1016
      end
      object ToolBar1: TToolBar
        Left = 0
        Top = 639
        Width = 1231
        Height = 29
        Align = alBottom
        ButtonHeight = 23
        ButtonWidth = 87
        TabOrder = 0
        ExplicitWidth = 1008
        object btnSplitFirst: TBitBtn
          Left = 0
          Top = 0
          Width = 63
          Height = 23
          Caption = 'First'
          TabOrder = 3
          OnClick = btnDiagFirstClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888888088888808888888808888800888888880888800088
            8888880888000088888888088000008888888808000000888888880000000088
            8888880800000088888888088000008888888808880000888888880888800088
            8888880888880088888888088888808888888888888888888888}
        end
        object bntSplitPrev: TBitBtn
          Left = 63
          Top = 0
          Width = 63
          Height = 23
          Caption = 'Prev'
          TabOrder = 2
          OnClick = btnDiagPrevClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888888888888808888888888888800888888888888800088
            8888888888000088888888888000008888888888000000888888888000000088
            8888888800000088888888888000008888888888880000888888888888800088
            8888888888880088888888888888808888888888888888888888}
        end
        object btnSplitNext: TBitBtn
          Left = 126
          Top = 0
          Width = 63
          Height = 23
          Caption = 'Next'
          TabOrder = 1
          OnClick = btnDiagNextClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888888888808888888888888880088888888888888000888
            8888888888000088888888888800000888888888880000008888888888000000
            0888888888000000888888888800000888888888880000888888888888000888
            8888888888008888888888888808888888888888888888888888}
        end
        object btnSplitLast: TBitBtn
          Left = 189
          Top = 0
          Width = 63
          Height = 23
          Caption = 'Last'
          TabOrder = 0
          OnClick = btnDiafLastClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888888888808888880888888880088888088888888000888
            8088888888000088808888888800000880888888880000008088888888000000
            0088888888000000808888888800000880888888880000888088888888000888
            8088888888008888808888888808888880888888888888888888}
        end
        object ToolButton1: TToolButton
          Left = 252
          Top = 0
          Width = 8
          Caption = 'ToolButton1'
          Style = tbsSeparator
        end
        object btnNextDifference: TButton
          Left = 260
          Top = 0
          Width = 173
          Height = 23
          Caption = 'Next Difference'
          TabOrder = 5
          OnClick = btnNextDifferenceClick
        end
        object btnCompare: TButton
          Left = 433
          Top = 0
          Width = 81
          Height = 23
          Caption = 'Compare'
          TabOrder = 4
          Visible = False
          OnClick = btnCompareClick
        end
        object lblSplitCompare: TLabel
          Left = 514
          Top = 0
          Width = 100
          Height = 23
          AutoSize = False
        end
      end
      object rtSplit1: TRichEdit
        Left = 0
        Top = 0
        Width = 1231
        Height = 300
        Align = alTop
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          '')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
        WantReturns = False
        WordWrap = False
        ExplicitWidth = 1008
      end
      object rtSplit2: TRichEdit
        Left = 0
        Top = 305
        Width = 1231
        Height = 334
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          '')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 2
        WantReturns = False
        WordWrap = False
        OnChange = rtSplit2Change
        ExplicitWidth = 1008
      end
    end
    object tsCompare: TTabSheet
      Caption = 'Compare'
      ImageIndex = 8
      OnContextPopup = tsCompareContextPopup
      ExplicitWidth = 1008
      object chartLineRating: TChart
        Left = 0
        Top = 0
        Width = 1231
        Height = 668
        AllowZoom = False
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Title.Text.Strings = (
          '')
        View3D = False
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 1008
        object Series4: TLineSeries
          Marks.ArrowLength = 8
          Marks.BackColor = clLime
          Marks.Visible = False
          SeriesColor = clGreen
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
        object Series3: TLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = clRed
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
    end
    object tsSummary: TTabSheet
      Caption = 'Summary'
      ImageIndex = 4
      ExplicitWidth = 1008
      object ToolBar2: TToolBar
        Left = 0
        Top = 0
        Width = 1231
        Height = 29
        Caption = 'ToolBar2'
        TabOrder = 0
        ExplicitWidth = 1008
      end
      object rtSummary: TRichEdit
        Left = 0
        Top = 29
        Width = 1231
        Height = 639
        Align = alClient
        Color = clCream
        TabOrder = 1
        ExplicitWidth = 1008
      end
    end
    object tsDistribution: TTabSheet
      Caption = 'Distribution'
      ImageIndex = 5
      ExplicitLeft = -44
      ExplicitTop = 22
      ExplicitWidth = 1008
      object chartDistribution: TChart
        Left = 3
        Top = 3
        Width = 823
        Height = 663
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Title.Text.Strings = (
          '')
        BottomAxis.Title.Caption = 'Crew'
        Legend.Visible = False
        View3D = False
        TabOrder = 0
        object SeriesDistribution: TBarSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = clRed
          BarPen.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Bar'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
      object lstRouteCodes: TListBox
        Left = 845
        Top = 55
        Width = 53
        Height = 138
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 1
        OnClick = lstRouteCodesClick
      end
      object btnCleaSelectedrRouteCodes: TButton
        Left = 845
        Top = 24
        Width = 155
        Height = 25
        Caption = 'Clear Selected Route Codes'
        TabOrder = 2
        OnClick = btnCleaSelectedrRouteCodesClick
      end
      object btnWeekendsOff: TButton
        Left = 872
        Top = 296
        Width = 121
        Height = 25
        Caption = 'Weekends Off'
        TabOrder = 3
        OnClick = btnWeekendsOffClick
      end
      object btnDaysAway: TButton
        Left = 872
        Top = 248
        Width = 121
        Height = 25
        Caption = 'Days Away'
        TabOrder = 4
        OnClick = btnDaysAwayClick
      end
    end
  end
  object dlgOpen: TOpenDialog
    Filter = 'Diagnostic Files|*.csv*|Text files|*.txt|AnyFile|*.*'
    FilterIndex = 0
    Options = [ofOverwritePrompt, ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 750
    Top = 31
  end
  object dlgSave: TSaveDialog
    Left = 722
    Top = 31
  end
  object dlgPrint: TPrintDialog
    Left = 699
    Top = 31
  end
  object dlgPrinterSetup: TPrinterSetupDialog
    Left = 676
    Top = 31
  end
  object MainMenu: TMainMenu
    Left = 16
    Top = 47
    object File1: TMenuItem
      Caption = 'File'
      object mnuOpen: TMenuItem
        Caption = 'Open Diag'
        OnClick = mnuOpenClick
      end
      object mnuOpen2nd: TMenuItem
        Caption = 'Open 2nd Diag'
        Enabled = False
        OnClick = mnuOpen2ndClick
      end
      object mnuClose2ndDiag: TMenuItem
        Caption = 'Close 2nd Diag'
        OnClick = mnuClose2ndDiagClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuLoadtoData: TMenuItem
        Caption = 'Load to Data'
      end
      object mnuFileCreateawards: TMenuItem
        Caption = 'Create awards'
        OnClick = mnuFileCreateawardsClick
      end
      object mnuEditCategories: TMenuItem
        Caption = 'Edit Categories'
        OnClick = mnuEditCategoriesClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object mnuEditUndo: TMenuItem
        Caption = '&Undo'
        ShortCut = 16474
      end
      object mnuSelectAll: TMenuItem
        Caption = 'Select All'
        ShortCut = 16449
        OnClick = mnuSelectAllClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mnuEditCut: TMenuItem
        Caption = 'Cu&t'
        ShortCut = 16472
        OnClick = mnuEditCutClick
      end
      object mnuEditCopy: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
        OnClick = mnuEditCopyClick
      end
      object mnuEditPaste: TMenuItem
        Caption = '&Paste'
        ShortCut = 16470
        OnClick = mnuEditPasteClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object ff: TMenuItem
        Caption = '&Find Pattern / Route code'
        ShortCut = 16454
        OnClick = ffClick
      end
    end
    object mnuView: TMenuItem
      Caption = 'View'
      object mnuAlphabetical: TMenuItem
        Caption = 'Alphabetical'
        OnClick = mnuAlphabeticalClick
      end
      object mnuShowList: TMenuItem
        Caption = '&Show List '
        OnClick = mnuShowListClick
      end
      object mnuHideList: TMenuItem
        Caption = '&Hide List'
        OnClick = mnuHideListClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuViewCaptain: TMenuItem
        Tag = 1
        Caption = 'Captain'
        OnClick = mnuViewRankClick
      end
      object mnuVeiwF_O: TMenuItem
        Tag = 2
        Caption = 'F/O'
        OnClick = mnuViewRankClick
      end
      object mnuViewS_O: TMenuItem
        Tag = 3
        Caption = 'S/O'
        OnClick = mnuViewRankClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
    end
    object mnuFilters: TMenuItem
      Caption = 'Filters'
      object mnuFiltersPreAlloc: TMenuItem
        Tag = 1
        Caption = 'Pre Allocations'
        RadioItem = True
        OnClick = mnuFiltersClick
      end
      object mnuFiltersLowLines: TMenuItem
        Tag = 2
        Caption = 'Low Lines'
        RadioItem = True
        OnClick = mnuFiltersClick
      end
      object mnuFiltersTrainingAllocated: TMenuItem
        Tag = 3
        Caption = 'Training Allocated'
        RadioItem = True
        OnClick = mnuFiltersClick
      end
      object mnuFiltersUnlocked: TMenuItem
        Tag = 4
        Caption = 'Unlocked'
        RadioItem = True
        OnClick = mnuFiltersClick
      end
    end
    object mnuAbout: TMenuItem
      Caption = 'About'
      OnClick = mnuAboutClick
    end
  end
  object dlgLoad: TOpenDialog
    Left = 616
    Top = 40
  end
  object FindDialog: TFindDialog
    Options = [frDown, frDisableMatchCase, frDisableUpDown, frDisableWholeWord]
    OnFind = FindDialogFind
    Left = 592
    Top = 40
  end
end
