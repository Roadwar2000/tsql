 /*
   Procedure: Get_DBHELP.sql
  Written on: 9/3/2009
  Written by: Alex State
     Purpose: To keep a log of the many databases.  The table is kept on DatabaseInfo.  
	      This script is run just once for each server using the Red Gate Multiscript tool.
*/
/*
CREATE TABLE #DatabaseInfo (
	[name] [varchar](100), 
	[db_size] [varchar](50),
	[owner] [varchar](255) ,
	[dbid] [int] NULL,
	[created] [datetime] NULL,
	[status] [varchar](2000), 
	[compatibilty_level] [int] NULL
)
go
INSERT INTO #DatabaseInfo (
            [name]
           ,[db_size]
           ,[owner]
           ,[dbid]
           ,[created]
           ,[status]
           ,[compatibilty_level])
		   */
exec sp_helpdb
/*
go
INSERT INTO [dbo].[DatabaseInfo] (
	    [name]
           ,[db_size]
           ,[owner]
           ,[dbid]
           ,[created]
           ,[status]
           ,[compatibilty_level]
           ,[ServerName])
SELECT      [name]
           ,[db_size]
           ,[owner]
           ,[dbid]
           ,[created]
           ,[status]
           ,[compatibilty_level]
           ,@@SERVERNAME as [ServerName]
FROM #DatabaseInfo
go
drop table #DatabaseInfo
go
*/