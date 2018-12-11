::=============================================================================
::
:: Main script of the plugin's deployment system.
::
:: Author: Andreas Heim
:: Date:   18.04.2017
::
:: This file is part of the deployment system of the plugin framework for Delphi.
::
:: This program is free software; you can redistribute it and/or modify it
:: under the terms of the GNU General Public License version 3 as published
:: by the Free Software Foundation.
::
:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU General Public License for more details.
::
:: You should have received a copy of the GNU General Public License along
:: with this program; if not, write to the Free Software Foundation, Inc.,
:: 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
::
::=============================================================================


@echo off & setlocal

::Get script's full call path from argv[0]
::and remove trailing backslash
set "DeployBasePath=%~dp0"
set "DeployBasePath=%DeployBasePath:~0,-1%"

::Extract project's base path from script's folder path
::and remove trailing backslash
for %%a in ("%DeployBasePath%") do set "ProjectPath=%%~dpa"
set "ProjectPath=%ProjectPath:~0,-1%"

::Get plugin's name from argv[1]
set "PluginName=%~1"

::Get platform from argv[2]
set "Platform=%~2"


::Set working directory to script's directory
pushd "%~dp0"


::Set deploy tools paths
set "SevenZip=%DeployBasePath%\bin\7za.exe"
set "MD5Sums=%DeployBasePath%\bin\md5sums.exe"
set "SHA256Sum=%DeployBasePath%\bin\sha256sum.exe"

::Set input files paths
set "DocDir=%ProjectPath%\doc"
set "DocFile=%PluginName%.txt"

set "DllDir=%ProjectPath%\_bin\%Platform%"
set "DllFile=%PluginName%.dll"

set "Plugins86XmlFile=%ProjectPath%\_pluginmanager\Win32\plugins86.xml"

set "Plugins64XmlFile=%ProjectPath%\_pluginmanager\Win64\plugins\plugins64.xml"
set "ValidateJsonFile=%ProjectPath%\_pluginmanager\Win64\plugins\validate.json"

set "Plugins86JsonFile=%ProjectPath%\_pluginadmin\src\pl.x86.json"
set "Plugins64JsonFile=%ProjectPath%\_pluginadmin\src\pl.x64.json"


::Set output files paths
for /f "delims=" %%a in ('cscript /nologo GetFileVersion.vbs "%DllDir%\%DllFile%"') do (
  set "FileVersion=%%a"
)

set "ZipOutDir=%ProjectPath%\_plugin\%Platform%"

if /i "%Platform%" equ "Win32" (
  set "ZipFile=%PluginName%_v%FileVersion%_UNI.zip"

) else if /i "%Platform%" equ "Win64" (
  set "ZipFile=%PluginName%_v%FileVersion%_x64.zip"
)

set "MD5OutDir=%DllDir%"
set "MD5File=%DllFile%.md5"

set "SHA256OutDir=%ZipOutDir%"
set "SHA256File=%ZipFile%.sha256"


::Create plugin ZIP file
call CreateZip.cmd & echo.
if %ERRORLEVEL% neq 0 goto :Quit


::Create MD5 hash file of plugin's DLL file
call CreateMD5Hash.cmd & echo.
if %ERRORLEVEL% neq 0 goto :Quit


::Create SHA-256 hash file of plugin's ZIP file
call CreateSHA256Hash.cmd & echo.
if %ERRORLEVEL% neq 0 goto :Quit


::If target platform is x86 patch plugins86.xml
::If target platform is x64 patch plugins64.xml and validate.json files
cscript /nologo PatchPluginsXml.vbs "%FileVersion%" & echo.
if %ERRORLEVEL% neq 0 goto :Quit

for /f "usebackq tokens=1 delims=* " %%a in ("%SHA256OutDir%\%SHA256File%") do set "SHA256Hash=%%a"
cscript /nologo PatchPluginsJson.vbs "%FileVersion%" "%SHA256Hash%" & echo.
if %ERRORLEVEL% neq 0 goto :Quit

if /i "%Platform%" equ "Win32" goto :Quit

for /f "usebackq tokens=1 delims=* " %%a in ("%MD5OutDir%\%MD5File%") do set "MD5Hash=%%a"
cscript /nologo PatchValidateJson.vbs "%MD5Hash%" & echo.
if %ERRORLEVEL% neq 0 goto :Quit


::Restore original working directory and exit
:Quit
popd
