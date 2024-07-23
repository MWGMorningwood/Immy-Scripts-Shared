<#
  Software: Auvik Endpoint Agent
  Type: Installation
  Context: Metascript
#>

$params = @{
    "SITE_KEY" = $siteKey
}

Install-MSI -Path $InstallerFile -MSIParameters $params -Tail
