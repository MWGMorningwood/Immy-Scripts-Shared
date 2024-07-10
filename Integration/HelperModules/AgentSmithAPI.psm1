function Get-SmithOrgID {
    try {
        $headers = @{
            'x-rewst-secret' = $IntegrationContext.SmithApiKey
        }
        $Orgs = Invoke-RestMethod -Uri $IntegrationContext.SmithOrgWebhook -Method Get -Headers $headers
        if ($Orgs.Response) {
            return $Orgs.Response
        } else {
            Write-Error "Response was null."
        }
    } catch {
        Write-Error "Error occurred while Getting Orgs: $_"
    }
}

function Get-SmithAgent {
    try {
        $headers = @{
            'x-rewst-secret' = $IntegrationContext.SmithApiKey
        }
        $Agents = Invoke-RestMethod -Uri $IntegrationContext.SmithAgentWebhook -Method Get -Headers $headers
        if ($Agents.Response) {
            return $Agents.Response
        } else {
            Write-Error "Response was null."
        }
    } catch {
        Write-Error "Error occurred while Getting Agents: $_"
    }
}

function Invoke-SmithCommand {
    param (
        [Parameter(Mandatory=$true)]
        [string]$agent,
        [Parameter(Mandatory=$true)]
        [string]$scriptCode
    )

    try {
        $headers = @{
            'x-rewst-secret' = $IntegrationContext.SmithApiKey
        }
        $body = @{
            'agent' = $agent
            'scriptCode' = $scriptCode
        }
        $Command = Invoke-RestMethod -Uri $IntegrationContext.SmithCommandWebhook -Method Post -Headers $headers -Body $body
        if ($Command.Response) {
            return $Command.Response
        } else {
            Write-Error "Response was null."
        }
    } catch {
        Write-Error "Error occurred while Getting Agents: $_"
    }
}

function Get-SmithAPIHealth {
    try {
        $headers = @{
            'x-rewst-secret' = $IntegrationContext.SmithApiKey
        }
        $response = Invoke-RestMethod -Uri $IntegrationContext.SmithHealthWebhook -Method Get -Headers $headers
        if ($response -match 'healthy') {
            return New-HealthyResult
        } else {
            return New-UnhealthyResult -Message "Error occurred while checking API health: $response"
        }
    } catch {
        Write-Error "Error occurred while checking API health: $_"
        New-UnhealthyResult -Message "Error occurred while checking API health: $_"
    }
}

Export-ModuleMember -Function @(
    'Get-SmithOrgID',
    'Get-SmithAgent',
    'Invoke-SmithCommand',
    'Get-SmithAPIHealth'
)
