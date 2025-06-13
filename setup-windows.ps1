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
    "Google.Chrome",
    "Mozilla.Firefox"
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

# --- Chocolatey installs ---
Write-Host "Installing apps via Chocolatey..."

foreach ($package in $chocoPackages) {
    choco install -y $package
}

# --- Winget installs ---
Write-Host "Installing apps via Winget..."

foreach ($package in $wingetPackages) {
    winget install --id $package -e --silent --accept-source-agreements
}

# Optional GUI SQLite Browser (if you want both CLI and GUI tools)
winget install --id DB Browser for SQLite.DB Browser for SQLite -e

# Reminders
Write-Host "`nTo upgrade all Chocolatey apps later: choco upgrade all -y"
Write-Host "To upgrade all Winget apps later: winget upgrade --all --include-unknown"

# Done!
Write-Host "`n=== Combo Setup Complete! ==="
