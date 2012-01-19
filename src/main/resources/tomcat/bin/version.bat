@REM
@REM ***************************************************************************
@REM Copyright (c) 2010 Qcadoo Limited
@REM Project: Qcadoo Framework
@REM Version: 1.1.2
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
rem Licensed to the Apache Software Foundation (ASF) under one or more
rem contributor license agreements.  See the NOTICE file distributed with
rem this work for additional information regarding copyright ownership.
rem The ASF licenses this file to You under the Apache License, Version 2.0
rem (the "License"); you may not use this file except in compliance with
rem the License.  You may obtain a copy of the License at
rem
rem     http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

if "%OS%" == "Windows_NT" setlocal
rem ---------------------------------------------------------------------------
rem Version script for the CATALINA Server
rem
rem $Id: version.bat 908749 2010-02-10 23:26:42Z markt $
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

call "%EXECUTABLE%" version %CMD_LINE_ARGS%

:end
