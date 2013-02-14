@REM
@REM ***************************************************************************
@REM Copyright (c) 2010 Qcadoo Limited
@REM Project: Qcadoo Framework
@REM Version: 1.2.0
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
rem Wrapper script for command line tools
rem
rem Environment Variable Prequisites
rem
rem   CATALINA_HOME May point at your Catalina "build" directory.
rem
rem   TOOL_OPTS     (Optional) Java runtime options used when the "start",
rem                 "stop", or "run" command is executed.
rem
rem   JAVA_HOME     Must point at your Java Development Kit installation.
rem
rem   JAVA_OPTS     (Optional) Java runtime options used when the "start",
rem                 "stop", or "run" command is executed.
rem
rem $Id: tool-wrapper.bat 908749 2010-02-10 23:26:42Z markt $
rem ---------------------------------------------------------------------------

rem Guess CATALINA_HOME if not defined
if not "%CATALINA_HOME%" == "" goto gotHome
set CATALINA_HOME=.
if exist "%CATALINA_HOME%\bin\tool-wrapper.bat" goto okHome
set CATALINA_HOME=..
:gotHome
if exist "%CATALINA_HOME%\bin\tool-wrapper.bat" goto okHome
echo The CATALINA_HOME environment variable is not defined correctly
echo This environment variable is needed to run this program
goto end
:okHome

rem Ensure that any user defined CLASSPATH variables are not used on startup,
rem but allow them to be specified in setenv.bat, in rare case when it is needed.
set CLASSPATH=

rem Get standard environment variables
if exist "%CATALINA_HOME%\bin\setenv.bat" call "%CATALINA_HOME%\bin\setenv.bat"

rem Get standard Java environment variables
if exist "%CATALINA_HOME%\bin\setclasspath.bat" goto okSetclasspath
echo Cannot find "%CATALINA_HOME%\bin\setclasspath.bat"
echo This file is needed to run this program
goto end
:okSetclasspath
set "BASEDIR=%CATALINA_HOME%"
call "%CATALINA_HOME%\bin\setclasspath.bat"

rem Add on extra jar files to CLASSPATH
rem Note that there are no quotes as we do not want to introduce random
rem quotes into the CLASSPATH
if "%CLASSPATH%" == "" goto noclasspath
set "CLASSPATH=%CLASSPATH%;%CATALINA_HOME%\bin\bootstrap.jar;%BASEDIR%\lib\servlet-api.jar"
goto okclasspath
:noclasspath
set "CLASSPATH=%CATALINA_HOME%\bin\bootstrap.jar;%BASEDIR%\lib\servlet-api.jar"
:okclasspath

rem Get remaining unshifted command line arguments and save them in the
set CMD_LINE_ARGS=
:setArgs
if ""%1""=="""" goto doneSetArgs
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto setArgs
:doneSetArgs

%_RUNJAVA% %JAVA_OPTS% %TOOL_OPTS% -Djava.endorsed.dirs="%JAVA_ENDORSED_DIRS%" -classpath "%CLASSPATH%" -Dcatalina.home="%CATALINA_HOME%" org.apache.catalina.startup.Tool %CMD_LINE_ARGS%

:end
