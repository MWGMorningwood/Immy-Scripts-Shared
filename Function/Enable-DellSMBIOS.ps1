Invoke-ImmyCommand {
    # Ensure NuGet is an installed Package Provider
    try {
        $NuGetTest = Get-PackageProvider -Name NuGet -ErrorAction Stop
        Write-Verbose $NuGetTest.toString()
        Write-Host "NuGet is already installed."
    } catch {
        Write-Warning "NuGet is not an installed Package Provider. Installing NuGet..."
        Install-PackageProvider -Name NuGet -Force -Scope AllUsers
        Write-Host "NuGet has been installed."
    }

    # Ensure that DellBIOSProvider module is installed
    try {
        $ModuleTest = Get-Module -ListAvailable -Name DellBIOSProvider -ErrorAction Stop
        Write-Verbose $ModuleTest.toString()
        Write-Host "Dell BIOS Provider is already insalled."
    } catch {
        Write-Warning "DellBIOSProvider module is not installed. Installing DellBIOSProvider..."
        Install-Module -Name DellBIOSProvider -force
        Write-Host "Dell BIOS Provider has been installed."
    }

    # Import the module in the environment that the function is called from
    Import-Module DellBIOSProvider

    #Check PSDrive
    try{
        Get-PSDrive -name "Dellsmbios" -ErrorAction Stop | Out-Null
        Write-Host "PS Drive Dellsmbios located."
    } catch {
        Write-Warning "PSDrive not found."
        Throw "Dell BIOS Provider preconfig failed."
    }
}
