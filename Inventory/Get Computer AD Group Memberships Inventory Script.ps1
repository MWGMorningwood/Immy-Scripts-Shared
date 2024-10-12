<#
    Summary: If the computer is part of an AD domain, queries a Domain Controller and provides a list of all Group memberships for the computer.
        Pair with a filter script in order to target deployments at machines that are members of an AD group.
    Script Type: Device Inventory-Metascript
    Dependencies: Get-ImmyADComputerGroups
    Author: Stephen Moody
#>
$PartofDomain = Invoke-ImmyCommand { (Get-CimInstance win32_computersystem).PartOfDomain }

if ($PartofDomain) {
    $groups = Get-ImmyADComputerGroups -ComputerName $ComputerName
    $($groups.name) -join "`r`n" | Out-String
} else {
    return $null
}