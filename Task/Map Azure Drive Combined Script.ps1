param(
[Parameter(Position=1,Mandatory=$True,HelpMessage=@'
Enter the name of your Azure Storage account.
'@)]
[String]$storageAccount,
[Parameter(Position=1,Mandatory=$True,HelpMessage=@'
Enter your storage Access Key or password.
'@)]
[Password()]$accessKey,
[Parameter(Position=2,Mandatory=$True,HelpMessage=@'
Array of drives to map at logon. Format is as follows:  
| Name         | Value |
|--------------|-------|
| `appshares`  | `Q`   |
| `timesheets` | `T`   |
'@)]
[Hashtable]$driveArray
)

### WARNING!################################################
# Permissions to the share will be in the context of the `UserName` param in the try/catch block below.
# If directory-specific permissions are in-place, you likely need to use IdP integration instead.
############################################################

#Relies on Set-ScheduledTask. This function is not included in immy.bot, but is included in this repo under the Functions folder.
#net use Q: $sharePath /persistent:yes <- old script

$driveArray.GetEnumerator() | ForEach-Object {
    $shareName = $_.Name
    $driveLetter = $_.Value
    $storageUrl = "$storageAccount.file.core.windows.net"
    $UNCpath = "\\$storageUrl\$shareName"
    Write-Host "Creating task for mapping drive $driveLetter to $UNCpath"

    # Writing codeblock as string first to forcefully eval variables
    $scriptString = @"
try {
    # Mount the drive
    New-SMBMapping -LocalPath "$($driveLetter):" -RemotePath $UNCpath -UserName "localhost\$storageAccount" -Password $accessKey
} catch {
    Write-Error -Message "Unable to mount the drive. Check credentials and connectivity to '$storageUrl'"
}
"@
    # Below two lines used to convert to codeblock and dodge PS Constrained mode in Immy metascript env.
    [scriptblock]$script = {}
    $script = Add-CodeToScriptBlock $script $scriptString

    Set-ScheduledTask -TaskName "Map $driveLetter Drive" -TaskDesc "Map the $driveLetter drive at logon via New-PSDrive to $UNCpath" -Trigger AtLogOn -ScriptContent $script
}