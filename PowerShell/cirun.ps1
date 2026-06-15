# Get current git branch
write-host "starting ci run"
$branch = git branch --show-current

$remoteUrl = git remote get-url origin 2>$null
if ($remoteUrl -match 'github\.com') {
    $repo = gh repo view --json nameWithOwner --jq '.nameWithOwner'
}
else {
    $repo = Read-Host 'Enter the GitHub repo name (owner/repo)'
}

if (-not $repo) {
    Write-Error 'Repository name is required.'
    exit 1
}

# Run the CI workflow on the current branch
gh workflow run ci.yml --repo $repo --ref $branch
Start-Sleep -Seconds 1
# Get the URL of the most recent workflow run for this branch
$runUrl = gh run list --workflow=ci.yml --repo $repo --branch=$branch --limit=1 --json url --jq ".[0].url"

# Open the workflow run URL in the default browser
Start-Process $runUrl