############################################################################
#
#
#  Author: 		Viktor Kucher
#  Email:  		viktor.kucher@gmail.com
#  Blog:                http://viktorkucher.blogspot.com/2015/10/exchange-2010-monitoring-database-by.html
#  Date created:   	20/10/2015
#  Version: 		1.0 
#  Description: 	Get Exchange mailbox database parameters and save to csv file
#                                                


$dbList			 = "c:\zabbix\ExchangeDbList.csv"
$ParametersDatabases 	 = @()



#Add Exchange 2010 snapin if not already loaded
if (!(Get-PSSnapin | where {$_.Name -eq "Microsoft.Exchange.Management.PowerShell.E2010"}))
{
	Write-Verbose "Loading Exchange 2010 Snapin"
	Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction SilentlyContinue
}



$dbs	 = @(Get-MailboxDatabase -Status | Where {$_.Recovery -ne $true})
$dn	 = get-date

foreach ($db in $dbs)
{

 
$lfb 			= [math]::Round(($dn - $db.LastFullBackup).TotalHours)
$dbStatistics 		= $db | Get-MailboxStatistics  |
			  select @{Name="TotalItemSize";Expression={$_.Totalitemsize.Value.ToMb()}}, 
      			         @{Name="TotalDeletedItemSize";Expression={$_.TotalDeletedItemSize.Value.ToMb()}}, 
			         itemcount | measure-object TotalItemSize, itemCount, TotalDeletedItemSize -Sum

$itemCount		= ($dbStatistics | where-object {$_.property -eq "ItemCount"}).Sum 
$TotalItemSize		= [math]::Round((($dbStatistics | where-object {$_.property -eq "TotalItemSize"}).Sum)/1024)  
$TotalDeletedItemSize	= [math]::Round((($dbStatistics | where-object {$_.property -eq "TotalDeletedItemSize"}).Sum)/1024)  
$mailboxcount 		= ($db | Get-Mailbox).count  


$ParametersDatabase = New-Object -TypeName PSObject
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name ts 		-Value $dn
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name name 		-Value $db.name
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name server 		-Value $db.server
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name guid 		-Value $db.guid
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name mounted		-Value $db.mounted
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name lfb 		-Value $lfb
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name mailboxcount	-Value $mailboxcount
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name itemcount	-Value $itemCount
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name dbsize		-Value $db.DatabaseSize.ToGb()
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name anmbs		-Value $db.AvailableNewMailboxSpace.ToGb()
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name tis		-Value $TotalItemSize
$ParametersDatabase | Add-Member -MemberType NoteProperty -Name tdis		-Value $TotalDeletedItemSize

$ParametersDatabases += $ParametersDatabase

}

$ParametersDatabases | Export-csv $dbList -NoTypeInformation





