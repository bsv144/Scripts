####################################################

### ComputerList Option 1 ###
# $ComputerList = @(“lana”, “lisaburger”)

### ComputerList Option 2 ###
# $ComputerList = @()
# Import-Csv “C:\Temp\ComputersThatNeedPrinters.csv” | `
# % {$ComputerList += $_.Computer}

####################################################

foreach ($computer in $ComputerList) {

Invoke-Command -ComputerName $computer -Scriptblock {RUNDLL32 PRINTUI.DLL,PrintUIEntry /ga /n\\PrintServer\ShareName }

}


####################################################