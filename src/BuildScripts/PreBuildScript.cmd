::=============================================================================
::
:: This script is executed before compiling a new built of the plugin's DLL.
:: Currently this script does nothing.
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
echo =======================
echo PreBuild script started
echo =======================
echo.


set "PluginName=%~1"
set "Config=%~2"
set "Platform=%~3"



:Step1
call "Res\res.cmd" /s
if %ERRORLEVEL% neq 0 goto :Abort


:Step2
goto :Quit



:Quit
set "ReturnCode=0"

echo =======================
echo PreBuild script successfully executed
echo =======================
echo.

goto :Terminate


:Abort
set "ReturnCode=%ERRORLEVEL%"

echo =======================
echo PreBuild script aborted with error code %ReturnCode%
echo =======================
echo.

goto :Terminate


:Terminate
exit /b %ReturnCode%
