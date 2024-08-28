<#
.SYNOPSIS
Convert a Azure AD SID to Object ID
 
.DESCRIPTION
Converts an Azure AD SID to Object ID.
Author: Oliver Kieselbach (oliverkieselbach.com)
The script is provided "AS IS" with no warranties.
 
.PARAMETER ObjectID
The SID to convert
#>

    param([String] $Sid)
    $guid = Invoke-ImmyCommand {
        $sid = $using:Sid
        $text = $sid.Replace('S-1-12-1-', '')
        $array = [UInt32[]]$text.Split('-')

        $bytes = New-Object 'Byte[]' 16
        [System.Buffer]::BlockCopy($array, 0, $bytes, 0, 16)
        [System.Guid]$guid = $bytes
        $guid
    }
    
    return $guid