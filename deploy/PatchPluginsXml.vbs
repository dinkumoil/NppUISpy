'==============================================================================
'
' Patch script for pluginsxXX.xml files to automate the deployment process of
' the plugin. The script sets the version information to the provided value.
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


'Declare variables
Dim strEnvVar, strPluginName, strPlatform, strRepositoryBaseUrl
Dim strVersionKey, strSourceUrlKey, strDownloadKey
Dim strXmlFile, strVersion, strZipFileName

Dim objFSO, objWshShell, objXmlDoc
Dim objPluginNode, objVersionNode, objSourceUrlNode, objDownloadNode


'Create some basic objects
Set objFSO      = CreateObject("Scripting.FileSystemObject")
Set objWshShell = CreateObject("WScript.Shell")
Set objXmlDoc   = CreateObject("Microsoft.XMLDOM")


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
strSourceUrlKey      = "homepage"

'Set target platform specific variables
If StrComp(strPlatform, "Win32", vbTextCompare) = 0 Then
  strEnvVar      = "%Plugins86XmlFile%"
  strVersionKey  = "unicodeVersion"
  strDownloadKey = "install/unicode/download"

ElseIf StrComp(strPlatform, "Win64", vbTextCompare) = 0 Then
  strEnvVar      = "%Plugins64XmlFile%"
  strVersionKey  = "x64Version"
  strDownloadKey = "install/x64/download"
  
Else
  WScript.Echo WScript.ScriptName & ": Unknown target platform"
  WScript.Quit 3
End If


'Retrieve input file from environment variable
strXmlFile = objWshShell.ExpandEnvironmentStrings(strEnvVar)

'Terminate with error code if environment variable is not set
If strXmlFile = strEnvVar Then
  WScript.Echo WScript.ScriptName & ": Environment variable not set"
  WScript.Quit 4
End If


'Retrieve absolute path of input file
strXmlFile = objFSO.GetAbsolutePathName(strXmlFile)

'Terminate with error code if input file does not exist
If Not objFSO.FileExists(strXmlFile) Then
  WScript.Echo WScript.ScriptName & ": File not found"
  WScript.Quit 5
End If


'Terminate with error code if params count is wrong
If WScript.Arguments.Count < 1 Then
  WScript.Echo WScript.ScriptName & ": Missing arguments"
  WScript.Quit 6
Else
  'Retrieve plugin version from command line param
  strVersion = WScript.Arguments(0)
End If


'Load XML file
objXmlDoc.async              = False
objXmlDoc.preserveWhiteSpace = True
objXmlDoc.validateOnParse    = False
objXmlDoc.load(strXmlFile)

'Terminate with error code on parsing errors
If objXmlDoc.parseError.errorCode <> 0 Then
  WScript.Echo WScript.ScriptName & ": XML file corrupted"
  WScript.Quit 7
End If


'Retrieve plugin's root node
Set objPluginNode = objXmlDoc.documentElement.selectSingleNode("//plugin[@name='" & strPluginName & "']")

'Retrieve plugin's version node and set its value
Set objVersionNode = objPluginNode.selectSingleNode(strVersionKey)
objVersionNode.nodeTypedValue = strVersion

'Retrieve plugin's sourceUrl node and set its value
Set objSourceUrlNode = objPluginNode.selectSingleNode(strSourceUrlKey)
objSourceUrlNode.nodeTypedValue = strRepositoryBaseUrl

'Retrieve plugin's download node and set its value
Set objDownloadNode = objPluginNode.selectSingleNode(strDownloadKey)
objDownloadNode.nodeTypedValue = strRepositoryBaseUrl & "/releases/download/v" & strVersion & "/" & strZipFileName


'Save XML file
objXmlDoc.save(strXmlFile)
Call ConvertUTF8EOLFormat(strXmlFile, vbLf)


'Output message indicating success
WScript.Echo "File """ & objFSO.GetFileName(strXmlFile) & """ successfully patched"

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
