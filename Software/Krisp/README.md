# Summary
Krisp is a high-quality noise cancellation software. [Learn More](https://krisp.ai)  

> [!WARNING]  
> The scripts involved rely on immy.bot metascript functions that are only available in immy.bot.  
> This repository is for immy-specific PowerShell, and a generic version may be added elsewhere.

# Deployment Settings
## Software Info
* **Name**: `Krisp`
* **Icon**: [Krisp Icon](https://help.krisp.ai/hc/article_attachments/4529355793180)
## Version Detection
* **Detection Method**: `Upgrade Code`
  * **Upgrade Code**: `2726b11d-3adc-4d53-8fa1-141911193a8d`
## Scripts
* **Installation**: `#1877 - Default MSI Install - With Log Stream - (Global)`
  * Select the dropdown and search for `Default MSI Install - With Log Stream` in the global repository.
* **Uninstallation**: `#1424 - Uninstall Software by Detection String - (Global)`
  * Select the dropdown and search for `Uninstall Software by Detection String` in the global repository.
* **Upgrade Strategy**: `Uninstall/Install` (as many existing installs will be EXE-based.)
## Advanced Settings
* **Dynamic Versions**: `#TBD - Krisp Dynamic Versions Script - (Local)`
  * Select the checkbox for `Use dynamic versions`
  * Select `+ New` and paste the [Krisp Dynamic Versions Script](./Krisp%20Dynamic%20Versions%20Script.ps1)
