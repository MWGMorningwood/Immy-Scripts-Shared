<#
Author: Logan Cook
Notes: Combined script with in-script parameters. This script will remove any network drives that are not in the list of permitted drives. This script will also set a pending reboot flag if any drives are removed.
#>

param (
    [Parameter(Position=0,HelpMessage='Enter drive letters in the format of `R:`, then hit add.')]
    [string[]]$PermittedDrives
)

$networkDrives = Invoke-ImmyCommand -Context "User" {
    # Switched from deprecated Get-WmiObject to Get-CimInstance (WS-Man & CIM standard compliant)
    try {
        $result = Get-CimInstance -ClassName Win32_NetworkConnection -ErrorAction Stop
        return $result
    }
    catch {
        Write-Error "Failed to retrieve network connections via CIM: $_"
        @() # Return empty collection on failure to avoid null reference issues later
    }
}

switch($method){
    "test"{
        Invoke-ImmyCommand -Context "User" {
            $allPermitted = $true
            foreach ($drive in $using:networkDrives) {
                if ($using:PermittedDrives -notcontains $drive.LocalName) {
                    $allPermitted = $false
                    Write-Host "Non-permitted network drive found:" $drive.LocalName
                } else {
                    Write-Host "Permitted network drive found:" $drive.LocalName
                }
            }
            return $allPermitted
        }
    }
    "set"{
        Write-Host "Enforcing permitted network drives: $PermittedDrives"
        Invoke-ImmyCommand -Context "User" {
            foreach ($drive in $using:networkDrives) {
                if ($using:PermittedDrives -notcontains $drive.LocalName) {
                    # Remove the network drive
                    Remove-PSDrive -Name $drive.LocalName.Substring(0, 1) -Force
                    Write-Host "Removed non-permitted network drive:" $drive.LocalName
                    $pendingReboot = $true
                }
            }
            if ($pendingReboot -eq $true) {
                Set-PendingRebootFlag
            }
            if($pendingReboot -and $RebootPreference -ne "Suppress") {
                Write-Host "Restarting to clear mapped drive references."
                Restart-ComputerAndWait
            }
        }
    }
}