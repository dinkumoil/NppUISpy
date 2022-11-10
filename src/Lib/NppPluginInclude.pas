{
    Plugin DLL interface routines for extending a plugin project's *.dpr file.

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

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH:
    begin
      if not Assigned(BasePlugin) then
        BasePlugin := PluginClass.Create;
    end;

    DLL_PROCESS_DETACH:
    begin
      FreeAndNil(BasePlugin);
    end;

    DLL_THREAD_ATTACH:
    begin
      // ignore
    end;

    DLL_THREAD_DETACH:
    begin
      // ignore
    end;
  end;
end;


function messageProc(msg: Cardinal; _wParam: WPARAM; _lParam: LPARAM): LRESULT; cdecl; export;
var
  xmsg: TMessage;

begin
  xmsg.Msg    := msg;
  xmsg.WParam := _wParam;
  xmsg.LParam := _lParam;
  xmsg.Result := 0;

  BasePlugin.MessageProc(xmsg);

  Result := xmsg.Result;
end;


procedure beNotified(sn: PSCNotification); cdecl; export;
begin
  BasePlugin.BeNotified(sn);
end;


procedure setInfo(NppData: TNppData); cdecl; export;
begin
  BasePlugin.SetInfo(NppData);
end;


function getFuncsArray(out nFuncs: integer): Pointer; cdecl; export;
begin
  Result := BasePlugin.GetFuncsArray(nFuncs);
end;


function getName(): nppPchar; cdecl; export;
begin
  Result := BasePlugin.GetName;
end;


function isUnicode : Boolean; cdecl; export;
begin
  Result := true;
end;



exports
  setInfo, getName, getFuncsArray, beNotified, messageProc, isUnicode;
