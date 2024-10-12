# Summary
Auvik is a network management and monitoring platform built for MSPs.  
This agent is meant to sit on endpoints to collect more data from the endpoint and report to the Auvik dashboard. [Learn More](https://auvik.com)  

> [!WARNING]  
> The scripts involved rely on immy.bot metascript functions that are only available in immy.bot.  
> This repository is for immy-specific PowerShell, and a generic version may be added elsewhere.

# Deployment Settings
## Software Info
* **Name**: `Auvik Endpoint Agent`
* **Icon**: [Auvik Icon](https://www.auvik.com/media-room/)
## Version Detection
* **Detection Method**: `Upgrade Code`
  * **Upgrade Code**: `5709cc19-bbab-4f78-94ee-51a5edde6b87`
## Scripts
* **Installation**: `#TBD - Auvik Endpoint Agent Install Script - (Local)`
  * Select `+ New` and paste the [Auvik Endpoint Agent Install Script](./Auvik%20Endpoint%20Agent%20Install%20Script.ps1)
* **Uninstallation**: `#993 - Uninstall MSI by Upgrade Code - (Global)`
  * Select the dropdown and search for `Uninstall Software by Detection String` in the global repository.
* **Upgrade Strategy**: `Uninstall/Install` (as many existing installs will be EXE-based.)
* **Configuration Task**: `#TBD - Auvik Endpoint Agent Configuration Task - (Local)`
  * Select `+ New`
  * Add a `Parameter`:
    * **Name**: `siteKey`
    * **Data Type**: `Text`
    * Select `Create Maintenance Task`
## Advanced Settings
* **Dynamic Versions**: `#TBD - Auvik Endpoint Agent Dynamic Versions Script - (Local)`
  * Select the checkbox for `Use dynamic versions`
  * Select `+ New` and paste the [Auvik Endpoint Agent Dynamic Versions Script](./Auvik%20Endpoint%20Agent%20Dynamic%20Versions%20Script.ps1)