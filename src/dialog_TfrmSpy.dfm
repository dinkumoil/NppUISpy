object frmSpy: TfrmSpy
  Left = 525
  Top = 410
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 344
  ClientWidth = 785
  Color = clBtnFace
  Constraints.MinHeight = 380
  Constraints.MinWidth = 801
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    785
    344)
  PixelsPerInch = 96
  TextHeight = 13
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
    TabStop = False
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toAutoChangeScale]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines, toAlwaysHideSelection]
    TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
    OnDrawText = vstMenuItemsDrawText
    OnGetText = vstMenuItemsGetText
    OnPaintText = vstMenuItemsPaintText
    OnGetImageIndex = vstMenuItemsGetImageIndex
    OnGetHint = vstMenuItemsGetHint
    OnIncrementalSearch = vstMenuItemsIncrementalSearch
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
        Width = 241
        WideText = 'Menu Items'
      end
      item
        MinWidth = 30
        Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coSmartResize, coAllowFocus]
        Position = 2
        Width = 76
        WideText = 'Command Id'
      end>
  end
  object btnExpand: TButton
    Left = 208
    Top = 286
    Width = 25
    Height = 25
    Hint = 'Expand all'
    Anchors = [akRight, akBottom]
    Caption = '-'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = btnExpandClick
  end
  object btnCollapse: TButton
    Left = 168
    Top = 286
    Width = 25
    Height = 25
    Hint = 'Collapse all'
    Anchors = [akRight, akBottom]
    Caption = '+'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
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
    TabOrder = 3
    TabStop = False
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toAutoChangeScale]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines, toAlwaysHideSelection]
    TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
    OnDrawText = vstToolbarButtonsDrawText
    OnGetText = vstToolbarButtonsGetText
    OnPaintText = vstToolbarButtonsPaintText
    OnGetImageIndex = vstToolbarButtonsGetImageIndex
    OnGetHint = vstToolbarButtonsGetHint
    OnIncrementalSearch = vstToolbarButtonsIncrementalSearch
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
    Top = 311
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 5
    OnClick = btnQuitClick
  end
  object btnReloadData: TButton
    Left = 598
    Top = 311
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Reload'
    Default = True
    TabOrder = 4
    OnClick = btnReloadDataClick
  end
  object imlToolbarButtonIcons: TImageList
    Left = 64
    Top = 296
  end
  object mnuItemContextMenu: TPopupMenu
    AutoPopup = False
    OnPopup = mnuItemContextMenuPopup
    Left = 296
    Top = 296
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
