'==============================================================================
'
' Patch script for the validate.json file of the plugin's x64 built to automate
' the deployment process of the plugin. The script sets the plugin's MD5 hash
' data to the provided value.
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


'Include external code files
Include ".\include\IO.vbs"
Include ".\include\ClassJsonFile.vbs"


'Declare variables
Dim strEnvVar, strPluginName, strJsonFile
Dim objFSO, objWshShell, objJsonFile


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


'Retrieve input file from environment variable
strEnvVar   = "%ValidateJsonFile%"
strJsonFile = objWshShell.ExpandEnvironmentStrings(strEnvVar)

'Terminate with error code if environment variable is not set
If strJsonFile = strEnvVar Then
  WScript.Echo WScript.ScriptName & ": Environment variable not set"
  WScript.Quit 1
End If


'Retrieve absolute path of input file
strJsonFile = objFSO.GetAbsolutePathName(strJsonFile)

'Terminate with error code if input file does not exist
If Not objFSO.FileExists(strJsonFile) Then
  WScript.Echo WScript.ScriptName & ": File not found"
  WScript.Quit 2
End If


'Terminate with error code if params count is wrong
If WScript.Arguments.Count < 1 Then
  WScript.Echo WScript.ScriptName & ": Missing arguments"
  WScript.Quit 3
End If


'Terminate with error code if loading JSON file fails
If Not objJsonFile.LoadFromFile(strJsonFile, AsAnsi) Then
  WScript.Echo WScript.ScriptName & ": JSON file corrupted"
  WScript.Quit 4
End If


'Retrieve plugin's JSON object and set its property
objJsonFile.Content.Item(strPluginName).RemoveAll
objJsonFile.Content.Item(strPluginName).Add WScript.Arguments(0), strPluginName & ".dll"

'Set bracket style and indentation of JSON data output
objJsonFile.EolStyle     = EolStyleUnix
objJsonFile.BracketStyle = BracketStyleJava
objJsonFile.Indent       = 4

'Save JSON data to file
objJsonFile.SaveToFile strJsonFile, AsAnsi


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
