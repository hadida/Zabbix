############################################################################
#
#
#  Author: 		Viktor Kucher
#  Email:  		viktor.kucher@gmail.com
#  Blog:                http://viktorkucher.blogspot.com/2015/10/exchange-2010-monitoring-database-by.html
#  Date created:   	20/10/2015
#  Version: 		1.0 
#  Description: 	Get Exchange mailbox database parameters and save to csv file
#  Arguments:		$p1 - database parameter
#			$p2 - GUID mailbox database                                              
#
param([string]$p1,[string]$pdb)

$dbList	 	= "c:\zabbix\ExchangeDbList.csv"
$dbs		= Import-csv -path $DbList
$db 		= $dbs | where { $_.guid -eq $pdb}


        # Mounted
	if ($p1 -eq "mounted" )
		{
		Write-Host  $db.mounted
		}

	# Last Full Backup
	if ($p1 -eq "lfb" )
	{
		Write-Host  $db.lfb
	}


	# DB size
	if ($p1 -eq "dbsize" )
	{
		Write-Host $db.dbsize
	}


	# Available new mailboxes space
	if ($p1 -eq "anmbs" )
	{
		Write-Host $db.anmbs
	}


	# Item count
	if ($p1 -eq "itemcount" )
	{
		Write-Host $db.itemcount
	}

	# Total Item Size
	if ($p1 -eq "tis" ) 
	{
		write-Host $db.tis 
	}



	# Total Deleted Item Size
	if ($p1 -eq "tdis" ) 
	{
		write-Host $db.tdis
	}

	# Total mailboxes 
	if ($p1 -eq "mailboxcount" )
	{
		Write-Host $db.mailboxcount
	}
