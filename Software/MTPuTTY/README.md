# Summary
MTPuTTY (Multi-Tabbed PuTTY) is a small *FREE* utility enabling you to wrap unlimited number of PuTTY applications in one tabbed GUI interface. 
You are still continue using your favorite SSH client, but you are no longer messing around with PuTTY windows - each window will be opened in a separate tab.  
[Read More](https://ttyplus.com/multi-tabbed-putty/)

> [!WARNING]  
> The scripts involved rely on immy.bot metascript functions that are only available in immy.bot.  
> This repository is for immy-specific PowerShell, and a generic version may be added elsewhere.

# Deployment Settings
## Software Info
* **Name**: `MTPuTTY`
* **Icon**: [MTPuTTY Icon](https://community.chocolatey.org/content/packageimages/mtputty.1.6.1.176.png)
## Version Detection
* **Detection Method**: `Display Name`
  * **Display Name Contains**: `MTPuTTY`
## Scripts
* **Installation**: `#TBD - MTPuTTY Installation Script - (Local)`
  * Select `+ New` and paste the [MTPuTTY Installation Script](./MTPuTTy%20Installation%20Script.ps1)
  * **Script Execution Context**: `Metascript`
* **Uninstallation**: `#1331 - Uninstall Software by Name - (Global)`
  * Select the dropdown and search for `Uninstall Software by Name` in the global repository.
* **Upgrade Strategy**: `Install Over` (tested)
* **Configuration Task**: N/A
## Advanced Settings
* **Dynamic Versions**: `#TBD - MTPuTTY Dynamic Versions Script - (Local)`
  * Select the checkbox for `Use dynamic versions`
  * Select `+ New` and paste the [MTPuTTY Dynamic Versions Script](./MTPuTTy%20Dynamic%20Versions%20Script.ps1)