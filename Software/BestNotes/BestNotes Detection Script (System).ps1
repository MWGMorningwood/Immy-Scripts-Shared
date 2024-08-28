$version = (Get-Package * | ? {$_.Name -eq "BestNotes"} | Select Version).version
return $version