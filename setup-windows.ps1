# Windows Setup Script — Chocolatey + Winget
# This will install Chocolatey if needed, then run Chocolatey and Winget installs.
# ------------------------------------------------
# Usage:
# 1) Open 'Terminal (Admin)' to get an elevated (Administrator) PowerShell.
# 2) cd to the path where windows-setup.ps1 exists
# 3) Set-ExecutionPolicy Bypass -Scope Process -Force
# 4) .\windows-setup.ps1

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
    @{ Id = "9NT1R1C2HH7J"; Source = "msstore" }, # ChatGPT
    @{ Id = "AutoHotkey.AutoHotkey"; Source = "winget" },
    @{ Id = "DBBrowserForSQLite.DBBrowserForSQLite"; Source = "winget" },
    @{ Id = "Google.Chrome"; Source = "winget" },
    @{ Id = "JAMSoftware.TreeSize.Free"; Source = "winget" },
    @{ Id = "Mozilla.Firefox"; Source = "winget" },
    @{ Id = "Piriform.Speccy"; Source = "winget" },
    @{ Id = "PrimateLabs.Geekbench.6"; Source = "winget" },
    @{ Id = "Vivaldi.Vivaldi"; Source = "winget" }
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
            winget install --id $package.Id --source $package.Source -e --silent --accept-package-agreements --accept-source-agreements
        } catch {
            Write-Host "Winget install failed for $package — skipping."
            $wingetFailures += $package
        }
    }
}

# --- Report any failures ---
if ($chocoFailures.Count -gt 0) {
    Write-Host "`nChocolatey installs failed for the following packages:"
    $chocoFailures | ForEach-Object { Write-Host "- $_" }
}

if ($wingetFailures.Count -gt 0) {
    Write-Host "`nWinget installs failed for the following packages:"
    $wingetFailures | ForEach-Object { Write-Host "- $_" }
}

# --- Reminders ---
Write-Host "`nTo upgrade all Chocolatey apps later: choco upgrade all -y"
Write-Host "To upgrade all Winget apps later: winget upgrade --all --include-unknown"

# --- Manual Installs ---
Write-Host "`nManual installs required:"
Write-Host "- Google Drive: https://www.google.com/drive/download/"
Write-Host "- Synology Assistant: https://www.synology.com/en-global/support/download/DS413j → Desktop Utilities → Synology Assistant"

# --- Final message + restart option ---
Write-Host "`n=== Windows Setup Complete! ==="
Write-Host "`nSetup is complete! Some installations may require a restart."
$restart = Read-Host "Would you like to restart now? (Y/N)"
if ($restart -match "[Yy]") {
    Restart-Computer -Force
}
