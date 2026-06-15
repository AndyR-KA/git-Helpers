@echo off
setlocal enabledelayedexpansion

for /f "tokens=*" %%i in ('git branch --show-current 2^>nul') do set "branch=%%i"
if not defined branch (
	echo Error: could not determine the current git branch.
	pause
	exit /b 1
)

set "remoteUrl="
for /f "tokens=*" %%i in ('git remote get-url origin 2^>nul') do set "remoteUrl=%%i"

set "repo="
echo !remoteUrl! | findstr /i "github.com" >nul
if not errorlevel 1 (
	for /f "tokens=*" %%i in ('gh repo view --json nameWithOwner --jq ".nameWithOwner" 2^>nul') do set "repo=%%i"
) else (
	set /p repo=Enter the GitHub repo name (owner/repo):
)

if not defined repo (
	echo Error: repository name is required.
	pause
	exit /b 1
)

echo Running CI workflow for !repo! on branch !branch!...
gh workflow run ci.yml --repo "!repo!" --ref "!branch!"
timeout /t 10 /nobreak >nul
gh run list --workflow=ci.yml --repo "!repo!" --branch="!branch!" --limit=1 --json url --jq ".[0].url" > temp_url.txt
set /p run_url=<temp_url.txt
del temp_url.txt
start msedge "!run_url!"