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

unit dialog_TfrmAbout;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils, System.IOUtils,
  System.Math, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.StdCtrls, Vcl.Forms,
  Vcl.Dialogs,

  NppPlugin, NppPluginForms;


type
  TfrmAbout = class(TNppPluginForm)
    lblHeader: TLabel;
    lblInfo: TLabel;
    lblReadInfos: TLabel;

    btnOK: TButton;

    procedure FormCreate(Sender: TObject);

    procedure lblReadInfosClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);

  public
    constructor Create(NppParent: TNppPlugin); override;
    destructor  Destroy; override;

  end;


var
  frmAbout: TfrmAbout;



implementation

{$R *.dfm}


uses
  Main;


const
  TXT_TITLE:      string = 'About';
  TXT_HEADER:     string = 'Notepad++ %s Plugin v';
  TXT_INFO:       string = '%s';
  TXT_READ_INFOS: string = 'Read some infos';


// =============================================================================
// Class TfrmAbout
// =============================================================================

// -----------------------------------------------------------------------------
// Create / Destroy
// -----------------------------------------------------------------------------

constructor TfrmAbout.Create(NppParent: TNppPlugin);
begin
  inherited;

  DefaultCloseAction := caHide;
end;


destructor TfrmAbout.Destroy;
begin
  inherited;

  frmAbout := nil;
end;


// -----------------------------------------------------------------------------
// Initialization
// -----------------------------------------------------------------------------

// Perform basic initialization tasks
procedure TfrmAbout.FormCreate(Sender: TObject);
var
  FormatString: string;

begin
  FormatString := TXT_HEADER + '%d.%d';

  if Plugin.GetReleaseNumber <> 0 then
    FormatString := FormatString + '.%d';

  Caption              := TXT_TITLE;
  lblHeader.Caption    := Format(FormatString, [Plugin.GetName, Plugin.GetMajorVersion, Plugin.GetMinorVersion, Plugin.GetReleaseNumber]);
  lblInfo.Caption      := Format(TXT_INFO, [Plugin.GetCopyRight]);
  lblReadInfos.Caption := TXT_READ_INFOS;
end;


// -----------------------------------------------------------------------------
// Event handlers
// -----------------------------------------------------------------------------

// Open plugin's info document in Notepad++
procedure TfrmAbout.lblReadInfosClick(Sender: TObject);
begin
  Plugin.OpenFile(TPath.Combine(Plugin.GetPluginDocDir, ReplaceStr(Plugin.GetName, ' ', '') + '.txt'), true);
  Close;
end;


// Close dialog
procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;


end.
