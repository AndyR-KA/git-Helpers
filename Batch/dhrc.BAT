@echo off
setlocal enabledelayedexpansion
set pipelineId=%1
if "%pipelineId%"=="" set pipelineId=136

for /f "tokens=*" %%i in ('git branch --show-current') do set branch=%%i


echo Running pipeline %pipelineId% on branch %branch%...
az pipelines run --project "darkhorse" --id %pipelineId% --branch "%branch%" --output json > pipeline_result.json

if not exist pipeline_result.json (
    echo Error: Failed to create pipeline_result.json
    pause
    exit /b 1
)

rem Extract the build ID using PowerShell for more reliable JSON parsing
for /f %%i in ('powershell -command "(Get-Content pipeline_result.json | ConvertFrom-Json).id"') do set buildId=%%i

echo Build ID: !buildId!

if "!buildId!"=="" (
    echo Error: Could not extract build ID from JSON
    type pipeline_result.json
    pause
    exit /b 1
)

del pipeline_result.json
echo Opening browser...
start "browser" "https://dev.azure.com/badhorse/Darkhorse/_build/results?buildId=!buildId!&view=results"


