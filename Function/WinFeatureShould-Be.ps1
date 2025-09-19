Param(
    [Parameter(Mandatory=$True,HelpMessage='Specifies the name of the feature to be enabled. Feature names are case sensitive if you are servicing a Windows image running a version of Windows earlier than Windows® 8. You can use Get-WindowsOptionalFeature to find the name of the feature in the image.')]
    [ValidateSet('Enabled','Disabled')]
    [String]$State,
    [Parameter(Mandatory=$True,HelpMessage='Specifies the state that the feature should be in. This function will set the feature to the correct state if it is not already.')]
    [String]$Feature
)

switch ($method) {
    Default {
        Write-Host 'Set a method when you test.'
    }
    "test" {
        $Current_Feature_State = Invoke-ImmyCommand { $feature = Get-WindowsOptionalFeature -FeatureName $using:Feature -Online; [string]$feature.State }
        $Feature_Test = ($Current_Feature_State -eq $State)
        return $Feature_Test
    }
    "set" {
        If ($State -eq 'Disabled') {
            Invoke-ImmyCommand -Timeout 600 { $result = Disable-WindowsOptionalFeature -Online -FeatureName $using:Feature; return $result }
            Write-Host "$Feature has been $State."
            Restart-ComputerAndWait
        } elseif ($State -eq 'Enabled') {
            Invoke-ImmyCommand -Timeout 600 { $result = Enable-WindowsOptionalFeature -Online -FeatureName $using:Feature -all -norestart; return $result }
            Write-Host "$Feature has been $State."
            Restart-ComputerAndWait
        } else {
            Write-Host "$Feature has already been $State."
        }
    }
}