############################################################################
#
#
#  Author: 		Viktor Kucher
#  Email:  		viktor.kucher@gmail.com
#  Blog:                http://viktorkucher.blogspot.com/2015/10/exchange-2010-monitoring-database-by.html
#  Date created:   	20/10/2015
#  Version: 		1.0 
#  Description: 	Get Exchange mailbox database parameters from csv file and send it to Zabbix server in JSON format
#                                                



$DbList	 	= "c:\zabbix\ExchangeDbList.csv"
$Dbs		= Import-csv -path $DbList


$dbsCount=$dbs.length

Write-Host "{"
Write-Host '"data":'
Write-Host "["

$i=0
	foreach ($db in $dbs)
	{
        $i += 1
	$dbJsonServer='"{#MBSERVER}":"'+$db.Server+'", '
	$dbJsonName='"{#MBNAME}":"'+$db.name+'", '
	$dbJsonGUID='"{#MBGUID}":"'+$db.Guid+'" '
        Write-Host "{"
	Write-Host $dbJsonServer
	Write-Host $dbJsonName
	Write-Host $dbJsonGUID

	if ($i -lt $dbsCount) 
	{
	Write-Host "},"
	}
	else
	{
	Write-Host "}"
	}

}


Write-Host "]"
Write-Host "}"
