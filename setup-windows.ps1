# Windows Setup Script — Chocolatey + Winget
# ------------------------------------------------
# Usage:
# 1. Run this script in an elevated PowerShell (Run as Administrator).
# 2. It will install Chocolatey if needed, then run Chocolatey and Winget installs.

$chocoPackages = @(
    "7zip",
    "dbeaver",
    "docker-desktop",
    "everything",
    "git",
    "hugo-extended",
    "make",
    "malwarebytes",
    "nodejs-lts",
    "notepadplusplus",
    "openssh",
    "powertoys",
    "python",
    "sqlite",
    "sysinternals",
    "vlc",
    "vscode",
    "windirstat"
)

$wingetPackages = @(
    "DBBrowserForSQLite.DBBrowserForSQLite" # Optional GUI SQLite Browser (if you want both CLI and GUI tools),
    "Google.Chrome",
    "Mozilla.Firefox",
    "Vivaldi.Vivaldi"
)

# --- Ensure Chocolatey is installed ---
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey already installed."
}

choco upgrade chocolatey -y
choco upgrade all -y

# --- Chocolatey installs ---
    
Write-Host "Installing apps via Chocolatey..."
$chocoFailures = @()

foreach ($package in $chocoPackages) {    
    if (!(choco install -y $package --ignore-existing)) {
        $chocoFailures += $package
    }
}

# --- Winget installs ---
    
$wingetFailures = @()

if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Winget is not installed or unavailable."
} else {
    Write-Host "Installing apps via Winget..."

    foreach ($package in $wingetPackages) {
        try {
            Write-Host "Installing $package via Winget..."
            winget install --id $package -e --silent --accept-source-agreements
        } catch {
            Write-Host "Winget install failed for $package — skipping."
            $wingetFailures += $package
        }
    }

}
    
if ($chocoFailures.Count -gt 0) {
    Write-Host "`nChocolatey installs failed for the following packages:"
    $chocoFailures | ForEach-Object { Write-Host "- $_" }
}
    
if ($wingetFailures.Count -gt 0) {
    Write-Host "`nWinget installs failed for the following packages:"
    $wingetFailures | ForEach-Object { Write-Host "- $_" }
}

# Reminders
Write-Host "`nTo upgrade all Chocolatey apps later: choco upgrade all -y"
Write-Host "To upgrade all Winget apps later: winget upgrade --all --include-unknown"

# Done!
Write-Host "`n=== Windows Setup Complete! ==="
Write-Host "`nSetup is complete! A system restart may be required for some installations."

