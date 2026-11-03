@echo off
git checkout main && git pull
if errorlevel 1 exit /b
if "%~1"=="" exit /b

git show-ref --verify --quiet "refs/heads/%~1"
if errorlevel 1 (
	git checkout -b "%~1"
) else (
	git checkout "%~1" && git pull
)