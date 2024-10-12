param(
[Parameter(Position=0,Mandatory=$False,HelpMessage=@'
Comma separated list of PowerShell module names
'@)]
[String]$Modules='ExchangeOnlineManagement,Microsoft.Graph'
)

$moduleList = $Modules -split ","
Ensure-PSModulePresent $moduleList -EnsureLatest $true