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

unit Main;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils, System.DateUtils,
  System.IOUtils, System.Math, System.Types, System.Classes, System.Generics.Defaults,
  System.Generics.Collections, Vcl.Graphics,

  SciSupport, NppSupport, NppMenuCmdID, NppPlugin, NppPluginForms, NppPluginDockingForms,

  dialog_TfrmSpy,
  dialog_TfrmAbout;


type
  // Plugin class
  TNppUISpyPlugin = class(TNppPlugin)
  private
    FMenuItemIdxSpy:   integer;
    FMenuItemIdxAbout: integer;

  protected
    // Handler for certain Notepad++ events

  public
    constructor Create; override;
    destructor  Destroy; override;

  end;


var
  // Class type to create in startup code
  PluginClass: TNppPluginClass = TNppUISpyPlugin;

  // Plugin instance variable, this is the reference to use in plugin's code
  Plugin: TNppUISpyPlugin;



implementation

const
  // Plugin name
  TXT_PLUGIN_NAME:    string = 'NppUISpy';

  TXT_MENUITEM_SPY:   string = 'Spy!';
  TXT_MENUITEM_ABOUT: string = 'About';


// Functions associated to the plugin's Notepad++ menu entries
procedure ShowSpy; cdecl; forward;
procedure ShowAbout; cdecl; forward;


// =============================================================================
// Class TNppUISpyPlugin
// =============================================================================

// -----------------------------------------------------------------------------
// Create / Destroy
// -----------------------------------------------------------------------------

constructor TNppUISpyPlugin.Create;
begin
  inherited Create;

  // Store a reference to the instance in a global variable with an appropriate
  // type to get access to its properties and methods
  Plugin := Self;

  // This property is important to extract version infos from the DLL file,
  // so set it right now after creation of the object
  PluginName := TXT_PLUGIN_NAME;

  // Add plugins's menu entries to Notepad++
  FMenuItemIdxSpy   := AddFuncItem(TXT_MENUITEM_SPY,   Main.ShowSpy);
  FMenuItemIdxAbout := AddFuncItem(TXT_MENUITEM_ABOUT, Main.ShowAbout);
end;


destructor TNppUISpyPlugin.Destroy;
begin
  // It's totally legal to call Free on already freed instances,
  // no checks needed
  frmSpy.Free;
  frmAbout.Free;

  inherited;
end;


// -----------------------------------------------------------------------------
// (De-)Initialization
// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
// Event handler
// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
// Worker methods
// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
// Plugin menu items
// -----------------------------------------------------------------------------

// Show "Spy" dialog in Notepad++
procedure ShowSpy; cdecl;
begin
  if not Assigned(frmSpy) then
  begin
    // Show settings dialog in a modal state and destroy it after close
    frmSpy := TfrmSpy.Create(Plugin);
    frmSpy.ShowModal;
    frmSpy.Free;
  end;
end;


// Show "About" dialog in Notepad++
procedure ShowAbout; cdecl;
begin
  if not Assigned(frmAbout) then
  begin
    // Show about dialog in a modal state and destroy it after close
    frmAbout := TfrmAbout.Create(Plugin);
    frmAbout.ShowModal;
    frmAbout.Free;
  end;
end;


end.
