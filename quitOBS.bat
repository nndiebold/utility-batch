@ECHO OFF 
SETLOCAL EnableDelayedExpansion

TITLE OBS AUTO SHUTDOWN SCRIPT

SET ShutdownTimer=300

GOTO ProcessQuit

:: =================================================
::     QUIT PROCEDURES
:: =================================================

:: Check if OBS is running, and if so, prompt user to ask if we can close it
:ProcessQuit
	:: Check if OBS is still running
	TASKLIST /FI "imagename eq obs64.exe" |find "obs64.exe" > nul && (
		:: OBS is currently running...
		GOTO RequestQuit
		:: NOP to ensure success "CALL "
		CALL 
	) || (
		:: OBS is not running... safe to exit!
		GOTO QuitSelf
	)


:: Ask user to confirm QUIT of OBS
:: https://stackoverflow.com/a/44999930
:RequestQuit
	CLS
	ECHO ========================================================================
	ECHO OBS will be forced to quit in %ShutdownTimer% seconds.
	ECHO Hold Y to speed up the countdown.
	ECHO Type N to keep OBS running.
	CHOICE /T 1 /C YN /D Y
	
	SET _e=%ERRORLEVEL%
	SET /A ShutdownTimer = %ShutdownTimer%-1
	
	IF %ShutdownTimer% LEQ 0 GOTO QuitOBS
	IF %_e%==2 GOTO QuitSelf
	
	GOTO RequestQuit


:: Close OBS and stop prompting
:QuitOBS
	ECHO ========================================================================
	ECHO Closing OBS...
	TASKKILL /F /IM "obs64.exe" && (
		:: OBS quit successfully!
		ECHO OBS has been closed. Good-bye.
		TIMEOUT /T 10
		GOTO :EOF
		:: NOP to ensure success "CALL "
		CALL 
	) || (
		:: OBS could not be quit...
		ECHO Unable to quit OBS.exe
		ECHO Did you already close OBS manually?
		TIMEOUT /T 10
		GOTO :EOF
	)

:: Say Good-bye
:QuitSelf
	ECHO ========================================================================
	ECHO Forced quit of OBS has been cancelled. Good-bye.
	TIMEOUT /T 10
	GOTO :EOF