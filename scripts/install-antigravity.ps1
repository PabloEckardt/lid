$ErrorActionPreference = "Stop"

Write-Host "=> Installing Linked-Intent Development (LID) for Antigravity (Gemini IDE)..."

$InstallDir = Join-Path $env:LOCALAPPDATA "lid"
$GeminiPluginsDir = Join-Path $env:USERPROFILE ".gemini\config\plugins"

# 1. Clone or update the repository
if (Test-Path $InstallDir) {
    Write-Host "=> LID repository already exists at $InstallDir. Pulling latest changes..."
    Push-Location $InstallDir
    git pull origin main --quiet
    Pop-Location
} else {
    Write-Host "=> Cloning LID repository to $InstallDir..."
    git clone https://github.com/PabloEckardt/lid $InstallDir --quiet
}

# 2. Ensure Gemini plugins directory exists
if (-not (Test-Path $GeminiPluginsDir)) {
    New-Item -ItemType Directory -Force -Path $GeminiPluginsDir | Out-Null
}

# 3. Create junctions (works without admin privileges unlike symlinks)
Write-Host "=> Setting up Antigravity plugin junctions..."
$plugins = @("linked-intent-dev", "arrow-maintenance", "lid-experimental")

foreach ($plugin in $plugins) {
    $Target = Join-Path $GeminiPluginsDir $plugin
    $Source = Join-Path $InstallDir "plugins\$plugin"
    
    if (Test-Path $Target) {
        Remove-Item -Recurse -Force $Target
    }
    
    New-Item -ItemType Junction -Path $Target -Target $Source | Out-Null
    Write-Host "   - Linked $plugin"
}

Write-Host "`n=> Success! The LID plugins have been installed."
Write-Host "=> Please restart Antigravity (Gemini IDE) to load the new skills."
