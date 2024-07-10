Get-ImmyComputer -InventoryKeys WindowsSystemInfo | ?{$_.Inventory.WindowsSystemInfo.DSRegStatus.DeviceState.AzureADJoined -eq "YES"}
