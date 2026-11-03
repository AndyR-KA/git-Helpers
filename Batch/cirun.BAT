@echo off
setlocal enabledelayedexpansion

set "ymlfile=%~1"
if not defined ymlfile set "ymlfile=ci"

for /f "tokens=*" %%i in ('git branch --show-current 2^>nul') do set "branch=%%i"
if not defined branch (
	echo Error: could not determine the current git branch.
	pause
	exit /b 1
)

set "repo="
echo current path: %cd%
for /f "tokens=4 delims=\\" %%i in ("%cd%") do set "repo=%%i"
echo determined repo: !repo!
if not defined repo (
	echo Error: could not determine repository name from current path: %cd%
	pause
	exit /b 1
)


set "repo=kineticadvantagedev/!repo!"

echo Running CI workflow for !repo! on branch !branch!...
gh workflow run "!ymlfile!.yml" --repo "!repo!" --ref "!branch!"
timeout /t 10 /nobreak >nul
gh run list --workflow="!ymlfile!.yml" --repo "!repo!" --branch="!branch!" --limit=1 --json url --jq ".[0].url" > temp_url.txt
set /p run_url=<temp_url.txt
del temp_url.txt
start msedge "!run_url!"