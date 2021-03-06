/*  This T-SQL statement will create a SHRINKFILE statement for each filegroup in a database.
	This only works well with database that are partitioned, for non partitioned databases use the 
	Shrink-Single-LogicalFile.sql script.
	
    You must first USE the database and also update the line of code that reads:
    and d.name = 'racdme'
    Put the name of the database you want to shrink as the name in quotes.
*/
declare @SQL varchar(max) =''

select @SQL = coalesce(@SQL,'') + '
DBCC SHRINKFILE (' + quotename(mf.[name],'''') + ', 1);'
FROM sys.databases d
INNER JOIN sys.master_files mf ON [d].[database_id] = [mf].[database_id]
WHERE
    d.[database_id] > 4 --no sys dbs
    AND d.is_read_only = 0
	and d.name='racdme'
ORDER BY d.name

print @SQL

execute (@SQL)

