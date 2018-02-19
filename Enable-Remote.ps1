function Enable-Remote
{
	# Enables Powershell Remoting
	Param (
			[Parameter(Mandatory=$true)]
			[System.String[]]$Computer
	)
	ForEach ($comp in $computer ) {
		#Start-Process -Filepath "psexec.exe" -Argumentlist "\\$comp -accepteula -s winrm.cmd qc -quiet" -NoNewWindow -Wait
		#Write-Host "Enabling WINRM Quickconfig" -ForegroundColor Green
		#Write-Host "Waiting for 60 Seconds......." -ForegroundColor Yellow
		#Start-Sleep -Seconds 60 -Verbose	
		Start-Process -Filepath "psexec.exe" -Argumentlist "\\$comp -accepteula -s powershell.exe enable-psremoting -force" -NoNewWindow -Wait
		Write-Host "Enabling PSRemoting" -ForegroundColor Green
		#Start-Process -Filepath "psexec.exe" -Argumentlist "\\$comp -accepteula -h -d powershell.exe set-executionpolicy RemoteSigned -force" -NoNewWindow -Wait
		#Write-Host "Enabling Execution Policy" -ForegroundColor Green	
		Test-Wsman -ComputerName $comp
	}
}          