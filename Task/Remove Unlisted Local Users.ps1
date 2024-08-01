param(
    [Parameter(Mandatory=$true, HelpMessage="Enter a comma separated list of allowed users.")]
    [string]$allowedUsers
)

# Convert the comma-separated list of allowed users into an array
$allowedUsersArray = $allowedUsers -split ','

# Function to get all local users
function Get-LocalUsers {
    Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount=True" | Where-Object { $_.Disabled -eq $false -and $_.LocalAccount -eq $true }
}

# Function to test compliance
function Test-Compliance {
    $localUsers = Get-LocalUsers
    foreach ($user in $localUsers) {
        if ($allowedUsersArray -notcontains $user.Name) {
            return $false
        }
    }
    return $true
}

# Function to disable non-allowed users
function Set-Compliance {
    $localUsers = Get-LocalUsers
    foreach ($user in $localUsers) {
        if ($allowedUsersArray -notcontains $user.Name) {
            Write-Host "Disabling user: $($user.Name)"
            Invoke-ImmyCommand -Command "Disable-LocalUser -Name $($user.Name)"
        }
    }
}

# Main script logic
switch ($method) {
    'test' {
        $compliance = Test-Compliance
        if ($compliance) {
            Write-Host "All local users are compliant."
            return $true
        } else {
            Write-Host "There are non-compliant local users."
            return $false
        }
    }
    'set' {
        Set-Compliance
        Write-Host "Non-allowed local users have been disabled."
    }
    default {
        Write-Error "Invalid method. Use 'test' or 'set'."
    }
}