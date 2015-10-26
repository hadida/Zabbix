############################################################################
#
#
#  
#  Distribution Zabbix agent among servers

#  Author: 		Viktor Kucher
#  Email:  		viktor.kucher@gmail.com
#  Date created:   	09/09/2015
#  Version: 		1.0 
#  Description: Distribution Zabbix agent among servers. Stop Zabbix agent service, copy file and start service
#
                                             
$Servers = ''
$server  = ''

#$Servers = ("MBX01", "MBX02", "DMS1", "DMS2", "ABS_SC3", "ABS_SC4", "SCBACK","SC_BACK" )
$Servers = Get-Content -Path "d:\tmp\server2.csv"

#############################################################################
## Parameters
##
## DelayServiceStatusScan (sec) Delay get service status 
$ServiceStatus          = "Running"
$DelayServiceStatusScan = 3
 
## 
$ServiceName            = "Zabbix Agent"
$InstallFile            = "zabbix_agentd.exe"
$PathInstallFolder      = "d:\tmp"
$PathDestinationFolder  = "\c$\Zabbix"





$PathInstallFileFull       = $PathInstallFolder + '\' + $InstallFile



foreach ( $server in $Servers)
{
    
    try
    {

            if (Test-Connection -ComputerName $server -ErrorAction Stop)
            {

                    write-host Processing: $server
                    Get-Service -ComputerName $server -Name $ServiceName | Stop-Service  
					

                    ## Stopping service 

                            while ($ServiceStatus -eq "Running")
                            {
                                try
                                {
                                    $ServiceStatus = (Get-Service -ComputerName $server -Name $ServiceName).Status
                                    Write-Host $server $ServiceName $ServiceStatus
                                }
                                 catch
                                {
                                    Write-Host  $Error[0].Exception.Message
                                }
                                    
                                    Start-Sleep -Seconds $DelayServiceStatusScan

                               
                            }

                    ## Copying file
							if ($ServiceStatus -eq "Stopped")
							{
                            $PathDestinationFolderFull = "\\" + $server + $PathDestinationFolder
                            $PathDestinationFileFull   = $PathDestinationFolderFull + '\' + $InstallFile
                            try
                            {
                                if (Test-path -Path $PathDestinationFolderFull -ErrorAction Stop)
                                {                                                                                
                                    Copy-Item -Path $PathInstallFileFull -Destination $PathDestinationFileFull -ErrorAction Stop
									Write-Host On host $server agent was copied
                                }
                                else 
                                {
                                    write-host On host $server path $PathDestinationFolderFull not found
                                }
                            }
                              catch
                            {
                                Write-Host  $Error[0].Exception.Message
                            }
    
							}

                    ## Start service
                            Get-Service -ComputerName $server -Name $ServiceName | Start-Service  
        
                            while ($ServiceStatus -eq "Stopped")
                            {
                                $ServiceStatus = (Get-Service -ComputerName $server -Name $ServiceName).Status
                                Write-Host $server $ServiceName $ServiceStatus
                                Start-Sleep -Seconds $DelayServiceStatusScan
                            }

            }
            else
            {
            Write-Host Host $server not found
            }
        }
       
        catch [System.Net.NetworkInformation.PingException]
        {
            
            Write-Host Host $server is not accessible 
        }
        catch
        {
            Write-Host  $Error[0].Exception.Message
        }
}

