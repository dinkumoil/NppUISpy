'==============================================================================
'
' Patch script for the pl.xXX.json file of Notepad++ plugin admin to automate
' the deployment process of the plugin. The script sets the plugin's SHA-256
' hash data to the provided value.
'
' Author: Andreas Heim
' Date:   05.11.2018
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


'Include external code files
Include ".\include\IO.vbs"
Include ".\include\ClassJsonFile.vbs"


'Declare variables
Dim strEnvVar, strPluginName, strPlatform, strRepositoryBaseUrl
Dim strVersionKey, strIdKey, strRepositoryKey, strHomepageKey
Dim strJsonFile, strId, strVersion, strZipFileName

Dim objFSO, objWshShell, objJsonFile, strFileContent, arrPlugins, intCnt


'Create some basic objects
Set objFSO      = CreateObject("Scripting.FileSystemObject")
Set objWshShell = CreateObject("WScript.Shell")
Set objJsonFile = New clsJsonFile


'Retrieve plugin name from environment variable
strEnvVar     = "%PluginName%"
strPluginName = objWshShell.ExpandEnvironmentStrings(strEnvVar)

'Terminate with error code if environment variable is not set
If strPluginName = strEnvVar Then
  WScript.Echo WScript.ScriptName & ": Environment variable not set"
  WScript.Quit 1
End If


'Retrieve ZIP file name from environment variable
strEnvVar      = "%ZipFile%"
strZipFileName = objWshShell.ExpandEnvironmentStrings(strEnvVar)

'Terminate with error code if environment variable is not set
If strZipFileName = strEnvVar Then
  WScript.Echo WScript.ScriptName & ": Environment variable not set"
  WScript.Quit 2
End If


'Retrieve target platform from environment variable
strPlatform = objWshShell.ExpandEnvironmentStrings("%Platform%")

'Set target platform platform independent variables
strRepositoryBaseUrl = "https://github.com/dinkumoil/" & strPluginName
strIdKey             = "id"
strVersionKey        = "version"
strRepositoryKey     = "repository"
strHomepageKey       = "homepage"

'Set target platform specific variables
If StrComp(strPlatform, "Win32", vbTextCompare) = 0 Then
  strEnvVar   = "%Plugins86JsonFile%"
  strJsonFile = objWshShell.ExpandEnvironmentStrings(strEnvVar)

ElseIf StrComp(strPlatform, "Win64", vbTextCompare) = 0 Then
  strEnvVar   = "%Plugins64JsonFile%"
  strJsonFile = objWshShell.ExpandEnvironmentStrings(strEnvVar)
  
Else
  WScript.Echo WScript.ScriptName & ": Unknown target platform"
  WScript.Quit 3
End If


'Retrieve absolute path of input file
strJsonFile = objFSO.GetAbsolutePathName(strJsonFile)

'Terminate with error code if input file does not exist
If Not objFSO.FileExists(strJsonFile) Then
  WScript.Echo WScript.ScriptName & ": File """ & strJsonFile & """ not found"
  WScript.Quit 4
End If


'Terminate with error code if params count is wrong
If WScript.Arguments.Count < 2 Then
  WScript.Echo WScript.ScriptName & ": Missing arguments"
  WScript.Quit 5
Else
  strVersion = WScript.Arguments(0)
  strId      = WScript.Arguments(1)
End If


'Set JSON file parameters
objJsonFile.EolStyle     = EolStyleUnix
objJsonFile.BracketStyle = BracketStyleJava
objJsonFile.IndentStyle  = IndentStyleTab
objJsonFile.Indent       = 1
objJsonFile.AllStrValues = True

'Load JSON file to string and terminate with error code if parsing it fails
strFileContent = ReadUTF8File(strJsonFile)

If Not objJsonFile.LoadFromString(strFileContent) Then
  WScript.Echo WScript.ScriptName & ": JSON file """ & objFSO.GetFileName(strJsonFile) & """ corrupted"
  WScript.Quit 6
End If


'Retrieve plugin's JSON object and set its properties
arrPlugins = objJsonFile.Content.Item("npp-plugins")

For intCnt = 0 to UBound(arrPlugins)
  If StrComp(arrPlugins(intCnt).Item("display-name"), strPluginName, vbTextCompare) = 0 Then
    arrPlugins(intCnt).Item(strIdKey)         = strId
    arrPlugins(intCnt).Item(strVersionKey)    = strVersion
    arrPlugins(intCnt).Item(strRepositoryKey) = strRepositoryBaseUrl & "/releases/download/v" & strVersion & "/" & strZipFileName
    arrPlugins(intCnt).Item(strHomepageKey)   = strRepositoryBaseUrl
    Exit For
  End If  
Next

'Save JSON data to file
WriteUTF8File strJsonFile, objJsonFile.ToString(True)


'Output message indicating success
WScript.Echo "File """ & objFSO.GetFileName(strJsonFile) & """ successfully patched"

'Exit
WScript.Quit 0




'===============================================================================
'Include external code file
'===============================================================================

Sub Include(ByRef strFilePath)
  Dim objFSO, objFileStream, strScriptFilePath, strAbsFilePath, strCode

  Set objFSO        = CreateObject("Scripting.FileSystemObject")
  strScriptFilePath = objFSO.GetParentFolderName(WScript.ScriptFullName)
  strAbsFilePath    = objFSO.GetAbsolutePathName(objFSO.BuildPath(strScriptFilePath, strFilePath))

  Set objFileStream = objFSO.OpenTextFile(strAbsFilePath, 1, False, 0)
  strCode           = objFileStream.ReadAll
  objFileStream.Close

  ExecuteGlobal strCode
End Sub
