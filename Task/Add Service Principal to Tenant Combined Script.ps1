$Header = Get-ImmyAzureAuthHeader
$SpBaseUri = "https://graph.microsoft.com/beta/servicePrincipals"
$AppId = "00000014-0000-0000-c000-000000000000"
$Body = @{ "appId" = $AppId } | ConvertTo-Json

try {
    Write-Host "Checking if 'Microsoft.Azure.SyncFabric' exists..."
    $FilteredUri = $SpBaseUri + "?`$filter=appId eq '$AppId'"
    $AppResult = Invoke-RestMethod -Uri $FilteredUri -Headers $Header -Method 'Get' -ContentType "application/json"
} catch {
    throw "Error occurred while retrieving the service principal: $_"
}

switch ($method) {
    'test' {
        if ($AppResult.value.Count -eq 0) {
            Write-Warning "'Microsoft.Azure.SyncFabric' not found"
            $false
        } else {
            Write-Host "'Microsoft.Azure.SyncFabric' is installed"
            $true
        }
    }
    'set' {
        Write-Host "Adding 'Microsoft.Azure.SyncFabric'..."
        try {
            $Response = Invoke-RestMethod -Uri $SpBaseUri -Headers $Header -Body $Body -Method 'Post' -ContentType "application/json"
            Write-Host "'Microsoft.Azure.SyncFabric' created successfully: $($Response.id)"
        } catch {
            throw "Error occurred while creating the application: $_"
        }
    }
}
