param(
[Parameter(Position=0,Mandatory=$True,HelpMessage=@'
Example task parameter. If you check off "use script params", this will be used in Immy.  
HelpMessage formatting supports MarkDown.
'@)]
[String]$list="stuff1,stuff2" #<- setting the variable here serves as a default for the parameter.
)

######################################################################################
# Add commands that need to be run regardless of phase here (run in test AND set)
# Common use-cases would be something like importing a module, defining a function,
# or `Connect-{Provider}`
######################################################################################

switch($method){ # $method contains the current phase immy is in, values are test, set
  "test" {
    ##################################################################################
    # Add commands that need to be run to validate the current setting on the machine.
    # Scripts should `return` either $true or $false to indicate COMPLIANCE
    ##################################################################################
  }
  "set" {
    ##################################################################################
    # Add commands that need to be run when the test script returns $false
    # The commands here should enforce settings and result in the test script returning $true
    ##################################################################################
  }
  default {
    Write-Error 'Set a $method when testing, dummy!'
    ##################################################################################
    # The default block is executed when none of the other switch options apply.
    # Immy sessions will always have a $method, so this should primarily be informational.
    ##################################################################################
  }
}
