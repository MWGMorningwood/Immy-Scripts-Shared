param (
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [Parameter(Mandatory=$true)]
    [string]$Value
)

Write-Host "Ensuring DellBiosProvider is present"
Ensure-PSModulePresent -RequiredModules DellBiosProvider -EnsureLatest $false

$BIOSPath = $Path
$BIOSValue = $Value

switch ($method) {
    "test" {
        $BIOSValue_Test = Invoke-ImmyCommand {
            Import-Module DellBIOSProvider
            try{
                $Result = (Get-ChildItem -Path "DellSmbios:\$($using:BIOSPath)" -ErrorAction Stop).CurrentValue
                return $Result
            } catch {
                Write-Error "Path failed to resolve. $($_.Exception.Message)"
            }
        }

        #Check actual setting value
        if ($BIOSValue_Test -eq $BIOSValue){
            Write-Host "Test results indicate success: $BIOSPath = $BIOSValue_Test"
            return $true
        } else {
            Write-Warning "Test results do not indicate success: $BIOSPath = $BIOSValue_Test"
            return $false
        }
    }
    "set" {
        Write-Host "Setting BIOS Value in DellSmbios:\$BIOSPath to $BIOSValue..."
        Invoke-ImmyCommand {
            Import-Module DellBIOSProvider
            Set-Item -Path "DellSmbios:\$($using:BIOSPath)" -value $using:BIOSValue
        }
    }
    Default {
        Write-Warning "No Method has been set. If you are running this outside of a maintenance session, uncomment the line that includes `$method"
    }
}