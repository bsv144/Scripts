######################################################################################
# Инвентаризация компьютеров
# .\Get-PCInfo.ps1 192.168.2.1
######################################################################################
param ( 
		[PARAMETER(Mandatory=$True,Position=0,HelpMessage = "Адрес удалённого хоста")] $_host 
		)

$computer = $product = $null

$product = Get-WmiObject -class win32_computersystemProduct -ComputerName $_host
#
<# Output data
PSComputerName
Caption
Description
IdentifyingNumber
Name
SKUNumber
UUID
Vendor
Version 

IdentifyingNumber Name                      Vendor          Version
----------------- ----                      ------          -------
RUA108013X        HP Pro 3130 Microtower PC Hewlett-Packard xxx0204GRxxxxxxxx0
#>

$computer = Get-WmiObject -class win32_computersystem -ComputerName $_host | Select-Object Name, UserName

<# Output
Name   UserName
----   --------
K-1630 NVGRES\BurlakovSV
#>
foreach($p in get-member -InputObject $product -MemberType Property )
{
	$name = $p.Name + '_'
	Add-Member -InputObject $computer -MemberType NoteProperty -Name $name -Value $product.$($p.Name) -Force
}