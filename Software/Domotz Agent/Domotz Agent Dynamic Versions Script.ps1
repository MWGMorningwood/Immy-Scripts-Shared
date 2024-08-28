$Result = Get-DynamicVersionFromInstallerURL https://portal.domotz.com/download/agent_packages/domotz-windows-x64-10.exe

foreach ($VersionInfo in $Result.Versions) {

    $NewVersion = '1.0.0'
    
    # Updating the object’s Version property
    $VersionInfo.Version = $NewVersion
}

$Result