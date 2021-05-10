{
    Base class for Notepad++ plugin development.

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

unit NppPlugin;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils, System.IOUtils,
  System.Types, System.Classes, Vcl.Dialogs, Vcl.Forms,

  SciSupport, NppSupport, NppMenuCmdID;


const
  FNITEM_NAMELEN = 64;
  C_NO_LANGUAGE  = -1;


type
  // Plugin metaclass
  // Eleminates the need to edit the file NppPluginInclude.pas for every new plugin
  TNppPluginClass = class of TNppPlugin;


  // Plugin base class
  TNppPlugin = class(TObject)
  private type
    PFuncPluginCmd = procedure; cdecl;

    TFuncItem = record
      ItemName    : array[0..FNITEM_NAMELEN-1] of nppChar;
      Func        : PFuncPluginCmd;
      CmdID       : cardinal;
      Checked     : Boolean;
      ShortcutKey : PShortcutKey;
    end;

  private
    FPluginName:          nppString;
    FPluginMajorVersion:  integer;
    FPluginMinorVersion:  integer;
    FPluginReleaseNumber: integer;
    FPluginBuildNumber:   integer;
    FPluginCopyRight:     string;
    FSCNotification:      PSCNotification;
    FFuncArray:           array of TFuncItem;

    function    GetVarSizeStringValue(DirType: cardinal; MaxSize: cardinal = $0000FFFF): string;

  protected
    // Internal utils
    procedure   GetVersionInfo;

    function    AddFuncItem(Name: nppString; Func: PFuncPluginCmd): Integer; overload;
    function    AddFuncItem(Name: nppString; Func: PFuncPluginCmd; ShortcutKey: TShortcutKey): Integer; overload;

    procedure   AddToolbarIcon(CmdId: cardinal; var ToolbarIcon: TToolbarIcons);

    // Notepad++ notification handlers
    procedure   DoNppnReady; virtual;
    procedure   DoNppnToolbarModification; virtual;
    procedure   DoNppnBeforeShutDown; virtual;
    procedure   DoNppnCancelShutDown; virtual;
    procedure   DoNppnShutdown; virtual;
    procedure   DoNppnFileBeforeLoad; virtual;
    procedure   DoNppnFileLoadFailed; virtual;
    procedure   DoNppnFileBeforeOpen; virtual;
    procedure   DoNppnFileOpened; virtual;
    procedure   DoNppnFileBeforeClose; virtual;
    procedure   DoNppnFileClosed; virtual;
    procedure   DoNppnFileBeforeSave; virtual;
    procedure   DoNppnFileSaved; virtual;
    procedure   DoNppnFileBeforeRename; virtual;
    procedure   DoNppnFileRenameCancel; virtual;
    procedure   DoNppnFileRenamed; virtual;
    procedure   DoNppnFileBeforeDelete; virtual;
    procedure   DoNppnFileDeleteFailed; virtual;
    procedure   DoNppnFileDeleted; virtual;
    procedure   DoNppnBufferActivated; virtual;
    procedure   DoNppnLangChanged; virtual;
    procedure   DoNppnReadOnlyChanged; virtual;
    procedure   DoNppnDocOrderChanged; virtual;
    procedure   DoNppnShortcutRemapped; virtual;
    procedure   DoNppnWordStylesUpdated; virtual;
    procedure   DoNppnSnapshotDirtyFileLoaded; virtual;

    // Basic plugin properties
    property    PluginName:         nppString       read FPluginName         write FPluginName;
    property    PluginMajorVersion: integer         read FPluginMajorVersion write FPluginMajorVersion;
    property    PluginMinorVersion: integer         read FPluginMinorVersion write FPluginMinorVersion;
    property    SCNotification:     PSCNotification read FSCNotification;

  public
    NppData: TNppData;

    constructor Create; virtual;
    destructor  Destroy; override;

    procedure   BeforeDestruction; override;

    // Plugin interface methods
    procedure   MessageProc(var Msg: TMessage); virtual;
    procedure   BeNotified(SN: PSCNotification);
    procedure   SetInfo(ANppData: TNppData); virtual;
    function    GetFuncsArray(out FuncsCount: integer): Pointer;
    function    GetName: nppPChar;

    // Utils and Npp message wrappers
    function    CmdIdFromMenuItemIdx(MenuItemIdx: integer): cardinal;
    procedure   CheckMenuItem(MenuItemIdx: integer; State: boolean);
    procedure   PerformMenuCommand(MenuCmdId: cardinal; Param: integer = 0);

    function    GetMajorVersion: integer;
    function    GetMinorVersion: integer;
    function    GetReleaseNumber: integer;
    function    GetBuildNumber: integer;
    function    GetCopyRight: string;

    function    GetNppVersion(var MajorVersion, MinorVersion: integer): integer;
    function    IsNppMinVersion(AMajorVersion, AMinorVersion: integer): boolean;

    function    GetNppDir: string;
    function    GetPluginDir: string;
    function    GetPluginConfigDir: string;
    function    GetPluginDocDir: string;
    function    GetPluginDllPath: string;

    function    GetFullCurrentPath: string;
    function    GetCurrentDirectory: string;
    function    GetFullFileName: string;
    function    GetFileNameWithoutExt: string;
    function    GetFileNameExt: string;

    function    GetEncoding: integer;
    function    GetEOLFormat: integer;
    function    GetLanguageType: integer;  // see TNppLang
    function    GetLanguageName(ALangType: TNppLang): string;
    function    GetLanguageDesc(ALangType: TNppLang): string;

    function    GetCurrentViewIdx: integer; overload;
    function    GetCurrentViewIdx(ScHandle: HWND): integer; overload;
    function    GetCurrentDocIndex(AViewIdx: integer): integer;
    function    GetCurrentLine: NativeInt;
    function    GetCurrentColumn: LongInt;

    function    GetCurrentBufferId: NativeInt;
    function    GetBufferIdFromPos(AViewIdx, ADocIdx: integer): NativeInt;
    function    GetPosFromBufferId(ABufferId: NativeInt; out ADocIdx: integer): integer;
    function    GetFullPathFromBufferId(ABufferId: NativeInt): string;
    function    GetCurrentBufferDirty(AViewIdx: integer): boolean;

    function    GetOpenFilesCnt(CntType: integer): integer;
    function    GetOpenFiles(CntType: integer): TStringDynArray;

    function    GetLineCount(AViewIdx: integer): NativeInt;
    function    GetLineFromPosition(AViewIdx: integer; APosition: NativeInt): NativeInt;
    function    GetFirstVisibleLine(AViewIdx: integer): NativeInt;
    function    GetLinesOnScreen(AViewIdx: integer): NativeInt;

    procedure   GetFilePos(out FileName: string; out Line: NativeInt; out Column: LongInt);
    function    GetCurrentWord: string;

    function    OpenFile(FileName: string; ReadOnly: boolean = false): boolean; overload;
    function    OpenFile(FileName: string; Line: NativeInt; ReadOnly: boolean = false): boolean; overload;
    procedure   SwitchToFile(FileName: string);
    procedure   ReloadFile(FileName: string; Alert: boolean);
    procedure   ReloadCurrentFile(Alert: boolean);

  end;



implementation

uses
  FileVersionInfo;


// =============================================================================
// Class TNppPlugin
// =============================================================================

// -----------------------------------------------------------------------------
// Create / Destroy
// -----------------------------------------------------------------------------

constructor TNppPlugin.Create;
begin
  inherited;
end;


destructor TNppPlugin.Destroy;
var
  i: integer;

begin
  for i:=0 to Length(FFuncArray)-1 do
  begin
    if Assigned(FFuncArray[i].ShortcutKey) then
      Dispose(FFuncArray[i].ShortcutKey);
  end;

  inherited;
end;


//  This is hacking for troubble...
//  We need to unset the Application handler so that the forms
//  don't get berserk and start throwing OS error 1004.
//  This happens because the main NPP HWND is already lost when the
//  DLL_PROCESS_DETACH gets called, and the form tries to allocate a new
//  handler for sending the "close" windows message...
procedure TNppPlugin.BeforeDestruction;
begin
  Application.Handle := 0;
  Application.Terminate;

  inherited;
end;


// -----------------------------------------------------------------------------
// Plugin interface
// -----------------------------------------------------------------------------

procedure TNppPlugin.MessageProc(var Msg: TMessage);
var
  hm: HMENU;
  i:  integer;

begin
  if (Msg.Msg = WM_CREATE) then
  begin
    hm := GetMenu(NppData.NppHandle);

    for i := 0 to Pred(Length(FFuncArray)) do
    begin
      if (FFuncArray[i].ItemName[0] = '-') then
        ModifyMenu(hm, FFuncArray[i].CmdID, MF_BYCOMMAND or MF_SEPARATOR, 0, nil);
    end;
  end;

  Dispatch(Msg);
end;


procedure TNppPlugin.BeNotified(SN: PSCNotification);
begin
  // Provide notification data to derived classes
  FSCNotification := SN;

  case SN.nmhdr.code of
    // Notepad++ notifications
    NPPN_READY:                   DoNppnReady;
    NPPN_FILEBEFORELOAD:          DoNppnFileBeforeLoad;
    NPPN_FILELOADFAILED:          DoNppnFileLoadFailed;
    NPPN_SNAPSHOTDIRTYFILELOADED: DoNppnSnapshotDirtyFileLoaded;
    NPPN_FILEBEFOREOPEN:          DoNppnFileBeforeOpen;
    NPPN_FILEOPENED:              DoNppnFileOpened;
    NPPN_FILEBEFORECLOSE:         DoNppnFileBeforeClose;
    NPPN_FILECLOSED:              DoNppnFileClosed;
    NPPN_FILEBEFORESAVE:          DoNppnFileBeforeSave;
    NPPN_FILESAVED:               DoNppnFileSaved;
    NPPN_FILEBEFORERENAME:        DoNppnFileBeforeRename;
    NPPN_FILERENAMECANCEL:        DoNppnFileRenameCancel;
    NPPN_FILERENAMED:             DoNppnFileRenamed;
    NPPN_FILEBEFOREDELETE:        DoNppnFileBeforeDelete;
    NPPN_FILEDELETEFAILED:        DoNppnFileDeleteFailed;
    NPPN_FILEDELETED:             DoNppnFileDeleted;
    NPPN_BEFORESHUTDOWN:          DoNppnBeforeShutDown;
    NPPN_CANCELSHUTDOWN:          DoNppnCancelShutDown;
    NPPN_SHUTDOWN:                DoNppnShutdown;
    NPPN_BUFFERACTIVATED:         DoNppnBufferActivated;
    NPPN_LANGCHANGED:             DoNppnLangChanged;
    NPPN_READONLYCHANGED:         DoNppnReadOnlyChanged;
    NPPN_DOCORDERCHANGED:         DoNppnDocOrderChanged;
    NPPN_SHORTCUTREMAPPED:        DoNppnShortcutRemapped;
    NPPN_WORDSTYLESUPDATED:       DoNppnWordStylesUpdated;
    NPPN_TB_MODIFICATION:         DoNppnToolbarModification;
  end;
end;


procedure TNppPlugin.SetInfo(ANppData: TNppData);
begin
  Self.NppData       := ANppData;
  Application.Handle := NppData.NppHandle;
end;


function TNppPlugin.GetFuncsArray(out FuncsCount: integer): Pointer;
begin
  FuncsCount := Length(FFuncArray);
  Result     := FFuncArray;
end;


function TNppPlugin.GetName: nppPChar;
begin
  Result := nppPChar(PluginName);
end;


// -----------------------------------------------------------------------------
// Internal utils
// -----------------------------------------------------------------------------

procedure TNppPlugin.GetVersionInfo;
var
  lptstrFilename: string;
  wLangId:        Word;

begin
  wLangId := wLangIdEnglish;

  lptstrFilename := GetPluginDllPath;
  if not FileExists(lptstrFilename) then exit;

  TFileVersionInfo.GetNumericVersionInfo(lptstrFilename,       nfvitFileVersion,
                                         FPluginMajorVersion,  FPluginMinorVersion,
                                         FPluginReleaseNumber, FPluginBuildNumber);

  TFileVersionInfo.GetVersionInfo(lptstrFilename, fvitLegalCopyright,
                                  wLangId,        FPluginCopyRight);
end;


function TNppPlugin.AddFuncItem(Name: nppString; Func: PFuncPluginCmd): integer;
var
  i: Integer;

begin
  i := Length(FFuncArray);
  SetLength(FFuncArray, i+1);

  StringToWideChar(Name, FFuncArray[i].ItemName, Length(FFuncArray[i].ItemName));

  FFuncArray[i].Func        := Func;
  FFuncArray[i].ShortcutKey := nil;

  Result := i;
end;


function TNppPlugin.AddFuncItem(Name: nppString; Func: PFuncPluginCmd;
  ShortcutKey: TShortcutKey): Integer;
var
  i: Integer;

begin
  i := AddFuncItem(Name, Func);
  New(FFuncArray[i].ShortcutKey);

  FFuncArray[i].ShortcutKey.IsCtrl  := ShortcutKey.IsCtrl;
  FFuncArray[i].ShortcutKey.IsAlt   := ShortcutKey.IsAlt;
  FFuncArray[i].ShortcutKey.IsShift := ShortcutKey.IsShift;
  FFuncArray[i].ShortcutKey.Key     := ShortcutKey.Key;

  Result := i;
end;


procedure TNppPlugin.AddToolbarIcon(CmdId: cardinal; var ToolbarIcon: TToolbarIcons);
begin
  SendMessage(NppData.NppHandle, NPPM_ADDTOOLBARICON, WPARAM(CmdId), LPARAM(@ToolbarIcon));
end;


// -----------------------------------------------------------------------------
// Utils and message wrapper methods
// -----------------------------------------------------------------------------

function TNppPlugin.CmdIdFromMenuItemIdx(MenuItemIdx: integer): cardinal;
begin
  Result := FFuncArray[MenuItemIdx].CmdId;
end;


procedure TNppPlugin.CheckMenuItem(MenuItemIdx: integer; State: boolean);
begin
  PostMessage(NppData.NppHandle, NPPM_SETMENUITEMCHECK, WPARAM(CmdIdFromMenuItemIdx(MenuItemIdx)), LPARAM(State));
end;


procedure TNppPlugin.PerformMenuCommand(MenuCmdId: cardinal; Param: integer = 0);
begin
  PostMessage(NppData.NppHandle, NPPM_MENUCOMMAND, WPARAM(Param), LPARAM(MenuCmdId));
end;


function TNppPlugin.GetMajorVersion: integer;
begin
  Result := FPluginMajorVersion;
end;


function TNppPlugin.GetMinorVersion: integer;
begin
  Result := FPluginMinorVersion;
end;


function TNppPlugin.GetReleaseNumber: integer;
begin
  Result := FPluginReleaseNumber;
end;


function TNppPlugin.GetBuildNumber: integer;
begin
  Result := FPluginBuildNumber;
end;


function TNppPlugin.GetCopyRight: string;
begin
  Result := FPluginCopyRight;
end;


function TNppPlugin.GetVarSizeStringValue(DirType: cardinal; MaxSize: cardinal = $0000FFFF): string;
var                                                         // NTFS limit for path length
  Buf:    nppString;
  BufLen: cardinal;
  RetVal: LRESULT;

begin
  Result := '';

  BufLen := 256; // The start value for this algorithm has to be a power of 2

  repeat
    SetLength(Buf, BufLen);

    RetVal := SendMessage(NppData.NppHandle, DirType, WPARAM(BufLen), LPARAM(nppPChar(Buf)));

    if RetVal <> 0       then break;
    if BufLen >= MaxSize then exit;

    BufLen := BufLen * 2;
  until false;

  SetString(Result, nppPChar(Buf), StrLen(nppPChar(Buf)));
end;


function TNppPlugin.GetNppVersion(var MajorVersion, MinorVersion: integer): integer;
var
  Version: LRESULT;

begin
  Version := SendMessage(NppData.NppHandle, NPPM_GETNPPVERSION, WPARAM(0), LPARAM(0));

  MajorVersion := HiWord(Version);
  MinorVersion := LoWord(Version);

  if MinorVersion < 10 then
    MinorVersion := MinorVersion * 10;

  Result := MajorVersion;
end;


function TNppPlugin.IsNppMinVersion(AMajorVersion, AMinorVersion: integer): boolean;
var
  MajorVersion: integer;
  MinorVersion: integer;

begin
  GetNppVersion(MajorVersion, MinorVersion);
  Result := (MajorVersion >= AMajorVersion) and (MinorVersion >= AMinorVersion);
end;


function TNppPlugin.GetNppDir: string;
begin
  Result := GetVarSizeStringValue(NPPM_GETNPPDIRECTORY);
end;


function TNppPlugin.GetPluginDir: string;
var
  szBuf:    string;
  dwBufLen: DWORD;
  dwRet:    DWORD;

begin
  Result := '';

  dwBufLen := MAX_PATH;

  repeat
    SetLength(szBuf, dwBufLen);
    dwRet := GetModuleFileName(HInstance, PChar(szBuf), dwBufLen);

    // If dwRet is 0 there was an error
    //   => leave loop
    // if dwRet is less than dwBufLen the buffer size was sufficient
    //   => leave loop
    // If dwRet is equal to dwBufLen the buffer size was too small
    //   => loop and retry with double sized buffer
    // dwRet greater than dwBufLen is a non-existing case
    if dwRet < dwBufLen then break;
    dwBufLen := dwBufLen * 2;
  until false;

  if dwRet > 0 then
  begin
    SetString(Result, PChar(szBuf), dwRet);
    Result := TPath.GetDirectoryName(Result);
  end;
end;


function TNppPlugin.GetPluginConfigDir: string;
begin
  Result := GetVarSizeStringValue(NPPM_GETPLUGINSCONFIGDIR);
end;


function TNppPlugin.GetPluginDocDir: string;
begin
  Result := TPath.Combine(GetPluginDir(), 'doc');
end;


function TNppPlugin.GetPluginDllPath: string;
begin
  Result := TPath.Combine(GetPluginDir(), ReplaceStr(GetName(), ' ', '') + '.dll')
end;


function TNppPlugin.GetFullCurrentPath: string;
begin
  Result := GetVarSizeStringValue(NPPM_GETFULLCURRENTPATH);
end;


function TNppPlugin.GetCurrentDirectory: string;
begin
  Result := GetVarSizeStringValue(NPPM_GETCURRENTDIRECTORY);
end;


function TNppPlugin.GetFullFileName: string;
begin
  Result := GetVarSizeStringValue(NPPM_GETFILENAME);
end;


function TNppPlugin.GetFileNameWithoutExt: string;
begin
  Result := GetVarSizeStringValue(NPPM_GETNAMEPART);
end;


function TNppPlugin.GetFileNameExt: string;
begin
  Result := GetVarSizeStringValue(NPPM_GETEXTPART);
end;


function TNppPlugin.GetEncoding: integer;
begin
  Result := SendMessage(NppData.NppHandle, NPPM_GETBUFFERENCODING, WPARAM(GetCurrentBufferId), LPARAM(0));
end;


function TNppPlugin.GetEOLFormat: integer;
begin
  Result := SendMessage(NppData.NppHandle, NPPM_GETBUFFERFORMAT, WPARAM(GetCurrentBufferId), LPARAM(0));
end;


function TNppPlugin.GetLanguageType: integer;
begin
  Result := SendMessage(NppData.NppHandle, NPPM_GETBUFFERLANGTYPE, WPARAM(GetCurrentBufferId), LPARAM(0));
  if Result = -1 then Result := C_NO_LANGUAGE;
end;


function TNppPlugin.GetLanguageName(ALangType: TNppLang): string;
var
  BufLen: LRESULT;

begin
  BufLen := SendMessage(NppData.NppHandle, NPPM_GETLANGUAGENAME, WPARAM(ALangType), LPARAM(0));
  SetLength(Result, BufLen);

  BufLen := SendMessage(NppData.NppHandle, NPPM_GETLANGUAGENAME, WPARAM(ALangType), LPARAM(nppPChar(Result)));
  SetLength(Result, BufLen);
end;


function TNppPlugin.GetLanguageDesc(ALangType: TNppLang): string;
var
  BufLen: LRESULT;

begin
  BufLen := SendMessage(NppData.NppHandle, NPPM_GETLANGUAGEDESC, WPARAM(ALangType), LPARAM(0));
  SetLength(Result, BufLen);

  BufLen := SendMessage(NppData.NppHandle, NPPM_GETLANGUAGEDESC, WPARAM(ALangType), LPARAM(nppPChar(Result)));
  SetLength(Result, BufLen);
end;


function TNppPlugin.GetCurrentViewIdx: integer;
begin
  Result := SendMessage(NppData.NppHandle, NPPM_GETCURRENTVIEW, WPARAM(0), LPARAM(0));
end;


function TNppPlugin.GetCurrentViewIdx(ScHandle: HWND): integer;
begin
  if ScHandle = NppData.ScintillaMainHandle then
    Result := MAIN_VIEW

  else if ScHandle = NppData.ScintillaSecondHandle then
    Result := SUB_VIEW

  else
    Result := -1;
end;


function TNppPlugin.GetCurrentDocIndex(AViewIdx: integer): integer;
begin
  Result := SendMessage(NppData.NppHandle, NPPM_GETCURRENTDOCINDEX, WPARAM(0), LPARAM(AViewIdx));
end;


function TNppPlugin.GetCurrentLine: NativeInt;
begin
  Result := SendMessage(NppData.NppHandle, NPPM_GETCURRENTLINE, WPARAM(0), LPARAM(0));
end;


function TNppPlugin.GetCurrentColumn: LongInt;
begin
  Result := SendMessage(NppData.NppHandle, NPPM_GETCURRENTCOLUMN, WPARAM(0), LPARAM(0));
end;


function TNppPlugin.GetCurrentBufferId: NativeInt;
begin
  Result := SendMessage(NppData.NppHandle, NPPM_GETCURRENTBUFFERID, WPARAM(0), LPARAM(0));
end;


function TNppPlugin.GetBufferIdFromPos(AViewIdx, ADocIdx: integer): NativeInt;
begin
  Result := SendMessage(NppData.NppHandle, NPPM_GETBUFFERIDFROMPOS, WPARAM(ADocIdx), LPARAM(AViewIdx));
end;


function TNppPlugin.GetPosFromBufferId(ABufferId: NativeInt; out ADocIdx: integer): integer;
var
  Pos: LRESULT;

begin
  Result  := -1;
  ADocIdx := -1;

  Pos := SendMessage(NppData.NppHandle, NPPM_GETPOSFROMBUFFERID, WPARAM(ABufferId), LPARAM(MAIN_VIEW));

  if Pos <> -1 then
  begin
    Result  := Pos shr 30;
    ADocIdx := Pos and $3FFFFFFF;
  end;
end;


function TNppPlugin.GetFullPathFromBufferId(ABufferId: NativeInt): string;
var
  BufLen: LRESULT;

begin
  BufLen := SendMessage(NppData.NppHandle, NPPM_GETFULLPATHFROMBUFFERID, WPARAM(ABufferId), LPARAM(0));
  SetLength(Result, BufLen);

  if BufLen = -1 then exit;

  BufLen := SendMessage(NppData.NppHandle, NPPM_GETFULLPATHFROMBUFFERID, WPARAM(ABufferId), LPARAM(nppPChar(Result)));
  SetLength(Result, BufLen);
end;


function TNppPlugin.GetCurrentBufferDirty(AViewIdx: integer): boolean;
begin
  case AViewIdx of
    MAIN_VIEW: Result := (SendMessage(NppData.ScintillaMainHandle, SCI_GETMODIFY, WPARAM(0), LPARAM(0)) <> 0);
    SUB_VIEW:  Result := (SendMessage(NppData.ScintillaSecondHandle, SCI_GETMODIFY, WPARAM(0), LPARAM(0)) <> 0);
    else       Result := false;
  end;
end;


function TNppPlugin.GetOpenFilesCnt(CntType: integer): integer;
begin
  Result := SendMessage(NppData.NppHandle, NPPM_GETNBOPENFILES, WPARAM(0), LPARAM(CntType));
end;


function TNppPlugin.GetOpenFiles(CntType: integer): TStringDynArray;
var
  Cnt:    integer;
  Idx:    integer;
  Buffer: array of nppPChar;

begin
  Cnt := GetOpenFilesCnt(CntType);
  SetLength(Buffer, Cnt);

  for Idx := 0 to Pred(Cnt) do
    Buffer[Idx] := StrAlloc(MAX_PATH);

  case CntType of
    ALL_OPEN_FILES: Cnt := SendMessage(NppData.NppHandle, NPPM_GETOPENFILENAMES,        WPARAM(Buffer), LPARAM(Cnt));
    PRIMARY_VIEW:   Cnt := SendMessage(NppData.NppHandle, NPPM_GETOPENFILENAMESPRIMARY, WPARAM(Buffer), LPARAM(Cnt));
    SECOND_VIEW:    Cnt := SendMessage(NppData.NppHandle, NPPM_GETOPENFILENAMESSECOND,  WPARAM(Buffer), LPARAM(Cnt));
    else            Cnt := 0;
  end;

  SetLength(Result, Cnt);

  for Idx := 0 to Pred(Cnt) do
  begin
    SetString(Result[Idx], Buffer[Idx], StrLen(Buffer[Idx]));
    StrDispose(Buffer[Idx]);
  end;
end;


function TNppPlugin.GetLineCount(AViewIdx: integer): NativeInt;
begin
  case AViewIdx of
    MAIN_VIEW: Result := SendMessage(NppData.ScintillaMainHandle, SCI_GETLINECOUNT, WPARAM(0), LPARAM(0));
    SUB_VIEW:  Result := SendMessage(NppData.ScintillaSecondHandle, SCI_GETLINECOUNT, WPARAM(0), LPARAM(0));
    else       Result := 0;
  end;
end;


function TNppPlugin.GetLineFromPosition(AViewIdx: integer; APosition: NativeInt): NativeInt;
begin
  case AViewIdx of
    MAIN_VIEW: Result := SendMessage(NppData.ScintillaMainHandle, SCI_LINEFROMPOSITION, WPARAM(APosition), LPARAM(0));
    SUB_VIEW:  Result := SendMessage(NppData.ScintillaSecondHandle, SCI_LINEFROMPOSITION, WPARAM(APosition), LPARAM(0));
    else       Result := -1;
  end;
end;


function TNppPlugin.GetFirstVisibleLine(AViewIdx: integer): NativeInt;
begin
  case AViewIdx of
    MAIN_VIEW: Result := SendMessage(NppData.ScintillaMainHandle, SCI_GETFIRSTVISIBLELINE, WPARAM(0), LPARAM(0));
    SUB_VIEW:  Result := SendMessage(NppData.ScintillaSecondHandle, SCI_GETFIRSTVISIBLELINE, WPARAM(0), LPARAM(0));
    else       Result := -1;
  end;
end;


function TNppPlugin.GetLinesOnScreen(AViewIdx: integer): NativeInt;
begin
  case AViewIdx of
    MAIN_VIEW: Result := SendMessage(NppData.ScintillaMainHandle, SCI_LINESONSCREEN, WPARAM(0), LPARAM(0));
    SUB_VIEW:  Result := SendMessage(NppData.ScintillaSecondHandle, SCI_LINESONSCREEN, WPARAM(0), LPARAM(0));
    else       Result := 0;
  end;
end;


procedure TNppPlugin.GetFilePos(out FileName: string; out Line: NativeInt; out Column: LongInt);
begin
  FileName := GetFullCurrentPath();
  Line     := GetCurrentLine();
  Column   := GetCurrentColumn();
end;


function TNppPlugin.GetCurrentWord: string;
begin
  Result := GetVarSizeStringValue(NPPM_GETCURRENTWORD, $7FFFFFFF);
end;


function TNppPlugin.OpenFile(FileName: string; ReadOnly: boolean = false): boolean;
var
  Cnt:       integer;
  Ret:       integer;
  FileNames: TStringDynArray;

begin
  // Ask if we are not already opened
  FileNames := GetOpenFiles(ALL_OPEN_FILES);

  for Cnt := Low(FileNames) to High(FileNames) do
  begin
    if SameFileName(FileNames[Cnt], FileName) then
    begin
      // Activate document tab and exit
      SwitchToFile(FileName);
      exit(true);
    end;
  end;

  // Open the file
  Ret    := SendMessage(NppData.NppHandle, NPPM_DOOPEN, WPARAM(0), LPARAM(nppPChar(FileName)));
  Result := (Ret <> 0);

  // If requested set read-only state
  if Result and ReadOnly then
    PerformMenuCommand(IDM_EDIT_SETREADONLY, 1);
end;


function TNppPlugin.OpenFile(FileName: string; Line: NativeInt; ReadOnly: boolean = false): boolean;
var
  Ret: boolean;

begin
  Ret := OpenFile(FileName, ReadOnly);

  if Ret then
    case GetCurrentViewIdx() of
      MAIN_VIEW: SendMessage(NppData.ScintillaMainHandle, SCI_GOTOLINE, WPARAM(Line), LPARAM(0));
      SUB_VIEW:  SendMessage(NppData.ScintillaSecondHandle, SCI_GOTOLINE, WPARAM(Line), LPARAM(0));
    end;

  Result := Ret;
end;


procedure TNppPlugin.SwitchToFile(FileName: string);
begin
  SendMessage(NppData.NppHandle, NPPM_SWITCHTOFILE, 0, LPARAM(nppPChar(FileName)));
end;


procedure TNppPlugin.ReloadFile(FileName: string; Alert: boolean);
begin
  SendMessage(NppData.NppHandle, NPPM_RELOADFILE, WPARAM(Alert), LPARAM(nppPChar(FileName)));
end;


procedure TNppPlugin.ReloadCurrentFile(Alert: boolean);
begin
  SendMessage(NppData.NppHandle, NPPM_RELOADBUFFERID, WPARAM(GetCurrentBufferId()), LPARAM(Alert));
end;



// -----------------------------------------------------------------------------
// Notepad++ notification handlers
// -----------------------------------------------------------------------------

// Notifies plugins that all the procedures of launching notepad++
// completed succesfully
// hwndFrom = HWND hwndNpp
procedure TNppPlugin.DoNppnReady;
begin
  // When overriding this ensure to call "inherited"

  // Retrieve version infos from plugin's DLL file
  // and write them to internal variables
  GetVersionInfo();
end;


// Notifies plugins that toolbar icons can be registered.
// hwndFrom = HWND hwndNpp
procedure TNppPlugin.DoNppnToolbarModification;
begin
  // override this
end;


// Notifies plugins that Npp shutdown has been triggered,
// files have not been closed yet
// hwndFrom = HWND hwndNpp
procedure TNppPlugin.DoNppnBeforeShutDown;
begin
  // override this
end;


// Notifies plugins that Notepad++ shut down has been cancelled
// hwndFrom = HWND hwndNpp
procedure TNppPlugin.DoNppnCancelShutDown;
begin
  // override this
end;


// Notifies plugins that Notepad++ is about to shut down
// hwndFrom = HWND hwndNpp
procedure TNppPlugin.DoNppnShutdown;
begin
  // override this
end;


// Notifies plugins that a file is about to be loaded
// hwndFrom = HWND hwndNpp
// idFrom   = NULL
procedure TNppPlugin.DoNppnFileBeforeLoad;
begin
  // override this
end;


// Notifies plugins that the file load operation failed
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileLoadFailed;
begin
  // override this
end;


// Notifies plugins that a file is about to be opened
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileBeforeOpen;
begin
  // override this
end;


// Notifies plugins that the current file just opened
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileOpened;
begin
  // override this
end;


// Notifies plugins that the current file is about to be closed
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileBeforeClose;
begin
  // override this
end;


// Notifies plugins that the current file is just closed
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileClosed;
begin
  // override this
end;


// Notifies plugins that the current file is about to be saved
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileBeforeSave;
begin
  // override this
end;


// Notifies plugins that the current file was just saved
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileSaved;
begin
  // override this
end;


// Notifies plugins that the current file is about to be renamed
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileBeforeRename;
begin
  // override this
end;


// Notifies plugins that user cancelled the file rename operation
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileRenameCancel;
begin
  // override this
end;


// Notifies plugins that the current file was just renamed
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileRenamed;
begin
  // override this
end;


// Notifies plugins that the current file is about to be deleted
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileBeforeDelete;
begin
  // override this
end;


// Notifies plugins that the file delete operation failed
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileDeleteFailed;
begin
  // override this
end;


// Notifies plugins that the current file was just deleted
// hwndFrom = HWND hwndNpp
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnFileDeleted;
begin
  // override this
end;


// Notifies plugins that a buffer was activated (put to foreground).
// hwndFrom = HWND hwndNpp
// idFrom   = int activatedBufferID
procedure TNppPlugin.DoNppnBufferActivated;
begin
  // override this
end;


// Notifies plugins that the language in the current doc just changed.
// hwndFrom = HWND hwndNpp
// idFrom   = int currentBufferID
procedure TNppPlugin.DoNppnLangChanged;
begin
  // override this
end;


// Notifies plugins that the read-only state of the current buffer was changed
// hwndFrom = int bufferID
// idFrom   = int docStatus   can be combined by
//                              DOCSTATUS_READONLY = 1
//                              DOCSTATUS_BUFFERDIRTY = 2
procedure TNppPlugin.DoNppnReadOnlyChanged;
begin
  // override this
end;


// Notifies plugins that document order is changed,
// buffer bufferID having index newIndex.
// hwndFrom = int newIndex
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnDocOrderChanged;
begin
  // override this
end;


// Notifies plugins that a plugin command shortcut is remapped.
// hwndFrom = PShortcutKey ShortcutKeyStructure
// idFrom   = int cmdID
procedure TNppPlugin.DoNppnShortcutRemapped;
begin
  // override this
end;


// Notifies plugins that user initiated a WordStyleDlg change.
// hwndFrom = HWND hwndNpp
// idFrom   = int currentBufferID
procedure TNppPlugin.DoNppnWordStylesUpdated;
begin
  // override this
end;


// Notifies plugins that a snapshot dirty file is loaded on startup
// hwndFrom = NULL
// idFrom   = int bufferID
procedure TNppPlugin.DoNppnSnapshotDirtyFileLoaded;
begin
  // override this
end;


end.
