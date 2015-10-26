# Exchange 2010 mailbox database monitoring by Zabbix 


Zabbix monitoring and gathering mailbox databases's statistics in Exchange 2010 enviroment.

It was tested in Exchange 2010 and Zabbix 2.4.0


For Zabbix agent:

Get-ExchangeDb.ps1 		- send items parameters to Zabbix server
Get-ExchangeDbDiscovery.ps1     - discovery mailbox databases and send list to Zabbix sevrer in JSON format
Get-ExchangeDbStatus.ps1        - create csv file that contains info about mailbox databases
zabbix_agentd.userparams.conf   - user parameters for Zabbix agent



For Zabbix server:

MicrosoftExchange2010MailboxDatabases.xml - Zabbix's template 


Using:

  Zabbix agent located in c:\zabbix . Copy scripts *.ps1 to c:\zabbix folder. Copy zabbix_agentd.userparams.conf to c:\zabbix or add lines to existing file.
Configure scheduler to start Get-ExchangeDbStatus.ps1 every 5 minutes.
  Import template into Zabbix server.

Blog:  
  http://viktorkucher.blogspot.com/2015/10/exchange-2010-monitoring-database-by.html

 



