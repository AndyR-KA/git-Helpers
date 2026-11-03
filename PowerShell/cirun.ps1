# Get current git branch
write-host "starting ci run"
$branch = git branch --show-current

$pathParts = (Get-Location).Path -split '[\\/]'
if ($pathParts.Length -ge 3) {
    $repo = $pathParts[3]
}

if (-not $repo) {
    Write-Error "Could not determine repository name from current path: $((Get-Location).Path)"
    exit 1
}

if ($repo -notmatch '/') {
    $repo = "kineticadvantagedev/$repo"
}

# Run the CI workflow on the current branch
gh workflow run ci.yml --repo $repo --ref $branch
Start-Sleep -Seconds 2
# Get the URL of the most recent workflow run for this branch
$runUrl = gh run list --workflow=ci.yml --repo $repo --branch=$branch --limit=1 --json url --jq ".[0].url"

# Open the workflow run URL in the default browser
Start-Process $runUrl