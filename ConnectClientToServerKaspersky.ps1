######################################################################################
# Скрипт для подключения агента администрирования антивирса касперский к серверу
# .\ConnectClientToServerKasperssky.ps1 -comp 192.168.2.1 -kasp_server "ksc"
# где:
#	comp - список хостов на которых настраивается агент
#   kasp_server - сервер касперского к которому будут подключаться пользователи
#
# Два решения с помощью функции или workflow. 
# При запуске через workflow процессы будут запускать параллельно
######################################################################################
function Connect-KasperskyServer
{
	[CmdletBinding()]
    Param (
		[Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
        [string[]]$comp,
		[Parameter(Mandatory=$True)]
		[string]$kasp_server
    )

    Begin {
        #���������� ���������� ��� �������� ������ �� ������� ���� ������
        $errComp = @()
        #Switch off/on debug mode by $false/$true
        $mode_debug = $true
		$ErrorActionPreference = "Stop"
        
        $process_param = "-PassThru","-WindowStyle Hidden","-Wait"
        $process_debug = $None
        if ($mode_debug)
        {
            $process_debug = "-RedirectStandardOutput `"d:\logOutput.txt`" -RedirectStandardError `"d:\logError.txt`""
        }
    }
    Process {
        #$comp = $_
        Write-Host $comp
        #��������� ����������� �����
        if (!(Test-Connection -ComputerName $comp -Quiet)) 
	        {
    	        $errComp += $comp
                #Debug
                if ($mode_debug)
                {
                    Write-Host "$comp  Test-Connection" -BackgroundColor Red
                }
                return
	        }

        #ToDO
		
        #Get OS arch x86 or x64
        Try 
		{
			$arch =(Get-WmiObject Win32_OperatingSystem -computername $comp).OSArchitecture
		}
        Catch 
		{
            #$errComp += $comp
            #Debug
            if ($mode_debug)
               {
                   Write-Host "$comp  Catch WmiObject" -BackgroundColor Red
               }
            $arch = '32-bit'
	    }	
        if ($arch -like '32-bit')
	    {
		    #$pf_arch = ""
            $klmover_path = "`"c:\Program Files\Kaspersky Lab\NetworkAgent\klmover`""
	    }
        else 
	    {
	        #$pf_arch = "Program Files (x86)"
            $klmover_path = "`"c:\Program Files (x86)\Kaspersky Lab\NetworkAgent\klmover`""
	    }
        #Start process
        $klmover = 	start-process -FilePath D:\PortableSoft\PsTools\PsExec.exe  -ArgumentList "\\$comp","cmd /c",$klmover_path,"-address",$kasp_server  -PassThru -WindowStyle Hidden -Wait
        #If process exit with error
        if ($klmover.ExitCode -ne 0)
	    {
            $errComp += $comp
            #Debug
            if ($mode_debug)
            {
                Write-Host "$comp  Error start process " -BackgroundColor Red
                Write-Host "$klmover_path " -BackgroundColor Red
            }
	    }
    }
    End  {
        if ($errComp.Length -ne 0)
        {
            Write-Host "PC with error" -BackgroundColor Red
            $errComp
        } 
        else
        {
            Write-Host "Ok" -BackgroundColor Green
        }
    }

}	



######################################################################################
# WorkFlow
######################################################################################
workflow WFConnect-KasperskyServer
{
	[CmdletBinding()]
    Param (
		[Parameter(Mandatory=$True)]
        [string[]]$comps,
		[Parameter(Mandatory=$True)]
		[string]$kasp_server
    )
	
#	inlineScript {
		#Measure script execution time
		$StopWatch = [system.diagnostics.stopwatch]::startNew()
		
		$errComp = @()
		#Switch off/on debug mode by $false/$true
		$mode_debug = $true
		#$ErrorActionPreference = "Stop"
			
		$process_param = "-PassThru","-WindowStyle Hidden","-Wait"
		$process_debug = $None
		if ($mode_debug)
		{
			$process_debug = "-RedirectStandardOutput `"d:\logOutput.txt`" -RedirectStandardError `"d:\logError.txt`""
		}
#	}
	
	foreach -parallel ($comp in $comps) {
        InlineScript {Write-Host $Using:comp}
		# Test connection
        if (!(Test-Connection -ComputerName $comp -Quiet)) 
	        {
    	        $workflow:errComp += $comp
                #Debug
				InlineScript 
				{
					Write-Host "Err Test-Connection" -BackgroundColor Red
					Write-Debug "$comp  Test-Connection"
				}
                return
	        }

        #ToDO
        #Get OS arch x86 or x64
		$arch = (Get-WmiObject Win32_OperatingSystem -ComputerName $comp -ErrorAction "Continue").OSArchitecture
		if ($arch -like '64-bit')
	    {
		    #$pf_arch = ""
            $klmover_path = "`"c:\Program Files (x86)\Kaspersky Lab\NetworkAgent\klmover`""
	    }
        else 
	    {
	        #$pf_arch = "Program Files (x86)"
            $klmover_path = "`"c:\Program Files\Kaspersky Lab\NetworkAgent\klmover`""
	    }
        #Start process
        #$klmover = 	start-process -FilePath D:\PortableSoft\PsTools\PsExec.exe  -ArgumentList "\\$comp","cmd /c",$klmover_path,"-address",$kasp_server  -PassThru -WindowStyle Hidden -Wait -RedirectStandardError "d:\kasp_error_$comp.txt" -RedirectStandardOutput "d:\kasp_output_$comp.txt"
		$klmover = 	(start-process -FilePath D:\PortableSoft\PsTools\PsExec.exe  -ArgumentList "\\$comp","cmd /c",$klmover_path,"-address",$kasp_server  -PassThru -WindowStyle Hidden -Wait).ExitCode 
        #If process exit with error
        if ($klmover -ne 0)
	    {
            $workflow:errComp += $comp
            #Debug
			InlineScript 
			{
				Write-Host "$Using:comp -> Err" -BackgroundColor Red
				Write-Debug "$Using:comp Error start process"
				Write-Debug "$Using:comp $Using:klmover_path"
			}
	    } else 
		{
			InlineScript 
			{
				Write-Host "$Using:comp - > OK" -BackgroundColor Green
			}
		}
    }
	
	#Error output
	if ($errComp.Length -ne 0)
	{
		InlineScript 
		{
			Write-Debug "PC with error"
			$Using:errComp
		}
	} 
	
	InlineScript 
	{
		Write-Debug $Using:stopwatch.Elapsed
	}

}	