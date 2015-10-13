use master
go

DECLARE @DatabaseNameType as varchar(100)
DECLARE @DriveLetterMoveTo as varchar(1)
DECLARE @SQL as nvarchar(MAX) 

SET @DatabaseNameType = '%201%'
SET @DriveLetterMoveTo = 'M'

SET @SQL = 'IF EXISTS (SELECT 1 FROM master.sys.databases where name = ''?'' and name like ''' + @DatabaseNameType +''')
BEGIN
use [?]
	IF EXISTS (SELECT 1 FROM sys.database_files where LEFT(physical_name, 1) <> '''+ @DriveLetterMoveTo + ''' and type = 0)
	BEGIN
		select ''print ''''?''''''
		union all
		select ''ALTER DATABASE [?]''+'' SET OFFLINE;''
		union all
		select ''GO''
		union all
		select ''xp_cmdshell ''''move ''+physical_name+'' '+ @DriveLetterMoveTo + ':\datafiles''''''
		from sys.database_files where type = 0 and physical_name like ''%datafiles%'' 
		union all
		select ''GO''
		union all
		select ''xp_cmdshell ''''move ''+physical_name+'' '+ @DriveLetterMoveTo + ':\indexfiles''''''
		from sys.database_files where type = 0 and physical_name like ''%indexfiles%'' 
		union all
		--select ''GO''
		--union all
		select ''ALTER DATABASE [?]''+'' MODIFY FILE (name=''''''+name+'''''', filename='''''+ @DriveLetterMoveTo + '''+SUBSTRING(physical_name, 2, LEN(physical_name))+'''''')''
		from sys.database_files where type = 0
		union all
		select ''ALTER DATABASE [?]''+'' SET ONLINE;''
	END
END'

exec sp_msforeachdb @SQL


