@REM
@REM ***************************************************************************
@REM Copyright (c) 2010 Qcadoo Limited
@REM Project: Qcadoo Framework
@REM Version: 0.4.3
@REM
@REM This file is part of Qcadoo.
@REM
@REM Qcadoo is free software; you can redistribute it and/or modify
@REM it under the terms of the GNU Affero General Public License as published
@REM by the Free Software Foundation; either version 3 of the License,
@REM or (at your option) any later version.
@REM
@REM This program is distributed in the hope that it will be useful,
@REM but WITHOUT ANY WARRANTY; without even the implied warranty
@REM of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
@REM See the GNU Affero General Public License for more details.
@REM
@REM You should have received a copy of the GNU Affero General Public License
@REM along with this program; if not, write to the Free Software
@REM Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
@REM ***************************************************************************
@REM

@echo off
if "%OS%" == "Windows_NT" setlocal
rem ---------------------------------------------------------------------------
rem Restart script for the CATALINA Server
rem ---------------------------------------------------------------------------

rem Guess CATALINA_HOME if not defined
set "CURRENT_DIR=%cd%"
if not "%CATALINA_HOME%" == "" goto gotHome
set "CATALINA_HOME=%CURRENT_DIR%"
if exist "%CATALINA_HOME%\bin\catalina.bat" goto okHome
cd ..
set "CATALINA_HOME=%cd%"
cd "%CURRENT_DIR%"
:gotHome
if exist "%CATALINA_HOME%\bin\catalina.bat" goto okHome
echo The CATALINA_HOME environment variable is not defined correctly
echo This environment variable is needed to run this program
goto end
:okHome

set "EXECUTABLE=%CATALINA_HOME%\bin\catalina.bat"

rem Check that target executable exists
if exist "%EXECUTABLE%" goto okExec
echo Cannot find "%EXECUTABLE%"
echo This file is needed to run this program
goto end
:okExec

rem Get remaining unshifted command line arguments and save them in the
set CMD_LINE_ARGS=
:setArgs
if ""%1""=="""" goto doneSetArgs
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto setArgs
:doneSetArgs


timeout /T 5 /NOBREAK


call "%EXECUTABLE%" start


exit


:end
