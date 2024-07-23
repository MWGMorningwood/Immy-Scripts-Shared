<#
  Software: Auvik Endpoint Agent
  Step: Installation
  Type: Metascript
#>

$params = @{
    "SITE_KEY" = $siteKey
}

Install-MSI -Path $InstallerFile -MSIParameters $params -Tail
