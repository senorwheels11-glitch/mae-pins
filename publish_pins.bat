@echo off
rem Publishes the Pinterest pin images to GitHub Pages (account: senorwheels11-glitch).
rem Safe to re-run: if the repo already exists it just pushes any new images.
cd /d "%~dp0"

gh repo view senorwheels11-glitch/mae-pins >nul 2>&1
if errorlevel 1 (
  echo Creating public repository mae-pins and uploading the images...
  gh repo create mae-pins --public --source=. --push
) else (
  echo Repository already exists, pushing any changes...
  git push origin main
)

echo.
echo Turning on GitHub Pages...
gh api repos/senorwheels11-glitch/mae-pins/pages -X POST -f "source[branch]=main" -f "source[path]=/" >nul 2>&1

echo.
echo Waiting for the site to go live (this can take a minute or two)...
set /a tries=0
:check
curl -s -o nul -w "%%{http_code}" https://senorwheels11-glitch.github.io/mae-pins/retro-camping-clipart-cute-chibi_grid.png > "%TEMP%\mae_pins_status.txt"
set /p status=<"%TEMP%\mae_pins_status.txt"
if "%status%"=="200" goto done
set /a tries+=1
if %tries% GEQ 12 goto timeout
timeout /t 15 >nul
goto check

:done
echo.
echo DONE: images are live at https://senorwheels11-glitch.github.io/mae-pins/
echo You can now import pins_test.csv into Pinterest.
pause
exit /b 0

:timeout
echo.
echo Pages is not answering yet. Wait a few minutes, then open
echo https://senorwheels11-glitch.github.io/mae-pins/retro-camping-clipart-cute-chibi_grid.png in your browser.
echo If the image shows, you are fine; if not, tell me what you see.
pause
