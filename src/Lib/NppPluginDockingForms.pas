{
    Base class for Notepad++ plugin docked dialog development.

    The content of this file was originally provided by Damjan Zobo Cvetko
    Modified by Andreas Heim for using in the plugin framework for Delphi.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

unit NppPluginDockingForms;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  NppSupport, NppPlugin, NppPluginForms;


type
  TNppPluginDockingForm = class(TNppPluginForm)
  private
    FDlgId:   Integer;
    FOnDock:  TNotifyEvent;
    FOnFloat: TNotifyEvent;

    procedure RemoveControlParent(AControl: TControl);

  protected
    FTbData:                TTbData;
    FNppDefaultDockingMask: Cardinal;

    // @todo: change caption and stuff....
    procedure OnWM_NOTIFY(var Msg: TWMNotify); message WM_NOTIFY;

    property  OnDock: TNotifyEvent  read FOnDock  write FOnDock;
    property  OnFloat: TNotifyEvent read FOnFloat write FOnFloat;

  public
    CmdId: Integer;

    constructor Create(NppParent: TNppPlugin); reintroduce; overload; virtual;
    constructor Create(AOwner: TNppPluginForm); reintroduce; overload; virtual;
    constructor Create(NppParent: TNppPlugin; DlgId: Integer); overload; virtual;
    constructor Create(AOwner: TNppPluginForm; DlgId: Integer); overload; virtual;

    procedure   Show;
    procedure   Hide;

    procedure   RegisterDockingForm(MaskStyle: Cardinal = DWS_DF_CONT_LEFT);

    procedure   UpdateDisplayInfo; overload;
    procedure   UpdateDisplayInfo(Info: string); overload;

    property    DlgID: Integer read FDlgid;

  end;



implementation

{$R *.dfm}


// =============================================================================
// Class TNppDockingForm
// =============================================================================

// -----------------------------------------------------------------------------
// Create / Destroy
// -----------------------------------------------------------------------------

// Hide constructor
constructor TNppPluginDockingForm.Create(NppParent: TNppPlugin);
begin
  MessageBox(0, 'Do not use this constructor', 'Plugin Framework error', MB_OK);
  Halt(1);
end;


// Hide constructor
constructor TNppPluginDockingForm.Create(AOwner: TNppPluginForm);
begin
  MessageBox(0, 'Do not use this constructor', 'Plugin Framework error', MB_OK);
  Halt(1);
end;


// Constructor for main dialogs
constructor TNppPluginDockingForm.Create(NppParent: TNppPlugin; DlgId: Integer);
begin
  inherited Create(NppParent);

  FDlgId := DlgId;
  CmdId  := Self.Plugin.CmdIdFromMenuItemIdx(DlgId);

  RegisterDockingForm(FNppDefaultDockingMask);
  RemoveControlParent(Self);
end;


// Constructor for sub dialogs
constructor TNppPluginDockingForm.Create(AOwner: TNppPluginForm; DlgId: Integer);
begin
  inherited Create(AOwner);

  FDlgId := DlgId;

  RegisterDockingForm(FNppDefaultDockingMask);
  RemoveControlParent(Self);
end;


// -----------------------------------------------------------------------------
// (De-)Initialization
// -----------------------------------------------------------------------------

// Register docking dialog in Notepad++
procedure TNppPluginDockingForm.RegisterDockingForm(MaskStyle: Cardinal = DWS_DF_CONT_LEFT);
begin
  HandleNeeded;

  FillChar(FTbData, SizeOf(TTbData), 0);

  if not Self.Icon.Empty then
  begin
    FTbData.IconTab := Icon.Handle;
    FTbData.Mask    := FTbData.Mask or DWS_ICONTAB;
  end;

  FTbData.ClientHandle := Handle;
  FTbData.DlgId        := FDlgId;
  FTbData.Mask         := MaskStyle;
  FTbData.Mask         := FTbData.Mask or DWS_ADDINFO;

  GetMem(FTbData.Name ,          500  * SizeOf(nppPChar));
  GetMem(FTbData.ModuleName,     1000 * SizeOf(nppPChar));
  GetMem(FTbData.AdditionalInfo, 1000 * SizeOf(nppPChar));

  StringToWideChar(Caption, FTbData.Name, 500);
  GetModuleFileName(HInstance, FTbData.ModuleName, 1000);
  StringToWideChar(ExtractFileName(FTbData.ModuleName), FTbData.ModuleName, 1000);
  StringToWideChar('', FTbData.AdditionalInfo, 1);

  SendMessage(Self.Plugin.NppData.NppHandle, NPPM_DMMREGASDCKDLG, 0, LPARAM(@FTbData));

  Visible := true;
end;


// -----------------------------------------------------------------------------
// Show / Hide
// -----------------------------------------------------------------------------

procedure TNppPluginDockingForm.Show;
begin
  SendMessage(Self.Plugin.NppData.NppHandle, NPPM_DMMSHOW, 0, LPARAM(Self.Handle));
  inherited Show;
  DoShow;
end;


procedure TNppPluginDockingForm.Hide;
begin
  SendMessage(Self.Plugin.NppData.NppHandle, NPPM_DMMHIDE, 0, LPARAM(Self.Handle));
  // inherited Hide;
  DoHide;
end;


// -----------------------------------------------------------------------------
// Overridden event handlers
// -----------------------------------------------------------------------------

procedure TNppPluginDockingForm.OnWM_NOTIFY(var Msg: TWMNotify);
begin
  if (Self.Plugin.NppData.NppHandle = Msg.NMHdr.hwndFrom) then
  begin
    Msg.Result := 0;

    if (Msg.NMHdr.code = DMN_CLOSE) then
    begin
      DoHide;
    end

    else if ((Msg.NMHdr.code and $ffff) = DMN_FLOAT) then
    begin
      if Assigned(FOnFloat) then FOnFloat(Self);
    end

    else if ((Msg.NMHdr.code and $ffff) = DMN_DOCK) then
    begin
      if Assigned(FOnDock) then FOnDock(Self);
    end;
  end;

  inherited;
end;


// -----------------------------------------------------------------------------
// Worker methods
// -----------------------------------------------------------------------------

procedure TNppPluginDockingForm.UpdateDisplayInfo;
begin
  UpdateDisplayInfo('');
end;


procedure TNppPluginDockingForm.UpdateDisplayInfo(Info: String);
begin
  StringToWideChar(Info, FTbData.AdditionalInfo, 1000);
  SendMessage(Plugin.NppData.NppHandle, NPPM_DMMUPDATEDISPINFO, 0, LPARAM(Self.Handle));
end;


// -----------------------------------------------------------------------------
// Internal Utils
// -----------------------------------------------------------------------------

// This hack prevents the Win Dialog default procedure from an endless loop while
// looking for the prevoius component, while in a floating state.
// I still don't know why the pointer climbs up to the docking dialog that holds
// this one but this works for now.
procedure TNppPluginDockingForm.RemoveControlParent(AControl: TControl);
var
  WinCtrl: TWinControl;
  i:       integer;
  r:       NativeInt;

begin
  if (AControl is TWinControl) then
  begin
    WinCtrl := AControl as TWinControl;
    WinCtrl.HandleNeeded;

    r := GetWindowLong(WinCtrl.Handle, GWL_EXSTYLE);

    if (r and WS_EX_CONTROLPARENT = WS_EX_CONTROLPARENT) then
      SetWindowLong(WinCtrl.Handle, GWL_EXSTYLE, r and not WS_EX_CONTROLPARENT);
  end;

  for i := AControl.ComponentCount-1 downto 0 do
  begin
    if (AControl.Components[i] is TControl) then
      RemoveControlParent(AControl.Components[i] as TControl);
  end;
end;


end.
