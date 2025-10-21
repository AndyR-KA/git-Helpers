# Get current git branch
$branch = git branch --show-current

# Run the CI workflow on the current branch
gh workflow run ci.yml --ref $branch
Start-Sleep -Seconds 1
# Get the URL of the most recent workflow run for this branch
$runUrl = gh run list --workflow=ci.yml --branch=$branch --limit=1 --json url --jq ".[0].url"

# Open the workflow run URL in the default browser
Start-Process $runUrl