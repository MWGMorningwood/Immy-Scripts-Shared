# Summary
Unifi Identity is the managed VPN/Wifi client for Unifi's flaship firewalls. [Learn More](https://ui.com/identity)  

> [!WARNING]  
> The scripts involved rely on immy.bot metascript functions that are only available in immy.bot.  
> This repository is for immy-specific PowerShell, and a generic version may be added elsewhere.

# Deployment Settings
## Software Info
* **Name**: `Unifi Identity`
* **Icon**: [UID Icon](https://play-lh.googleusercontent.com/GlNrRUsmkuYGZJtHsjMHACaQ1wEQr4X-9HZLm15Aq-2u-uEt17j_N21S_PhbUMrngFM)
## Version Detection
* **Detection Method**: `Regex`
  * **Upgrade Code**: `^Identity$|^Identity Enterprise$`
## Scripts
* **Installation**: `#1877 - Default MSI Install - With Log Stream - (Global)`
  * Select the dropdown and search for `Default MSI Install - With Log Stream` in the global repository.
* **Uninstallation**: `#1424 - Uninstall Software by Detection String - (Global)`
  * Select the dropdown and search for `Uninstall Software by Detection String` in the global repository.
* **Upgrade Strategy**: `Uninstall/Install` (as many existing installs will be EXE-based.)
## Advanced Settings
* **Dynamic Versions**: `#TBD - Unifi Identity Dynamic Versions Script - (Local)`
  * Select the checkbox for `Use dynamic versions`
  * Select `+ New` and paste the [Unifi Identity Dynamic Versions Script](./Unifi%20Identity%20Dynamic%20Versions%20Script.ps1)
