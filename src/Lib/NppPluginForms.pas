{
    Base class for Notepad++ plugin dialog development.

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

unit NppPluginForms;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Math, System.Types,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  NppSupport, NppPlugin;


type
  TNppPluginForm = class(TForm)
  protected
    procedure CreateParams(var Params: TCreateParams); override;

    procedure DoCreate; override;
    procedure DoClose(var Action: TCloseAction); override;

    procedure RegisterForm();
    procedure UnregisterForm();

  public
    Plugin:             TNppPlugin;
    DefaultCloseAction: TCloseAction;

    constructor Create(ParentPlugin: TNppPlugin); reintroduce; overload; virtual;
    constructor Create(AOwner: TNppPluginForm); reintroduce; overload; virtual;
    destructor  Destroy; override;

    procedure   InitLanguage; virtual;

    function    WantChildKey(Child: TControl; var Message: TMessage): Boolean; override;

  end;



implementation

{$R *.dfm}


// =============================================================================
// Class TNppForm
// =============================================================================

// -----------------------------------------------------------------------------
// Create / Destroy
// -----------------------------------------------------------------------------

// Constructor for main dialogs
constructor TNppPluginForm.Create(ParentPlugin: TNppPlugin);
begin
  Self.Plugin        := ParentPlugin;
  DefaultCloseAction := caNone;

  inherited Create(nil);
  ParentWindow := Self.Plugin.NppData.NppHandle;

  RegisterForm();
end;


// Constructor for sub dialogs
constructor TNppPluginForm.Create(AOwner: TNppPluginForm);
begin
  Self.Plugin        := AOwner.Plugin;
  DefaultCloseAction := caNone;

  inherited Create(AOwner);
end;


destructor TNppPluginForm.Destroy;
begin
  if (HandleAllocated) then
    UnregisterForm();

  inherited;
end;


// -----------------------------------------------------------------------------
// (De-)Initialization
// -----------------------------------------------------------------------------

// Register plugin's dialog in Notepad++
procedure TNppPluginForm.RegisterForm();
begin
  SendMessage(Self.Plugin.NppData.NppHandle, NPPM_MODELESSDIALOG, MODELESSDIALOGADD, Handle);
end;


// Unregister plugin's dialog in Notepad++
procedure TNppPluginForm.UnregisterForm();
begin
  if (not HandleAllocated) then exit;
  SendMessage(Self.Plugin.NppData.NppHandle, NPPM_MODELESSDIALOG, MODELESSDIALOGREMOVE, Handle);
end;


// Set caption of GUI controls
procedure TNppPluginForm.InitLanguage;
begin
  // override
end;


// -----------------------------------------------------------------------------
// Overridden methods
// -----------------------------------------------------------------------------

// Remove WS_CHILD window style to allow the Notepad++ UI to get visible
// when the task bar icon of Notepad++ has been clicked
procedure TNppPluginForm.CreateParams(var Params: TCreateParams);
begin
  inherited;

  Params.Style := Params.Style and (not WS_CHILD);
end;


// Ensure correct placement of plugin dialogs
procedure TNppPluginForm.DoCreate;
var
  ParentRect:   TRect;
  TargetRect:   TRect;
  MonitorRect:  TRect;
  WorkareaRect: TRect;
  CurMonitor:   TMonitor;

begin
  if (ParentWindow <> 0) and GetWindowRect(ParentWindow, ParentRect) then
  begin
    TargetRect          := Bounds(Max(ParentRect.Left, (ParentRect.Left + ParentRect.Right  - Width ) div 2),
                                  Max(ParentRect.Top,  (ParentRect.Top  + ParentRect.Bottom - Height) div 2),
                                  Width,
                                  Height
                                 );

    CurMonitor          := Screen.MonitorFromRect(TargetRect);
    MonitorRect         := CurMonitor.BoundsRect;
    WorkareaRect        := CurMonitor.WorkareaRect;

    TargetRect.Location := Point(EnsureRange(TargetRect.Left, MonitorRect.Left, IfThen(CurMonitor.Primary, WorkareaRect.Right,  MonitorRect.Right)  - TargetRect.Width),
                                 EnsureRange(TargetRect.Top,  MonitorRect.Top,  IfThen(CurMonitor.Primary, WorkareaRect.Bottom, MonitorRect.Bottom) - TargetRect.Height)
                                );

    BoundsRect          := TargetRect;
  end;

  inherited;
end;


// Perform close action according to plugin's needs
procedure TNppPluginForm.DoClose(var Action: TCloseAction);
begin
  if (DefaultCloseAction <> caNone) then
    Action := DefaultCloseAction;

  inherited;
end;


// This is going to help us solve the problems we are having because of N++ handling our messages
function TNppPluginForm.WantChildKey(Child: TControl; var Message: TMessage): Boolean;
begin
  Result := (Child.Perform(CN_BASE + Message.Msg, Message.WParam, Message.LParam) <> 0);
end;


end.
