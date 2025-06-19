# Requires -PSEdition Core and needs administrator privileges
# Windows Setup Script — Chocolatey + Winget
# ------------------------------------------------
# This will install Chocolatey if needed, then run Chocolatey and Winget installs.

# --- Require PowerShell 7+ ---
if ($PSVersionTable.PSEdition -ne 'Core' -or $PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "❌ This script requires PowerShell 7 or higher. You are using $($PSVersionTable.PSVersion)."
    Write-Host "Download it from https://aka.ms/powershell"
    exit 1
}

# --- Require Elevated Privileges ---
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ This script must be run as Administrator."
    exit 1
}

# ------------------------------------------------
# Usage:
# 1) Open 'Terminal (Admin)' to get an elevated (Administrator) PowerShell.
# 2) cd to the path where windows-setup.ps1 exists
# 3) Set-ExecutionPolicy Bypass -Scope Process -Force
# 4) .\windows-setup.ps1
# ------------------------------------------------

# everything is a search utility
# revisit sysinternals
$chocoPackages = @(
    "7zip", "dbeaver", "everything", "git", "hugo-extended",
    "make", "malwarebytes", "nodejs-lts", "notepadplusplus", "openssh",
    "powertoys", "python", "sqlite", "vlc", "vscode", "windirstat"
)

$wingetPackages = @(
    @{ Id = "9NT1R1C2HH7J"; Source = "msstore" }, # ChatGPT
    @{ Id = "AutoHotkey.AutoHotkey"; Source = "winget" },
    @{ Id = "DBBrowserForSQLite.DBBrowserForSQLite"; Source = "winget" },
    @{ Id = "Google.Chrome"; Source = "winget" },
    @{ Id = "JAMSoftware.TreeSize.Free"; Source = "winget" },
    @{ Id = "Microsoft.PowerShell"; Source = "winget" },
    @{ Id = "Mozilla.Firefox"; Source = "winget" },
    @{ Id = "Piriform.Speccy"; Source = "winget" },
    @{ Id = "PrimateLabs.Geekbench.6"; Source = "winget" },
    @{ Id = "Vivaldi.Vivaldi"; Source = "winget" }
)

function Install-ChocoPackages {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$Packages
    )

    $failures = @()

    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    } else {
        Write-Host "Chocolatey already installed."
    }

    choco upgrade chocolatey -y
    choco upgrade all -y

    Write-Host "Installing apps via Chocolatey..."
    foreach ($package in $Packages) {
        Write-Host "Installing $package via Chocolatey..."
        $output = choco install -y $package --ignore-existing 2>&1
        $exitCode = $LASTEXITCODE

        if ($exitCode -eq 0) {
            Write-Host "✅ $package installed successfully."
        } elseif ($output -match '(?i)(already installed|use --force|latest version available)') {
            Write-Host "✔️ $package is already installed."
        } else {
            Write-Host "❌ $package failed to install:"
            Write-Host $output
            $failures += $package
        }
    }

    return $failures
}

function Install-WingetPackages {
    param (
        [Parameter(Mandatory = $true)]
        [array]$Packages
    )

    $failures = @()

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "Winget is not installed or unavailable."
        return $Packages | ForEach-Object { $_.Id }
    }

    Write-Host "Installing apps via Winget..."
    foreach ($package in $Packages) {
        $id = $package.Id
        $source = $package.Source

        Write-Host "Installing $id from $source via Winget..."
        try {
            $output = & winget install --id $id --source $source -e --silent --accept-package-agreements --accept-source-agreements 2>&1
            $exitCode = $LASTEXITCODE

            if ($exitCode -ne 0) {
                if ($output -match "already installed" -or $output -match "No applicable update found") {
                    Write-Host "✔️ $id is already installed or up to date."
                } else {
                    Write-Host "❌ $id failed to install via Winget:"
                    Write-Host $output
                    $failures += $id
                }
            } else {
                Write-Host "✅ $id installed successfully."
            }
        } catch {
            Write-Host "❌ $id threw an exception during install:"
            Write-Host $_.Exception.Message
            $failures += $id
        }
    }

    return $failures
}

# --- Install using Chocolatey ---
$chocoFailures = Install-ChocoPackages -Packages $chocoPackages

# --- Install using Winget ---
$wingetFailures = Install-WingetPackages -Packages $wingetPackages

# --- Report any failures ---
if ($chocoFailures.Count -gt 0) {
    Write-Host "`n❗ $($chocoFailures.Count) Chocolatey installs failed for:"
    $chocoFailures | ForEach-Object { Write-Host "- $_" }
}

if ($wingetFailures.Count -gt 0) {
    Write-Host "`n❗ $($wingetFailures.Count) Winget installs failed for:"
    $wingetFailures | ForEach-Object { Write-Host "- $_" }
}

# --- Reminders ---
Write-Host "`n🔄 To upgrade all Chocolatey apps later: choco upgrade all -y"
Write-Host "🔄 To upgrade all Winget apps later: winget upgrade --all --include-unknown"

# --- Manual installs ---
Write-Host "`n📦 Manual installs required:"
Write-Host "- Google Drive: https://www.google.com/drive/download/"
Write-Host "- Synology Assistant: https://www.synology.com/en-global/support/download/DS413j → Desktop Utilities → Synology Assistant"

# --- Final message + optional restart ---
Write-Host "`n✅ Windows Setup Complete!"
$restart = Read-Host 'Would you like to restart now? (Y/N)'
if ($restart -match '[Yy]') {
    Restart-Computer -Force
}
