::=============================================================================
::
:: This script creates a SHA-256 hash file of the plugin's ZIP file.
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
del "%SHA256OutDir%\%SHA256File%" 1>NUL 2>&1


::Create SHA-256 hash file of archive file
pushd "%SHA256OutDir%"
"%SHA256Sum%" "%ZipFile%" > "%SHA256File%"
popd

if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%


::Output message indicating success
echo SHA-256 hash file successfully created
