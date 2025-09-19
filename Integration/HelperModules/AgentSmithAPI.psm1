function Get-SmithOrgID {
    <#
        .SYNOPSIS
        Retrieves a list of all organization IDs from the Agent Smith API.

        .DESCRIPTION
        Retrieves a list of all organization IDs from the Agent Smith API.

        .INPUTS
        None. You can't pipe objects to Get-SmithOrgID.

        .OUTPUTS
        System.Object[]    Get-SmithOrgID returns a list of organization IDs.

        .EXAMPLE
        PS> Get-SmithOrgID
        @{123456, 789012, 345678}
    #>

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
    <#
        .SYNOPSIS
        Retrieves a list of all agents from the Agent Smith API.

        .DESCRIPTION
        Retrieves a list of all agents from the Agent Smith API.

        .INPUTS
        None. You can't pipe objects to Get-SmithAgent.

        .OUTPUTS
        System.Object[]    Get-SmithAgent returns a list of agents.

        .EXAMPLE
        PS> Get-SmithAgent
        @{agent1, agent2, agent3}
    #>
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
    <#
        .SYNOPSIS
        Invokes a command on a specified agent via the Agent Smith API.

        .DESCRIPTION
        Invokes a command on a specified agent via the Agent Smith API.

        .PARAMETER agent
        The ID of the agent to run the command on.

        .PARAMETER scriptCode
        The script code to execute on the agent.

        .INPUTS
        None. You can't pipe objects to Invoke-SmithCommand.

        .OUTPUTS
        System.String    Invoke-SmithCommand returns the response from the command execution.

        .EXAMPLE
        PS> Invoke-SmithCommand -agent "agent1" -scriptCode "Get-Process"
        Process1, Process2, Process3
    #>
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
    <#
        .SYNOPSIS
        Checks the health of the Agent Smith API.

        .DESCRIPTION
        Checks the health of the Agent Smith API.

        .INPUTS
        None. You can't pipe objects to Get-SmithAPIHealth.

        .OUTPUTS
        .HealthResult    Get-SmithAPIHealth returns a HealthResult indicating the health status of the API.

        .EXAMPLE
        PS> Get-SmithAPIHealth
        Healthy
    #>
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