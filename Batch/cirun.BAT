@echo off
for /f "tokens=*" %%i in ('git branch --show-current') do set branch=%%i
gh workflow run ci.yml --ref %branch%
timeout /t 10 /nobreak >nul
gh run list --workflow=ci.yml --branch=%branch% --limit=1 --json url --jq ".[0].url" > temp_url.txt
set /p run_url=<temp_url.txt
del temp_url.txt
start msedge "%run_url%"