::=============================================================================
::
:: This script creates the plugin's ZIP file for downloading by the Notepad++
:: Plugin Manager and Plugin Admin.
::
:: Author: Andreas Heim
:: Date:   05.11.2018
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

::Delete already existing output file
del "%ZipOutDir%\%ZipFile%" 1>NUL 2>&1


::Add plugin's DLL file to archive
"%SevenZip%" a "%ZipOutDir%\%ZipFile%" "%DllDir%\%DllFile%" -bso0 -bsp0
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

::Add plugin's documentation file to archive
"%SevenZip%" a "%ZipOutDir%\%ZipFile%" "%DocDir%" -xr!"__*" -bso0 -bsp0
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%


::Output message indicating success
echo ZIP file successfully created
