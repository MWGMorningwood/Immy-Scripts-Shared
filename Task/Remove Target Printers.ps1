param(
[Parameter(Position=0,Mandatory=$True,HelpMessage=@'
Comma-separated list of printer names to remove.\
You can obtain this list with `Get-Printer | Select-Object -ExpandProperty Name`
'@)] # Backslash is an acceptable line break in markdown, allowing satisfaction of PSAvoidTrailingWhitespace
[String]$list
)
$printerNamesToCheck = $list -split ','
#$printerNamesToCheck = "KONICA MINOLTA 423SeriesPCL-8,KONICA Front Office" -split ','
# maybe KONICA MINOLTA bizhub 454e PCL (10.1.10.72) v4

switch($method){
    "test" {
        $printers = Invoke-ImmyCommand {
            $printers = Get-Printer | Select-Object -ExpandProperty Name
            return $printers
        }
        # Define the list of printer names to check against

        # Check if any of the specified printer names are in the list of printers
        $containsPrinter = $false
        Write-Host $printers
        foreach ($printerName in $printerNamesToCheck) {
            Write-Host "Checking above list for $printerName"
            if ($printers -contains $printerName) {
                $containsPrinter = $true
                break
            }
        }

        # Return $false if any specified printer names are found, otherwise return $true
        return -not $containsPrinter

    }
    "set" {
        Invoke-ImmyCommand {
            foreach ($printerName in $using:printerNamesToCheck) {
                # Check if the printer exists
                $printer = Get-Printer -Name $printerName -ErrorAction SilentlyContinue
                if ($printer) {
                    # Remove the printer
                    Remove-Printer -Name $printerName
                    Write-Host "Removed printer: $printerName"
                } else {
                    Write-Host "Printer not found: $printerName"
                }
            }
        }
    }
}