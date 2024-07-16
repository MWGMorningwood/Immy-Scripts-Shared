$Integration = New-DynamicIntegration -Init {
    [CmdletBinding()]
    param(
        [ValidateSet('eu','app','oc','ca','us2')]
        [string]$Region='app',
        [Parameter(Mandatory, HelpMessage=@"
  Go to https://app.ninjarmm.com/#/administration/apps/api/client 
    * Create a 'Client App ID' 
    * Application Platform: Web (PHP, Java, .Net Core, etc.)
    * Enter the Client ID and Secret below.
    * Perform the OAuth Consent
"@)]
        $ClientID,
        [Parameter(Mandatory)]
        [Password()]
        $ClientSecret,
        [Parameter(Mandatory, HelpMessage=@'
    Go to https://app.ninjarmm.com/#/editor/script/new
    Paste in the following code:
``````
Param(
[Parameter(Mandatory=$true)]
[string]$code
)
iex $code
``````
#

* Name it ImmyBot
* Language: PowerShell
* Operating System: Windows
* Architecture: All

Save

Make a note of the script id in the URL
https://app.ninjarmm.com/#/editor/script/71 -> 71

Enter the script ID
'@)]
        [int]$ScriptID
        
    )    
    dynamicparam
    {
        New-ParameterCollection @(
            
            try
            {                
                <#
                    TODO
                    - Scope needs to be optional
                    - Neither Default nor explicitly provided static parameter values are available
                #>
                $Region | Write-Variable
                $Region = 'app'
                if($true -or $Region)
                {                    
                    New-OAuthConsentParameter -Name RefreshToken `
                        -ResponseType code `
                        -AuthorizationEndpoint "https://$($Region).ninjarmm.com/ws/oauth/authorize" `
                        -TokenEndpoint "https://$($Region).ninjarmm.com/ws/oauth/token" `
                        -ClientSecret $ClientSecret -ClientID $ClientID -Scope "management monitoring offline_access" -Mandatory       
                    
                }
            } catch
            {
                New-HelpText -Name "Error" -HelpMessage "$($_ | Out-String)"
            }
            if($error)
            {
                New-HelpText -Name "Error2" -HelpMessage "$($Error | Out-String)"
            }

        )
    }
    end{
        Write-host "Oauth info:"
        Write-Host "Code: $($RefreshToken.code)"
        Write-Host "Access Token: $($RefreshToken.AccessToken)"
        Write-Host "Refresh Token: $($RefreshToken.RefreshToken)"
        $RefreshToken | Write-Variable

        $IntegrationContext.RefreshToken = $RefreshToken
        $IntegrationContext.ScriptId = $ScriptID
        $IntegrationContext | Write-Variable
        Clear-Error
        [opresult]::Ok();
    }
} -HealthCheck {
    [CmdletBinding()]
    [OutputType([HealthCheckResult])]
    param(
        
    )

    # TODO: impliment health check. Reach out to one of the endpoints and check the responce take make sure we are still authenticated

    # this script gets run on a schedule to determine whether the integration is working as expected
    # to indicate a failure, return New-UnhealthyResult -Message 'Some message'
    # otherwise, return New-HealthyResult
    return New-HealthyResult
}

# Supports listing clients
$Integration | Add-DynamicIntegrationCapability -Interface ISupportsListingClients -GetClients {
    [CmdletBinding()]
    [OutputType([Immybot.Backend.Domain.Providers.IProviderClientDetails[]])]
    param()

    Import-Module NinjaRMMAPI
    Connect-NinjaRmmApi
    Get-NinjaSite | ForEach-Object {
        New-IntegrationClient -ClientID $_.id -ClientName $_.name
    }
    
}

# Supports listing agents
$Integration | Add-DynamicIntegrationCapability -Interface ISupportsListingAgents -GetAgents {
    [CmdletBinding()]
    [OutputType([Immybot.Backend.Domain.Providers.IProviderAgentDetails[]])]
    param(
        [Parameter()]
        [string[]]$clientIds = $null
    )
    Import-Module NinjaRMMAPI
    Connect-NinjaRmmApi

    Get-NinjaAgent -Detailed | ForEach-Object {
        <#
        Write-Host "-----------" -ForegroundColor Cyan -BackgroundColor Cyan
        Write-Host "Name: $($_.systemName)"
        Write-Host "Serial: $($_.system.serialNumber)"
        Write-Host "OS: $($_.os.name)"
        Write-Host "Manuf: $($_.system.manufacturer)"
        Write-Host "Org: $($_.organizationId)"
        Write-Host "AgentID: $($_.id)" 
        Write-Host "-----------" -ForegroundColor Cyan -BackgroundColor Cyan
        #>
        $online = ($_.offline -eq $false)
        New-IntegrationAgent -Name $_.systemName -SerialNumber $_.system.serialNumber -OSName $_.os.name -Manufacturer $_.system.manufacturer -ClientId $_.organizationId -AgentId $_.id -IsOnline $online -AgentVersion "1.2.3"
    }     
}

$Integration | Add-DynamicIntegrationCapability -Interface ISupportsInventoryIdentification -GetInventoryScript {
    [CmdletBinding()]
    [OutputType([scriptblock])]
    param()
    (Get-WindowsRegistryValue -Path 'HKLM:\SOFTWARE\WOW6432Node\NinjaRMM LLC\NinjaRMMAgent\Agent' -Name 'NodeId').Value
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
    Import-Module NinjaRMMAPI
    Connect-NinjaRmmApi
    $Uid = New-Guid
    Invoke-NinjaRmmRestMethod -Method Post -Endpoint "/device/$($Agent.ExternalAgentId)/script/run" -BOdy (ConvertTo-Json @{
        "type" = "SCRIPT"
        "id"= $IntegrationContext.ScriptId
        "uid" = $Uid
        "parameters" = "-Code '$scriptCode'"
        "runAs" = "system"
    })
} -get_DefaultTimeout { 300 }

# Supports TenantInstallToken
$Integration | Add-DynamicIntegrationCapability -Interface ISupportsTenantInstallToken -GetTenantInstallToken {
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory=$true)]
        [System.String]$clientId
    )
    Import-Module NinjaRMMAPI
    Connect-NinjaRmmApi
    $InstallerURL = Get-NinjaAgentDownloadUri -Orgid $clientId
    $InstallerURL
}

$Integration
