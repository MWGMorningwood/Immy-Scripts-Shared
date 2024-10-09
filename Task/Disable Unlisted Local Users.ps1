param(
    [Parameter(Mandatory=$true, HelpMessage=@'
Enter a comma separated list of allowed usernames. For example, if workstation\administrator and workstation\bob permitted, enter `administrator,bob`
'@)]
    [string]$allowedUsers,
    [Parameter(Mandatory=$false, HelpMessage=@'
Toggle whether domain/workgroup users should be skipped.
`False` = Domain users will be evaluated and disabled if not allowed.
`True` = Domain users will not be evaluated, and are left alone.
'@)]
    [boolean]$skipDomain = $true
)

# Convert the comma-separated list of allowed users into an array
$allowedUsersArray = $allowedUsers -split ','

# Function to get all local users
function Get-UserList {
    $users = Invoke-ImmyCommand {
        $result = Get-LocalUser
        if($skipDomain){
            $filteredResult = $result | Where-Object { $_.Disabled -eq $false -and $_.LocalAccount -eq $true }
        } else {
            $filteredResult = $result | Where-Object { $_.Disabled -eq $false }
        }
        return $filteredResult
    }
    return $users
}

# Function to test compliance
function Test-Compliance {
    $localUsers = Get-UserList
    foreach ($user in $localUsers) {
        if ($allowedUsersArray -notcontains $user.Name) {
            return $false
        }
    }
    return $true
}

# Function to disable non-allowed users
function Set-Compliance {
    [CmdletBinding(SupportsShouldProcess)]
    param()
    $localUsers = Get-UserList
    foreach ($user in $localUsers) {
        if (($allowedUsersArray -notcontains $user.Name) -and $PSCmdlet.ShouldProcess($user.Name)) {
            Write-Host "Disabling user: $($user.Name)"
            $userName = $user.Name
            Invoke-ImmyCommand {
                Disable-LocalUser -Name $using:userName
            }
        }
    }
}

# Main script logic
switch ($method) {
    'test' {
        $compliance = Test-Compliance
        if ($compliance) {
            Write-Host "All local users are compliant."
            Write-Host $localUsers
            return $true
        } else {
            Write-Host "There are non-compliant local users."
            Write-Host $localUsers
            return $false
        }
    }
    'set' {
        Set-Compliance -Confirm:$false
        Write-Host "Non-allowed local users have been disabled."
    }
    default {
        Write-Error "Invalid method. Use 'test' or 'set'."
    }
}
