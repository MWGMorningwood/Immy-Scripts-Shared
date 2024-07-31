param(
[Parameter(Position=0,Mandatory=$True,HelpMessage=@'
Array of drives to map at logon. Format is as follows:  
| Name | Value           |
|------|-----------------|
| `Q`  | `\\path\for\Q\` |
| `T`  | `\\path\for\T\` |
'@)]
[Hashtable]$driveArray
)

#Relies on Set-ScheduledTask. This function is not included in immy.bot, but is included in this repo under the Functions folder.
#net use Q: $sharePath /persistent:yes <- old script

$driveArray.GetEnumerator() | ForEach-Object {
    $driveName = $_.Name
    $driveValue = $_.Value
    Write-Host "Creating task for mapping drive $driveName to $driveValue"

    # Writing codeblock as string first to forcefully eval variables
    $scriptString = @"
try {
    # Mount the drive
    New-PSDrive -Persist -Name '$driveName' -PSProvider FileSystem -Root '$driveValue' -Scope Global
} catch {
    Write-Error -Message "Unable to mount the drive. Check credentials and connectivity to '$driveValue'"
}
"@
    # Below two lines used to convert to codeblock and dodge PS Constrained mode in Immy metascript env.
    [scriptblock]$script = {}
    $script = Add-CodeToScriptBlock $script $scriptString

    Set-ScheduledTaskBeta -TaskName "Map $driveName Drive" -TaskDesc "Map the $driveName drive at logon via New-PSDrive to $driveValue" -Trigger AtLogOn -ScriptContent $script
}