# deploy-gh.ps1 — Helper script to initialize and push this site to GitHub
# Usage: Open PowerShell in the project folder and run: .\deploy-gh.ps1

param(
  [string]$RepoName = ''
)

function Check-Command($cmd) {
  try {
    Get-Command $cmd -ErrorAction Stop | Out-Null
    return $true
  } catch {
    return $false
  }
}

if (-not (Check-Command git)) {
  Write-Error "Git is not installed or not available in PATH. Install Git and try again."
  exit 1
}

# Initialize local repo if needed
if (-not (Test-Path .git)) {
  git init
  git add .
  git commit -m "Initial site commit"
  Write-Host "Initialized local git repository and made initial commit."
} else {
  Write-Host "Existing git repository found. Skipping init."
}

# If user provided a repo name and gh is available, try to create and push
if ($RepoName -ne '' -and (Check-Command gh)) {
  Write-Host "Creating GitHub repository: $RepoName"
  gh repo create $RepoName --public --source=. --remote=origin --push --confirm
  if ($LASTEXITCODE -eq 0) {
    Write-Host "Repository created and pushed."
    exit 0
  }
}

# If gh isn't available or repo name wasn't supplied, show manual commands
Write-Host "No remote created. To push to GitHub, run the following commands (replace USERNAME and REPO):"
Write-Host "git branch -M main"
Write-Host "git remote add origin https://github.com/USERNAME/REPO.git"
Write-Host "git push -u origin main"

Write-Host "Or run this script again with -RepoName 'USERNAME/REPO' if you have the 'gh' CLI installed and authenticated."
