$owner = "azure"
$repo  = "azure-cli"

# 1. Fetch the UI URL and parse the exact redirection path
$url = [string]::Format("https://github.com/{0}/{1}/releases/latest", $owner, $repo)
$request = [System.Net.WebRequest]::Create($url)
$request.AllowAutoRedirect = $false
try {
    $response = $request.GetResponse()
    $redirectUrl = $response.GetResponseHeader("Location")
    $response.Close()
} catch {
    $redirectUrl = $_.Exception.InnerException.Response.Headers.Location
}

# 2. Extract the clean tag name out of the URL string path
$tag = ($redirectUrl -split "/tag/")[-1]

# 3. Query the remote repository for that specific tag using Git
$remoteUrl = [string]::Format("https://github.com/{0}/{1}.git", $owner, $repo)
$gitOutput = git ls-remote --tags $remoteUrl $tag

# 4. FIXED: Use a precise RegEx match to capture the entire 40-character SHA string safely
if ($gitOutput -match "([a-f0-9]{40})") {
    $sha = $Matches[1]
} else {
    $sha = "SHA could not be parsed"
}

# 5. Output completely clean and validated variables
Write-Host "---------------------------------------"
Write-Host "Target Repository:  $owner/$repo"
Write-Host "Latest Release Tag: $tag"
Write-Host "Target Commit SHA:  $sha"
Write-Host "---------------------------------------"