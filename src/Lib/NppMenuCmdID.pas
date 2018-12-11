{
    Notepad++ menu command IDs

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

unit NppMenuCmdID;


interface

const
  // ---------------------------------------------------------------------------
  // Base id for menu entries
  // ---------------------------------------------------------------------------
  IDM                                          = 40000;


  // ---------------------------------------------------------------------------
  // Menu File
  // ---------------------------------------------------------------------------
  IDM_FILE                                     = (IDM + 1000);

  IDM_FILE_NEW                                 = (IDM_FILE + 1);
  IDM_FILE_OPEN                                = (IDM_FILE + 2);

  IDM_FILE_OPEN_FOLDER                         = (IDM_FILE + 19);
  IDM_FILE_OPEN_CMD                            = (IDM_FILE + 20);

  IDM_FILE_OPEN_DEFAULT_VIEWER                 = (IDM_FILE + 23);
  IDM_FILE_OPENFOLDERASWORKSPACE               = (IDM_FILE + 22);

  IDM_FILE_RELOAD                              = (IDM_FILE + 14);

  IDM_FILE_SAVE                                = (IDM_FILE + 6);
  IDM_FILE_SAVEAS                              = (IDM_FILE + 8);
  IDM_FILE_SAVECOPYAS                          = (IDM_FILE + 15);
  IDM_FILE_SAVEALL                             = (IDM_FILE + 7);

  IDM_FILE_RENAME                              = (IDM_FILE + 17);

  IDM_FILE_CLOSE                               = (IDM_FILE + 3);
  IDM_FILE_CLOSEALL                            = (IDM_FILE + 4);
  IDM_FILE_CLOSEALL_BUT_CURRENT                = (IDM_FILE + 5);
  IDM_FILE_CLOSEALL_TOLEFT                     = (IDM_FILE + 9);
  IDM_FILE_CLOSEALL_TORIGHT                    = (IDM_FILE + 18);

  IDM_FILE_DELETE                              = (IDM_FILE + 16);

  IDM_FILE_LOADSESSION                         = (IDM_FILE + 12);
  IDM_FILE_SAVESESSION                         = (IDM_FILE + 13);

  IDM_FILE_PRINT                               = (IDM_FILE + 10);
  IDM_FILE_PRINTNOW                            = 1001;

  IDM_FILE_RESTORELASTCLOSEDFILE               = (IDM_FILE + 21);

  IDM_FILE_EXIT                                = (IDM_FILE + 11);


  // ---------------------------------------------------------------------------
  // Menu Edit
  // ---------------------------------------------------------------------------
  IDM_EDIT                                     = (IDM + 2000);

  IDM_EDIT_UNDO                                = (IDM_EDIT + 3);
  IDM_EDIT_REDO                                = (IDM_EDIT + 4);

  IDM_EDIT_CUT                                 = (IDM_EDIT + 1);
  IDM_EDIT_COPY                                = (IDM_EDIT + 2);
  IDM_EDIT_PASTE                               = (IDM_EDIT + 5);
  IDM_EDIT_DELETE                              = (IDM_EDIT + 6);
  IDM_EDIT_SELECTALL                           = (IDM_EDIT + 7);
  IDM_EDIT_BEGINENDSELECT                      = (IDM_EDIT + 20);

  IDM_EDIT_FULLPATHTOCLIP                      = (IDM_EDIT + 29);
  IDM_EDIT_FILENAMETOCLIP                      = (IDM_EDIT + 30);
  IDM_EDIT_CURRENTDIRTOCLIP                    = (IDM_EDIT + 31);

  IDM_EDIT_INS_TAB                             = (IDM_EDIT + 8);
  IDM_EDIT_RMV_TAB                             = (IDM_EDIT + 9);

  IDM_EDIT_UPPERCASE                           = (IDM_EDIT + 16);
  IDM_EDIT_LOWERCASE                           = (IDM_EDIT + 17);
  IDM_EDIT_PROPERCASE_FORCE                    = (IDM_EDIT + 67);
  IDM_EDIT_PROPERCASE_BLEND                    = (IDM_EDIT + 68);
  IDM_EDIT_SENTENCECASE_FORCE                  = (IDM_EDIT + 69);
  IDM_EDIT_SENTENCECASE_BLEND                  = (IDM_EDIT + 70);
  IDM_EDIT_INVERTCASE                          = (IDM_EDIT + 71);
  IDM_EDIT_RANDOMCASE                          = (IDM_EDIT + 72);

  IDM_EDIT_DUP_LINE                            = (IDM_EDIT + 10);
  IDM_EDIT_TRANSPOSE_LINE                      = (IDM_EDIT + 11);  // Missing
  IDM_EDIT_SPLIT_LINES                         = (IDM_EDIT + 12);
  IDM_EDIT_JOIN_LINES                          = (IDM_EDIT + 13);
  IDM_EDIT_LINE_UP                             = (IDM_EDIT + 14);
  IDM_EDIT_LINE_DOWN                           = (IDM_EDIT + 15);
  IDM_EDIT_REMOVEEMPTYLINES                    = (IDM_EDIT + 55);
  IDM_EDIT_REMOVEEMPTYLINESWITHBLANK           = (IDM_EDIT + 56);
  IDM_EDIT_BLANKLINEABOVECURRENT               = (IDM_EDIT + 57);
  IDM_EDIT_BLANKLINEBELOWCURRENT               = (IDM_EDIT + 58);

  IDM_EDIT_SORTLINES_LEXICOGRAPHIC_ASCENDING   = (IDM_EDIT + 59);
  IDM_EDIT_SORTLINES_INTEGER_ASCENDING         = (IDM_EDIT + 61);
  IDM_EDIT_SORTLINES_DECIMALCOMMA_ASCENDING    = (IDM_EDIT + 63);
  IDM_EDIT_SORTLINES_DECIMALDOT_ASCENDING      = (IDM_EDIT + 65);

  IDM_EDIT_SORTLINES_LEXICOGRAPHIC_DESCENDING  = (IDM_EDIT + 60);
  IDM_EDIT_SORTLINES_INTEGER_DESCENDING        = (IDM_EDIT + 62);
  IDM_EDIT_SORTLINES_DECIMALCOMMA_DESCENDING   = (IDM_EDIT + 64);
  IDM_EDIT_SORTLINES_DECIMALDOT_DESCENDING     = (IDM_EDIT + 66);

  IDM_EDIT_BLOCK_COMMENT                       = (IDM_EDIT + 22);
  IDM_EDIT_BLOCK_COMMENT_SET                   = (IDM_EDIT + 35);
  IDM_EDIT_BLOCK_UNCOMMENT                     = (IDM_EDIT + 36);
  IDM_EDIT_STREAM_COMMENT                      = (IDM_EDIT + 23);
  IDM_EDIT_STREAM_UNCOMMENT                    = (IDM_EDIT + 47);

  IDM_EDIT_AUTOCOMPLETE                        = (50000 + 0);
  IDM_EDIT_AUTOCOMPLETE_CURRENTFILE            = (50000 + 1);
  IDM_EDIT_FUNCCALLTIP                         = (50000 + 2);
  IDM_EDIT_AUTOCOMPLETE_PATH                   = (50000 + 6);

  IDM_EDIT_TRIMTRAILING                        = (IDM_EDIT + 24);
  IDM_EDIT_TRIMLINEHEAD                        = (IDM_EDIT + 42);
  IDM_EDIT_TRIM_BOTH                           = (IDM_EDIT + 43);
  IDM_EDIT_EOL2WS                              = (IDM_EDIT + 44);
  IDM_EDIT_TRIMALL                             = (IDM_EDIT + 45);

  IDM_EDIT_TAB2SW                              = (IDM_EDIT + 46);
  IDM_EDIT_SW2TAB_ALL                          = (IDM_EDIT + 54);
  IDM_EDIT_SW2TAB_LEADING                      = (IDM_EDIT + 53);

  IDM_EDIT_PASTE_AS_HTML                       = (IDM_EDIT + 38);
  IDM_EDIT_PASTE_AS_RTF                        = (IDM_EDIT + 39);

  IDM_EDIT_COPY_BINARY                         = (IDM_EDIT + 48);
  IDM_EDIT_CUT_BINARY                          = (IDM_EDIT + 49);
  IDM_EDIT_PASTE_BINARY                        = (IDM_EDIT + 50);

  IDM_EDIT_OPENASFILE                          = (IDM_EDIT + 73);
  IDM_EDIT_OPENINFOLDER                        = (IDM_EDIT + 74);
  IDM_EDIT_SEARCHONINTERNET                    = (IDM_EDIT + 75);
  IDM_EDIT_CHANGESEARCHENGINE                  = (IDM_EDIT + 76);

  IDM_EDIT_COLUMNMODETIP                       = (IDM_EDIT + 37);
  IDM_EDIT_COLUMNMODE                          = (IDM_EDIT + 34);
  IDM_EDIT_CHAR_PANEL                          = (IDM_EDIT + 51);
  IDM_EDIT_CLIPBOARDHISTORY_PANEL              = (IDM_EDIT + 52);

  IDM_EDIT_SETREADONLY                         = (IDM_EDIT + 28);
  IDM_EDIT_CLEARREADONLY                       = (IDM_EDIT + 33);

  // Located in menu File
  IDM_OPEN_ALL_RECENT_FILE                     = (IDM_EDIT + 40);
  IDM_CLEAN_RECENT_FILE_LIST                   = (IDM_EDIT + 41);

  // Located in menu View
  IDM_EDIT_RTL                                 = (IDM_EDIT + 26);
  IDM_EDIT_LTR                                 = (IDM_EDIT + 27);

  // Located in menu Macro
  IDM_MACRO_STARTRECORDINGMACRO                = (IDM_EDIT + 18);
  IDM_MACRO_STOPRECORDINGMACRO                 = (IDM_EDIT + 19);
  IDM_MACRO_PLAYBACKRECORDEDMACRO              = (IDM_EDIT + 21);
  IDM_MACRO_SAVECURRENTMACRO                   = (IDM_EDIT + 25);
  IDM_MACRO_RUNMULTIMACRODLG                   = (IDM_EDIT + 32);


  // ---------------------------------------------------------------------------
  // Menu Search
  // ---------------------------------------------------------------------------
  IDM_SEARCH                                   = (IDM + 3000);

  IDM_SEARCH_FIND                              = (IDM_SEARCH + 1);
  IDM_SEARCH_FINDINFILES                       = (IDM_SEARCH + 13);
  IDM_SEARCH_FINDNEXT                          = (IDM_SEARCH + 2);
  IDM_SEARCH_FINDPREV                          = (IDM_SEARCH + 10);

  IDM_SEARCH_SETANDFINDNEXT                    = (IDM_SEARCH + 48);
  IDM_SEARCH_SETANDFINDPREV                    = (IDM_SEARCH + 49);
  IDM_SEARCH_VOLATILE_FINDNEXT                 = (IDM_SEARCH + 14);
  IDM_SEARCH_VOLATILE_FINDPREV                 = (IDM_SEARCH + 15);

  IDM_SEARCH_REPLACE                           = (IDM_SEARCH + 3);

  IDM_SEARCH_FINDINCREMENT                     = (IDM_SEARCH + 11);

  IDM_FOCUS_ON_FOUND_RESULTS                   = (IDM_SEARCH + 45);

  IDM_SEARCH_GOTONEXTFOUND	                   = (IDM_SEARCH + 46);
  IDM_SEARCH_GOTOPREVFOUND	                   = (IDM_SEARCH + 47);
  IDM_SEARCH_GOTOLINE                          = (IDM_SEARCH + 4);

  IDM_SEARCH_GOTOMATCHINGBRACE                 = (IDM_SEARCH + 9);
  IDM_SEARCH_SELECTMATCHINGBRACES              = (IDM_SEARCH + 53);

  IDM_SEARCH_MARK                              = (IDM_SEARCH + 54);

  IDM_SEARCH_MARKALLEXT1                       = (IDM_SEARCH + 22);
  IDM_SEARCH_MARKALLEXT2                       = (IDM_SEARCH + 24);
  IDM_SEARCH_MARKALLEXT3                       = (IDM_SEARCH + 26);
  IDM_SEARCH_MARKALLEXT4                       = (IDM_SEARCH + 28);
  IDM_SEARCH_MARKALLEXT5                       = (IDM_SEARCH + 30);

  IDM_SEARCH_UNMARKALLEXT1                     = (IDM_SEARCH + 23);
  IDM_SEARCH_UNMARKALLEXT2                     = (IDM_SEARCH + 25);
  IDM_SEARCH_UNMARKALLEXT3                     = (IDM_SEARCH + 27);
  IDM_SEARCH_UNMARKALLEXT4                     = (IDM_SEARCH + 29);
  IDM_SEARCH_UNMARKALLEXT5                     = (IDM_SEARCH + 31);
  IDM_SEARCH_CLEARALLMARKS                     = (IDM_SEARCH + 32);

  IDM_SEARCH_GOPREVMARKER1                     = (IDM_SEARCH + 33);
  IDM_SEARCH_GOPREVMARKER2                     = (IDM_SEARCH + 34);
  IDM_SEARCH_GOPREVMARKER3                     = (IDM_SEARCH + 35);
  IDM_SEARCH_GOPREVMARKER4                     = (IDM_SEARCH + 36);
  IDM_SEARCH_GOPREVMARKER5                     = (IDM_SEARCH + 37);
  IDM_SEARCH_GOPREVMARKER_DEF                  = (IDM_SEARCH + 38);

  IDM_SEARCH_GONEXTMARKER1                     = (IDM_SEARCH + 39);
  IDM_SEARCH_GONEXTMARKER2                     = (IDM_SEARCH + 40);
  IDM_SEARCH_GONEXTMARKER3                     = (IDM_SEARCH + 41);
  IDM_SEARCH_GONEXTMARKER4                     = (IDM_SEARCH + 42);
  IDM_SEARCH_GONEXTMARKER5                     = (IDM_SEARCH + 43);
  IDM_SEARCH_GONEXTMARKER_DEF                  = (IDM_SEARCH + 44);

  IDM_SEARCH_TOGGLE_BOOKMARK                   = (IDM_SEARCH + 5);
  IDM_SEARCH_NEXT_BOOKMARK                     = (IDM_SEARCH + 6);
  IDM_SEARCH_PREV_BOOKMARK                     = (IDM_SEARCH + 7);
  IDM_SEARCH_CLEAR_BOOKMARKS                   = (IDM_SEARCH + 8);

  IDM_SEARCH_CUTMARKEDLINES                    = (IDM_SEARCH + 18);
  IDM_SEARCH_COPYMARKEDLINES                   = (IDM_SEARCH + 19);
  IDM_SEARCH_PASTEMARKEDLINES                  = (IDM_SEARCH + 20);

  IDM_SEARCH_DELETEMARKEDLINES                 = (IDM_SEARCH + 21);
  IDM_SEARCH_DELETEUNMARKEDLINES               = (IDM_SEARCH + 51);

  IDM_SEARCH_INVERSEMARKS                      = (IDM_SEARCH + 50);

  IDM_SEARCH_FINDCHARINRANGE                   = (IDM_SEARCH + 52);


  // ---------------------------------------------------------------------------
  // Menu View
  // ---------------------------------------------------------------------------
  IDM_VIEW                                     = (IDM + 4000);

  IDM_VIEW_ALWAYSONTOP                         = (IDM_VIEW + 34);
  IDM_VIEW_FULLSCREENTOGGLE                    = (IDM_VIEW + 32);
  IDM_VIEW_POSTIT                              = (IDM_VIEW + 9);

  IDM_VIEW_TAB_SPACE                           = (IDM_VIEW + 25);
  IDM_VIEW_EOL                                 = (IDM_VIEW + 26);
  IDM_VIEW_ALL_CHARACTERS                      = (IDM_VIEW + 19);
  IDM_VIEW_INDENT_GUIDE                        = (IDM_VIEW + 20);
  IDM_VIEW_WRAP_SYMBOL                         = (IDM_VIEW + 41);

  IDM_VIEW_ZOOMIN                              = (IDM_VIEW + 23);
  IDM_VIEW_ZOOMOUT                             = (IDM_VIEW + 24);
  IDM_VIEW_ZOOMRESTORE                         = (IDM_VIEW + 33);

  IDM_VIEW_GOTO_ANOTHER_VIEW                   = 10001;
  IDM_VIEW_CLONE_TO_ANOTHER_VIEW               = 10002;
  IDM_VIEW_GOTO_NEW_INSTANCE                   = 10003;
  IDM_VIEW_LOAD_IN_NEW_INSTANCE                = 10004;

  IDM_VIEW_TAB1                                = (IDM_VIEW + 86);
  IDM_VIEW_TAB2                                = (IDM_VIEW + 87);
  IDM_VIEW_TAB3                                = (IDM_VIEW + 88);
  IDM_VIEW_TAB4                                = (IDM_VIEW + 89);
  IDM_VIEW_TAB5                                = (IDM_VIEW + 90);
  IDM_VIEW_TAB6                                = (IDM_VIEW + 91);
  IDM_VIEW_TAB7                                = (IDM_VIEW + 92);
  IDM_VIEW_TAB8                                = (IDM_VIEW + 93);
  IDM_VIEW_TAB9                                = (IDM_VIEW + 94);
  IDM_VIEW_TAB_NEXT                            = (IDM_VIEW + 95);
  IDM_VIEW_TAB_PREV                            = (IDM_VIEW + 96);
  IDM_VIEW_TAB_MOVEFORWARD                     = (IDM_VIEW + 98);
  IDM_VIEW_TAB_MOVEBACKWARD                    = (IDM_VIEW + 99);

  IDM_VIEW_WRAP                                = (IDM_VIEW + 22);
  IDM_VIEW_SWITCHTO_OTHER_VIEW                 = (IDM_VIEW + 72);
  IDM_VIEW_HIDELINES                           = (IDM_VIEW + 42);

  IDM_VIEW_TOGGLE_FOLDALL                      = (IDM_VIEW + 10);
  IDM_VIEW_TOGGLE_UNFOLDALL                    = (IDM_VIEW + 29);
  IDM_VIEW_FOLD_CURRENT                        = (IDM_VIEW + 30);
  IDM_VIEW_UNFOLD_CURRENT                      = (IDM_VIEW + 31);

  IDM_VIEW_FOLD                                = (IDM_VIEW + 50);
  IDM_VIEW_FOLD_1                              = (IDM_VIEW_FOLD + 1);
  IDM_VIEW_FOLD_2                              = (IDM_VIEW_FOLD + 2);
  IDM_VIEW_FOLD_3                              = (IDM_VIEW_FOLD + 3);
  IDM_VIEW_FOLD_4                              = (IDM_VIEW_FOLD + 4);
  IDM_VIEW_FOLD_5                              = (IDM_VIEW_FOLD + 5);
  IDM_VIEW_FOLD_6                              = (IDM_VIEW_FOLD + 6);
  IDM_VIEW_FOLD_7                              = (IDM_VIEW_FOLD + 7);
  IDM_VIEW_FOLD_8                              = (IDM_VIEW_FOLD + 8);

  IDM_VIEW_UNFOLD                              = (IDM_VIEW + 60);
  IDM_VIEW_UNFOLD_1                            = (IDM_VIEW_UNFOLD + 1);
  IDM_VIEW_UNFOLD_2                            = (IDM_VIEW_UNFOLD + 2);
  IDM_VIEW_UNFOLD_3                            = (IDM_VIEW_UNFOLD + 3);
  IDM_VIEW_UNFOLD_4                            = (IDM_VIEW_UNFOLD + 4);
  IDM_VIEW_UNFOLD_5                            = (IDM_VIEW_UNFOLD + 5);
  IDM_VIEW_UNFOLD_6                            = (IDM_VIEW_UNFOLD + 6);
  IDM_VIEW_UNFOLD_7                            = (IDM_VIEW_UNFOLD + 7);
  IDM_VIEW_UNFOLD_8                            = (IDM_VIEW_UNFOLD + 8);

  IDM_VIEW_SUMMARY                             = (IDM_VIEW + 49);

  IDM_VIEW_PROJECT_PANEL_1                     = (IDM_VIEW + 81);
  IDM_VIEW_PROJECT_PANEL_2                     = (IDM_VIEW + 82);
  IDM_VIEW_PROJECT_PANEL_3                     = (IDM_VIEW + 83);

  IDM_VIEW_FILEBROWSER                         = (IDM_VIEW + 85);
  IDM_VIEW_DOC_MAP                             = (IDM_VIEW + 80);
  IDM_VIEW_FUNC_LIST                           = (IDM_VIEW + 84);

  IDM_VIEW_SYNSCROLLV                          = (IDM_VIEW + 35);
  IDM_VIEW_SYNSCROLLH                          = (IDM_VIEW + 36);

  IDM_VIEW_MONITORING                          = (IDM_VIEW + 97);

  IDM_VIEW_LINENUMBER                          = (IDM_VIEW + 12);
  IDM_VIEW_SYMBOLMARGIN                        = (IDM_VIEW + 13);
  IDM_VIEW_FOLDERMAGIN                         = (IDM_VIEW + 14);

  // The following items are not part of a menu but of the Preferences dialog
//  IDM_VIEW_TOOLBAR_HIDE                      = (IDM_VIEW + 1);
  IDM_VIEW_TOOLBAR_REDUCE                      = (IDM_VIEW + 2);
  IDM_VIEW_TOOLBAR_ENLARGE                     = (IDM_VIEW + 3);
  IDM_VIEW_TOOLBAR_STANDARD                    = (IDM_VIEW + 4);

  IDM_VIEW_FILESWITCHER_PANEL                  = (IDM_VIEW + 70);

  IDM_VIEW_DRAWTABBAR_MULTILINE                = (IDM_VIEW + 44);
  IDM_VIEW_DRAWTABBAR_VERTICAL                 = (IDM_VIEW + 43);
  IDM_VIEW_REDUCETABBAR                        = (IDM_VIEW + 5);
  IDM_VIEW_LOCKTABBAR                          = (IDM_VIEW + 6);
  IDM_VIEW_DRAWTABBAR_INACIVETAB               = (IDM_VIEW + 8);
  IDM_VIEW_DRAWTABBAR_TOPBAR                   = (IDM_VIEW + 7);
  IDM_VIEW_DRAWTABBAR_CLOSEBOTTUN              = (IDM_VIEW + 38);
  IDM_VIEW_DRAWTABBAR_DBCLK2CLOSE              = (IDM_VIEW + 39);

  IDM_VIEW_FOLDERMAGIN_SIMPLE                  = (IDM_VIEW + 15);
  IDM_VIEW_FOLDERMAGIN_ARROW                   = (IDM_VIEW + 16);
  IDM_VIEW_FOLDERMAGIN_CIRCLE                  = (IDM_VIEW + 17);
  IDM_VIEW_FOLDERMAGIN_BOX                     = (IDM_VIEW + 18);

  IDM_VIEW_EDGELINE                            = (IDM_VIEW + 27);
  IDM_VIEW_EDGEBACKGROUND                      = (IDM_VIEW + 28);
  IDM_VIEW_EDGENONE                            = (IDM_VIEW + 37);

  IDM_VIEW_LWDEF                               = (IDM_VIEW + 46);
  IDM_VIEW_LWALIGN                             = (IDM_VIEW + 47);
  IDM_VIEW_LWINDENT                            = (IDM_VIEW + 48);

  IDM_VIEW_CURLINE_HILITING                    = (IDM_VIEW + 21);

  // The following items seem to be internal messages and not related to menu items
  IDM_VIEW_REFRESHTABAR                        = (IDM_VIEW + 40);
  IDM_VIEW_DOCCHANGEMARGIN                     = (IDM_VIEW + 45);
  IDM_EXPORT_FUNC_LIST_AND_QUIT                = (IDM_VIEW + 73);

//  IDM_VIEW_USER_DLG                            = (IDM_VIEW + 11);


  // ---------------------------------------------------------------------------
  // Menu Encoding
  // ---------------------------------------------------------------------------
  IDM_FORMAT                                   = (IDM + 5000);

  IDM_FORMAT_ANSI                              = (IDM_FORMAT + 4);
  IDM_FORMAT_AS_UTF_8                          = (IDM_FORMAT + 8);  // UTF-8 w/o BOM
  IDM_FORMAT_UTF_8                             = (IDM_FORMAT + 5);  // UTF-8 w/ BOM
  IDM_FORMAT_UCS_2BE                           = (IDM_FORMAT + 6);
  IDM_FORMAT_UCS_2LE                           = (IDM_FORMAT + 7);

  IDM_FORMAT_CONV2_ANSI                        = (IDM_FORMAT + 9);
  IDM_FORMAT_CONV2_AS_UTF_8                    = (IDM_FORMAT + 10); // UTF-8 w/o BOM
  IDM_FORMAT_CONV2_UTF_8                       = (IDM_FORMAT + 11); // UTF-8 w/ BOM
  IDM_FORMAT_CONV2_UCS_2BE                     = (IDM_FORMAT + 12);
  IDM_FORMAT_CONV2_UCS_2LE                     = (IDM_FORMAT + 13);

  IDM_FORMAT_ENCODE                            = (IDM_FORMAT + 20);

  IDM_FORMAT_WIN_1250                          = (IDM_FORMAT_ENCODE + 0);
  IDM_FORMAT_WIN_1251                          = (IDM_FORMAT_ENCODE + 1);
  IDM_FORMAT_WIN_1252                          = (IDM_FORMAT_ENCODE + 2);
  IDM_FORMAT_WIN_1253                          = (IDM_FORMAT_ENCODE + 3);
  IDM_FORMAT_WIN_1254                          = (IDM_FORMAT_ENCODE + 4);
  IDM_FORMAT_WIN_1255                          = (IDM_FORMAT_ENCODE + 5);
  IDM_FORMAT_WIN_1256                          = (IDM_FORMAT_ENCODE + 6);
  IDM_FORMAT_WIN_1257                          = (IDM_FORMAT_ENCODE + 7);
  IDM_FORMAT_WIN_1258                          = (IDM_FORMAT_ENCODE + 8);

  IDM_FORMAT_ISO_8859_1                        = (IDM_FORMAT_ENCODE + 9);
  IDM_FORMAT_ISO_8859_2                        = (IDM_FORMAT_ENCODE + 10);
  IDM_FORMAT_ISO_8859_3                        = (IDM_FORMAT_ENCODE + 11);
  IDM_FORMAT_ISO_8859_4                        = (IDM_FORMAT_ENCODE + 12);
  IDM_FORMAT_ISO_8859_5                        = (IDM_FORMAT_ENCODE + 13);
  IDM_FORMAT_ISO_8859_6                        = (IDM_FORMAT_ENCODE + 14);
  IDM_FORMAT_ISO_8859_7                        = (IDM_FORMAT_ENCODE + 15);
  IDM_FORMAT_ISO_8859_8                        = (IDM_FORMAT_ENCODE + 16);
  IDM_FORMAT_ISO_8859_9                        = (IDM_FORMAT_ENCODE + 17);
//  IDM_FORMAT_ISO_8859_10                       = (IDM_FORMAT_ENCODE + 18);
//  IDM_FORMAT_ISO_8859_11                       = (IDM_FORMAT_ENCODE + 19);
  IDM_FORMAT_ISO_8859_13                       = (IDM_FORMAT_ENCODE + 20);
  IDM_FORMAT_ISO_8859_14                       = (IDM_FORMAT_ENCODE + 21);
  IDM_FORMAT_ISO_8859_15                       = (IDM_FORMAT_ENCODE + 22);
//  IDM_FORMAT_ISO_8859_16                       = (IDM_FORMAT_ENCODE + 23);

  IDM_FORMAT_DOS_437                           = (IDM_FORMAT_ENCODE + 24);
  IDM_FORMAT_DOS_720                           = (IDM_FORMAT_ENCODE + 25);
  IDM_FORMAT_DOS_737                           = (IDM_FORMAT_ENCODE + 26);
  IDM_FORMAT_DOS_775                           = (IDM_FORMAT_ENCODE + 27);
  IDM_FORMAT_DOS_850                           = (IDM_FORMAT_ENCODE + 28);
  IDM_FORMAT_DOS_852                           = (IDM_FORMAT_ENCODE + 29);
  IDM_FORMAT_DOS_855                           = (IDM_FORMAT_ENCODE + 30);
  IDM_FORMAT_DOS_857                           = (IDM_FORMAT_ENCODE + 31);
  IDM_FORMAT_DOS_858                           = (IDM_FORMAT_ENCODE + 32);
  IDM_FORMAT_DOS_860                           = (IDM_FORMAT_ENCODE + 33);
  IDM_FORMAT_DOS_861                           = (IDM_FORMAT_ENCODE + 34);
  IDM_FORMAT_DOS_862                           = (IDM_FORMAT_ENCODE + 35);
  IDM_FORMAT_DOS_863                           = (IDM_FORMAT_ENCODE + 36);
  IDM_FORMAT_DOS_865                           = (IDM_FORMAT_ENCODE + 37);
  IDM_FORMAT_DOS_866                           = (IDM_FORMAT_ENCODE + 38);
  IDM_FORMAT_DOS_869                           = (IDM_FORMAT_ENCODE + 39);

  IDM_FORMAT_BIG5                              = (IDM_FORMAT_ENCODE + 40);
  IDM_FORMAT_GB2312                            = (IDM_FORMAT_ENCODE + 41);
  IDM_FORMAT_SHIFT_JIS                         = (IDM_FORMAT_ENCODE + 42);
  IDM_FORMAT_KOREAN_WIN                        = (IDM_FORMAT_ENCODE + 43);
  IDM_FORMAT_EUC_KR                            = (IDM_FORMAT_ENCODE + 44);
  IDM_FORMAT_TIS_620                           = (IDM_FORMAT_ENCODE + 45);

  IDM_FORMAT_MAC_CYRILLIC                      = (IDM_FORMAT_ENCODE + 46);
  IDM_FORMAT_KOI8U_CYRILLIC                    = (IDM_FORMAT_ENCODE + 47);
  IDM_FORMAT_KOI8R_CYRILLIC                    = (IDM_FORMAT_ENCODE + 48);

  // Located in menu Edit
  IDM_FORMAT_TODOS                             = (IDM_FORMAT + 1);
  IDM_FORMAT_TOUNIX                            = (IDM_FORMAT + 2);
  IDM_FORMAT_TOMAC                             = (IDM_FORMAT + 3);


  // ---------------------------------------------------------------------------
  // Menu Language
  // ---------------------------------------------------------------------------
  IDM_LANG                                     = (IDM + 6000);

  IDM_LANG_C                                   = (IDM_LANG + 2);
  IDM_LANG_CPP                                 = (IDM_LANG + 3);
  IDM_LANG_JAVA                                = (IDM_LANG + 4);
  IDM_LANG_HTML                                = (IDM_LANG + 5);
  IDM_LANG_XML                                 = (IDM_LANG + 6);
  IDM_LANG_JS                                  = (IDM_LANG + 7);
  IDM_LANG_PHP                                 = (IDM_LANG + 8);
  IDM_LANG_ASP                                 = (IDM_LANG + 9);
  IDM_LANG_CSS                                 = (IDM_LANG + 10);
  IDM_LANG_PASCAL                              = (IDM_LANG + 11);
  IDM_LANG_PYTHON                              = (IDM_LANG + 12);
  IDM_LANG_PERL                                = (IDM_LANG + 13);
  IDM_LANG_OBJC                                = (IDM_LANG + 14);
  IDM_LANG_ASCII                               = (IDM_LANG + 15);
  IDM_LANG_TEXT                                = (IDM_LANG + 16);
  IDM_LANG_RC                                  = (IDM_LANG + 17);
  IDM_LANG_MAKEFILE                            = (IDM_LANG + 18);
  IDM_LANG_INI                                 = (IDM_LANG + 19);
  IDM_LANG_SQL                                 = (IDM_LANG + 20);
  IDM_LANG_VB                                  = (IDM_LANG + 21);
  IDM_LANG_BATCH                               = (IDM_LANG + 22);
  IDM_LANG_CS                                  = (IDM_LANG + 23);
  IDM_LANG_LUA                                 = (IDM_LANG + 24);
  IDM_LANG_TEX                                 = (IDM_LANG + 25);
  IDM_LANG_FORTRAN                             = (IDM_LANG + 26);
  IDM_LANG_BASH                                = (IDM_LANG + 27);
  IDM_LANG_FLASH                               = (IDM_LANG + 28);
  IDM_LANG_NSIS                                = (IDM_LANG + 29);
  IDM_LANG_TCL                                 = (IDM_LANG + 30);
  IDM_LANG_LISP                                = (IDM_LANG + 31);
  IDM_LANG_SCHEME                              = (IDM_LANG + 32);
  IDM_LANG_ASM                                 = (IDM_LANG + 33);
  IDM_LANG_DIFF                                = (IDM_LANG + 34);
  IDM_LANG_PROPS                               = (IDM_LANG + 35);
  IDM_LANG_PS                                  = (IDM_LANG + 36);
  IDM_LANG_RUBY                                = (IDM_LANG + 37);
  IDM_LANG_SMALLTALK                           = (IDM_LANG + 38);
  IDM_LANG_VHDL                                = (IDM_LANG + 39);
  IDM_LANG_CAML                                = (IDM_LANG + 40);
  IDM_LANG_KIX                                 = (IDM_LANG + 41);
  IDM_LANG_ADA                                 = (IDM_LANG + 42);
  IDM_LANG_VERILOG                             = (IDM_LANG + 43);
  IDM_LANG_AU3                                 = (IDM_LANG + 44);
  IDM_LANG_MATLAB                              = (IDM_LANG + 45);
  IDM_LANG_HASKELL                             = (IDM_LANG + 46);
  IDM_LANG_INNO                                = (IDM_LANG + 47);
  IDM_LANG_CMAKE                               = (IDM_LANG + 48);
  IDM_LANG_YAML                                = (IDM_LANG + 49);
  IDM_LANG_COBOL                               = (IDM_LANG + 50);
  IDM_LANG_D                                   = (IDM_LANG + 51);
  IDM_LANG_GUI4CLI                             = (IDM_LANG + 52);
  IDM_LANG_POWERSHELL                          = (IDM_LANG + 53);
  IDM_LANG_R                                   = (IDM_LANG + 54);
  IDM_LANG_JSP                                 = (IDM_LANG + 55);
  IDM_LANG_COFFEESCRIPT                        = (IDM_LANG + 56);
  IDM_LANG_JSON                                = (IDM_LANG + 57);
  IDM_LANG_FORTRAN_77                          = (IDM_LANG + 58);
  IDM_LANG_BAANC                               = (IDM_LANG + 59);
  IDM_LANG_SREC                                = (IDM_LANG + 60);
  IDM_LANG_IHEX                                = (IDM_LANG + 61);
  IDM_LANG_TEHEX                               = (IDM_LANG + 62);
  IDM_LANG_SWIFT                               = (IDM_LANG + 63);
  IDM_LANG_ASN1                                = (IDM_LANG + 64);
  IDM_LANG_AVS                                 = (IDM_LANG + 65);
  IDM_LANG_BLITZBASIC                          = (IDM_LANG + 66);
  IDM_LANG_PUREBASIC                           = (IDM_LANG + 67);
  IDM_LANG_FREEBASIC                           = (IDM_LANG + 68);
  IDM_LANG_CSOUND                              = (IDM_LANG + 69);
  IDM_LANG_ERLANG                              = (IDM_LANG + 70);
  IDM_LANG_ESCRIPT                             = (IDM_LANG + 71);
  IDM_LANG_FORTH                               = (IDM_LANG + 72);
  IDM_LANG_LATEX                               = (IDM_LANG + 73);
  IDM_LANG_MMIXAL                              = (IDM_LANG + 74);
  IDM_LANG_NIMROD                              = (IDM_LANG + 75);
  IDM_LANG_NNCRONTAB                           = (IDM_LANG + 76);
  IDM_LANG_OSCRIPT                             = (IDM_LANG + 77);
  IDM_LANG_REBOL                               = (IDM_LANG + 78);
  IDM_LANG_REGISTRY                            = (IDM_LANG + 79);
  IDM_LANG_RUST                                = (IDM_LANG + 80);
  IDM_LANG_SPICE                               = (IDM_LANG + 81);
  IDM_LANG_TXT2TAGS                            = (IDM_LANG + 82);
  IDM_LANG_VISUALPROLOG                        = (IDM_LANG + 83);

  IDM_LANG_EXTERNAL                            = (IDM_LANG + 165);
  IDM_LANG_EXTERNAL_LIMIT                      = (IDM_LANG + 179);

  IDM_LANG_USER                                = (IDM_LANG + 180);   //46180: Used for translation
  IDM_LANG_USER_LIMIT                          = (IDM_LANG + 210);   //46210: Ajust with IDM_LANG_USER
  IDM_LANG_USER_DLG                            = (IDM_LANG + 250);   //46250: Used for translation

  // Located in menu Settings (item "Styles Configurator")
  IDM_LANGSTYLE_CONFIG_DLG                     = (IDM_LANG + 1);


  // ---------------------------------------------------------------------------
  // Menu Settings
  // ---------------------------------------------------------------------------
  IDM_SETTING = (IDM + 8000);

  IDM_SETTING_PREFERECE                        = (IDM_SETTING + 11);
  IDM_SETTING_SHORTCUT_MAPPER                  = (IDM_SETTING + 9);

  IDM_SETTING_IMPORTPLUGIN                     = (IDM_SETTING + 5);
  IDM_SETTING_IMPORTSTYLETHEMS                 = (IDM_SETTING + 6);
  IDM_SETTING_EDITCONTEXTMENU                  = (IDM_SETTING + 18);

  // Located in menu Macro
  IDM_SETTING_SHORTCUT_MAPPER_MACRO            = (IDM_SETTING + 16);

  // Located in menu Run
  IDM_SETTING_SHORTCUT_MAPPER_RUN              = (IDM_SETTING + 17);

  // Located in menu Plugins
  IDM_SETTING_PLUGINADM                        = (IDM_SETTING + 15);

  // The following items are not part of a menu but seem to be related to the
  // Preferences dialog
  IDM_SETTING_TRAYICON                         = (IDM_SETTING + 8);
  IDM_SETTING_REMEMBER_LAST_SESSION            = (IDM_SETTING + 10);

//  IDM_SETTING_TAB_SIZE                       = (IDM_SETTING + 1);
//  IDM_SETTING_TAB_REPLCESPACE                = (IDM_SETTING + 2);
//  IDM_SETTING_HISTORY_SIZE                   = (IDM_SETTING + 3);
//  IDM_SETTING_EDGE_SIZE                      = (IDM_SETTING + 4);


  // ---------------------------------------------------------------------------
  // Menu Tools
  // ---------------------------------------------------------------------------
  IDM_TOOL                                     = (IDM + 8500);

  IDM_TOOL_MD5_GENERATE                        = (IDM_TOOL + 1);
  IDM_TOOL_MD5_GENERATEFROMFILE                = (IDM_TOOL + 2);
  IDM_TOOL_MD5_GENERATEINTOCLIPBOARD           = (IDM_TOOL + 3);


  // ---------------------------------------------------------------------------
  // Menu Macro
  // ---------------------------------------------------------------------------
  // All entries of the menu Macros have IDs which derive from other menus


  // ---------------------------------------------------------------------------
  // Menu Run
  // ---------------------------------------------------------------------------
  IDM_EXECUTE                                  = (IDM + 9000);


  // ---------------------------------------------------------------------------
  // Menu Plugins
  // ---------------------------------------------------------------------------
  // The entries of the menu Plugins are created dynamically during run time
  // execpt the Plugin Admin entry


  // ---------------------------------------------------------------------------
  // Menu Window
  // ---------------------------------------------------------------------------
  IDM_WINDOW                                   = (11000);

  IDM_WINDOW_WINDOWS                           = (IDM_WINDOW + 1);


  // ---------------------------------------------------------------------------
  // Menu ?
  // ---------------------------------------------------------------------------
  IDM_ABOUT                                    = (IDM + 7000);

  IDM_CMDLINEARGUMENTS                         = (IDM_ABOUT + 10);
  IDM_HOMESWEETHOME                            = (IDM_ABOUT + 1);
  IDM_PROJECTPAGE                              = (IDM_ABOUT + 2);
  IDM_FORUM                                    = (IDM_ABOUT + 4);
  IDM_ONLINESUPPORT                            = (IDM_ABOUT + 11);
  IDM_PLUGINSHOME                              = (IDM_ABOUT + 5);
  IDM_UPDATE_NPP                               = (IDM_ABOUT + 6);
  IDM_CONFUPDATERPROXY                         = (IDM_ABOUT + 9);
  IDM_DEBUGINFO                                = (IDM_ABOUT + 12);

  // The following items are not part of a menu
  IDM_ONLINEHELP                               = (IDM_ABOUT + 3);
  IDM_WIKIFAQ                                  = (IDM_ABOUT + 7);
  IDM_HELP                                     = (IDM_ABOUT + 8);


  // ---------------------------------------------------------------------------
  // Tab context menu
  // ---------------------------------------------------------------------------
  IDM_MISC                                     = (IDM + 3500);

  IDM_FILESWITCHER_FILESCLOSE                  = (IDM_MISC + 1);
  IDM_FILESWITCHER_FILESCLOSEOTHERS            = (IDM_MISC + 2);


  // ---------------------------------------------------------------------------
  // System tray menu
  // ---------------------------------------------------------------------------
  IDM_SYSTRAYPOPUP                             = (IDM + 3100);

  IDM_SYSTRAYPOPUP_ACTIVATE                    = (IDM_SYSTRAYPOPUP + 1);
  IDM_SYSTRAYPOPUP_NEWDOC                      = (IDM_SYSTRAYPOPUP + 2);
  IDM_SYSTRAYPOPUP_NEW_AND_PASTE               = (IDM_SYSTRAYPOPUP + 3);
  IDM_SYSTRAYPOPUP_OPENFILE                    = (IDM_SYSTRAYPOPUP + 4);
  IDM_SYSTRAYPOPUP_CLOSE                       = (IDM_SYSTRAYPOPUP + 5);



implementation


end.
