<#
    Summary: Inventories local built-in "Administrator" group members, resolves any SIDs that correspond to Entra ID roles in the process
    Script Type: Device Inventory-Metascript
    Dependencies: Get-EntraIDObjectByGuidArray, Convert-AzureAdSidToObjectId
    Author: Stephen Moody
#>

# Get-LocalGroupMembers built-in cmdlet has a bug and fails if there are any unresolved Entra SIDs
$administrators = Invoke-Immycommand {
    $administrators = @(
            ([ADSI]"WinNT://./Administrators").psbase.Invoke('Members') |
            ForEach-Object {
                $_.GetType().InvokeMember('AdsPath', 'GetProperty', $null, $($_), $null)
            }
        ) -match '^WinNT';
    $administrators
}

$administrators = $administrators -replace 'WinNT://', ''

# Get unresolved Entra-formatted SIDs and convert to GUIDs.
# See https://oliverkieselbach.com/2020/05/13/powershell-helpers-to-convert-azure-ad-object-ids-and-sids/
$EntraGUIDTable = $administrators -match "S-1-12-1*" | ForEach-Object {
        $object = New-Object -TypeName PSObject
        $guid = Convert-AzureAdSidToObjectId -Sid $_
        $object | Add-Member -MemberType NoteProperty -Name Guid -Value $guid
        $object | Add-Member -MemberType NoteProperty -Name Sid -Value $_
        return $object
    }

# Get array of Entra objects that correlate to these GUIDs, in a single batch using Graph's /directoryObjects/getByIds endpoint
$EntraObjects = Get-EntraIDObjectByGuidArray -GuidArray $($EntraGUIDTable.guid)

# For each entry, we'll replace with the friendly info if we have it, or mark as unknown
foreach ($Entry in $EntraGUIDTable) {
    $EntraObject = $EntraObjects | Where-Object {$_.id -match $Entry.Guid }
    if ($EntraObject) {
        $administrators = $administrators -replace $($Entry.Sid),"[$($EntraObject.'@odata.type')] $($EntraObject.displayName)"
    } else {
        $administrators = $administrators -replace $($Entry.Sid),"$($Entry.Sid) (Unknown Entra GUID $($Entry.Guid))"
    }
}

$administrators -join "`r`n" | Out-String
