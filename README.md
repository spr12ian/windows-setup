# windows-setup

Open PowerShell as Administrator → navigate to the folder with the script.

Set-ExecutionPolicy Bypass -Scope Process -Force
.\windows-setup.ps1


Key notes:
✅ Chocolatey handles most CLI tools + apps not in Winget.
✅ Winget is used for Chrome, Firefox, and GUI SQLite browser — those tend to be fresher via Winget.
✅ The script is idempotent — safe to run again later; it will skip what is already installed.
✅ Future maintenance:

powershell

choco upgrade all -y
winget upgrade --all --include-unknown

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
