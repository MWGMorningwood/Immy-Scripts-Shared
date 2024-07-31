#Relies on Set-ScheduledTask. This function is not included in immy.bot, but is included in this repo under the Functions folder.

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
    Set-ScheduledTask -TaskName "Map $($using:drive.Name) Drive" -TaskDesc "Map the $($using:drive.Name) drive at logon via New-PSDrive" -Trigger AtLogOn -ScriptContent {
        #net use Q: $sharePath /persistent:yes <- old script
        $connectTestResult = Test-NetConnection -ComputerName appshares.file.core.windows.net -Port 445
        if ($connectTestResult.TcpTestSucceeded) {
            # Mount the drive
            New-PSDrive -Persist -Name $using:drive.Name -PSProvider FileSystem -Root $using:drive.Value -Scope Global
        } else {
            Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
        }
    }
}