Ensure-PSModulePresent DellBiosProvider
$BIOSPath = "PowerManagement\AutoOn"
$BIOSValue = "Everyday"
#$method = "test"


switch ($method) {
    "test" {
        Invoke-ImmyCommand {
            Import-Module DellBIOSProvider
            try{
                $BIOSValue_Test = (Get-ChildItem -Path "DellSmbios:\$($using:BIOSPath)" -ErrorAction Stop).CurrentValue
            } catch {
                Write-Warning "Path failed to resolve. Please check script logs if this is unexpected."
                Write-Verbose $BIOSValue_Test
                return $false 
            }

            #Check actual setting value
            if ($BIOSValue_Test -eq $using:BIOSValue){
                Write-Host "Test results indicate success: $BIOSValue_Test"
                return $true
            } else {
                Write-Warning "Test results do not indicate success: $BIOSValue_Test"
                return $false
            }
        }
        
    }
    "set" {
        #Enable-DellSMBIOS
        Invoke-ImmyCommand {
            Import-Module DellBIOSProvider
            Write-Host "Setting BIOS Value in DellSmbios:\$($using:BIOSPath)..."
            Set-Item -Path "DellSmbios:\$($using:BIOSPath)" -value $using:BIOSValue
        }
    }
    Default {
        Write-Warning "No Method has been set. If you are running this outside of a maintenance session, uncomment the line that includes `$method"
    }
}
