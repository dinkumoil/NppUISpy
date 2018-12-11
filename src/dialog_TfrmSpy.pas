{
    This file is part of the NppUISpy plugin for Notepad++
    Author: Andreas Heim

    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License version 3 as published
    by the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

unit dialog_TfrmSpy;


interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl,System.SysUtils, System.StrUtils,
  System.IOUtils, System.Math, System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ImgList, Vcl.Forms,
  Vcl.Dialogs, Vcl.Menus, Vcl.Clipbrd,

  VirtualTrees,

  NppPlugin, NppPluginForms;


type
  TfrmSpy = class(TNppPluginForm)
    vstMenuItems: TVirtualStringTree;
    btnCollapse: TButton;
    btnExpand: TButton;

    vstToolbarButtons: TVirtualStringTree;
    imlToolbarButtonIcons: TImageList;

    mnuItemContextMenu: TPopupMenu;
    mniCopyIcon: TMenuItem;
    mniCopyText: TMenuItem;
    mniCopyCommandId: TMenuItem;

    btnReloadData: TButton;
    btnQuit: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    // .........................................................................

    procedure vstMenuItemsIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: string; var Result: Integer);

    procedure vstMenuItemsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure vstMenuItemsNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);

    procedure vstMenuItemsGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);

    procedure vstMenuItemsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);

    procedure vstMenuItemsGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: string);

    procedure vstMenuItemsDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);

    procedure vstMenuItemsPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);

    // .........................................................................

    procedure vstToolbarButtonsIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: string; var Result: Integer);

    procedure vstToolbarButtonsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure vstToolbarButtonsNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);

    procedure vstToolbarButtonsGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);

    procedure vstToolbarButtonsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);

    procedure vstToolbarButtonsGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: string);

    procedure vstToolbarButtonsDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);

    procedure vstToolbarButtonsPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);

    // .........................................................................

    procedure mnuItemContextMenuPopup(Sender: TObject);
    procedure mniCopyItemDataClick(Sender: TObject);

    procedure btnCollapseClick(Sender: TObject);
    procedure btnExpandClick(Sender: TObject);

    procedure btnReloadDataClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);

  private type
    // -------------------------------------------------------------------------
    // Helpers for menu items tree
    // -------------------------------------------------------------------------
    TMenuItemTreeInfo     = class;
    TMenuItemTreeInfoList = class(TObjectList<TMenuItemTreeInfo>);

    TMenuItemTreeInfo = class(TObject)
    public
      Text:       string;
      CmdId:      cardinal;
      ImageIndex: integer;
      Children:   TMenuItemTreeInfoList;

      constructor Create;
      destructor  Destroy; override;
    end;

    PMenuItemTreeData = ^TMenuItemTreeData;
    TMenuItemTreeData = packed record
      NppMenuItem: TMenuItemTreeInfo;
    end;

    // -------------------------------------------------------------------------
    // Helpers for toolbar buttons tree
    // -------------------------------------------------------------------------
    TToolbarButtonTreeInfo     = class;
    TToolbarButtonTreeInfoList = class(TObjectList<TToolbarButtonTreeInfo>);

    TToolbarButtonTreeInfo = class(TObject)
    public
      CmdId:      cardinal;
      HintText:   string;
      ImageIndex: integer;
    end;

    PToolbarButtonTreeData = ^TToolbarButtonTreeData;
    TToolbarButtonTreeData = packed record
      NppToolbarButton: TToolbarButtonTreeInfo;
    end;

  private
    FMenuItems:        TMenuItemTreeInfoList;
    FToolbarButtons:   TToolbarButtonTreeInfoList;
    FMouseButtonState: TShiftState;
    FHitInfo:          THitInfo;

    procedure   UpdateGUI;

    procedure   ListMenuItems(AMenu: HMENU = 0; AList: TMenuItemTreeInfoList = nil);
    procedure   FillMenuItemTree(ANode: PVirtualNode = nil; AList: TMenuItemTreeInfoList = nil);
    procedure   GetMenuItemText(out Result: string; CmdId: cardinal; AList: TMenuItemTreeInfoList = nil);
    function    NormalizeMenuItemText(const AText: string): string;

    function    ListToolbarButtons(ReList: boolean): boolean;
    procedure   FillToolbarButtonTree();
    function    GetToolbarButtonIdx(CmdId: cardinal): integer;
    function    FindNppToolbar(NppWnd: HWND): HWND;

  public
    constructor Create(NppParent: TNppPlugin); override;
    destructor  Destroy; override;

  end;


var
  frmSpy: TfrmSpy;



implementation

{$R *.dfm}

const
  TXT_TITLE: string = 'Notepad++ UI Spy';

  COL_TOOLBARBUTTON_ICON      = 0;
  COL_TOOLBARBUTTON_HINT_TEXT = 1;
  COL_TOOLBARBUTTON_CMD_ID    = 2;

  COL_MENUITEM_ICON           = 0;
  COL_MENUITEM_TEXT           = 1;
  COL_MENUITEM_CMD_ID         = 2;


// =============================================================================
// Class TfrmSpy
// =============================================================================

// -----------------------------------------------------------------------------
// Create / Destroy
// -----------------------------------------------------------------------------

constructor TfrmSpy.Create(NppParent: TNppPlugin);
begin
  inherited;

  DefaultCloseAction := caHide;
end;


destructor TfrmSpy.Destroy;
begin
  inherited;

  frmSpy := nil;
end;


// -----------------------------------------------------------------------------
// Initialization
// -----------------------------------------------------------------------------

procedure TfrmSpy.FormCreate(Sender: TObject);
begin
  Caption := TXT_TITLE;

  FMenuItems                     := TMenuItemTreeInfoList.Create(true);
  FToolbarButtons                := TToolbarButtonTreeInfoList.Create(true);

  vstMenuItems.NodeDataSize      := SizeOf(TMenuItemTreeData);
  vstToolbarButtons.NodeDataSize := SizeOf(TToolbarButtonTreeData);
end;


procedure TfrmSpy.FormShow(Sender: TObject);
begin
  UpdateGUI();
end;


procedure TfrmSpy.FormDestroy(Sender: TObject);
begin
  FMenuItems.Clear;
  FToolbarButtons.Clear;
end;


// -----------------------------------------------------------------------------
// Event handlers
// -----------------------------------------------------------------------------

// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// Menu items tree
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

procedure TfrmSpy.vstMenuItemsIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: string; var Result: Integer);
var
  NodeData: PMenuItemTreeData;

begin
  NodeData := PMenuItemTreeData(vstMenuItems.GetNodeData(Node));
  Result   := integer(not ContainsText(NodeData.NppMenuItem.Text, SearchText));
end;


procedure TfrmSpy.vstMenuItemsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseButtonState := Shift;
end;


procedure TfrmSpy.vstMenuItemsNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
var
  NodeData: PMenuItemTreeData;
  MousePos: TPoint;

begin
  FHitInfo := HitInfo;

  if ssLeft in FMouseButtonState then
  begin
    NodeData := PMenuItemTreeData(vstMenuItems.GetNodeData(FHitInfo.HitNode));

    if (FHitInfo.HitPositions * [hiOnItemLabel, hiOnItemRight, hiOnNormalIcon] <> []) and
       (NodeData.NppMenuItem.CmdId <> 0)                                              then
      Plugin.PerformMenuCommand(NodeData.NppMenuItem.CmdId);
  end

  else if ssRight in FMouseButtonState then
  begin
    if Assigned(vstMenuItems.PopupMenu)     and
       not vstMenuItems.PopupMenu.AutoPopup then
    begin
      try
        MousePos := Mouse.CursorPos;  // Can cause exception
        vstMenuItems.PopupMenu.Popup(MousePos.X, MousePos.Y);
      except
      end;
    end;
  end;
end;


procedure TfrmSpy.vstMenuItemsGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData: PMenuItemTreeData;

begin
  NodeData := PMenuItemTreeData(vstMenuItems.GetNodeData(Node));

  if Column = COL_MENUITEM_ICON then
    ImageIndex := NodeData.NppMenuItem.ImageIndex;
end;


procedure TfrmSpy.vstMenuItemsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData: PMenuItemTreeData;

begin
  NodeData := PMenuItemTreeData(vstMenuItems.GetNodeData(Node));

  if Column = COL_MENUITEM_ICON then
    CellText := ''

  else if Column = COL_MENUITEM_TEXT then
    CellText := NodeData.NppMenuItem.Text

  else if Column = COL_MENUITEM_CMD_ID then
    CellText := UIntToStr(NodeData.NppMenuItem.CmdId);
end;


procedure TfrmSpy.vstMenuItemsGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: string);
var
  NodeData: PMenuItemTreeData;

begin
  NodeData := PMenuItemTreeData(vstMenuItems.GetNodeData(Node));

  if Column = COL_MENUITEM_TEXT then
    HintText := NodeData.NppMenuItem.Text

  else if Column = COL_MENUITEM_CMD_ID then
    HintText := UIntToStr(NodeData.NppMenuItem.CmdId);
end;


procedure TfrmSpy.vstMenuItemsDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
var
  TextRect: TRect;

begin
  TextRect := TRect.Create(CellRect);

  InflateRect(TextRect, vstMenuItems.TextMargin, 0);
  OffsetRect(TextRect, -vstMenuItems.Header.Columns[Column].Spacing, 0);
  TextRect.Width := TextRect.Width + vstMenuItems.Header.Columns[Column].Spacing;

  if Column = COL_MENUITEM_ICON then
  begin
    TargetCanvas.Brush.Color := ColorToRGB(vstMenuItems.Color);
    TargetCanvas.FillRect(TextRect);
  end

  else if Column in [COL_MENUITEM_TEXT, COL_MENUITEM_CMD_ID] then
  begin
    if vsSelected in Node.States then
      if vstMenuItems.Focused then
        TargetCanvas.Brush.Color := ColorToRGB(vstMenuItems.Colors.FocusedSelectionColor)
      else
        TargetCanvas.Brush.Color := ColorToRGB(vstMenuItems.Colors.UnfocusedSelectionColor)
    else
      TargetCanvas.Brush.Color := ColorToRGB(vstMenuItems.Color);

    TargetCanvas.FillRect(TextRect);
  end;
end;


procedure TfrmSpy.vstMenuItemsPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  TextColor: TColor;

begin
  if Column in [COL_MENUITEM_TEXT, COL_MENUITEM_CMD_ID] then
  begin
    if (vsSelected in Node.States) and
       vstMenuItems.Focused        then
      TextColor := ColorToRGB(vstMenuItems.Colors.SelectionTextColor)
    else
      TextColor := ColorToRGB(vstMenuItems.Font.Color);

    TargetCanvas.Font.Color := TextColor;
  end;
end;


// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// Toolbar buttons tree
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

procedure TfrmSpy.vstToolbarButtonsIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: string; var Result: Integer);
var
  NodeData: PToolbarButtonTreeData;

begin
  NodeData := PToolbarButtonTreeData(vstToolbarButtons.GetNodeData(Node));
  Result   := integer(not ContainsText(NodeData.NppToolbarButton.HintText, SearchText));
end;


procedure TfrmSpy.vstToolbarButtonsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseButtonState := Shift;
end;


procedure TfrmSpy.vstToolbarButtonsNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
var
  NodeData: PToolbarButtonTreeData;
  MousePos: TPoint;

begin
  FHitInfo := HitInfo;

  if ssLeft in FMouseButtonState then
  begin
    NodeData := PToolbarButtonTreeData(vstToolbarButtons.GetNodeData(FHitInfo.HitNode));

    if (FHitInfo.HitPositions * [hiOnItem, hiOnItemLabel] <> []) and
       (NodeData.NppToolbarButton.CmdId <> 0)                    then
      Plugin.PerformMenuCommand(NodeData.NppToolbarButton.CmdId);
  end

  else if ssRight in FMouseButtonState then
  begin
    if Assigned(vstToolbarButtons.PopupMenu)     and
       not vstToolbarButtons.PopupMenu.AutoPopup then
    begin
      try
        MousePos := Mouse.CursorPos;  // Can cause exception
        vstToolbarButtons.PopupMenu.Popup(MousePos.X, MousePos.Y);
      except
      end;
    end;
  end;
end;


procedure TfrmSpy.vstToolbarButtonsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData: PToolbarButtonTreeData;

begin
  NodeData := PToolbarButtonTreeData(vstToolbarButtons.GetNodeData(Node));

  if Column = COL_TOOLBARBUTTON_ICON then
    CellText := ''

  else if Column = COL_TOOLBARBUTTON_HINT_TEXT then
    CellText := NodeData.NppToolbarButton.HintText

  else if Column = COL_TOOLBARBUTTON_CMD_ID then
    CellText := UIntToStr(NodeData.NppToolbarButton.CmdId);
end;


procedure TfrmSpy.vstToolbarButtonsGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: string);
var
  NodeData: PToolbarButtonTreeData;

begin
  NodeData := PToolbarButtonTreeData(vstToolbarButtons.GetNodeData(Node));

  if Column = COL_TOOLBARBUTTON_ICON then
    HintText := ''

  else if Column = COL_TOOLBARBUTTON_HINT_TEXT then
    HintText := NodeData.NppToolbarButton.HintText

  else if Column = COL_TOOLBARBUTTON_CMD_ID then
    HintText := UIntToStr(NodeData.NppToolbarButton.CmdId);
end;


procedure TfrmSpy.vstToolbarButtonsGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData: PToolbarButtonTreeData;

begin
  NodeData := PToolbarButtonTreeData(vstToolbarButtons.GetNodeData(Node));

  if Column = COL_TOOLBARBUTTON_ICON then
    ImageIndex := NodeData.NppToolbarButton.ImageIndex;
end;


procedure TfrmSpy.vstToolbarButtonsDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
var
  TextRect: TRect;

begin
  TextRect := TRect.Create(CellRect);

  InflateRect(TextRect, vstToolbarButtons.TextMargin, 0);
  OffsetRect(TextRect, -vstToolbarButtons.Header.Columns[Column].Spacing, 0);
  TextRect.Width := TextRect.Width + vstToolbarButtons.Header.Columns[Column].Spacing;

  if Column = COL_TOOLBARBUTTON_ICON then
  begin
    TargetCanvas.Brush.Color := ColorToRGB(vstToolbarButtons.Color);
    TargetCanvas.FillRect(TextRect);
  end

  else if Column in [COL_TOOLBARBUTTON_HINT_TEXT, COL_TOOLBARBUTTON_CMD_ID] then
  begin
    if vsSelected in Node.States then
      if vstToolbarButtons.Focused then
        TargetCanvas.Brush.Color := ColorToRGB(vstToolbarButtons.Colors.FocusedSelectionColor)
      else
        TargetCanvas.Brush.Color := ColorToRGB(vstToolbarButtons.Colors.UnfocusedSelectionColor)
    else
      TargetCanvas.Brush.Color := ColorToRGB(vstToolbarButtons.Color);

    TargetCanvas.FillRect(TextRect);
  end;
end;


procedure TfrmSpy.vstToolbarButtonsPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  TextColor: TColor;

begin
  if Column in [COL_TOOLBARBUTTON_HINT_TEXT, COL_TOOLBARBUTTON_CMD_ID] then
  begin
    if (vsSelected in Node.States) and vstToolbarButtons.Focused then
      TextColor := ColorToRGB(vstToolbarButtons.Colors.SelectionTextColor)
    else
      TextColor := ColorToRGB(vstToolbarButtons.Font.Color);

    TargetCanvas.Font.Color := TextColor;
  end;
end;


// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// Other GUI elements
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

procedure TfrmSpy.mnuItemContextMenuPopup(Sender: TObject);
var
  NodeDataMenuItem:      PMenuItemTreeData;
  NodeDataToolbarButton: PToolbarButtonTreeData;

begin
  if vstMenuItems.Focused and (vstMenuItems.FocusedNode = FHitInfo.HitNode) then
  begin
    NodeDataMenuItem    := PMenuItemTreeData(vstMenuItems.GetNodeData(FHitInfo.HitNode));
    mniCopyIcon.Enabled := (NodeDataMenuItem.NppMenuItem.ImageIndex >= 0);
  end

  else if vstToolbarButtons.Focused and (vstToolbarButtons.FocusedNode = FHitInfo.HitNode) then
  begin
    NodeDataToolbarButton := PToolbarButtonTreeData(vstToolbarButtons.GetNodeData(FHitInfo.HitNode));
    mniCopyIcon.Enabled   := (NodeDataToolbarButton.NppToolbarButton.ImageIndex >= 0);
  end

  else
    mniCopyIcon.Enabled := false;
end;


procedure TfrmSpy.mniCopyItemDataClick(Sender: TObject);
var
  NodeDataMenuItem:      PMenuItemTreeData;
  NodeDataToolbarButton: PToolbarButtonTreeData;
  ItemImage:             TBitmap;

begin
  if vstMenuItems.Focused and (vstMenuItems.FocusedNode = FHitInfo.HitNode) then
  begin
    NodeDataMenuItem := PMenuItemTreeData(vstMenuItems.GetNodeData(FHitInfo.HitNode));

    if (Sender = mniCopyIcon) and (NodeDataMenuItem.NppMenuItem.ImageIndex >= 0) then
    begin
      ItemImage := TBitmap.Create;

      try
        vstMenuItems.Images.GetBitmap(NodeDataMenuItem.NppMenuItem.ImageIndex, ItemImage);
        Clipboard.Assign(ItemImage);

      finally
        ItemImage.Free;
      end;
    end

    else if Sender = mniCopyText then
      Clipboard.AsText := NodeDataMenuItem.NppMenuItem.Text

    else if Sender = mniCopyCommandId then
      Clipboard.AsText := UIntToStr(NodeDataMenuItem.NppMenuItem.CmdId);
  end

  else if vstToolbarButtons.Focused and (vstToolbarButtons.FocusedNode = FHitInfo.HitNode) then
  begin
    NodeDataToolbarButton := PToolbarButtonTreeData(vstToolbarButtons.GetNodeData(FHitInfo.HitNode));

    if (Sender = mniCopyIcon) and (NodeDataToolbarButton.NppToolbarButton.ImageIndex >= 0) then
    begin
      ItemImage := TBitmap.Create;

      try
        vstToolbarButtons.Images.GetBitmap(NodeDataToolbarButton.NppToolbarButton.ImageIndex, ItemImage);
        Clipboard.Assign(ItemImage);

      finally
        ItemImage.Free;
      end;
    end

    else if Sender = mniCopyText then
      Clipboard.AsText := NodeDataToolbarButton.NppToolbarButton.HintText

    else if Sender = mniCopyCommandId then
      Clipboard.AsText := UIntToStr(NodeDataToolbarButton.NppToolbarButton.CmdId);
  end;
end;


procedure TfrmSpy.btnCollapseClick(Sender: TObject);
begin
  vstMenuItems.FullCollapse();
end;


procedure TfrmSpy.btnExpandClick(Sender: TObject);
begin
  vstMenuItems.FullExpand();
end;


procedure TfrmSpy.btnReloadDataClick(Sender: TObject);
begin
  UpdateGUI();
end;


procedure TfrmSpy.btnQuitClick(Sender: TObject);
begin
  Close;
end;


// -----------------------------------------------------------------------------
// Worker routines
// -----------------------------------------------------------------------------

procedure TfrmSpy.UpdateGUI;
var
  ListResult: boolean;

begin
  // Create data model of the Notepad++ toolbar and its main menu
  ListResult := ListToolbarButtons(false);
  ListMenuItems();

  // If it was not possible to retrieve the toolbar button hint texts
  // repeat data model creation and get them from the menu entries now
  if not ListResult then
    ListToolbarButtons(true);

  // Fill the trees with the collected data
  FillMenuItemTree();
  FillToolbarButtonTree();
end;


// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// Menu items tree
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

procedure TfrmSpy.ListMenuItems(AMenu: HMENU = 0; AList: TMenuItemTreeInfoList = nil);
var
  MenuBarInfo:       TMenuBarInfo;
  MenuItemInfo:      TMenuItemInfo;
  MenuItemExclTypes: cardinal;
  MenuItemCnt:       integer;
  Buffer:            string;
  MenuItemText:      string;
  CntChr:            integer;
  Cnt:               integer;

begin
  // Check if we have to init recursion or if we are already in traversion
  if not Assigned(AList) then
  begin
    // Reset tree and data model
    vstMenuItems.Clear;
    FMenuItems.Clear;

    // Retrieve handle to Notepad++ main menu bar
    MenuBarInfo.cbSize := SizeOf(TMenuBarInfo);
    if not GetMenuBarInfo(Plugin.NppData.NppHandle, integer(OBJID_MENU), 0, MenuBarInfo) then exit;

    // Init recursion
    AMenu := MenuBarInfo.hMenu;
    AList := FMenuItems;
  end;

  // In case of an empty menu there is nothing to do
  MenuItemCnt := GetMenuItemCount(AMenu);
  if MenuItemCnt < 0 then exit;

  // Set menu item types to exclude from processing
  MenuItemExclTypes := MFT_BITMAP or MFT_SEPARATOR or MFT_OWNERDRAW;

  // Iterate over all items of the current menu
  for Cnt := 0 to Pred(MenuItemCnt) do
  begin
    MenuItemText := '';
    CntChr       := -1;

    // Retrieve menu item and extract its text if it is a MFT_STRING type item
    repeat
      // Get buffer memory
      SetLength(Buffer, CntChr);

      // Init retrieval structure
      ZeroMemory(@MenuItemInfo, SizeOf(TMenuItemInfo));

      MenuItemInfo.cbSize     := SizeOf(TMenuItemInfo);
      MenuItemInfo.fMask      := MIIM_FTYPE or MIIM_STRING or MIIM_SUBMENU or MIIM_ID;
      MenuItemInfo.dwTypeData := PChar(Buffer);
      MenuItemInfo.cch        := Succ(CntChr);

      // Query menu item infos, if this fails break loop
      if not GetMenuItemInfo(AMenu, Cnt, true, MenuItemInfo) then break;

      // Break loop if item's type is excluded from processing, if item text
      // has been retrieved already or if its lenght is 0. Otherwise retrieve
      // required buffer size and repeat query.
      if (MenuItemInfo.fType and MenuItemExclTypes) = 0 then
        CntChr := MenuItemInfo.cch
    until (CntChr <= 0) or (Length(Buffer) > 0);

    // Skip menu item if querying its infos failed or if its type is excluded
    // from processing
    if CntChr < 0 then continue;

    // For allowed item type MFT_STRING copy item text to local string
    SetString(MenuItemText, PChar(Buffer), CntChr);

    // Create tree object and add it to the list
    AList.Add(TMenuItemTreeInfo.Create);

    // Store menu item infos in tree object
    with AList.Last do
    begin
      Text       := NormalizeMenuItemText(MenuItemText);
      CmdId      := IfThen(MenuItemInfo.hSubMenu = 0, MenuItemInfo.wID, 0);
      ImageIndex := GetToolbarButtonIdx(MenuItemInfo.wID);
    end;

    // If the menu item has a submenu enter next recursion level
    if MenuItemInfo.hSubMenu <> 0 then
      ListMenuItems(MenuItemInfo.hSubMenu, AList.Last.Children);
  end;
end;


procedure TfrmSpy.FillMenuItemTree(ANode: PVirtualNode = nil; AList: TMenuItemTreeInfoList = nil);
var
  Idx:      integer;
  DoInit:   boolean;
  Node:     PVirtualNode;
  NodeData: PMenuItemTreeData;

begin
  if Assigned(AList) then
    DoInit := false
  else
  begin
    vstMenuItems.BeginUpdate;
    vstMenuItems.Clear;

    AList  := FMenuItems;
    DoInit := true;
  end;

  try
    for Idx := 0 to Pred(AList.Count) do
    begin
      Node     := vstMenuItems.AddChild(ANode);
      NodeData := PMenuItemTreeData(vstMenuItems.GetNodeData(Node));

      NodeData.NppMenuItem := AList[Idx];

      if AList[Idx].Children.Count > 0 then
        FillMenuItemTree(Node, AList[Idx].Children);
    end;

  finally
    if DoInit then
    begin
      vstMenuItems.EndUpdate;
      vstMenuItems.Refresh;
    end;
  end
end;


procedure TfrmSpy.GetMenuItemText(out Result: string; CmdId: cardinal; AList: TMenuItemTreeInfoList = nil);
var
  Idx: integer;

begin
  Result := '';

  // Init recursion and don't search in menu bar
  if not Assigned(AList) then
    AList := FMenuItems
  else
    // Search in entries of current menu
    for Idx := 0 to Pred(AList.Count) do
    begin
      if AList[Idx].CmdId <> CmdId then continue;

      Result := AList[Idx].Text;
      exit;
    end;

  // Search in submenus of current menu
  for Idx := 0 to Pred(AList.Count) do
  begin
    if AList[Idx].Children.Count = 0 then continue;

    GetMenuItemText(Result, CmdId, AList[Idx].Children);
    if Result <> '' then exit;
  end;
end;


function TfrmSpy.NormalizeMenuItemText(const AText: string): string;
const
  HintSepChar: Char = #9;
  AmpChar:     Char = '&';

var
  Index:  integer;
  Offset: integer;

begin
  Index := Pos(HintSepChar, AText);

  if Index > 0 then
    Result := Copy(AText, 1, Pred(Index))
  else
    Result := AText;

  Offset := 1;

  repeat
    Index := PosEx(AmpChar, Result, Offset);
    if Index = 0 then break;

    Delete(Result, Index, 1);

    if PosEx(AmpChar, Result, Index) = Index then
      Offset := Succ(Index)
    else
      Offset := Index;
  until false;
end;


// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// Toolbar buttons tree
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

function TfrmSpy.ListToolbarButtons(ReList: boolean): boolean;
const
  BUF_SIZE = 255;

var
  NppTbWnd:          HWND;
  TbButtonCnt:       integer;
  TbButtonData:      TTBButton;
  TbImageList:       HIMAGELIST;
  TbImageListCnt:    integer;
  TbButtonImgWidth:  integer;
  TbButtonImgHeight: integer;
  TbButtonImg:       TBitmap;
  TbButtonMask:      TBitmap;
  TbButtonHint:      string;
  Buffer:            string;
  BufLen:            integer;
  Cnt:               integer;

begin
  Result := true;

  // Reset tree and data model
  vstToolbarButtons.Clear;
  imlToolbarButtonIcons.Clear;
  FToolbarButtons.Clear;

  // Retrieve window handle of Notepad++ toolbar
  NppTbWnd := FindNppToolbar(Plugin.NppData.NppHandle);
  if NppTbWnd = 0 then exit;

  // Retrieve number of toolbar buttons
  TbButtonCnt := SendMessage(NppTbWnd, TB_BUTTONCOUNT, WPARAM(0), LPARAM(0));
  if TbButtonCnt = 0 then exit;

  // Retrieve handle of the toolbar's image list
  TbImageList := SendMessage(NppTbWnd, TB_GETIMAGELIST, WPARAM(0), LPARAM(0));
  if TbImageList = 0 then exit;

  // Retrieve number of images in image list
  TbImageListCnt := ImageList_GetImageCount(TbImageList);

  // Retrieve size of images in image list
  if not ImageList_GetIconSize(TbImageList, TbButtonImgWidth, TbButtonImgHeight) then exit;

  // Iterate over all toolbar buttons
  for Cnt := 0 to Pred(TbButtonCnt) do
  begin
    // Erase buffer for querying toolbar button infos
    ZeroMemory(@TbButtonData, SizeOf(TbButtonData));

    // Query infos for current toolbar button
    SendMessage(NppTbWnd, TB_GETBUTTON, WPARAM(Cnt), LPARAM(@TbButtonData));

    // Skip separators
    if (TbButtonData.fsStyle and TBSTYLE_SEP) <> 0 then continue;

    // Skip invisible toolbar buttons
    if (TbButtonData.fsState and TBSTATE_HIDDEN) <> 0 then continue;

    // Copy hint text of current toolbar button to local buffer
    TbButtonHint := '';

    // If iString really contains a string pointer retrieve hint text from there
    if not IS_INTRESOURCE(PChar(TbButtonData.iString)) then
      SetString(TbButtonHint, PChar(TbButtonData.iString), StrLen(PChar(TbButtonData.iString)))

    // Otherwise retrieve hint text using the button's menu command id
    else
    begin
      Buffer := '';
      BufLen := 0;

      repeat
        SetLength(Buffer, BufLen);
        BufLen := SendMessage(NppTbWnd, TB_GETBUTTONTEXT, WPARAM(TbButtonData.idCommand), LPARAM(Buffer));

        if BufLen <= 0 then break;
      until Length(Buffer) > 0;

      // If retrieving hint text succeeded copy the buffer to local variable
      if BufLen > 0 then
        SetString(TbButtonHint, PChar(Buffer), BufLen)

      // If we are in re-list mode retrieve the hint text from the menu entries
      // list via the toolbar button's command id
      else if ReList then
        GetMenuItemText(TbButtonHint, TbButtonData.idCommand)

      // If we are NOT in re-list mode tell the caller that the toolbar buttons
      // have to be relisted to get the hint texts from the menu entries list
      // which is not filled yet
      else
        Result := false
    end;

    // Create tree object and add it to the list
    FToolbarButtons.Add(TToolbarButtonTreeInfo.Create);

    // Store toolbar button infos in tree object
    with FToolbarButtons.Last do
    begin
      CmdId      := TbButtonData.idCommand;
      HintText   := TbButtonHint;
      ImageIndex := -1;

      // Skip adding image of toolbar buttons with invalid image index
      if not InRange(TbButtonData.iBitmap, 0, Pred(TbImageListCnt)) then continue;

      // Create buffer bitmaps for toolbar button image and its mask
      TbButtonImg  := TBitmap.Create;
      TbButtonMask := TBitmap.Create;

      try
        // Set size of buffer bitmaps
        TbButtonImg.SetSize(TbButtonImgWidth, TbButtonImgHeight);
        TbButtonMask.SetSize(TbButtonImgWidth, TbButtonImgHeight);

        // Query image list to draw toolbar button image and its mask to buffer bitmaps
        if not ImageList_Draw(TbImageList, TbButtonData.iBitmap, TbButtonImg.Canvas.Handle, 0, 0, ILD_IMAGE or ILD_TRANSPARENT) then continue;
        if not ImageList_Draw(TbImageList, TbButtonData.iBitmap, TbButtonMask.Canvas.Handle, 0, 0, ILD_MASK) then continue;

        // Add masked image to tree's image list
        ImageIndex := imlToolbarButtonIcons.Add(TbButtonImg, TbButtonMask);

      finally
        TbButtonImg.Free;
        TbButtonMask.Free;
      end;
    end;
  end;
end;


procedure TfrmSpy.FillToolbarButtonTree();
var
  Idx:      integer;
  Node:     PVirtualNode;
  NodeData: PToolbarButtonTreeData;

begin
  vstToolbarButtons.BeginUpdate;

  try
    vstToolbarButtons.Clear;

    for Idx := 0 to Pred(FToolbarButtons.Count) do
    begin
      Node     := vstToolbarButtons.AddChild(nil);
      NodeData := PToolbarButtonTreeData(vstToolbarButtons.GetNodeData(Node));

      NodeData.NppToolbarButton := FToolbarButtons[Idx];
    end;

  finally
    vstToolbarButtons.EndUpdate;
    vstToolbarButtons.Refresh;
  end
end;


function TfrmSpy.GetToolbarButtonIdx(CmdId: cardinal): integer;
var
  Idx: integer;

begin
  Result := -1;

  for Idx := 0 to Pred(FToolbarButtons.Count) do
    if FToolbarButtons[Idx].CmdId = CmdId then exit(Idx);
end;


function TfrmSpy.FindNppToolbar(NppWnd: HWND): HWND;
var
  TbParent: HWND;

begin
  Result   := 0;
  TbParent := 0;

  repeat
    TbParent := FindWindowEx(NppWnd, TbParent, 'ReBarWindow32', nil);
    if TbParent = 0 then break;

    Result := FindWindowEx(TbParent, 0, 'ToolbarWindow32', nil);
  until Result <> 0;
end;



// =============================================================================
// Class TfrmSpy.TMenuItemTreeInfo
// =============================================================================

constructor TfrmSpy.TMenuItemTreeInfo.Create;
begin
  inherited;

  Children := TMenuItemTreeInfoList.Create(true);
end;


destructor TfrmSpy.TMenuItemTreeInfo.Destroy;
begin
  Children.Free;

  inherited;
end;


end.

