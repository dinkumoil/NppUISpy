{
    Extraction of version infos from Windows EXE and DLL files.
    Author: Andreas Heim

    This file is part of the Notepad++ plugin framework for Delphi.

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

unit FileVersionInfo;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes;


const
  // Language ID of english
  wLangIdEnglish: WORD = 1033;


type
  // Enum to specify the type of version info to query
  TFileVersionInfoTag = (
    fvitCompanyName,
    fvitFileDescription,
    fvitComments,
    fvitProductName,
    fvitInternalName,
    fvitOriginalFilename,
    fvitFileVersion,
    fvitProductVersion,
    fvitLegalCopyright,
    fvitLegalTrademarks,
    fvitPrivateBuild,
    fvitSpecialBuild
  );


  // Enum to specify the type of numeric version info to query
  TNumericFileVersionInfoTag = (
    nfvitFileVersion,
    nfvitProductVersion
  );


  // Class to read version infos from EXE or DLL files
  TFileVersionInfo = class
  public
    class function GetVersionInfoTagName(const InfoTag: TFileVersionInfoTag): string; static;
    class function GetVersionInfoFriendlyTagName(const InfoTag: TFileVersionInfoTag): string; static;
    class function GetVersionInfo(const FileName: string; const InfoTag: TFileVersionInfoTag; var LangId: Word; out Buffer: string): boolean; static;

    class function GetNumericVersionInfoTagName(const InfoTag: TNumericFileVersionInfoTag): string; static;
    class function GetNumericVersionInfoFriendlyTagName(const InfoTag: TNumericFileVersionInfoTag): string; static;
    class function GetNumericVersionInfo(const FileName: string; const InfoTag: TNumericFileVersionInfoTag; out VersionMajor, VersionMinor, Release, Build: integer): boolean; static;

    class function GetLanguageName(LangId: Word): string;

  end;



implementation

type
  TFileVersionTagMapping = record
    TagName:         string;
    TagFriendlyName: string;
  end;


var
  szVersionInfoTags: array[TFileVersionInfoTag] of TFileVersionTagMapping =
  (
    (TagName: 'CompanyName'     ; TagFriendlyName: 'Company name'     ),
    (TagName: 'FileDescription' ; TagFriendlyName: 'Description'      ),
    (TagName: 'Comments'        ; TagFriendlyName: 'Comments'         ),
    (TagName: 'ProductName'     ; TagFriendlyName: 'Product name'     ),
    (TagName: 'InternalName'    ; TagFriendlyName: 'Internal name'    ),
    (TagName: 'OriginalFilename'; TagFriendlyName: 'Original filename'),
    (TagName: 'FileVersion'     ; TagFriendlyName: 'File version'     ),
    (TagName: 'ProductVersion'  ; TagFriendlyName: 'Product version'  ),
    (TagName: 'LegalCopyright'  ; TagFriendlyName: 'Copyright'        ),
    (TagName: 'LegalTrademarks' ; TagFriendlyName: 'Trademarks'       ),
    (TagName: 'PrivateBuild'    ; TagFriendlyName: 'Private build'    ),
    (TagName: 'SpecialBuild'    ; TagFriendlyName: 'Special build'    )
  );


  szNumericVersionInfoTags: array[TNumericFileVersionInfoTag] of TFileVersionTagMapping =
  (
    (TagName: 'FileVersion'   ; TagFriendlyName: 'File version'   ),
    (TagName: 'ProductVersion'; TagFriendlyName: 'Product version')
  );


// =============================================================================
// Class TFileVersionInfo
// =============================================================================

class function TFileVersionInfo.GetVersionInfoTagName(const InfoTag: TFileVersionInfoTag): string;
begin
  Result := szVersionInfoTags[InfoTag].TagName;
end;


class function TFileVersionInfo.GetVersionInfoFriendlyTagName(const InfoTag: TFileVersionInfoTag): string;
begin
  Result := szVersionInfoTags[InfoTag].TagFriendlyName;
end;


class function TFileVersionInfo.GetVersionInfo(const FileName: string; const InfoTag: TFileVersionInfoTag; var LangId: Word; out Buffer: string): boolean;
type
  {$POINTERMATH ON}
  PLangCodepage = ^TLangCodepage;
  {$POINTERMATH OFF}

  TLangCodepage = packed record
    wLangId:   WORD;
    wCodePage: WORD;
  end;

var
  dwLen:           DWORD;
  dwHandle:        DWORD;
  lpData:          pointer;
  lpTranslate:     PLangCodepage;
  cbTranslate:     UINT;
  lpszSubData:     string;
  lpszVersionData: PChar;
  dwBytes:         UINT;
  wLangId:         WORD;
  bEngFound:       boolean;
  i:               integer;

begin
  Result := false;
  Buffer := '';

  dwLen := GetFileVersionInfoSize(PChar(FileName), dwHandle);
  if dwLen = 0 then exit;

  GetMem(lpData, dwLen);

  try
    if not GetFileVersionInfo(PChar(FileName), dwHandle, dwLen, lpData) then
      exit;

    if not VerQueryValue(lpData, '\VarFileInfo\Translation', pointer(lpTranslate), cbTranslate) then
      exit;

    wLangId   := LangId;
    bEngFound := false;

    for i := 0 to Pred(cbTranslate div sizeof(TLangCodepage)) do
    begin
      if (lpTranslate[i].wLangId = LangId        ) or
         (lpTranslate[i].wLangId = wLangIdEnglish) or
         not bEngFound                             then
      begin
        lpszSubData := Format('\StringFileInfo\%.4x%.4x\%s',
                              [lpTranslate[i].wLangId,
                               lpTranslate[i].wCodePage,
                               szVersionInfoTags[InfoTag].TagName
                              ]);

        if not VerQueryValue(lpData, PChar(lpszSubData), pointer(lpszVersionData), dwBytes) then
          continue;

        Buffer    := Format('%s', [lpszVersionData]);
        wLangId   := lpTranslate[i].wLangId;
        bEngFound := (lpTranslate[i].wLangId = wLangIdEnglish);
        Result    := true;

        if lpTranslate[i].wLangId = LangId then
          break;
      end;
    end;

    LangId := wLangId;

  finally
    FreeMem(lpData);
  end;
end;


class function TFileVersionInfo.GetNumericVersionInfoTagName(const InfoTag: TNumericFileVersionInfoTag): string;
begin
  Result := szNumericVersionInfoTags[InfoTag].TagName;
end;


class function TFileVersionInfo.GetNumericVersionInfoFriendlyTagName(const InfoTag: TNumericFileVersionInfoTag): string;
begin
  Result := szNumericVersionInfoTags[InfoTag].TagFriendlyName;
end;


class function TFileVersionInfo.GetNumericVersionInfo(const FileName: string; const InfoTag: TNumericFileVersionInfoTag; out VersionMajor, VersionMinor, Release, Build: integer): boolean;
var
  dwLen:    DWORD;
  dwHandle: DWORD;
  lpData:   pointer;
  dwBytes:  UINT;
  FileInfo: PVSFixedFileInfo;

begin
  Result       := false;

  VersionMajor := 0;
  VersionMinor := 0;
  Release      := 0;
  Build        := 0;

  dwLen := GetFileVersionInfoSize(PChar(FileName), dwHandle);
  if dwLen = 0 then exit;

  GetMem(lpData, dwLen);

  try
    if not GetFileVersionInfo(PChar(FileName), dwHandle, dwLen, lpData) then
      exit;

    if not VerQueryValue(lpData, '\', pointer(FileInfo), dwBytes) then
      exit;

    case InfoTag of
      nfvitProductVersion:
      begin
        VersionMajor := (FileInfo.dwProductVersionMS) shr 16;
        VersionMinor := (FileInfo.dwProductVersionMS) and $FFFF;
        Release      := (FileInfo.dwProductVersionLS) shr 16;
        Build        := (FileInfo.dwProductVersionLS) and $FFFF;
      end;

      nfvitFileVersion:
      begin
        VersionMajor := (FileInfo.dwFileVersionMS) shr 16;
        VersionMinor := (FileInfo.dwFileVersionMS) and $FFFF;
        Release      := (FileInfo.dwFileVersionLS) shr 16;
        Build        := (FileInfo.dwFileVersionLS) and $FFFF;
      end;
    end;

    Result := true;

  finally
    FreeMem(lpData);
  end;
end;


class function TFileVersionInfo.GetLanguageName(LangId: Word): string;
var
  Buffer: string;
  BufLen: integer;

begin
  Result := '';
  Buffer := '';
  BufLen := 0;

  repeat
    SetLength(Buffer, BufLen);
    BufLen := GetLocaleInfo(LangId, LOCALE_SLANGUAGE, PChar(Buffer), BufLen);
  until BufLen = Length(Buffer);

  if Buffer <> '' then
  begin
    SetLength(Buffer, StrLen(PChar(Buffer)));
    Result := Buffer;
  end;
end;


end.

