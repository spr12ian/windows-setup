# windows-setup

On a fresh Widows installation, first ensure Windows Update has downloaded and installed all that it can.

Open PowerShell as Administrator → navigate to the folder with the script.

Set-ExecutionPolicy Bypass -Scope Process -Force
.\windows-setup.ps1

Key notes:
✅ Chocolatey handles most CLI tools + apps not in Winget.
✅ Winget is used for Chrome, Firefox, and GUI SQLite browser — those tend to be fresher via Winget.
✅ The script is idempotent — safe to run again later; it will skip what is already installed.
✅ Future maintenance in PowerShell as Administrator:

choco upgrade all -y
winget upgrade --all --include-unknown

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

Some apps are not really suitable for automatics installation, and so should be manually installed if needed:

[Synology Assistant](https://www.synology.com/en-us/support/download)
To map a Z drive to your Synology NAS in Windows Explorer, follow these steps:

Enable SMB on Synology NAS:

Log into DSM (DiskStation Manager).

Go to Control Panel > File Services > SMB and ensure it's enabled.

Find Your NAS IP Address:

Open Control Panel > Network and note the IP address of your NAS.

Map the Network Drive in Windows:

Open File Explorer and right-click This PC.

Select Map network drive.

Choose Z: as the drive letter.

In the Folder field, enter \\YourNASIP\SharedFolderName (replace with your NAS IP and shared folder name).

Check Reconnect at sign-in if you want it to stay mapped.

Click Finish and enter your NAS credentials if prompted.
