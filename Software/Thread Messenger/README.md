# Summary
Thread Messenger is the client-facing chat support application for [Thread](https://getthread.com)  
You should already have your application ID from the [Messenger Installation](https://admin.getthread.com/dashboard/messenger/settings/installation) page.  
If you need to deploy a client-specific application, open that client in the admin center and use the application ID from there.  
[Understand the difference between Partner-level and Customer-level deployments](https://docs.getthread.com/article/2a21yr4emf-how-do-i-override-messenger-branding-and-configuration-for-a-customer).

> [!WARNING]  
> The scripts involved rely on immy.bot metascript functions that are only available in immy.bot.  
> This repository is for immy-specific PowerShell, and a generic version may be added elsewhere.

# Deployment Settings
## Software Info
* **Name**: `Thread Messenger`
* **Icon**: [Messenger Icon](https://6446646.fs1.hubspotusercontent-na1.net/hubfs/6446646/messenger-icon.svg)
## Version Detection
* **Detection Method**: `Upgrade Code`
  * **Upgrade Code**: `25fd42bc-9ea5-5754-99f5-9811da79ebf1`
## Scripts
* **Installation**: `#TBD - Thread Messenger Installation Script - (Local)`
  * Select `+ New` and paste the [Thread Messenger Installation Script](./Thread%20Messenger%20Installation%20Script.ps1)
  * **Script Execution Context**: `System`
* **Uninstallation**: `#993 - Uninstall MSI By UpgradeCode - (Global)`
  * Select the dropdown and search for `Uninstall MSI By UpgradeCode` in the global repository.
* **Upgrade Strategy**: `Uninstall/Install` (as directed by [System-level Install Considerations](https://docs.getthread.com/article/68gd2y9l0b-deploying-messenger-on-windows#what_to_consider_2))
* **Configuration Task**: `#TBD - Thread Messenger Configuration Task - (Local)`
  * Select `+ New`
  * Add a `Parameter`:
    * **Name**: `appId`
    * **Data Type**: `Text`
    * Select `Create Maintenance Task`
## Advanced Settings
* **Dynamic Versions**: `#TBD - Thread Messenger Dynamic Versions Script - (Local)`
  * Select the checkbox for `Use dynamic versions`
  * Select `+ New` and paste the [Thread Messenger Dynamic Versions Script](./Thread%20Messenger%20Dynamic%20Versions%20Script.ps1)
