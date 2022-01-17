@echo off

REM Ensure that current directory is the location of this batch file.
set mypath=%~dp0
for /f %%i in ('cd') do set curdir=%%i
cd %mypath%

REM Set up linkdir.txt
set argC=0
for %%x in (%*) do Set /A argC+=1

if %argC%==0 (
    if exist ..\Utilities\qap_readFile.m (
        cd ..\Utilities\
        for /f %%i in ('cd') do set loc=%%i
        cd %mypath%
    ) else (
        set /P loc="Enter location of utilities folder containing qap_readFile.m, etc: " 
    )
) else (
    set loc=%1
)

REM Write the location of utilities in the first line of linkdir.txt
echo Setting utilities folder location as %loc%
echo %loc% > .\linkdir.txt

REM find features
if %argC% LEQ 1 (
    if exist ..\Features\matlab (
        cd ..\Features\
        for /f %%i in ('cd') do set locf=%%i
        cd %mypath%
        echo Setting features folder location as %locf%
    ) else (
        set /P locf="Enter location of features folder containing /matlab/defineFeatures.m, etc: " 
    )
) else (
    set locf=%2
    echo Setting features folder location as %locf%
)

REM Write the location of features in the second line of linkdir.txt
echo %locf% >> .\linkdir.txt

cd %curdir%