param(
    [Parameter(Mandatory=$true)]
    [string]$TaskName,

    [Parameter(Mandatory=$true)]
    [string]$TaskDesc,

    [Parameter(Mandatory=$true)]
    [ValidateSet("AtLogOn", "AtStartup", "Daily", "Weekly")]
    [string]$Trigger,

    [Parameter(Mandatory=$false)]
    [string]$Timing,

    [Parameter(Mandatory=$true)]
    [scriptblock]$ScriptContent
)
$task = Invoke-ImmyCommand { Get-ScheduledTask | Where-Object {$_.TaskName -like $using:TaskName} -ErrorAction SilentlyContinue }
$scriptDir = "C:\ScheduledTasks"
$scriptPath = "C:\ScheduledTasks\$TaskName.ps1"

function Test-ScheduledTaskScript {
    $CurrentScriptContent = Invoke-ImmyCommand { Get-Content -Path $using:scriptPath -raw -Encoding utf8 }
    $ScriptContentString = $ScriptContent.ToString()

    #Normalizing contents
    $NormalizedCurrentScriptContentString = ($CurrentScriptContent -replace '\s','')
    $NormalizedScriptContentString = ($ScriptContentString -replace '\s','')

    #Comparison operation
    $ScriptCompare = Compare-Object -ReferenceObject $NormalizedCurrentScriptContentString -DifferenceObject $NormalizedScriptContentString
    if ($null -eq $ScriptCompare) {
        # The contents are identical
        $Test_ScheduledTaskScript_result = $true
    } else {
        # The contents are not identical
        $Test_ScheduledTaskScript_result = $false
    }
    return $Test_ScheduledTaskScript_result
}

function Set-ScheduledTaskScript {
    Write-Warning "Script did not pass validation, configuring!"
    $Set_ScheduledTaskScript_result = Invoke-ImmyCommand {
        if(-not (test-path $using:scriptDir)){
            New-Item -Path $using:scriptDir -ItemType Directory | Out-Null 
        }
        New-Item -Path $using:scriptPath -Name "$TaskName.ps1" -Value $ScriptContent -force
    }
    Write-Host $Set_ScheduledTaskScript_result
}

if(!$method)
{
    Write-Warning "`$method variable is `$null, likely because you are running this from the terminal and not in the context of a session/task. Add `$method = 'set' before running this command if you want it to actually set this value"
}
switch ($method) {
    "test" {
        #referring to line 18, don't think too much about it
        Write-Progress -Activity "Testing Scheduled Task" -CurrentOperation "Retrieving current task" -PercentComplete 0 -Id 1

        #Overall task comparison
        Write-Debug "DEBUG: Scheduled task: $task"
        
        #Fail condition
        if ($null -eq $task) {
            Write-Progress -Activity "Testing Scheduled Task" -CurrentOperation "Comparison failed - Task Missing" -Completed -Id 1
            return $false
        }

        $Test_ScriptResult = Test-ScheduledTaskScript
        Write-Progress -Activity "Testing Scheduled Task" -CurrentOperation "Script Comparison finished with result: $Test_ScriptResult" -PercentComplete 75 -Id 1
        
        $Test_DescResult = ( $task.Description -eq $TaskDesc )
        Write-Progress -Activity "Testing Scheduled Task" -CurrentOperation "Description Comparison finished with result: $Test_DescResult" -PercentComplete 80 -Id 1

        $TestResult = ( $Test_DescResult -and $Test_ScriptResult )
        Write-Progress -Activity "Testing Scheduled Task" -CurrentOperation "Validation finished with result: $TestResult" -Completed -Id 1
        
        $TestResult
    }

    "set" {
        Write-Progress -Activity "Setting Scheduled Task" -CurrentOperation "Beginning enforcement" -PercentComplete 0 -Id 2

        # Pass the params to the machine directly and build the task
        if(!$Test_ScriptResult){
            $Set_ScriptResult = Set-ScheduledTaskScript
            Write-Progress -Activity "Setting Scheduled Task" -CurrentOperation "Enforced configured scriptblock" -PercentComplete 50 -Id 2
        }
        $result = Invoke-ImmyCommand {
            switch ($using:Trigger) {
                "AtLogOn"   { $buildtrigger = New-ScheduledTaskTrigger -AtLogon }
                "AtStartup" { $buildtrigger = New-ScheduledTaskTrigger -AtStartup }
                "Daily"     { $buildtrigger = New-ScheduledTaskTrigger -Daily -At $using:Timing }
                "Weekly"    { $buildtrigger = New-ScheduledTaskTrigger -Weekly -At $using:Timing }
            }
            Write-Debug "DEBUG: Trigger is set to $($using:Trigger)"
            Write-Debug "DEBUG: Build Trigger: $buildtrigger"
            
            # Check if the task exists and remove it if it does
            if (![string]::IsNullOrWhiteSpace($using:task)){
                Unregister-ScheduledTask -TaskName $using:TaskName -Confirm:$false 
            }

            # Build the task
            $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -file `"$using:scriptPath`""
            $principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Users" -RunLevel limited
            #$User = "NT AUTHORITY\INTERACTIVE"
            #$principal = New-ScheduledTaskPrincipal -UserId $User -LogonType Interactive

            Register-ScheduledTask `
                -Action $action `
                -Principal $Principal `
                -Trigger $buildtrigger `
                -TaskName $using:TaskName `
                -Description $using:TaskDesc
        }
        Write-Progress -Activity "Setting Scheduled Task" -CurrentOperation "Task configured" -PercentComplete 95 -Id 2
        Write-Progress -Activity "Setting Scheduled Task" -CurrentOperation "Enforcement complete" -Completed -Id 2
        Write-Information "INFO: Scheduled Task Results:"
        return $result
    }
}