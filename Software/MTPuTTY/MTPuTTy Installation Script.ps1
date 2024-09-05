<#
Modified from the Immy Default Inno Setup Install Script
Needed to add /ALLUSERS
#>

$Arguments = @"
/SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /ALLUSERS /LOG="$InstallerLogFile"
"@
Start-ProcessWithLogTail $InstallerFile -ArgumentList $Arguments -LogFilePath $InstallerLogFile -RegexActions @{
    '\d\s+Filename: (.*.exe)' = {
        try {
            $FileNameWithExtension = Split-Path -Leaf $matches[1]
            $FileName = [IO.Path]::GetFileNameWithoutExtension($FileNameWithExtension)
        } catch {
            $FileName = $null
        }
        if ($FileName) {
            Write-Host "Checking if $FileName is running"
            $process = Get-Process -Name $FileName -ErrorAction SilentlyContinue
            if ($process) {
                Write-Host "Killing $FileNameWithExtension"
                taskkill /im $FileNameWithExtension /f 2>&1 | Out-Null
                Write-Host "Done"
            } else {
                Write-Host "$FileNameWithExtension is not running"
            }
        }
    }
    '\d\s+Log closed'={
        # taskkill /im TrayTipAgentE.exe /f 2>&1 | Out-Null
    }
}