 <#
.SYNOPSIS
Gets associated Entra ID objects for an input list of GUIDs

.DESCRIPTION
Returns an array of objects corresponding to the input GUIDs from the Entra ID tenant

.PARAMETER GuidArray
An array of 1 or more GUIDs to look up
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [String[]]
    $GuidArray
)

$Headers = Get-ImmyAzureAuthHeader
$GraphURI = "https://graph.microsoft.com/beta/directoryObjects/getByIds"

$Body = @{
    ids = $GuidArray
} | ConvertTo-Json

$objects = Invoke-RestMethod -Uri $GraphURI -Headers $Headers -Method Post -ContentType "application/json" -Body $Body  | select -ExpandProperty Value

return $objects