######################################################################################
# Запускает службу RemoteRegistry на удалённом хосте
# .\Start-RemoteRegistry.ps1 192.168.2.1
######################################################################################
param ( 
		[PARAMETER(Mandatory=$True,Position=0,HelpMessage = "Адрес удалённого хоста")]$host 
		)

sc.exe \\$host start RemoteRegistry


#$service =  Get-WmiObject Win32_Service -cn $host -Filter "DisplayName='Remote Registry'"
#$service.StartService()