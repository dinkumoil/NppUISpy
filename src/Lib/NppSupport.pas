{
    Constants and records for Notepad++ message interface.

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

unit NppSupport;


interface

uses
  Winapi.Windows, Winapi.Messages;


const
  // ---------------------------------------------------------------------------
  // Notepad++ command messages
  // ---------------------------------------------------------------------------
  NPPMSG                         = (WM_USER + 1000);

  NPPM_GETCURRENTSCINTILLA       = (NPPMSG + 4);
  // BOOL NPPM_GETCURRENTSCINTILLA(0, INT *currentEdit)
  // currentEdit indicates the current Scintilla view:
  //   0 is the main Scintilla view
  //   1 is the second Scintilla view.
  // Returns TRUE

  NPPM_GETCURRENTLANGTYPE        = (NPPMSG + 5);
  // BOOL NPPM_GETCURRENTLANGTYPE(0, INT *langType)
  // langType indicates the language type of current Scintilla view document
  // please see the enum LangType for all possible value.
  // Returns TRUE

  NPPM_SETCURRENTLANGTYPE        = (NPPMSG + 6);
  // BOOL NPPM_GETCURRENTLANGTYPE(0, INT langTypeToSet)
  // langTypeToSet is language type to set in current Scintilla view document
  // please see the enum LangType for all possible value
  // Returns TRUE

  NPPM_GETNBOPENFILES            = (NPPMSG + 7);
  // INT NPPM_GETNBOPENFILES(0, INT nbType)
  // the return value depends on nbType:
    ALL_OPEN_FILES = 0;  // the total number of files opened in Notepad++
    PRIMARY_VIEW   = 1;  // the number of files opened in the primary view
    SECOND_VIEW    = 2;  // the number of files opened in the second view

  NPPM_GETOPENFILENAMES          = (NPPMSG + 8);
  // INT NPPM_GETOPENFILENAMES(TCHAR **fileNames, INT nbFile)
  // nbFile is the size of your fileNames array. You should get this value by
  // using NPPM_GETNBOPENFILES message with constant ALL_OPEN_FILES, then allocate
  // fileNames array with this value.
  // fileNames receives the full path names of all the opened files in Notepad++.
  // User is responsible to allocate fileNames array with enough size.
  // The return value is the number of file full path names copied in fileNames
  // array.

  NPPM_MODELESSDIALOG            = (NPPMSG + 12);
  // HWND NPPM_MODELESSDIALOG(INT op, HWND hDlg)
  // For each created dialog in your plugin, you should register it to Notepad++
  // (and unregister while destroying it) by using this message. If this message
  // is ignored, then your dialog won't react with the key stroke messages such
  // as TAB key. For the good functioning of your plugin dialog, you're recommended
  // to not ignore this message.
  //   hDlg: handle of the dialog to be registed.
  //   op:   operation mode. MODELESSDIALOGADD is to register;
  //                         MODELESSDIALOGREMOVE is to unregister.
	// Returns hDlg (HWND) on success, NULL on failure
    MODELESSDIALOGADD    = 0;
    MODELESSDIALOGREMOVE = 1;

  NPPM_GETNBSESSIONFILES         = (NPPMSG + 13);
  // INT NPPM_GETNBSESSIONFILES(0, const TCHAR *sessionFileName)
  // This message returns the number of files to load in the session sessionFileName.
  // sessionFileName should be a full path name of an xml file. 0 is returned if
  // sessionFileName is NULL or an empty string

  NPPM_GETSESSIONFILES           = (NPPMSG + 14);
  // INT NPPM_GETSESSIONFILES(TCHAR **sessionFileArray, const TCHAR *sessionFileName)
  // Send this message to get files' full path names from a session file.
  // sessionFileName is the session file from which you retrieve the files.
  // sessionFileArray is the array in which the files' full path of the same
  // group are written. You should send message NPPM_GETNBSESSIONFILES before
  // to allocate this array with the proper size.
	// Returns FALSE on failure, TRUE on success

  NPPM_SAVESESSION               = (NPPMSG + 15);  // see TSessionInfo
  // TCHAR *NPPM_SAVESESSION(0, TSessionInfo *sessionInfomation)
  // This message let plugins save a session file (xml format) by providing an
  // array of full file path names.
	// Contrary to NPPM_SAVECURRENTSESSION (see below), which saves the current
  // opened files, this call can be used to freely define any file which should
  // be part of a session.
	// Returns sessionInfomation.sessionFilePathName on success, NULL otherwise

  NPPM_SAVECURRENTSESSION        = (NPPMSG + 16);
  // TCHAR *NPPM_SAVECURRENTSESSION(0, const TCHAR *sessionFileName)
  // You can save the current opened files in Notepad++ as a group of files
  // (session) by using this message. Notepad++ saves the current opened files'
  // full pathe names and their current stats in an xml file. The xml full path
  // name is provided by sessionFileName.
	// Returns sessionFileName on success, NULL otherwise

  NPPM_GETOPENFILENAMESPRIMARY   = (NPPMSG + 17);
  // INT NPPM_GETOPENFILENAMESPRIMARY(TCHAR **fileNames, INT nbFile)
  // nbFile is the size of your fileNames array. You should get this value by
  // using NPPM_GETNBOPENFILES message with constant PRIMARY_VIEW, then allocate
  // fileNames array with this value.
  // fileNames receives the full path names of the opened files in the primary
  // view. User is responsible to allocate fileNames array with enough size.
  // The return value is the number of file full path names copied in fileNames
  // array.

  NPPM_GETOPENFILENAMESSECOND    = (NPPMSG + 18);
  // INT NPPM_GETOPENFILENAMESSECOND(TCHAR **fileNames, INT nbFile)
  // nbFile is the size of your fileNames array. You should get this value by
  // using NPPM_GETNBOPENFILES message with constant SECOND_VIEW, then allocate
  // fileNames array with this value.
  // fileNames receives the full path names of the opened files in the second
  // view. User is responsible to allocate fileNames array with enough size.
  // The return value is the number of file full path names copied in fileNames
  // array.

  NPPM_CREATESCINTILLAHANDLE     = (NPPMSG + 20);
  // HWND NPPM_CREATESCINTILLAHANDLE(0, HWND pluginWindowHandle)
  // A plugin can create a Scintilla for its usage by sending this message to
  // Notepad++. The return value is the created Scintilla handle. The handle
  // should be destroyed by NPPM_DESTROYSCINTILLAHANDLE message during exit of
  // the plugin. If pluginWindowHandle is set (non NULL), it will be set as
  // parent window of this created Scintilla handle, otherwise the parent window
  // is Notepad++.

  NPPM_DESTROYSCINTILLAHANDLE    = (NPPMSG + 21);
  // BOOL NPPM_DESTROYSCINTILLAHANDLE(0, HWND scintillaHandle2Destroy)
  // If plugin called NPPM_CREATESCINTILLAHANDLE to create a Scintilla handle,
  // it should call this message to destroy this handle while it exits.
	// Returns TRUE

  NPPM_GETNBUSERLANG             = (NPPMSG + 22);
  // INT NPPM_GETNBUSERLANG(0, INT *userLangCmdId)
  // Send this message to get the number of installed user defined languages.
  // The optional parameter userLangCmdId can be NULL or it can point to an
  // integer variable that after the call contains the menu command id of the
  // menu entry "User defined" in the "Languages" menu.

  NPPM_GETCURRENTDOCINDEX        = (NPPMSG + 23);
  // INT NPPM_GETCURRENTDOCINDEX(0, INT iView)
  // Send this message to get the current index in the view that you indicate
  // in iView: MAIN_VIEW or SUB_VIEW.
  // Returned value is -1 if the view is invisible (hidden), otherwise is the
  // current tab index.
    MAIN_VIEW = 0;
    SUB_VIEW  = 1;

  NPPM_SETSTATUSBAR              = (NPPMSG + 24);
  // BOOL NPPM_SETSTATUSBAR(INT sbItem, TCHAR *text)
  // Send this message to set the text of a certain status bar item indicated
  // by parameter sbItem.
  // The return value is FALSE if sbItem contains an invalid value or if
  // parameter text is NULL or points to an empty string. Otherwise the return
  // value is TRUE.
  // Parameter sbItem can be one of the following values:
    STATUSBAR_DOC_TYPE     = 0;
    STATUSBAR_DOC_SIZE     = 1;
    STATUSBAR_CUR_POS      = 2;
    STATUSBAR_EOF_FORMAT   = 3;
    STATUSBAR_UNICODE_TYPE = 4;
    STATUSBAR_TYPING_MODE  = 5;

  NPPM_GETMENUHANDLE             = (NPPMSG + 25);
  // INT NPPM_GETMENUHANDLE(INT menuChoice, 0)
  // Return: menu handle (HMENU) of choice (plugin menu handle or
  // Notepad++ main menu handle)
    NPPPLUGINMENU = 0;
    NPPMAINMENU   = 1;

  NPPM_ENCODESCI                 = (NPPMSG + 26);
  // TUniMode NPPM_ENCODESCI(int inView, 0)
	// Changes current buffer in view to UTF-8.
	// - inView:
  //    MAIN_VIEW = 0
  //    SUB_VIEW  = 1
	// Returns new UniMode, see TUniMode

  NPPM_DECODESCI                 = (NPPMSG + 27);
	// TUniMode NPPM_DECODESCI(int inView, 0)
	// Changes current buffer in view to ANSI.
	// - inView:
  //    MAIN_VIEW = 0
  //    SUB_VIEW  = 1
	// Returns old UniMode - see TUniMode

  NPPM_ACTIVATEDOC               = (NPPMSG + 28);
  // BOOL NPPM_ACTIVATEDOC(INT view, INT index2Activate)
  // When Notepad++ receives this message, it switches to iView (MAIN_VIEW or
  // SUB_VIEW) as current view, then it switches to the index2Activate-th
  // document of the view
  //   MAIN_VIEW = 0;
  //   SUB_VIEW  = 1;
	// Returns TRUE

  NPPM_LAUNCHFINDINFILESDLG      = (NPPMSG + 29);
  // BOOL NPPM_LAUNCHFINDINFILESDLG(TCHAR *dir2Search, TCHAR *filter)
  // This message triggers the Find in files dialog. The fields Directory and
  // filters are filled by respectively dir2Search and filter if those parameters
  // are not NULL or empty.
	// Return TRUE

  NPPM_DMMSHOW                   = (NPPMSG + 30);
  // BOOL NPPM_DMMSHOW(0, HWND hDlg)
  // This message is used for your plugin's dockable dialog. Send this message
  // to show the dialog. hDlg is the handle of your dialog to be shown (tTbData->hClient).
	// Return TRUE

  NPPM_DMMHIDE                   = (NPPMSG + 31);
  // BOOL NPPM_DMMHIDE(0, HWND hDlg)
  // This message is used for your plugin's dockable dialog. Send this message
  // to hide the dialog. hDlg is the handle of your dialog to be hidden (tTbData->hClient).
	// Return TRUE

  NPPM_DMMUPDATEDISPINFO         = (NPPMSG + 32);
  // BOOL NPPM_DMMUPDATEDISPINFO(0, HWND hDlg)
  // This message is used for your plugin's dockable dialog. Send this message
  // to update (redraw) the dialog. hDlg is the handle of your dialog to be updated (tTbData->hClient).
	// Return TRUE

  NPPM_DMMREGASDCKDLG            = (NPPMSG + 33);
  // BOOL NPPM_DMMREGASDCKDLG(0, TTbData *dockingData)
  // From v4.0, Notepad++ supports the dockable dialog feature for plugins.
  // This message passes the necessary data dockingData to Notepad++ in order
  // to make your dialog dockable. Minimum informations you need to fill out
  // before sending it by NPPM_DMMREGASDCKDLG message is hClient, pszName,
  // dlgID, uMask and pszModuleName. Notice that rcFloat and iPrevCont shouldn't
  // be filled. They are used internally.
  // See TTbData
	// Return TRUE

  NPPM_LOADSESSION               = (NPPMSG + 34);
  // BOOL NPPM_LOADSESSION(0, const TCHAR *sessionFileName)
  // Open all files of same session in Notepad++ via a
  // xml format session file sessionFileName.
	// Return TRUE

  NPPM_DMMVIEWOTHERTAB           = (NPPMSG + 35);
  // BOOL NPPM_DMMVIEWOTHERTAB(0, TCHAR* name)
	// Show the plugin dialog (switch to plugin tab) with the given name.
	// - name should be the same value as previously used to register the dialog (pszName of tTbData)
	// Return TRUE
	// Return TRUE

  NPPM_RELOADFILE                = (NPPMSG + 36);
  // BOOL NPPM_RELOADFILE(BOOL withAlert, TCHAR *filePathName2Reload)
  // This Message reloads the file indicated in filePathName2Reload.
  // If withAlert is TRUE, then an alert message box will be launched.
  // Since v8.6.5, returns TRUE if reloading file succeeds, otherwise FALSE

  NPPM_SWITCHTOFILE              = (NPPMSG + 37);
  // BOOL NPPM_SWITCHTOFILE(0, TCHAR *filePathName2switch)
  // When this message is received, Notepad++ switches to the document which
  // matches with the given filePathName2switch.
	// Returns TRUE

  NPPM_SAVECURRENTFILE           = (NPPMSG + 38);
  // BOOL NPPM_SAVECURRENTFILE(0, 0)
  // Send this message to Notepad++ to save the current document.
	// Return TRUE if file is saved, otherwise FALSE (the file doesn't need
  // to be saved, or other reasons).

  NPPM_SAVEALLFILES              = (NPPMSG + 39);
  // BOOL NPPM_SAVEALLFILES(0, 0)
  // Send this message to Notepad++ to save all opened document.
	// Return FALSE when no file needs to be saved, else TRUE if at least
  // one file has been saved.

  NPPM_SETMENUITEMCHECK          = (NPPMSG + 40);
  // BOOL NPPM_SETMENUITEMCHECK(UINT cmdID, TRUE/FALSE)
  // Use this message to set/remove the check on menu item.
  // cmdID is the command ID which corresponds to the menu item.
  // Returns TRUE

  NPPM_ADDTOOLBARICON_DEPRECATED = (NPPMSG + 41);
  // BOOL NPPM_ADDTOOLBARICON_DEPRECATED(UINT cmdID, TToolbarIcons *icon)
  // see TToolbarIcons
	// Add an icon to the toolbar.
  // DEPRECATED: use NPPM_ADDTOOLBARICON_FORDARKMODE instead
	// - CmdID is the plugin command ID which corresponds to the menu item: funcItem[X]._cmdID
	// - icon is a TToolbaIcons structure containing icon handles. 2 formats are needed: .ico & .bmp
  //   Both handles should be set so the icon will be displayed correctly if toolbar
  //   icon sets are changed by users
  // Returns TRUE

  NPPM_GETWINDOWSVERSION         = (NPPMSG + 42);
  // TWinVer NPPM_GETWINDOWSVERSION(0, 0)
  // The return value is windows version of enum TWinVer.

  NPPM_DMMGETPLUGINHWNDBYNAME    = (NPPMSG + 43);
  // HWND NPPM_DMMGETPLUGINHWNDBYNAME(const TCHAR *windowName, const TCHAR *moduleName)
  // This message returns the dialog handle corresponding to the windowName and
  // moduleName. You may need this message if you want to communicate with another
  // plugin "dockable" dialog, by knowing its name and its plugin module name.
  // if moduleName is NULL, then return value is NULL
  // if windowName is NULL, then the first found window handle which matches
  //                        with the moduleName will be returned

  NPPM_MAKECURRENTBUFFERDIRTY    = (NPPMSG + 44);
  // BOOL NPPM_MAKECURRENTBUFFERDIRTY(0, 0)
	// Make the current document dirty, aka set the save state to unsaved.
	// Returns TRUE

  NPPM_GETENABLETHEMETEXTUREFUNC = (NPPMSG + 45);
  // THEMEAPI NPPM_GETENABLETHEMETEXTUREFUNC(0, 0)
	// Get "EnableThemeDialogTexture" function address.
  // DEPRECATED: plugin can use EnableThemeDialogTexture directly from uxtheme.h instead
	// Returns a proc address or NULL

  NPPM_GETPLUGINSCONFIGDIR       = (NPPMSG + 46);
  // INT NPPM_GETPLUGINSCONFIGDIR(int strLen, TCHAR *str)
	// Get user's plugin config directory path.
	// - strLen is length of  allocated buffer in which directory path is copied
	// - str is the allocated buffere.
  // User should call this message twice:
	//   - The 1st call with "str" be NULL to get the required number of TCHAR (not including the terminating nul character)
	//   - The 2nd call to allocate "str" buffer with the 1st call's return value + 1, then call it again to get the path
	// Return value:
  //   - The 1st call - the number of TCHAR to copy.
	//   - The 2nd call - FALSE on failure, TRUE on success

  NPPM_MSGTOPLUGIN               = (NPPMSG + 47);
  // BOOL NPPM_MSGTOPLUGIN(TCHAR *destModuleName, TCommunicationInfo *info)
  // This message allows the communication between 2 plugins. For example,
  // plugin X can execute a command of plugin Y if plugin X knows the command ID
  // and the file name of plugin Y. destModuleName is the complete module name
  // (with the extesion .dll) of plugin Y.
  // The returned value is TRUE if Notepad++ found the plugin by its module name
  // (destModuleName), and pass the info (TCommunicationInfo) to the module.
  // The returned value is FALSE if no plugin with such name is found or if
  // destModule or info is NULL
  // see TCommunicationInfo

  NPPM_MENUCOMMAND               = (NPPMSG + 48);
  // BOOL NPPM_MENUCOMMAND(int param, UINT cmdID)
  // This message allows plugins to call all the Notepad++ menu commands.
  // See the command symbols defined in "NppMenuCmdID.pas" file
  // to access all the Notepad++ menu command items
  // Returns TRUE

  NPPM_TRIGGERTABBARCONTEXTMENU  = (NPPMSG + 49);
  // BOOL NPPM_TRIGGERTABBARCONTEXTMENU(INT view, INT index2Activate)
  // This message switches to iView (MAIN_VIEW or SUB_VIEW) as current view,
  // and to index2Activate from the current document. Finally it triggers the
  // tabbar context menu for the current document.
  // Returns TRUE

  NPPM_GETNPPVERSION             = (NPPMSG + 50);
  // INT NPPM_GETNPPVERSION(BOOL ADD_ZERO_PADDING, 0)
  // You can get Notepad++ version via this message. The return value is made up
  // of 2 parts: the major version (high word) and the minor version (low word).
  // Note that this message is supported by the v4.7 or higher version. Earlier
  // versions return 0.
  //
  // ADD_ZERO_PADDING == TRUE
  //
  // version  | HIWORD | LOWORD
  //------------------------------
  // 8.9.6.4  | 8      | 964
  // 9        | 9      | 0
  // 6.9      | 6      | 900
  // 6.6.6    | 6      | 660
  // 13.6.6.6 | 13     | 666
  //
  //
  // ADD_ZERO_PADDING == FALSE
  //
  // version  | HIWORD | LOWORD
  //------------------------------
  // 8.9.6.4  | 8      | 964
  // 9        | 9      | 0
  // 6.9      | 6      | 9
  // 6.6.6    | 6      | 66
  // 13.6.6.6 | 13     | 666

  NPPM_HIDETABBAR                = (NPPMSG + 51);
  // BOOL NPPM_HIDETABBAR(0, BOOL hideOrNot)
  // if hideOrNot is set as TRUE then tab bar will be hidden
  // otherwise it'll be shown.
  // return value : the old status value

  NPPM_ISTABBARHIDDEN            = (NPPMSG + 52);
  // BOOL NPPM_ISTABBARHIDDEN(0, 0)
  // By sending this message, a plugin is able to tell the current status of
  // tabbar from the returned value:
  //   TRUE if tab bar is hidden
  //   otherwise FALSE

  NPPM_GETPOSFROMBUFFERID        = (NPPMSG + 57);
  // INT NPPM_GETPOSFROMBUFFERID(UINT_PTR bufferID, INT priorityView)
  // Return VIEW|INDEX from a buffer ID. -1 if the bufferID non existing.
  // If priorityView set to SUB_VIEW, then SUB_VIEW will be search firstly.
  // VIEW takes 2 highest bits and INDEX (0 based) takes the rest (30 bits)
  // Possible values for view:
  //   MAIN_VIEW 0
  //   SUB_VIEW  1

  NPPM_GETFULLPATHFROMBUFFERID   = (NPPMSG + 58);
  // INT NPPM_GETFULLPATHFROMBUFFERID(UINT_PTR bufferID, TCHAR *fullFilePath)
  // Get full path file name from a bufferID.
  // Returns -1 if the bufferID not exists, otherwise the number of TCHAR
  // copied/to copy
  // User should call it with fullFilePath be NULL to get the number of TCHAR
  // (not including the nul character), allocate fullFilePath with the return
  // values + 1, then call it again to get full path file name

  NPPM_GETBUFFERIDFROMPOS        = (NPPMSG + 59);
  // UINT_PTR NPPM_GETBUFFERIDFROMPOS(INT index, INT iView)
  // index: Position of document
  // iView: View to use, 0 = Main, 1 = Secondary
  // Returns 0 if invalid, otherwise bufferID

  NPPM_GETCURRENTBUFFERID        = (NPPMSG + 60);
  // UINT_PTR NPPM_GETCURRENTBUFFERID(0, 0)
  // Returns active document BufferID

  NPPM_RELOADBUFFERID            = (NPPMSG + 61);
  // BOOL NPPM_RELOADBUFFERID(UINT_PTR bufferID, BOOL alert)
  // Reloads Buffer
  // wParam: Buffer to reload
  // lParam: 0 if no alert, else alert
	// Returns TRUE on success, FALSE otherwise

  NPPM_GETBUFFERLANGTYPE         = (NPPMSG + 64);
  // INT NPPM_GETBUFFERLANGTYPE(UINT_PTR bufferID, 0)
  // wParam: BufferID to get LangType from
  // lParam: 0
  // Returns as int, see TLangType. -1 on error

  NPPM_SETBUFFERLANGTYPE         = (NPPMSG + 65);
  // BOOL NPPM_SETBUFFERLANGTYPE(UINT_PTR bufferID, INT langType)
  // wParam: BufferID to set LangType of
  // lParam: TNppLang
  // Returns TRUE on success, FALSE otherwise
  // langType as int, see TNppLang for possible values
  // L_USER and L_EXTERNAL are not supported

  NPPM_GETBUFFERENCODING         = (NPPMSG + 66);
  // TUniMode NPPM_GETBUFFERENCODING(UINT_PTR bufferID, 0)
	// Get encoding from the document with the given bufferID
	// - BufferID is the BufferID of the document to get encoding from
	// Returns -1 on error, otherwise UniMode, see TUniMode

  NPPM_SETBUFFERENCODING         = (NPPMSG + 67);
  // BOOL NPPM_SETBUFFERENCODING(UINT_PTR bufferID, INT encoding)
	// Set encoding to the document with the given bufferID
	// - bufferID is the BufferID of the document to set encoding of
	// - encoding, see UniMode value in NPPM_GETBUFFERENCODING (above)
	// Returns TRUE on success, FALSE otherwise
	// Can only be done on new, unedited files

  NPPM_GETBUFFERFORMAT                 = (NPPMSG + 68);
  // INT NPPM_GETBUFFERFORMAT(UINT_PTR bufferID, 0)
  // wParam: BufferID to get format from
  // lParam: 0
  // Returns end of line (EOL) format
  //  0: Windows EOL format
  //  1: Macintosh EOL format
  //  2: UNIX EOL format
  //  3: unknown
  //  -1 on error

  NPPM_SETBUFFERFORMAT                 = (NPPMSG + 69);
  // BOOL NPPM_SETBUFFERFORMAT(UINT_PTR bufferID, INT format)
  // wParam: BufferID to set EOL format
  // lParam: format
  // Returns TRUE on success, FALSE otherwise
  // format 0: Windows EOL format
  //        1: Macintosh EOL format
  //        2: UNIX EOL format
  //        3: unknown

  NPPM_HIDETOOLBAR                     = (NPPMSG + 70);
  // BOOL NPPM_HIDETOOLBAR(0, BOOL hideOrNot)
  // if hideOrNot is set as TRUE then toolbar will be hidden
  // otherwise it'll be shown.
  // return value : the old status value

  NPPM_ISTOOLBARHIDDEN                 = (NPPMSG + 71);
  // BOOL NPPM_ISTOOLBARHIDDEN(0, 0)
  // By sending this message, a plugin is able to tell the current status of
  // toolbar from the returned value:
  //   TRUE if tool bar is hidden,
  //   otherwise FALSE

  NPPM_HIDEMENU                        = (NPPMSG + 72);
  // BOOL NPPM_HIDEMENU(0, BOOL hideOrNot)
  // if hideOrNot is set as TRUE then menu will be hidden
  // otherwise it'll be shown.
  // return value : the old status value

  NPPM_ISMENUHIDDEN                    = (NPPMSG + 73);
  // BOOL NPPM_ISMENUHIDDEN(0, 0)
  // By sending this message, a plugin is able to tell the current status of
  // the menu from the returned value:
  //   TRUE if menu is hidden,
  //   otherwise FALSE

  NPPM_HIDESTATUSBAR                   = (NPPMSG + 74);
  // BOOL NPPM_HIDESTATUSBAR(0, BOOL hideOrNot)
  // if hideOrNot is set as TRUE then STATUSBAR will be hidden
  // otherwise it'll be shown.
  // return value : the old status value

  NPPM_ISSTATUSBARHIDDEN               = (NPPMSG + 75);
  // BOOL NPPM_ISSTATUSBARHIDDEN(0, 0)
  // By sending this message, a plugin is able to tell the current status of
  // statusbar from the returned value:
  //   TRUE if STATUSBAR is hidden,
  //   otherwise FALSE

  NPPM_GETSHORTCUTBYCMDID              = (NPPMSG + 76);
  // BOOL NPPM_GETSHORTCUTBYCMDID(UINT cmdID, ShortcutKey *sk)
  // get your plugin command current mapped shortcut into sk via cmdID
  // You may need it after getting NPPN_READY notification
  // returned value:
  //   TRUE if this function call is successful and shortcut is enable,
  //   otherwise FALSE

  NPPM_DOOPEN                          = (NPPMSG + 77);
  // BOOL NPPM_DOOPEN(0, const TCHAR *fullPathName2Open)
  // fullPathName2Open indicates the full file path name to be opened.
  // The return value is TRUE (1) if the operation is successful, otherwise FALSE (0).

  NPPM_SAVECURRENTFILEAS               = (NPPMSG + 78);
  // BOOL NPPM_SAVECURRENTFILEAS(BOOL asCopy, const TCHAR *filename)
  // Performs a Save As (asCopy == 0) or Save a Copy As (asCopy == 1) on the
  // current buffer, outputting to filename.

  NPPM_GETCURRENTNATIVELANGENCODING   = (NPPMSG + 79);
  // INT NPPM_GETCURRENTNATIVELANGENCODING(0, 0)
  // Returns the code page associated with the current localisation of Notepad++.
  // As of v6.6.6, returned values are 1252 (ISO 8859-1), 437 (OEM US) or 950 (Big5).

  NPPM_ALLOCATESUPPORTED               = (NPPMSG + 80);
  // BOOL NPPM_ALLOCATESUPPORTED(0, 0)
  // returns TRUE if NPPM_ALLOCATECMDID is supported
  // Use to identify if subclassing is necessary
	// DEPRECATED: the message has been made (since 2010 AD) for checking if
  // NPPM_ALLOCATECMDID is supported. This message is no more needed.

  NPPM_ALLOCATECMDID                   = (NPPMSG + 81);
  // BOOL NPPM_ALLOCATECMDID(INT numberRequested, UINT *startNumber)
  // Allows a plugin to obtain a number of consecutive menu item IDs for creating
  // menus dynamically, with the guarantee of these IDs not clashing with any
  // other plugin. Sets startNumber to the initial command ID if successful and
  // to 0 if unsuccessful.
  // Returns: TRUE if successful, FALSE otherwise.

  NPPM_ALLOCATEMARKER                  = (NPPMSG + 82);
  // BOOL NPPM_ALLOCATEMARKER(INT numberRequested, INT *startNumber)
  // Allows a plugin to obtain a number of consecutive marker IDs dynamically,
  // with the guarantee of these IDs not clashing with any other plugin.
  // Usefull if a plugin needs to add a marker on Notepad++'s Scintilla marker margin.
  // Sets startNumber to the initial command ID if successful and to 0 if unsuccessful.
  // Returns: TRUE if successful, FALSE otherwise.

  NPPM_GETLANGUAGENAME                 = (NPPMSG + 83);
  // INT NPPM_GETLANGUAGENAME(INT langType, TCHAR *langName)
  // Get programming language name from the given language type (LangType)
  // Return value is the number of copied character / number of character to copy (\0 is not included)
  // You should call this function 2 times - the first time you pass langName as NULL to get the number of characters to copy.
  // You allocate a buffer of the length of (the number of characters + 1) then call NPPM_GETLANGUAGENAME function the 2nd time
  // by passing allocated buffer as argument langName

  NPPM_GETLANGUAGEDESC                 = (NPPMSG + 84);
  // INT NPPM_GETLANGUAGEDESC(INT langType, TCHAR *langDesc)
  // Get programming language short description from the given language type (LangType)
  // Return value is the number of copied character / number of character to copy (\0 is not included)
  // You should call this function 2 times - the first time you pass langDesc as NULL to get the number of characters to copy.
  // You allocate a buffer of the length of (the number of characters + 1) then call NPPM_GETLANGUAGEDESC function the 2nd time
  // by passing allocated buffer as argument langDesc

  NPPM_SHOWDOCLIST                     = (NPPMSG + 85);
  // VOID NPPM_ISDOCSWITCHERSHOWN(0, BOOL toShowOrNot)
  // Send this message to show or hide doc switcher.
  // if toShowOrNot is TRUE then show doc switcher, otherwise hide it.

  NPPM_ISDOCLISTSHOWN                  = (NPPMSG + 86);
  // BOOL NPPM_ISDOCSWITCHERSHOWN(0, 0)
  // Check to see if doc switcher is shown.

  NPPM_GETAPPDATAPLUGINSALLOWED        = (NPPMSG + 87);
  // BOOL NPPM_GETAPPDATAPLUGINSALLOWED(0, 0)
  // Prior v7.6: Check to see if loading plugins from "%APPDATA%\Notepad++\plugins" is allowed.
  // Since v7.6: Check to see if loading plugins from "%LOCALAPPDATA%\Notepad++\plugins" is allowed.
  //             If file doLocalConf.xml is present and Npp directory is NOT under %ProgramFiles% no, else yes

  NPPM_GETCURRENTVIEW                  = (NPPMSG + 88);
  // INT NPPM_GETCURRENTVIEW(0, 0)
  // Return: current edit view of Notepad++.
  // Only 2 possible values: 0 = Main, 1 = Secondary

  NPPM_DOCLISTDISABLEEXTCOLUMN         = (NPPMSG + 89);
  // BOOL NPPM_DOCLISTDISABLEEXTCOLUMN(0, BOOL disableOrNot)
  // Disable or enable extension column of doc switcher
  // Returns TRUE

  NPPM_GETEDITORDEFAULTFOREGROUNDCOLOR = (NPPMSG + 90);
  // INT NPPM_GETEDITORDEFAULTFOREGROUNDCOLOR(0, 0)
	// Returns the foreground color as integer with hex format being 0x00bbggrr
  // You should convert the returned value in COLORREF

  NPPM_GETEDITORDEFAULTBACKGROUNDCOLOR = (NPPMSG + 91);
  // INT NPPM_GETEDITORDEFAULTBACKGROUNDCOLOR(0, 0)
	// Returns the background color as integer with hex format being 0x00bbggrr
  // You should convert the returned value in COLORREF

  NPPM_SETSMOOTHFONT                   = (NPPMSG + 92);
  // BOOL NPPM_SETSMOOTHFONT(0, BOOL setSmoothFontOrNot)
	// Set (or remove) smooth font. The API uses underlying Scintilla
  // command SCI_SETFONTQUALITY to manage the font quality.
  // Returns TRUE

  NPPM_SETEDITORBORDEREDGE             = (NPPMSG + 93);
  // BOOL NPPM_SETEDITORBORDEREDGE(0, BOOL withEditorBorderEdgeOrNot)
	// Add (or remove) an additional sunken edge style to the Scintilla window
  // Returns TRUE

  NPPM_SAVEFILE                        = (NPPMSG + 94);
  // BOOL NPPM_SAVEFILE(0, const TCHAR *fileNameToSave)
	// Save the file (opened in Notepad++) with the given full file name path.
	// Returns TRUE on success, FALSE on fileNameToSave is not found

  NPPM_DISABLEAUTOUPDATE               = (NPPMSG + 95);
  // BOOL NPPM_DISABLEAUTOUPDATE(0, 0)
	// Disable Notepad++ auto-update.
  // Returns TRUE

  NPPM_REMOVESHORTCUTBYCMDID           = (NPPMSG + 96);
  // BOOL NPPM_REMOVESHORTCUTASSIGNMENT(UINT cmdID, 0)
  // removes the assigned shortcut mapped to cmdID
  // returned value: TRUE if function call is successful, otherwise FALSE
  // Introduced in v7.5.9

  NPPM_GETPLUGINHOMEPATH               = (NPPMSG + 97);
  // INT NPPM_GETPLUGINHOMEPATH(size_t strLen, TCHAR *pluginRootPath)
  // Get plugin home root path. It's useful if plugins want to get its own path
  // by appending <pluginFolderName> which is the name of plugin without extension part.
  // Returns the number of TCHAR copied/to copy.
  // Users should call it with pluginRootPath be NULL to get the required number of TCHAR
  // (not including the terminating nul character), allocate pluginRootPath buffer with
  // the return value + 1, then call it again to get the path.
  // Introduced in v7.6

  NPPM_GETSETTINGSONCLOUDPATH          = (NPPMSG + 98);
  // INT NPPM_GETSETTINGSCLOUDPATH(size_t strLen, TCHAR *settingsOnCloudPath)
  // Get settings on cloud path. It's useful if plugins want to store its settings on Cloud, if this path is set.
  // Returns the number of TCHAR copied/to copy. If the return value is 0, then this path is not set, or the "strLen" is not enough to copy the path.
  // Users should call it with settingsCloudPath be NULL to get the required number of TCHAR (not including the terminating nul character),
  // allocate settingsCloudPath buffer with the return value + 1, then call it again to get the path.
  // Introduced in v7.9.2

  NPPM_SETLINENUMBERWIDTHMODE          = (NPPMSG + 99);
    LINENUMWIDTH_DYNAMIC  = 0;
    LINENUMWIDTH_CONSTANT = 1;
  // BOOL NPPM_SETLINENUMBERWIDTHMODE(0, INT widthMode)
  // Set line number margin width in dynamic width mode (LINENUMWIDTH_DYNAMIC) or constant width mode (LINENUMWIDTH_CONSTANT)
  // It may help some plugins to disable non-dynamic line number margins width to have a smoothly visual effect while vertical scrolling the content in Notepad++
  // If calling is successful return TRUE, otherwise return FALSE.
  // Introduced in v7.9.2

  NPPM_GETLINENUMBERWIDTHMODE          = (NPPMSG + 100);
  // INT NPPM_GETLINENUMBERWIDTHMODE(0, 0)
  // Get line number margin width in dynamic width mode (LINENUMWIDTH_DYNAMIC) or constant width mode (LINENUMWIDTH_CONSTANT)
  // Introduced in v7.9.2

  NPPM_ADDTOOLBARICON_FORDARKMODE      = (NPPMSG + 101);
  // Use NPPM_ADDTOOLBARICON_FORDARKMODE instead obsolete NPPM_ADDTOOLBARICON which doesn't support the dark mode
  // void NPPM_ADDTOOLBARICON_FORDARKMODE(UINT cmdID, TToolbarIconsWithDarkMode iconHandles)
  // see TToolbarIconsWithDarkMode
  // 2 formats / 3 icons are needed:  1 * BMP + 2 * ICO
  // All 3 handles below should be set so the icon will be displayed correctly if toolbar icon sets are changed by users, also in dark mode
  // Introduced in v8.0

  NPPM_DOCLISTDISABLEPATHCOLUMN        = (NPPMSG + 102);
  // BOOL NPPM_DOCLISTDISABLEPATHCOLUMN(0, BOOL disableOrNot)
  // Disable or enable path column of Document List
  // Returns TRUE
  // Introduced in v8.1.5

  NPPM_GETEXTERNALLEXERAUTOINDENTMODE  = (NPPMSG + 103);
  // BOOL NPPM_GETEXTERNALLEXERAUTOINDENTMODE(const TCHAR *languageName, TExternalLexerAutoIndentMode *autoIndentMode)
  // Get TExternalLexerAutoIndentMode for an installed external programming language.
  // - Standard means Notepad++ will keep the same TAB indentation between lines;
  // - C_Like means Notepad++ will perform a C-Language style indentation for the selected external language;
  // - Custom means a Plugin will be controlling auto-indentation for the current language.
  // returned values: TRUE for successful searches, otherwise FALSE.
  // Introduced in v8.3.3

  NPPM_SETEXTERNALLEXERAUTOINDENTMODE  = (NPPMSG + 104);
  // BOOL NPPM_SETEXTERNALLEXERAUTOINDENTMODE(const TCHAR *languageName, TExternalLexerAutoIndentMode autoIndentMode)
  // Set TExternalLexerAutoIndentMode for an installed external programming language.
  // - Standard means Notepad++ will keep the same TAB indentation between lines;
  // - C_Like means Notepad++ will perform a C-Language style indentation for the selected external language;
  // - Custom means a Plugin will be controlling auto-indentation for the current language.
  // returned value: TRUE if function call was successful, otherwise FALSE.
  // Introduced in v8.3.3

  NPPM_ISAUTOINDENTON                  = (NPPMSG + 105);
  // BOOL NPPM_ISAUTOINDENTON(0, 0)
  // Returns the current Use Auto-Indentation setting in Notepad++ Preferences.
  // Introduced in v8.3.3

  NPPM_GETCURRENTMACROSTATUS           = (NPPMSG + 106);
  // TMacroStatus NPPM_GETCURRENTMACROSTATUS(0, 0)
  // Gets current TMacroStatus. Idle means macro is not in use and it's empty
  // Introduced in v8.3.3

  NPPM_ISDARKMODEENABLED               = (NPPMSG + 107);
  // bool NPPM_ISDARKMODEENABLED(0, 0)
  // Returns true when Notepad++ Dark Mode is enable, false when it is not.
  // Introduced in v8.4.1

  NPPM_GETDARKMODECOLORS               = (NPPMSG + 108);
  // bool NPPM_GETDARKMODECOLORS(size_t cbSize, TNppDarkModeColors *returnColors)
  // - cbSize must be filled with sizeof(TNppDarkModeColors).
  // - returnColors must be a pre-allocated TNppDarkModeColors struct.
  // Returns true when successful, false otherwise.
  // Introduced in v8.4.1

  NPPM_GETCURRENTCMDLINE               = (NPPMSG + 109);
  // INT NPPM_GETCURRENTCMDLINE(size_t strLen, TCHAR *commandLineStr)
  // Get the Current Command Line string.
  // Returns the number of TCHAR copied/to copy.
  // Users should call it with commandLineStr as NULL to get the required number of TCHAR (not including the terminating nul character),
  // allocate commandLineStr buffer with the return value + 1, then call it again to get the current command line string.
  // Introduced in v8.4.2

  NPPM_CREATELEXER                     = (NPPMSG + 110);
  // void* NPPN_CREATELEXER(0, const TCHAR *lexer_name)
	// Get the ILexer pointer created by Lexilla. Call the lexilla "CreateLexer()"
  // function to allow plugins to set the lexer for a Scintilla instance created
  // by NPPM_CREATESCINTILLAHANDLE.
	// - lexer_name is the name of the lexer
	// Returns the ILexer pointer
  // Introduced in v8.4.3

  NPPM_GETBOOKMARKID                   = (NPPMSG + 111);
  // void* NPPM_GETBOOKMARKID(0, 0)
	// Get the bookmark ID - use this API to get bookmark ID dynamically that
  // guarantees you get always the right bookmark ID even it's been changed
  // through different versions of Scintilla.
	// Returns bookmark ID
  // Introduced in v8.4.7

	NPPM_DARKMODESUBCLASSANDTHEME        = (NPPMSG + 112);
	// ULONG NPPM_DARKMODESUBCLASSANDTHEME(ULONG dmFlags, HWND hwnd)
	// Add support for generic dark mode to plugin dialog. Subclassing is applied automatically unless DWS_USEOWNDARKMODE flag is used.
	// Might not work properly in C# plugins.
	// - dmFlags has 2 possible value dmfInit (0x0000000BUL) and dmfHandleChange (0x0000000CUL)
	// - hwnd is the dialog handle of plugin. Docking panels don't need to call NPPM_DARKMODESUBCLASSANDTHEME
	// Returns succesful combinations of flags.
  // Introduced in v8.5.4

	NPPM_ALLOCATEINDICATOR               = (NPPMSG + 113);
	// BOOL NPPM_ALLOCATEINDICATOR(int numberRequested, int* startNumber)
	// Allocates an indicator number to a plugin: if a plugin needs to add an indicator,
	// it has to use this message to get the indicator number, in order to prevent a conflict with other plugins.
	// - numberRequested is the number of indicators you request for reservation
	// - startNumber will be set to the initial command ID if successful
	// Returns TRUE if successful, FALSE otherwise. startNumber will also be set to 0 if unsuccessful
  // Introduced in v8.5.6
	//
	// Example: If a plugin needs 1 indicator ID, the following code can be used :
	//
	//    int idBegin;
	//    BOOL isAllocatedSuccessful = ::SendMessage(nppData._nppHandle, NPPM_ALLOCATEINDICATOR, 1, &idBegin);
	//
	// If isAllocatedSuccessful is TRUE and value of idBegin is 7,
	// then indicator ID 7 is preserved by Notepad++ and it is safe to be used by the plugin.

	NPPM_GETTABCOLORID                   = (NPPMSG + 114);
	// int NPPM_GETTABCOLORID(int view, int tabIndex)
	// Get the tab color ID with given tab index and view.
	// wParam[in]: view - main view (0) or sub-view (1) or -1 (active view)
	// lParam[in]: tabIndex - index (in the view indicated above). -1 for currently active tab
	// Returns tab color ID which contains the following values: 0 (yellow), 1 (green), 2 (blue), 3 (orange), 4 (pink) or -1 (no color)
	// Note: there's no symetric command NPPM_SETTABCOLORID. Plugins can use NPPM_MENUCOMMAND to set current tab color with the desired tab color ID.
  // Introduced in v8.6.8
    ACTIVE_VIEW      = -1;
    ACTIVE_TAB       = -1;

    TABCOLOR_NOCOLOR = -1;
    TABCOLOR_YELLOW  = 0;
    TABCOLOR_GREEN   = 1;
    TABCOLOR_BLUE    = 2;
    TABCOLOR_ORANGE  = 3;
    TABCOLOR_PINK    = 4;



  // ---------------------------------------------------------------------------
  // Unknown purpose
  // ---------------------------------------------------------------------------
  SCINTILLA_USER           = (WM_USER + 2000);


  // ---------------------------------------------------------------------------
  // Notepad++ command messages for loaded files
  // ---------------------------------------------------------------------------
  RUNCOMMAND_USER          = (WM_USER + 3000);

    VAR_NOT_RECOGNIZED  = 0;
    FULL_CURRENT_PATH   = 1;
    CURRENT_DIRECTORY   = 2;
    FILE_NAME           = 3;
    NAME_PART           = 4;
    EXT_PART            = 5;
    CURRENT_WORD        = 6;
    NPP_DIRECTORY       = 7;
    CURRENT_LINE        = 8;
    CURRENT_COLUMN      = 9;
    NPP_FULL_FILE_PATH  = 10;
    GETFILENAMEATCURSOR = 11;
    CURRENT_LINESTR     = 12;

  // BOOL NPPM_GETXXXXXXXXXXXXXXXX(size_t strLen, TCHAR *str)
  // where str is the allocated TCHAR array,
  //       strLen is the allocated array size
  // The return value is TRUE when get generic_string operation success
  // Otherwise (allocated array size is too small) FALSE

  NPPM_GETFULLCURRENTPATH  = (RUNCOMMAND_USER + FULL_CURRENT_PATH);
  NPPM_GETCURRENTDIRECTORY = (RUNCOMMAND_USER + CURRENT_DIRECTORY);
  NPPM_GETFILENAME         = (RUNCOMMAND_USER + FILE_NAME);
  NPPM_GETNAMEPART         = (RUNCOMMAND_USER + NAME_PART);
  NPPM_GETEXTPART          = (RUNCOMMAND_USER + EXT_PART);

  NPPM_GETCURRENTWORD      = (RUNCOMMAND_USER + CURRENT_WORD);
  NPPM_GETFILENAMEATCURSOR = (RUNCOMMAND_USER + GETFILENAMEATCURSOR);

  NPPM_GETCURRENTLINESTR   = (RUNCOMMAND_USER + CURRENT_LINESTR);

  NPPM_GETCURRENTLINE      = (RUNCOMMAND_USER + CURRENT_LINE);
  // INT NPPM_GETCURRENTLINE(0, 0)
  // return the caret current position line

  NPPM_GETCURRENTCOLUMN    = (RUNCOMMAND_USER + CURRENT_COLUMN);
  // INT NPPM_GETCURRENTCOLUMN(0, 0)
  // return the caret current position column

  NPPM_GETNPPDIRECTORY     = (RUNCOMMAND_USER + NPP_DIRECTORY);
  NPPM_GETNPPFULLFILEPATH  = (RUNCOMMAND_USER + NPP_FULL_FILE_PATH);


  // ---------------------------------------------------------------------------
  // Unknown purpose
  // ---------------------------------------------------------------------------
  MACRO_USER                = (WM_USER + 4000);

  WM_GETCURRENTMACROSTATUS  = (MACRO_USER + 01);
  WM_MACRODLGRUNMACRO       = (MACRO_USER + 02);


  // ---------------------------------------------------------------------------
  // Notification message codes
  // ---------------------------------------------------------------------------
  NPPN_FIRST                   = 1000;

  NPPN_READY                   = (NPPN_FIRST + 1);
  // To notify plugins that all the procedures of launchment of notepad++ are done.
  // scnNotification->nmhdr.code     = NPPN_READY;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom   = 0;

  NPPN_TBMODIFICATION          = (NPPN_FIRST + 2);
  // To notify plugins that toolbar icons can be registered
  // scnNotification->nmhdr.code     = NPPN_TBMODIFICATION;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom   = 0;

  NPPN_FILEBEFORECLOSE         = (NPPN_FIRST + 3);
  // To notify plugins that the current file is about to be closed
  // scnNotification->nmhdr.code     = NPPN_FILEBEFORECLOSE;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom   = 0;

  NPPN_FILEOPENED              = (NPPN_FIRST + 4);
  // To notify plugins that the current file is just opened
  // scnNotification->nmhdr.code     = NPPN_FILEOPENED;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom   = 0;

  NPPN_FILECLOSED              = (NPPN_FIRST + 5);
  // To notify plugins that the current file is just closed
  // scnNotification->nmhdr.code     = NPPN_FILECLOSED;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom   = 0;

  NPPN_FILEBEFOREOPEN          = (NPPN_FIRST + 6);
  // To notify plugins that the current file is about to be opened
  // scnNotification->nmhdr.code     = NPPN_FILEBEFOREOPEN;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom   = 0;

  NPPN_FILEBEFORESAVE          = (NPPN_FIRST + 7);
  // To notify plugins that the current file is about to be saved
  // scnNotification->nmhdr.code     = NPPN_FILEBEFORESAVE;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom   = 0;

  NPPN_FILESAVED               = (NPPN_FIRST + 8);
  // To notify plugins that the current file is just saved
  // scnNotification->nmhdr.code     = NPPN_FILESAVED;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom   = 0;

  NPPN_SHUTDOWN                = (NPPN_FIRST + 9);
  // To notify plugins that Notepad++ is about to be shutdowned.
  // scnNotification->nmhdr.code     = NPPN_SHUTDOWN;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom   = 0;

  NPPN_BUFFERACTIVATED         = (NPPN_FIRST + 10);
  // scnNotification->nmhdr.code = NPPN_BUFFERACTIVATED;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = activatedBufferID;

  NPPN_LANGCHANGED             = (NPPN_FIRST + 11);
  // scnNotification->nmhdr.code = NPPN_LANGCHANGED;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = currentBufferID;

  NPPN_WORDSTYLESUPDATED       = (NPPN_FIRST + 12);
  // To notify plugins that user initiated a WordStyleDlg change.
  // scnNotification->nmhdr.code = NPPN_WORDSTYLESUPDATED;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = currentBufferID;

  NPPN_SHORTCUTREMAPPED        = (NPPN_FIRST + 13);
  // To notify plugins that plugin command shortcut is remapped.
  // scnNotification->nmhdr.code = NPPN_SHORTCUTREMAPPED;
  // scnNotification->nmhdr.hwndFrom = ShortcutKeyStructurePointer;
  // scnNotification->nmhdr.idFrom = cmdID;
  // where ShortcutKeyStructurePointer is a pointer to record TShortcutKey:

  NPPN_FILEBEFORELOAD          = (NPPN_FIRST + 14);
  // To notify plugins that the current file is about to be loaded
  // scnNotification->nmhdr.code = NPPN_FILEBEFORELOAD;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = NULL;

  NPPN_FILELOADFAILED          = (NPPN_FIRST + 15);
  // To notify plugins that file open operation failed
  // scnNotification->nmhdr.code = NPPN_FILELOADFAILED;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = BufferID;

  NPPN_READONLYCHANGED         = (NPPN_FIRST + 16);
  // To notify plugins that current document change the readonly status,
  // scnNotification->nmhdr.code = NPPN_READONLYCHANGED;
  // scnNotification->nmhdr.hwndFrom = bufferID;
  // scnNotification->nmhdr.idFrom = docStatus;
  // where bufferID  is BufferID
  //       docStatus can be combined by DOCSTAUS_READONLY and DOCSTAUS_BUFFERDIRTY

    DOCSTAUS_READONLY    = 1;
    DOCSTAUS_BUFFERDIRTY = 2;

  NPPN_DOCORDERCHANGED         = (NPPN_FIRST + 17);
  // To notify plugins that document order is changed
  // scnNotification->nmhdr.code = NPPN_DOCORDERCHANGED;
  // scnNotification->nmhdr.hwndFrom = newIndex;
  // scnNotification->nmhdr.idFrom = BufferID;

  NPPN_SNAPSHOTDIRTYFILELOADED = (NPPN_FIRST + 18);
  // To notify plugins that a snapshot dirty file is loaded on startup
  // scnNotification->nmhdr.code = NPPN_SNAPSHOTDIRTYFILELOADED;
  // scnNotification->nmhdr.hwndFrom = NULL;
  // scnNotification->nmhdr.idFrom = BufferID;

  NPPN_BEFORESHUTDOWN          = (NPPN_FIRST + 19);
  // To notify plugins that Npp shutdown has been triggered, files have not been closed yet
  // scnNotification->nmhdr.code = NPPN_BEFORESHUTDOWN;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = 0;

  NPPN_CANCELSHUTDOWN          = (NPPN_FIRST + 20);
  // To notify plugins that Npp shutdown has been cancelled
  // scnNotification->nmhdr.code = NPPN_CANCELSHUTDOWN;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = 0;

  NPPN_FILEBEFORERENAME        = (NPPN_FIRST + 21);
  // To notify plugins that file is to be renamed
  // scnNotification->nmhdr.code = NPPN_FILEBEFORERENAME;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = BufferID;

  NPPN_FILERENAMECANCEL        = (NPPN_FIRST + 22);
  // To notify plugins that file rename has been cancelled
  // scnNotification->nmhdr.code = NPPN_FILERENAMECANCEL;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = BufferID;

  NPPN_FILERENAMED             = (NPPN_FIRST + 23);
  // To notify plugins that file has been renamed
  // scnNotification->nmhdr.code = NPPN_FILERENAMED;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = BufferID;

  NPPN_FILEBEFOREDELETE        = (NPPN_FIRST + 24);
  // To notify plugins that file is to be deleted
  // scnNotification->nmhdr.code = NPPN_FILEBEFOREDELETE;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = BufferID;

  NPPN_FILEDELETEFAILED        = (NPPN_FIRST + 25);
  // To notify plugins that file deletion has failed
  // scnNotification->nmhdr.code = NPPN_FILEDELETEFAILED;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = BufferID;

  NPPN_FILEDELETED             = (NPPN_FIRST + 26);
  // To notify plugins that file has been deleted
  // scnNotification->nmhdr.code = NPPN_FILEDELETED;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = BufferID;

  NPPN_DARKMODECHANGED         = (NPPN_FIRST + 27);
  // To notify plugins that Dark Mode was enabled/disabled
  // Use NPPM_ISDARKMODEENABLED to query Dark Mode status
  // scnNotification->nmhdr.code = NPPN_DARKMODECHANGED;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = 0;
  // Introduced in v8.4.1

  NPPN_CMDLINEPLUGINMSG        = (NPPN_FIRST + 28);
  // To notify plugins that the new argument for plugins (via '-pluginMessage="YOUR_PLUGIN_ARGUMENT"'
  // in command line) is available
  // scnNotification->nmhdr.code = NPPN_CMDLINEPLUGINMSG;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = pluginMessage;
  // where pluginMessage is pointer of type wchar_t
  // Introduced in v8.4.2

  NPPN_EXTERNALLEXERBUFFER     = (NPPN_FIRST + 29);
  // To notify lexer plugins that the buffer (in idFrom) is just applied to an
  // external lexer
  // scnNotification->nmhdr.code = NPPN_EXTERNALLEXERBUFFER;
  // scnNotification->nmhdr.hwndFrom = hwndNpp;
  // scnNotification->nmhdr.idFrom = BufferID;
  // Introduced in v8.5

	NPPN_GLOBALMODIFIED          = (NPPN_FIRST + 30);
  // To notify plugins that the current document is just modified by Replace All action.
  // For solving the performance issue (from v8.6.4), Notepad++ doesn't trigger SCN_MODIFIED during Replace All action anymore.
  // As a result, the plugins which monitor SCN_MODIFIED should also monitor NPPN_GLOBALMODIFIED.
	// scnNotification->nmhdr.code = NPPN_GLOBALMODIFIED;
	// scnNotification->nmhdr.hwndFrom = BufferID;
	// scnNotification->nmhdr.idFrom = 0; // preserved for future use, must be zero
  // Introduced in v8.6.5

  // ---------------------------------------------------------------------------
  // Defines for docking manager
  // ---------------------------------------------------------------------------
  // This is content provided by Damjan Zobo Cvetko and may be outdated

  // docking.h
  CONT_LEFT    = 0;
  CONT_RIGHT   = 1;
  CONT_TOP     = 2;
  CONT_BOTTOM  = 3;
  DOCKCONT_MAX = 4;

  // mask params for plugins of internal dialogs
  DWS_ICONTAB   = $00000001; // Icon for tabs are available
  DWS_ICONBAR   = $00000002; // Icon for icon bar are available (currently not supported)
  DWS_ADDINFO   = $00000004; // Additional information are in use
  DWS_PARAMSALL = $00000007;

  // default docking values for first call of plugin
  DWS_DF_CONT_LEFT   = CONT_LEFT shl 28;   // default docking on left
  DWS_DF_CONT_RIGHT  = CONT_RIGHT shl 28;  // default docking on right
  DWS_DF_CONT_TOP    = CONT_TOP shl 28;    // default docking on top
  DWS_DF_CONT_BOTTOM = CONT_BOTTOM shl 28; // default docking on bottom
  DWS_DF_FLOATING    = $80000000;          // default state is floating


  // dockingResource.h
  DMN_FIRST = 1050;

  DMN_CLOSE = (DMN_FIRST + 1); //nmhdr.code = DWORD(DMN_CLOSE, 0));
                               //nmhdr.hwndFrom = hwndNpp;
                               //nmhdr.idFrom = ctrlIdNpp;

  DMN_DOCK  = (DMN_FIRST + 2);

  DMN_FLOAT = (DMN_FIRST + 3); //nmhdr.code = DWORD(DMN_XXX, int newContainer);
                               //nmhdr.hwndFrom = hwndNpp;
                               //nmhdr.idFrom = ctrlIdNpp;


type
  // ---------------------------------------------------------------------------
  // String types
  // ---------------------------------------------------------------------------
  nppString = WideString;
  nppChar   = WChar;
  nppPChar  = PWChar;

  // ---------------------------------------------------------------------------
  // Languages enumeration, s.a. Notepad++ menu Language
  // ---------------------------------------------------------------------------
  // Don't use L_JS, use L_JAVASCRIPT instead
  TNppLang = (
    L_TEXT        , L_PHP      , L_C         , L_CPP       , L_CS          , L_OBJC      , L_JAVA   , L_RC          ,
    L_HTML        , L_XML      , L_MAKEFILE  , L_PASCAL    , L_BATCH       , L_INI       , L_ASCII  , L_USER        ,
    L_ASP         , L_SQL      , L_VB        , L_JS        , L_CSS         , L_PERL      , L_PYTHON , L_LUA         ,
    L_TEX         , L_FORTRAN  , L_BASH      , L_FLASH     , L_NSIS        , L_TCL       , L_LISP   , L_SCHEME      ,
    L_ASM         , L_DIFF     , L_PROPS     , L_PS        , L_RUBY        , L_SMALLTALK , L_VHDL   , L_KIX         ,
    L_AU3         , L_CAML     , L_ADA       , L_VERILOG   , L_MATLAB      , L_HASKELL   , L_INNO   , L_SEARCHRESULT,
    L_CMAKE       , L_YAML     , L_COBOL     , L_GUI4CLI   , L_D           , L_POWERSHELL, L_R      , L_JSP         ,
    L_COFFEESCRIPT, L_JSON     , L_JAVASCRIPT, L_FORTRAN_77, L_BAANC       , L_SREC      , L_IHEX   , L_TEHEX       ,
    L_SWIFT       , L_ASN1     , L_AVS       , L_BLITZBASIC, L_PUREBASIC   , L_FREEBASIC , L_CSOUND , L_ERLANG      ,
    L_ESCRIPT     , L_FORTH    , L_LATEX     , L_MMIXAL    , L_NIM         , L_NNCRONTAB , L_OSCRIPT, L_REBOL       ,
    L_REGISTRY    , L_RUST     , L_SPICE     , L_TXT2TAGS  , L_VISUALPROLOG, L_TYPESCRIPT, L_JSON5  , L_MSSQL       ,
    L_GDSCRIPT    , L_HOLLYWOOD, L_GOLANG    , L_RAKU      ,
    // The end of enumerated language type, so it should be always at the end
    L_EXTERNAL
  );


  // ---------------------------------------------------------------------------
  // Unicode mode enumeration
  // ---------------------------------------------------------------------------
  TUniMode = (
    uni8Bit       = 0,  // ANSI
    uniUTF8       = 1,  // UTF-8 with BOM
    uni16BE       = 2,  // UTF-16 Big Ending with BOM
    uni16LE       = 3,  // UTF-16 Little Ending with BOM
    uniCookie     = 4,  // UTF-8 without BOM
    uni7Bit       = 5,  // uni7Bit
    uni16BE_NoBOM = 6,  // UTF-16 Big Ending without BOM
    uni16LE_NoBOM = 7,  // UTF-16 Little Ending without BOM
    uniEnd
  );


  // ---------------------------------------------------------------------------
  // External lexer auto indent mode enumeration
  // ---------------------------------------------------------------------------
  TExternalLexerAutoIndentMode = (
    Standard, C_Like, Custom
  );


  // ---------------------------------------------------------------------------
  // Macro status enumeration
  // ---------------------------------------------------------------------------
  TMacroStatus = (
    Idle, RecordInProgress, RecordingStopped, PlayingBack
  );


  // ---------------------------------------------------------------------------
  // Windows version enumeration
  // ---------------------------------------------------------------------------
  TWinVer = (
    WV_UNKNOWN, WV_WIN32S, WV_95,    WV_98,   WV_ME,   WV_NT,    WV_W2K,   WV_XP,
    WV_S2003,   WV_XPX64,  WV_VISTA, WV_WIN7, WV_WIN8, WV_WIN81, WV_WIN10, WV_WIN11
  );


  // ---------------------------------------------------------------------------
  // Processor platform enumeration
  // ---------------------------------------------------------------------------
  TPlatform = (
    PF_UNKNOWN, PF_X86, PF_X64, PF_IA64, PF_ARM64
  );


  // ---------------------------------------------------------------------------
  // Support of generic dark mode for plugin dialogs
  // See NPPM_DARKMODESUBCLASSANDTHEME
  // ---------------------------------------------------------------------------
  TNppDarkMode = (
    dmfInit = $0000000B,
    dmfHandleChange = $0000000C
  );


  // ---------------------------------------------------------------------------
  // Records for data exchange Notepad++ <-> Plugin
  // ---------------------------------------------------------------------------

  // Basic infos for communication between Notepad++ and the plugin
  // This structure is sent by Npp to the plugin via SetInfo
  TNppData = record
    NppHandle             : HWND;
    ScintillaMainHandle   : HWND;
    ScintillaSecondHandle : HWND;
  end;


  // Set plugin keyboard shortcut
  PShortcutKey = ^TShortcutKey;

  TShortcutKey = record
    IsCtrl  : Boolean;
    IsAlt   : Boolean;
    IsShift : Boolean;
    Key     : nppChar;
  end;


  // Set plugin toolbar icon, deprecated since Npp v8.0
  TToolbarIcons = record
    ToolbarBmp  : HBITMAP;
    ToolbarIcon : HICON;
  end;


  // Set plugin toolbar icon, use from Npp v8.0 onwards
  TToolbarIconsWithDarkMode = record
    ToolbarBmp:          HBITMAP;  // light mode 16x16
    ToolbarIcon:         HICON;    // dark mode unfilled 16x16 or 32x32
    ToolbarIconDarkMode: HICON;    // dark mode filled 16x16 or 32x32
  end;


  TNppDarkModeColors = record
    background:       COLORREF;
    softerBackground: COLORREF;
    hotBackground:    COLORREF;
    pureBackground:   COLORREF;
    errorBackground:  COLORREF;
    text:             COLORREF;
    darkerText:       COLORREF;
    disabledText:     COLORREF;
    linkText:         COLORREF;
    edge:             COLORREF;
    hotEdge:          COLORREF;
    disabledEdge:     COLORREF;
  end;


  // Dockable dialogs
  TTbData = record
    ClientHandle   : HWND;      // dockable dialog handle
    Name           : nppPChar;  // name of plugin dialog
    DlgId          : Integer;   // index of menu entry where the dialog in question will be triggered
    Mask           : Cardinal;  // contains the behaviour informations of the dialog, can be one of the DWS_DF_... constants combined (optional) with DWS_ICONTAB, DWS_ICONBAR, DWS_ADDINFO
    IconTab        : HICON;     // handle to the icon to display on the dialog's tab
    AdditionalInfo : nppPChar;  // pointer to a string joined to the caption using " - ", if not NULL
    FloatRect      : TRect;     // internal, don't use
    PrevContainer  : Cardinal;  // internal, don't use
    ModuleName     : nppPChar;  // the name of your plugin module (with extension .dll)
  end;


  // Loading/saving sessions
  TSessionInfo = record
    SessionFilePathName : nppPChar;           // the full path name of session file to save
    NumFiles            : Integer;            // the number of files in the session
    Files               : array of nppPChar;  // session files' full path
  end;


  // Inter-plugin communication
  TCommunicationInfo = record
    internalMsg   : Cardinal;  // message-id (defined by dest-plugin)
    srcModuleName : nppPChar;  // complete module name (with extension .dll) of src-plugin
    info          : Pointer;   // pointer to block of informations to be exchanged
  end;



implementation


end.

