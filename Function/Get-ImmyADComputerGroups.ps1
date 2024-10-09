param(
    [string]$ComputerName,
    [string]$DomainName,
    [string]$PreferredDomainControllerName
)

$DomainController = Get-ImmyDomainController -DomainName $DomainToJoin -PreferredDomainControllerName $PreferredDomainControllerName
$ExistingComputer = Get-ImmyADComputer @PSBoundParameters

if ($ExistingComputer) {
    Write-Host "Computer Found! Looking up Group Memberships for $($ExistingComputer.Name) Using Domain Controller $($DomainController.Name)"

    $ExistingComputerGroups = Invoke-ImmyCommand -Computer $DomainController {
        Import-Module ActiveDirectory -Verbose:$false
        #Write-Host -Fore Green $env:computername
        if($using:ComputerName) {
            try {
                Get-ADPrincipalGroupMembership (Get-ADComputer $using:ComputerName).DistinguishedName
            }
            catch {
                Write-Error "Failed to get group membership for computer $($using:ComputerName): $_"
                return @()
            }
        }
    }
}

$ExistingComputerGroups