SELECT 
@@SERVERNAME
,@@SERVICENAME
,@@VERSION
,@@OPTIONS
,@@REMSERVER

SP_CONFIGURE 'show advanced options', 1
go
reconfigure
go
sp_configure