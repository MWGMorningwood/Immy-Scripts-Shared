<#
Plug one of your domains into the $AzureDomain variable below

Create a brand-new App Registration in Azure Active Directory, leave it completely unmodified, don’t change any defaults.

Copy the Client (Application) ID into the $ClientID variable below

Create a secret under Certificates and Secrets and copy the secret VALUE (NOT THE ID!!!!!!!) into the $Secret variable below

Navigate to the Enterprise App that was created in your Azure AD (You can do this by clicking the Managed Application link on the bottom right of the App Registration) and copy the object id into the AD External ID field into a new Person in Immy

Make that person a user

Make the user an admin

Run The code below

Find the API endpoints you need by using the network tab in your browser.

Modify the code below to suit your needs
#>

$AzureDomain = ''
$ClientID = ''
$Secret = ''
$InstanceSubdomain = ''

#####################

$TokenEndpointUri = [uri](Invoke-RestMethod "https://login.windows.net/$AzureDomain/.well-known/openid-configuration").token_endpoint
$TenantID = ($TokenEndpointUri.Segments | Select-Object -Skip 1 -First 1).Replace("/", "")

function Get-ImmyBotApiAuthToken {
    param($TenantId, $ApplicationId, $Secret, $ApiEndpointUri)

    $RequestAccessTokenUri = "https://login.microsoftonline.com/$tenantId/oauth2/token"
    $body = "grant_type=client_credentials&client_id=$applicationId&client_secret=$Secret&resource=$apiEndpointUri"
    $contentType = 'application/x-www-form-urlencoded'

    try {
        $Token = Invoke-RestMethod -Method Post -Uri $RequestAccessTokenUri -Body $body -ContentType $contentType
        return $Token
    } catch { throw }
}

$Script:BaseURL = "https://$($InstanceSubdomain).immy.bot"
$Token = Get-ImmyBotApiAuthToken -ApplicationId $ClientId -TenantId$TenantID -Secret $Secret -ApiEndpointUri $BaseURL
$Script:ImmyBotApiAuthHeader = @{
    "authorization" = "Bearer $($Token.access_token)"
}

function Invoke-ImmyBotRestMethod {
    param([string]$Endpoint, [string]$Method, $Body)
    $Endpoint = $Endpoint.TrimStart('/')

    $params = @{}

    if ($Method) {
        $params.method = $Method
    }

    if ($Body) {
        $params.body = $body
    }

    Invoke-RestMethod -Uri "$($Script:BaseURL)/$Endpoint" -Headers $Script:ImmyBotApiAuthHeader @params
}

Invoke-ImmyBotRestMethod -Endpoint "/api/v1/computers"
