::=============================================================================
::
:: This script is executed after compiling a new built of the plugin's DLL.
:: In case of a release built it calls the main deployment script.
::
:: Author: Andreas Heim
:: Date:   18.04.2017
::
:: This file is part of the build system of the plugin framework for Delphi.
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

echo.
echo ========================
echo PostBuild script started
echo ========================
echo.


set "PluginName=%~1"
set "Config=%~2"
set "Platform=%~3"



:Step1
copy "..\doc\%PluginName%.txt" "..\_npp\Win32\plugins\%PluginName%\doc" > NUL
copy "..\doc\%PluginName%.txt" "..\_npp\Win64\plugins\%PluginName%\doc" > NUL


:Step2
if /i "%Config%" neq "Release" goto :Step3

call "..\deploy\Deploy.cmd" "%PluginName%" "%Platform%"
if %ERRORLEVEL% neq 0 goto :Abort


:Step3
goto :Quit



:Quit
set "ReturnCode=0"

echo ========================
echo PostBuild script successfully executed
echo ========================
echo.

goto :Terminate


:Abort
set "ReturnCode=%ERRORLEVEL%"

echo ========================
echo PostBuild script aborted with error code %ReturnCode%
echo ========================
echo.

goto :Terminate


:Terminate
exit /b %ReturnCode%
