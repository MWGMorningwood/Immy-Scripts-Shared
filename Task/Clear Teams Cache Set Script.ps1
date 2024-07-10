Invoke-HKCU -ScriptBlock {
    # Description: This script will close the Teams app and clear the cache for the Teams app.
    try {
        # Forcefully close the old Teams app
        Get-Process | Where-Object { $_.Name -like '*Teams*' } | Stop-Process -Force
        Write-Host "Teams closed"
    }
    catch {
        Throw "Failed to stop Teams app: $($_.Exception.Message)"
    }

    try {
        # Forefully close Outlook
        Get-Process | Where-Object { $_.Name -like 'Outlook*' } | Stop-Process -Force
        Write-Host "Outlook closed"
    }
    catch {
        Throw "Failed to stop Outlook: $($_.Exception.Message)"
    }

    try {
        #Clear Caches
        Remove-Item -Path "$env:USERPROFILE\AppData\Roaming\Microsoft\Teams" -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:USERPROFILE\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe" -Force -Recurse -ErrorAction SilentlyContinue
        Write-Host "Teams caches cleared"
    }
    catch {
        Throw "Failed to clear Teams caches: $($_.Exception.Message)"
    }
}
