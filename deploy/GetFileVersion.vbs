'==============================================================================
'
' This script extracts the version info from a provided exe or dll file.
'
' Author: Andreas Heim
' Date:   18.04.2017
'
' This file is part of the deployment system of the plugin framework for Delphi.
'
' This program is free software; you can redistribute it and/or modify it
' under the terms of the GNU General Public License version 3 as published
' by the Free Software Foundation.
'
' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.
'
' You should have received a copy of the GNU General Public License along
' with this program; if not, write to the Free Software Foundation, Inc.,
' 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
'
'==============================================================================


'Variables have to be declared before first usage
Option Explicit


'Declare variables
Dim strPEFile, strFileVersion, arrFileVersion
Dim objFSO, objShell, objNameSpace, objFolderItem
Dim intCnt


'Create some basic objects
Set objFSO   = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("Shell.Application")


'Terminate with error code if params count is wrong
If WScript.Arguments.Count < 1 Then
  WScript.Quit 1
End If


'Retrieve absolute path of input file
strPEFile = objFSO.GetAbsolutePathName(WScript.Arguments(0))

'Terminate with error code if input file does not exist
If Not objFSO.FileExists(strPEFile) Then
  WScript.Quit 2
End If


'Terminate with error code if input file's filetype is not supported
If StrComp(objFSO.GetExtensionName(strPEFile), "exe", vbTextCompare) <> 0 And _
   StrComp(objFSO.GetExtensionName(strPEFile), "dll", vbTextCompare) <> 0 Then
  WScript.Quit 3
End If


'Get shell object of input file
Set objNameSpace  = objShell.Namespace(objFSO.GetParentFolderName(strPEFile))
Set objFolderItem = objNameSpace.ParseName(objFSO.GetFileName(strPEFile))

'Retrieve FileVersion extended property
strFileVersion = CStr(objFolderItem.ExtendedProperty("Fileversion"))

'Split version string and discard all trailing zeros beyond 2nd digit
arrFileVersion = Split(strFileVersion, ".")

For intCnt = UBound(arrFileVersion) To 2 Step -1
  If arrFileVersion(intCnt) <> "0" Then Exit For
  ReDim Preserve arrFileVersion(intCnt - 1)
Next

'Join version number parts and output resulting string
WScript.Echo Join(arrFileVersion, ".")


'Exit
WScript.Quit 0
