# Domotz doesn't give us a true version number anywhere very visible. Appears the agent has its own bootstrapped update engine. 
# So we just look to see if it's installed and return a pseudo version.
# MetaScript

$Computer = Get-ImmyComputer -InventoryKeys Software

$software = $Computer.Inventory.Software | ? {"Domotz Agent" -in $_.DisplayName}

if ($software) {
    $Version = 1.0.0 #Installed
    $Version
}