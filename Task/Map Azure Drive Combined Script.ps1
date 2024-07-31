# Relies on Set-ScheduledTask. This function is not included in immy.bot, but is included in this repo under the Functions folder.

param(
[Parameter(Position=0,Mandatory=$False,DontShow,HelpMessage=@'
Array of drives to map at logon. Format is as follows:  
| Name | Value |
|------|-------|
| `Q`  | `\\path\for\Q\` |
| `T`  | `\\path\for\T\` |
'@)]
[Hashtable]$driveArray = @{
    'Q' = '\\appshares.file.core.windows.net\quickbooks'
    'T' = '\\TEST-RAS-prod\share'
}
)

foreach ($drive in $driveArray){
    # pre-evaluate the scriptblock to insert the drive letter and share path
    # this is done to avoid issues with the scriptblock not being able to access the variables after being passed to the function.
    # might be able to preempt that by using $using: variables in the scriptblock, but this is a more brute-force solution.
    $scriptBlockString = @"
    \$connectTestResult = Test-NetConnection -ComputerName (if (\$sharePath -match '\\\\([^\\]+)') { \$matches[1] } else { \$null }) -Port 445
    if (\$connectTestResult.TcpTestSucceeded) {
        # Mount the drive
        New-PSDrive -Persist -Name $driveLetter -PSProvider FileSystem -Root $sharePath -Scope Global
    } else {
        Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
    }
"@
    Write-Host "Scriptblock Generated:  "
    Write-Host $scriptBlockString
    
    # convert back into a scriptblock
    $scriptBlock = [scriptblock]::Create($scriptBlockString)
    Set-ScheduledTask -TaskName "Map QB Drive" -TaskDesc "Map the $($drive.Name) drive at logon via New-PSDrive" -Trigger AtLogOn -ScriptContent $scriptBlock
    
}