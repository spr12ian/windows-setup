# windows-setup

Open PowerShell as Administrator → navigate to the folder with the script.

Set-ExecutionPolicy Bypass -Scope Process -Force .\combo-setup.ps1


Key notes:
✅ Chocolatey handles most CLI tools + apps not in Winget.
✅ Winget is used for Chrome, Firefox, and GUI SQLite browser — those tend to be fresher via Winget.
✅ The script is idempotent — safe to run again later; it will skip what is already installed.
✅ Future maintenance:

powershell

choco upgrade all -y
winget upgrade --all --include-unknown
