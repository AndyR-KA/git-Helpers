# Get current git branch
$branch = git branch --show-current

# Run GitHub workflow
gh workflow run ci.yml --ref $branch

# Run Azure Pipeline and capture the JSON output
$pipelineResult = az pipelines run --project "darkhorse" --id 136 --branch $branch --output json | ConvertFrom-Json

# Extract the build ID and construct the URL
$buildId = $pipelineResult.id
$buildUrl = "https://dev.azure.com/badhorse/Darkhorse/_build/results?buildId=$buildId&view=results"

# Open the build results URL in the default browser
Start-Process $buildUrl