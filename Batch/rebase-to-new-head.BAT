@echo off
setlocal enabledelayedexpansion

echo.
echo Apply commits from one branch onto a new branch with a new base head
echo.

set "sourceBranch="
set /p sourceBranch=Enter source branch (branch with current changes):
if not defined sourceBranch (
    echo Error: source branch is required.
    pause
    exit /b 1
)

set "targetBranch="
set /p targetBranch=Enter new branch name to create/use:
if not defined targetBranch (
    echo Error: target branch is required.
    pause
    exit /b 1
)

set "newHead="
set /p newHead=Enter new head/base (commit, tag, or branch) for target branch:
if not defined newHead (
    echo Error: new head/base is required.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('git branch --show-current 2^>nul') do set "originalBranch=%%i"
if not defined originalBranch (
    echo Error: could not determine current git branch.
    pause
    exit /b 1
)

git rev-parse --verify "%sourceBranch%" >nul 2>&1
if errorlevel 1 (
    echo Error: source branch "%sourceBranch%" does not exist.
    pause
    exit /b 1
)

git rev-parse --verify "%newHead%" >nul 2>&1
if errorlevel 1 (
    echo Error: new head/base "%newHead%" does not exist.
    pause
    exit /b 1
)

set "commitListFile=%temp%\githelper_commits_%random%_%random%.txt"
git rev-list --reverse "%sourceBranch%" --not "%newHead%" > "%commitListFile%"
if errorlevel 1 (
    echo Error: failed to compute commits from "%sourceBranch%" not in "%newHead%".
    if exist "%commitListFile%" del "%commitListFile%"
    pause
    exit /b 1
)

set "hasCommits=0"
for /f "usebackq delims=" %%c in ("%commitListFile%") do (
    set "hasCommits=1"
    goto :has_commits
)

:has_commits
if "%hasCommits%"=="0" (
    echo No commits to apply. Source branch has no commits outside new head.
    if exist "%commitListFile%" del "%commitListFile%"
    pause
    exit /b 0
)

git show-ref --verify --quiet "refs/heads/%targetBranch%"
if not errorlevel 1 (
    echo Error: target branch "%targetBranch%" already exists. Use a new branch name.
    if exist "%commitListFile%" del "%commitListFile%"
    pause
    exit /b 1
)

echo Creating branch "%targetBranch%" from "%newHead%"...
git checkout -b "%targetBranch%" "%newHead%"

if errorlevel 1 (
    echo Error: failed to prepare target branch "%targetBranch%".
    if exist "%commitListFile%" del "%commitListFile%"
    pause
    exit /b 1
)

echo.
echo Applying commits from "%sourceBranch%" onto "%targetBranch%"...

for /f "usebackq delims=" %%c in ("%commitListFile%") do (
    echo Cherry-picking %%c
    git cherry-pick %%c
    if errorlevel 1 (
        echo.
        echo Cherry-pick failed at commit %%c.
        echo Resolve conflicts, then run: git cherry-pick --continue
        echo Or abort with: git cherry-pick --abort
        if exist "%commitListFile%" del "%commitListFile%"
        pause
        exit /b 1
    )
)

if exist "%commitListFile%" del "%commitListFile%"

echo.
echo Success: all source-only commits were applied to "%targetBranch%" based on "%newHead%".
echo Original branch was "%originalBranch%".
pause
exit /b 0
