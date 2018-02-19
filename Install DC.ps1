Rename-computer -newname 2016-DC01
Get-NetAdapter
New-NetIPAddress -InterfaceAlias Ethernet -IPAddress $ipaddress -AddressFamily IPv4 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses $dnsaddress
Restart-Computer
get-timezone
set-timezone -Id 'Ekaterinburg Standard Time'

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName sixteen.contoso.ad


#Validate AD install
#Make sure AD/DNS services are running
Get-Service adws,kdc,netlogon,dns
#Check for sysvol and netlogon shares
Get-smbshare
#Review logs
get-eventlog "Directory Service" | select entrytype, source, eventid, message
get-eventlog "Active Directory Web Services" | select entrytype, source, eventid, message