param(
[Parameter(Position=0,Mandatory=$True,HelpMessage=@'
Example task parameter. If you check off "use script params", this will be used in Immy.
HelpMessage formatting supports MarkDown.
'@)]
[String]$list="stuff1,stuff2" #<- setting the variable here serves as a default for the parameter.
)

$splitList = $list -split ','

######################################################################################
# Add commands that need to be run regardless of phase here (run in test AND set)
# Common use-cases would be something like importing a module, defining a function,
# modifying variables, or `Connect-{Provider}`
######################################################################################

switch ($method) { # $method contains the current phase immy is in, values are get, test, and set
  "test" {
    ##################################################################################
    # Add commands that need to be run to validate the current setting on the machine.
    # Scripts should `return` either $TRUE or $FALSE to indicate COMPLIANCE
    ##################################################################################
    Test-Function $splitList -Action {
      if ($_ -notin $list){
        return $false
      } else {
        return $true
      }
    }
  }
  "set" {
    ##################################################################################
    # Add commands that need to be run when the test script returns $FALSE
    # The commands here should enforce DSC and result in the test script returning $TRUE
    ##################################################################################
    Set-Function $splitList -Action {
      For-each $thing in $splitList {
        Do-ThingTo $thing
        Write-Host "Did thing to $($thing.name)"
      }
    }

  }
  default {
    Write-Error 'Set a $method when testing, dummy!'
    ##################################################################################
    # The default block is executed when none of the other switch options apply.
    # Immy sessions will always have a $method, so this should primarily be informational.
    ##################################################################################
  }
}