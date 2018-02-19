Class Computer {
    [String]$Name
    [String]$Description
    [String]$Type
    [String]$Owner
    [String]$Model
    [int]$Roboots

    Computer ([String]$Name,$Description,$Owner){
        $this.Name = $Name
        $this.Description = $Description
        $this.Owner = $Owner
    }

    [void]Reboot(){
        $this.Roboots ++
    }
}

$NewComputer = [Computer]::New()
$NewComputer = [Computer]::New('SRVDC01','First Domain Controller','Stephane van Gulick')