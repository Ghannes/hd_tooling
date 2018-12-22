@echo off 
cls
echo Choose map type: 
echo [P] Premium maps 
echo [M] Motion maps
echo [K] Move maps
echo [N] Next maps
echo. 
SET /P C=[P,M,K,N]? 
for %%? in (P) do if /I "%C%"=="%%?" set version=0x28
for %%? in (M) do if /I "%C%"=="%%?" set version=0x47
for %%? in (K) do if /I "%C%"=="%%?" set version=0x88
for %%? in (N) do if /I "%C%"=="%%?" set version=0xA9

set workdir=%cd%\workdir
set ip=169.254.199.99

set timestring=%time: =0%
set HH=%timestring:~-11,2%
set MM=%time:~-8,2%
set SS=%time:~-5,2%

set formattedtime=%date:~-10%_%HH%_%MM%_%SS%

set rawFile=%formattedtime%_raw.hex
REM echo rawFile=%rawFile%

set hexFile=%formattedtime%_1b.hex
REM echo hexFile=%hexFile%

REM 	user name is "root", password is either "Hm83stN)" or "cic0803"

echo.
echo ****************************downloading****************************
winscp.com /ini=nul /command ^
	"open ftp://root:cic0803@%%ip%%/" ^
	"get /HBpersistence/normal/generalPersistencyData_DiagnosticSWTController %%workdir%%\%%rawFile%%" ^
	"exit"

	rem errorlevel 9009 - winscp.com is not recoginized as internal or extrenal command
	rem errorlevel 1 - connection failure
echo errorlevel=%errorlevel%	

IF  %errorlevel%==1 (
	echo ***Connection failure, try other password
	winscp.com /ini=nul /command ^
	"open ftp://root:Hm83stN)@%%ip%%/" ^
	"get /HBpersistence/normal/generalPersistencyData_DiagnosticSWTController %%workdir%%\%%rawFile%%" ^
	"exit"
)
	
echo.
echo ****************************parsing****************************
Parse1bFile.exe %workdir%\%rawFile% %workdir%\%hexfile%

echo.
echo ****************************generateFSC****************************
cd %workdir%

REM Premium 0x28
REM Motion 0x47
REM Move 0x88
REM Next 0xA9
rem echo %version%
fsc.exe %hexfile% %version% 0xFF

cd ..	

:END