switch($method) {
    "test" {
        Invoke-ImmyCommand { 
            Try{
                Test-WSMan -Authentication Default -ErrorAction Stop | Out-Null
                return $true
            } catch {
                return $false
            }
        }
    }
    "set" {
        Invoke-ImmyCommand { 
            WinRM quickconfig -force 
        }
    }
    default {
        Write-Warning "Set a method if you're testing, dummy"
    }
}
