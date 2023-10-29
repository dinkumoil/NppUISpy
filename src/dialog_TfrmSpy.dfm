object frmSpy: TfrmSpy
  Left = 525
  Top = 410
  ActiveControl = cbxSearchText
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 357
  ClientWidth = 785
  Color = clBtnFace
  Constraints.MinHeight = 380
  Constraints.MinWidth = 801
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMode = pmAuto
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    785
    357)
  PixelsPerInch = 96
  TextHeight = 13
  object lblSearchFor: TLabel
    Left = 228
    Top = 332
    Width = 54
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Search for:'
    ExplicitTop = 319
  end
  object vstMenuItems: TVirtualStringTree
    Left = 8
    Top = 8
    Width = 377
    Height = 273
    Anchors = [akLeft, akTop, akRight, akBottom]
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.MainColumn = 1
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible, hoAutoSpring]
    HintMode = hmTooltip
    Images = imlToolbarButtonIcons
    IncrementalSearch = isAll
    Indent = 15
    ParentShowHint = False
    PopupMenu = mnuItemContextMenu
    ShowHint = True
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toAutoChangeScale]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines, toAlwaysHideSelection]
    TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
    OnDrawText = vstMenuItemsDrawText
    OnGetText = vstMenuItemsGetText
    OnPaintText = vstMenuItemsPaintText
    OnGetImageIndex = vstMenuItemsGetImageIndex
    OnGetHint = vstMenuItemsGetHint
    OnHeaderClick = vstMenuItemsHeaderClick
    OnIncrementalSearch = vstMenuItemsIncrementalSearch
    OnKeyPress = vstMenuItemsKeyPress
    OnMouseDown = vstMenuItemsMouseDown
    OnNodeClick = vstMenuItemsNodeClick
    Columns = <
      item
        Alignment = taCenter
        MaxWidth = 35
        MinWidth = 35
        Options = [coEnabled, coParentBidiMode, coParentColor, coShowDropMark, coVisible, coAllowFocus]
        Position = 0
        Width = 35
        WideText = 'Icon'
      end
      item
        MinWidth = 80
        Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coSmartResize, coAllowFocus]
        Position = 1
        Width = 240
        WideText = 'Menu Items'
      end
      item
        MinWidth = 30
        Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coSmartResize, coAllowFocus]
        Position = 2
        Width = 75
        WideText = 'Command Id'
      end>
  end
  object btnExpand: TButton
    Left = 170
    Top = 285
    Width = 22
    Height = 22
    Hint = 'Expand all'
    Anchors = [akLeft, akBottom]
    Caption = '&-'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = btnExpandClick
  end
  object btnCollapse: TButton
    Left = 142
    Top = 285
    Width = 22
    Height = 22
    Hint = 'Collapse all'
    Anchors = [akLeft, akBottom]
    Caption = '&+'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = btnCollapseClick
  end
  object vstToolbarButtons: TVirtualStringTree
    Left = 400
    Top = 8
    Width = 377
    Height = 273
    Anchors = [akTop, akRight, akBottom]
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.MainColumn = 1
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible, hoAutoSpring]
    HintMode = hmTooltip
    Images = imlToolbarButtonIcons
    IncrementalSearch = isAll
    Indent = 0
    ParentShowHint = False
    PopupMenu = mnuItemContextMenu
    ShowHint = True
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toAutoChangeScale]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines, toAlwaysHideSelection]
    TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
    OnDrawText = vstToolbarButtonsDrawText
    OnGetText = vstToolbarButtonsGetText
    OnPaintText = vstToolbarButtonsPaintText
    OnGetImageIndex = vstToolbarButtonsGetImageIndex
    OnGetHint = vstToolbarButtonsGetHint
    OnHeaderClick = vstToolbarButtonsHeaderClick
    OnIncrementalSearch = vstToolbarButtonsIncrementalSearch
    OnKeyPress = vstToolbarButtonsKeyPress
    OnMouseDown = vstToolbarButtonsMouseDown
    OnNodeClick = vstToolbarButtonsNodeClick
    Columns = <
      item
        Alignment = taCenter
        MaxWidth = 35
        MinWidth = 35
        Options = [coEnabled, coParentBidiMode, coParentColor, coShowDropMark, coVisible, coAllowFocus]
        Position = 0
        Width = 35
        WideText = 'Icon'
      end
      item
        MinWidth = 80
        Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coSmartResize, coAllowFocus]
        Position = 1
        Width = 240
        WideText = 'Hint Text'
      end
      item
        MinWidth = 30
        Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coSmartResize, coAllowFocus]
        Position = 2
        Width = 75
        WideText = 'Command Id'
      end>
  end
  object btnQuit: TButton
    Left = 697
    Top = 324
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cl&ose'
    TabOrder = 13
    OnClick = btnQuitClick
  end
  object btnReloadData: TButton
    Left = 598
    Top = 324
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Reload'
    TabOrder = 12
    OnClick = btnReloadDataClick
  end
  object btnSearchBackwards: TButton
    Left = 396
    Top = 304
    Width = 22
    Height = 22
    Hint = 'Search backwards'
    Anchors = [akRight, akBottom]
    Caption = '&<'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnClick = btnSearchClick
  end
  object btnSearchForwards: TButton
    Left = 424
    Top = 304
    Width = 22
    Height = 22
    Hint = 'Search forwards'
    Anchors = [akRight, akBottom]
    Caption = '&>'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = btnSearchClick
  end
  object rbtSearchForMenuItem: TRadioButton
    Left = 292
    Top = 331
    Width = 73
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = '&Menu item'
    Checked = True
    TabOrder = 10
    TabStop = True
    OnClick = rbtSearchForClick
  end
  object rbtSearchForCommandId: TRadioButton
    Left = 370
    Top = 331
    Width = 85
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = '&Command id'
    TabOrder = 11
    TabStop = True
    OnClick = rbtSearchForClick
  end
  object chkWrapAround: TCheckBox
    Left = 458
    Top = 306
    Width = 83
    Height = 17
    Hint = 
      'When search reaches start/end of list,'#13#10'continue from other end ' +
      'of list'
    Anchors = [akRight, akBottom]
    Caption = '&Wrap around'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = chkWrapAroundClick
  end
  object chkSearchSelectMenuItems: TCheckBox
    Left = 8
    Top = 287
    Width = 97
    Height = 17
    Hint = 'Search in menu items tree'
    Anchors = [akLeft, akBottom]
    Caption = '&Select for search'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = chkSearchSelectClick
  end
  object chkSearchSelectToolbarButtons: TCheckBox
    Left = 680
    Top = 287
    Width = 97
    Height = 17
    Hint = 'Search in toolbar buttons tree'
    Alignment = taLeftJustify
    Anchors = [akRight, akBottom]
    Caption = 'Selec&t for search'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = chkSearchSelectClick
  end
  object cbxSearchText: TComboBox
    Left = 228
    Top = 304
    Width = 162
    Height = 21
    Hint = 
      'Enter search term (case insensitive)'#13#10'Press ENTER to search forw' +
      'ards'#13#10'Press CTRL+ENTER to search backwards'
    AutoComplete = False
    Anchors = [akLeft, akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnChange = cbxSearchTextChange
    OnKeyUp = cbxSearchTextKeyUp
  end
  object imlToolbarButtonIcons: TImageList
    Left = 560
    Top = 216
  end
  object mnuItemContextMenu: TPopupMenu
    AutoPopup = False
    OnPopup = mnuItemContextMenuPopup
    Left = 696
    Top = 216
    object mniCopyIcon: TMenuItem
      Caption = 'Copy Icon'
      OnClick = mniCopyItemDataClick
    end
    object mniCopyText: TMenuItem
      Caption = 'Copy Text'
      OnClick = mniCopyItemDataClick
    end
    object mniCopyCommandId: TMenuItem
      Caption = 'Copy Command Id'
      OnClick = mniCopyItemDataClick
    end
  end
end
