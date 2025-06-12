# Combo Setup Script for Ian — Chocolatey + Winget
# ------------------------------------------------
# Usage:
# 1. Run this script in an elevated PowerShell (Run as Administrator).
# 2. It will install Chocolatey if needed, then run Chocolatey and Winget installs.

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

# Core Utilities
choco install -y git
choco install -y vscode
choco install -y 7zip
choco install -y notepadplusplus
choco install -y vlc

# Developer Tools
choco install -y python --version=3.12.3
choco install -y nodejs-lts
choco install -y docker-desktop
choco install -y make
choco install -y openssh

# Data / Database Tools
choco install -y sqlite
choco install -y dbeaver

# Utilities / Power User Tools
choco install -y powertoys
choco install -y windirstat
choco install -y sysinternals
choco install -y everything

# Optional / Blogging
choco install -y hugo-extended

# Security / Maintenance
choco install -y malwarebytes

# --- Winget installs ---
Write-Host "Installing apps via Winget..."

# Core Utilities
winget install --id Google.Chrome -e
winget install --id Mozilla.Firefox -e

# Optional GUI SQLite Browser (if you want both CLI and GUI tools)
winget install --id DB Browser for SQLite.DB Browser for SQLite -e

# Reminders
Write-Host "`nTo upgrade all Chocolatey apps later: choco upgrade all -y"
Write-Host "To upgrade all Winget apps later: winget upgrade --all --include-unknown"

# --- WSL Setup Checklist ---
# Recommended steps to run after Windows + Chocolatey + Winget setup:
#
# 1️⃣ Update WSL platform:
#    wsl --install --no-distribution
#
# 2️⃣ Check WSL version + kernel:
#    wsl --version
#    wsl --list --verbose
#
# 3️⃣ Install desired distro (if not already installed):
#    wsl --install -d Ubuntu
#
# 4️⃣ Inside WSL (Ubuntu), run first update:
#    sudo apt update && sudo apt upgrade -y
#    sudo apt autoremove -y
#
# 5️⃣ Optional: convert existing distros to WSL 2:
#    wsl --set-version <distro name> 2
#
# Notes:
# - Kernel 6.6.x or newer is great.
# - WSLg is enabled (you can run Linux GUI apps if needed).
# - Use VS Code with Remote - WSL extension for best dev experience.

# Google Drive — manual install recommended:
# https://www.google.com/drive/download/

# Done!
Write-Host "`n=== Combo Setup Complete! ==="
