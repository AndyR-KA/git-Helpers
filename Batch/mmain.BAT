@echo off
for /f "tokens=*" %%i in ('git branch --show-current') do set branch=%%i
git checkout main && git pull
git checkout %branch%
git merge main