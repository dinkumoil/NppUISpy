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

unit DataModule;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils, System.DateUtils,
  System.IOUtils, System.Math, System.Types, System.Classes, System.Generics.Collections,
  System.Generics.Defaults, System.TypInfo, System.IniFiles,

  NppSupport, NppMenuCmdID, NppPlugin;


type
  TSearchFocus = (sfMenuItemTree, sfToolbarButtonTree);

  TSearchFocusHelper = record
    class function ToString(Value: TSearchFocus): string; static;
    class function FromString(const Value: string; Default: TSearchFocus): TSearchFocus; static;
  end;

  TSearchType  = (stMenuItem, stCommandId);

  TSearchTypeHelper = record
    class function ToString(Value: TSearchType): string; static;
    class function FromString(const Value: string; Default: TSearchType): TSearchType; static;
  end;

  
  // Abstraction of the settings file
  TSettings = class(TObject)
  strict private
    FIniFile:           TIniFile;
    FValid:             boolean;
    FSearchFocus:       TSearchFocus;
    FSearchType:        TSearchType;
    FWrapAround:        boolean;
    FSearchHistory:     TStringList;

    class function GetFilePath: string; static;

    procedure   SetSearchHistory(Idx: integer; const Value: string);
    function    GetSearchHistory(Idx: integer): string;
    
    function    GetSearchHistoryLength: integer;

    procedure   LoadSettings;
    procedure   SaveSettings;

  public
    constructor Create(const AFilePath: string);
    destructor  Destroy; override;

    // Class properties
    class property FilePath: string  read GetFilePath;

    // Common properties
    property    Valid:                       boolean      read FValid;
    property    SearchFocus:                 TSearchFocus read FSearchFocus            write FSearchFocus;
    property    SearchType:                  TSearchType  read FSearchType             write FSearchType;
    property    WrapAround:                  boolean      read FWrapAround             write FWrapAround;
    property    SearchHistory[Idx: integer]: string       read GetSearchHistory        write SetSearchHistory;
    property    SearchHistoryLength:         integer      read GetSearchHistoryLength;

  end;



implementation

uses
  Main;


const
  // Data for INI file section "Header"
  SECTION_HEADER:                 string = 'Header';
  KEY_VERSION:                    string = 'Version';
  VALUE_VERSION:                  string = '1.0';

  // Data for INI file section "Settings"
  SECTION_SETTINGS:               string = 'Settings';
  KEY_SETTINGS_SEARCH_FOCUS_NAME: string = 'SearchFocus';
  KEY_SETTINGS_SEARCH_TYPE_NAME:  string = 'SearchType';
  KEY_SETTINGS_WRAP_AROUND_NAME:  string = 'WrapAround';

  // Data for INI file section "SearchHistory"
  SECTION_SEARCH_HISTORY:         string = 'SearchHistory';
  KEY_SEARCH_HISTORY_ITEM_NAME:   string = 'Item';


const
  MAX_SEARCH_HISTORY_LENGTH = 20;


// =============================================================================
// Class TSettings
// =============================================================================

// -----------------------------------------------------------------------------
// Create / Destroy
// -----------------------------------------------------------------------------

constructor TSettings.Create(const AFilePath: string);
begin
  inherited Create;

  FValid   := false;
  FIniFile := TIniFile.Create(AFilePath);
  
  FSearchHistory                 := TStringList.Create;
  FSearchHistory.Sorted          := false;
  FSearchHistory.CaseSensitive   := false;
  FSearchHistory.Duplicates      := dupIgnore;
  FSearchHistory.StrictDelimiter := true;
  FSearchHistory.Delimiter       := ';';

  LoadSettings;
end;


destructor TSettings.Destroy;
begin
  // Settings are saved to disk at instance destruction
  SaveSettings;

  FSearchHistory.Free;
  FIniFile.Free;

  inherited;
end;


// -----------------------------------------------------------------------------
// Getter / Setter
// -----------------------------------------------------------------------------

// Get path of settings file
class function TSettings.GetFilePath: string;
begin
  Result := TPath.Combine(Plugin.GetPluginConfigDir, ReplaceStr(Plugin.GetName, ' ', '') + '.ini');
end;


// Store search term in search history list
procedure TSettings.SetSearchHistory(Idx: integer; const Value: string);
var
  Cnt:      integer;
  FoundIdx: integer;

begin
  // Check if search term is already part of search history
  FoundIdx := -1;

  for Cnt := 0 to Pred(FSearchHistory.Count) do
  begin
    if SameText(FSearchHistory.ValueFromIndex[Cnt], Value) then
    begin
      FoundIdx := Cnt;
      break;
    end;
  end;

  // If search term is not part of search history, push existing items of search
  // history towards end of list and add new search term to beginning of list.
  // If search history exceeds its maximum length, the oldest item will be lost.
  if FoundIdx = -1 then
  begin
    // If search history is empty, add new item
    if FSearchHistory.Count = 0 then
      FSearchHistory.Add(Format('%s%d=', [KEY_SEARCH_HISTORY_ITEM_NAME, 0]))

    // If search history is not empty, append new item and push existing items
    // towards end of list
    else
      for Cnt := Min(FSearchHistory.Count, Pred(MAX_SEARCH_HISTORY_LENGTH)) downto 1 do
      begin
        if Cnt = FSearchHistory.Count then
          FSearchHistory.Add(Format('%s%d=', [KEY_SEARCH_HISTORY_ITEM_NAME, Cnt]));

        FSearchHistory.Values[Format('%s%d', [KEY_SEARCH_HISTORY_ITEM_NAME, Cnt])] := FSearchHistory.Values[Format('%s%d', [KEY_SEARCH_HISTORY_ITEM_NAME, Pred(Cnt)])];
      end;

    // Store search term at beginning of search history
    FSearchHistory.Values[Format('%s%d', [KEY_SEARCH_HISTORY_ITEM_NAME, 0])] := Value;
  end

  // If search term is already part of search history, ...
  else
  begin
    // ... push preceding items towards end of list ...
    for Cnt := FoundIdx downto 1 do
      FSearchHistory.Values[Format('%s%d', [KEY_SEARCH_HISTORY_ITEM_NAME, Cnt])] := FSearchHistory.Values[Format('%s%d', [KEY_SEARCH_HISTORY_ITEM_NAME, Pred(Cnt)])];

    // ... and store search term at beginning of list
    FSearchHistory.Values[Format('%s%d', [KEY_SEARCH_HISTORY_ITEM_NAME, 0])] := Value;
  end;
end;


function TSettings.GetSearchHistory(Idx: integer): string;
begin
  Idx    := EnsureRange(Idx, 0, Min(Pred(FSearchHistory.Count), Pred(MAX_SEARCH_HISTORY_LENGTH)));
  Result := FSearchHistory.Values[Format('%s%d', [KEY_SEARCH_HISTORY_ITEM_NAME, Idx])];
end;


function TSettings.GetSearchHistoryLength: integer;
begin
  Result := FSearchHistory.Count;
end;


// -----------------------------------------------------------------------------
// I/O methods
// -----------------------------------------------------------------------------

// Parse settings file and store its content in a data model
procedure TSettings.LoadSettings;
var
  Header:   TStringList;
  Settings: TStringList;
  Cnt:      integer;

begin
  Header                 := TStringList.Create;
  Header.Sorted          := false;
  Header.CaseSensitive   := false;
  Header.Duplicates      := dupIgnore;
  Header.StrictDelimiter := true;
  Header.Delimiter       := ';';

  try
    // Skip header checking if the settings file doesn't exist
    if FileExists(FIniFile.FileName) then
    begin
      // In future versions of the plugin here we could call an update function
      // for the settings file of older plugin versions
      FIniFile.ReadSectionValues(SECTION_HEADER, Header);
      if not SameText(Header.Values[KEY_VERSION], VALUE_VERSION) then exit;
    end;

    Settings                 := TStringList.Create;
    Settings.Sorted          := false;
    Settings.CaseSensitive   := false;
    Settings.Duplicates      := dupIgnore;
    Settings.StrictDelimiter := true;
    Settings.Delimiter       := ';';

    try
      // Retrieve settings data...
      FIniFile.ReadSectionValues(SECTION_SETTINGS, Settings);

      // ...and transfer it to the datamodel
      if Settings.IndexOfName(KEY_SETTINGS_SEARCH_FOCUS_NAME) >= 0 then
        FSearchFocus := TSearchFocusHelper.FromString(Settings.Values[KEY_SETTINGS_SEARCH_FOCUS_NAME], sfMenuItemTree)
      else
        FSearchFocus := sfMenuItemTree;

      if Settings.IndexOfName(KEY_SETTINGS_SEARCH_TYPE_NAME) >= 0 then
        FSearchType := TSearchTypeHelper.FromString(Settings.Values[KEY_SETTINGS_SEARCH_TYPE_NAME], stMenuItem)
      else
        FSearchType := stMenuItem;

      if Settings.IndexOfName(KEY_SETTINGS_WRAP_AROUND_NAME) >= 0 then
        FWrapAround := StrToBoolDef(Settings.Values[KEY_SETTINGS_WRAP_AROUND_NAME], false)
      else
        FWrapAround := false;

      // Retrieve search history data
      FIniFile.ReadSectionValues(SECTION_SEARCH_HISTORY, FSearchHistory);

      for Cnt := Pred(FSearchHistory.Count) downto 0 do
      begin
        if FSearchHistory.Count <= MAX_SEARCH_HISTORY_LENGTH then break;
        FSearchHistory.Delete(Cnt);
      end;

      // If we reached this point we can mark settings as valid
      FValid := true;

    finally
      Settings.Free;
    end;

  finally
    Header.Free;
  end;
end;


// Save settings data model to a disk file
procedure TSettings.SaveSettings;
var
  Settings: TStringList;
  Cnt:      integer;

begin
  if not FValid then exit;

  // Clear whole settings file
  Settings := TStringList.Create;

  try
    FIniFile.ReadSections(Settings);

    for Cnt := 0 to Pred(Settings.Count) do
      FIniFile.EraseSection(Settings[Cnt]);

  finally
    Settings.Free;
  end;

  // Write Header
  FIniFile.WriteString(SECTION_HEADER, KEY_VERSION, VALUE_VERSION);

  // Write settings data
  FIniFile.WriteString(SECTION_SETTINGS, KEY_SETTINGS_SEARCH_FOCUS_NAME, TSearchFocusHelper.ToString(FSearchFocus));
  FIniFile.WriteString(SECTION_SETTINGS, KEY_SETTINGS_SEARCH_TYPE_NAME,  TSearchTypeHelper.ToString(FSearchType));
  FIniFile.WriteString(SECTION_SETTINGS, KEY_SETTINGS_WRAP_AROUND_NAME,  BoolToStr(FWrapAround, true));

  // Write search history
  for Cnt := 0 to Min(Pred(FSearchHistory.Count), Pred(MAX_SEARCH_HISTORY_LENGTH)) do
    FIniFile.WriteString(SECTION_SEARCH_HISTORY, Format('%s%d', [KEY_SEARCH_HISTORY_ITEM_NAME, Cnt]), FSearchHistory.Values[Format('%s%d', [KEY_SEARCH_HISTORY_ITEM_NAME, Cnt])]);
end;



// =============================================================================
// TSearchFocusHelper
// =============================================================================

class function TSearchFocusHelper.FromString(const Value: string; Default: TSearchFocus): TSearchFocus;
begin
  Result := TSearchFocus(GetEnumValue(TypeInfo(TSearchFocus), Value));

  if not (Result in [Low(TSearchFocus)..High(TSearchFocus)])  then
    Result := Default;
end;


class function TSearchFocusHelper.ToString(Value: TSearchFocus): string;
begin
  Result := GetEnumName(TypeInfo(TSearchFocus), Ord(Value));
end;



// =============================================================================
// TSearchTypeHelper
// =============================================================================

class function TSearchTypeHelper.FromString(const Value: string; Default: TSearchType): TSearchType;
begin
  Result := TSearchType(GetEnumValue(TypeInfo(TSearchType), Value));

  if not (Result in [Low(TSearchType)..High(TSearchType)])  then
    Result := Default;
end;


class function TSearchTypeHelper.ToString(Value: TSearchType): string;
begin
  Result := GetEnumName(TypeInfo(TSearchType), Ord(Value));
end;


end.
