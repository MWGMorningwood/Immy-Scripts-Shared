############################
# Author: Logan@bezalu.com #
############################

$Integration = New-DynamicIntegration -Init {
    param(
        [Parameter(Mandatory = $false, HelpMessage='URL of the repo containing Agent Smith releases')]
        [String]$GitRepoURL = 'https://github.com/RewstApp/rewst_remote_agent',

        [Parameter(Mandatory = $true, HelpMessage='URL of the Agent Registration Workflow trigger')]
        [String]$RegistrationWebhook,

        [Parameter(Mandatory = $true, HelpMessage='Org Secret set in Rewst')]
        [String]$RegistrationSecret,

        [Parameter(Mandatory = $true, HelpMessage='URL of `Get_Orgs` trigger of the Foghorn Workflow')]
        [String]$OrgWebhook,

        [Parameter(Mandatory = $true, HelpMessage='URL of `Health_Check` trigger of the Foghorn Workflow')]
        [String]$HealthWebhook,

        [Parameter(Mandatory = $true, HelpMessage='URL of `Get_Agents` trigger of the Foghorn Workflow')]
        [String]$AgentsWebhook,

        [Parameter(Mandatory = $true, HelpMessage='URL of `Run_Command` trigger of the Foghorn Workflow')]
        [String]$CommandWebhook,

        [Parameter(Mandatory = $true, HelpMessage='Org Secret set in Rewst')]
        [Password(StripValue)]$ApiKey
    )
    Write-Host "Initializing Agent Smith"
    $IntegrationContext.SmithApiKey = $ApiKey
    $IntegrationContext.SmithHealthWebhook = $HealthWebhook
    $IntegrationContext.SmithOrgWebhook = $OrgWebhook
    $IntegrationContext.SmithAgentWebhook = $AgentsWebhook
    $IntegrationContext.SmithCommandWebhook = $CommandWebhook
    $IntegrationContext.SmithRegistrationWebhook = $RegistrationWebhook
    $IntegrationContext.SmithRegistrationSecret = $RegistrationSecret
    $IntegrationContext.SmithGitRepoURL = $GitRepoURL

    [OpResult]::Ok()
} -HealthCheck {
    Import-Module AgentSmithAPI
    Get-SmithAPIHealth
}

$Integration | Add-DynamicIntegrationCapability -Interface ISupportsListingClients -GetClients {
    [ScriptTimeout(TimeoutSeconds = 300)]
    [CmdletBinding()]
    [OutputType([IProviderClientDetails[]])]
    param()
    try{
        Import-Module AgentSmithAPI
        $Orgs = Get-SmithOrgID
        $managingOrgAdded = $false
        $Orgs | ForEach-Object {
            if (!$managingOrgAdded -and $_.managingOrg.id -and $_.managingOrg.name) {
                New-IntegrationClient -ClientId $_.managingOrg.id -ClientName $_.managingOrg.name
                $managingOrgAdded = $true
            }
            if ($_.id -and $_.name) {
                New-IntegrationClient -ClientId $_.id -ClientName $_.name
            } else {
                Write-Error "Not enough data for $_"
            }
        }
    }
    catch{
        $_ | Out-String | Write-Host
    }
}

$Integration | Add-DynamicIntegrationCapability -Interface ISupportsListingAgents -GetAgents {
    [CmdletBinding()]
    [OutputType([IProviderAgentDetails[]])]
    param(
        [Parameter(Mandatory)]
        [string[]]$clientIds
    )
    Import-Module AgentSmithAPI

    $currentTime = Get-Date

    Get-SmithAgent | ForEach-Object {
        $timestampDateTime = [DateTime]::Parse($_.Timestamp)
        $timeDifference = $currentTime - $timestampDateTime
        $online = ($timeDifference.TotalMinutes -le 5)

        New-IntegrationAgent `
            -Name $_.hostname `
            -OSName $_.license_type `
            -ClientId $_.org_id `
            -AgentId $_.device_id `
            -IsOnline $online `
            -SupportsRunningScripts $true
    }
}

$Integration | Add-DynamicIntegrationCapability -Interface ISupportsInventoryIdentification -GetInventoryScript {
    [CmdletBinding()]
    [OutputType([scriptblock])]
    param()
    Invoke-ImmyCommand {
        # implement a script block that should retrieve the agent identifier for this integration.
        Get-Content "C:\ProgramData\RewstRemoteAgent\*\config.json" | ConvertFrom-Json | ForEach-Object {$_.device_id}
    }
}

$Integration | Add-DynamicIntegrationCapability -Interface ISupportsDynamicVersions -GetDynamicVersions {
    [CmdletBinding()]
    [OutputType([Immybot.Backend.Domain.Models.DynamicVersion[]])]
    param(
        [Parameter(Mandatory=$True)]
        [System.String]$externalClientId
    )

    $version = Get-DynamicVersionsFromGitHubUrl `
    -GitHubReleasesUrl "$($IntegrationContext.SmithGitRepoURL)/releases" `
    -VersionsPattern ('(?<Uri>'+$IntegrationContext.SmithGitRepoURL+'/releases/download/v(?<Version>[\d\.]+)/(?<FileName>rewst_agent_config.win.exe))')
    return $version.Versions
}

$Integration |  Add-DynamicIntegrationCapability -Interface ISupportsTenantInstallToken -GetTenantInstallToken {
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory=$true)]
        [string]$clientId
    )
    $properties = @{
        secret = $IntegrationContext.SmithRegistrationSecret
        webhook = $IntegrationContext.SmithRegistrationWebhook
    }
    $object = New-Object -TypeName PSObject -Property $properties
    return ($object | ConvertTo-Json)
}

$Integration | Add-DynamicIntegrationCapability -Interface IRunScriptProvider -RunScript {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [IProviderAgentDetails]$agent,
        [Parameter(Mandatory)]
        [string]$scriptCode,
        [Parameter(Mandatory)]
        [ScriptLanguage]$scriptLanguage,
        [Parameter(Mandatory)]
        [int]$timeout,
        [Parameter(Mandatory)]
        [string]$scriptPath
    )
    Import-Module AgentSmithAPI
    Invoke-SmithCommand -agent $agent.ExternalAgentId -scriptCode $scriptCode
} -get_DefaultTimeout { 600 }

$Integration