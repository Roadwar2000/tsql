SELECT 
CASE 
  WHEN sv.name IS NULL --No matching name on server, drop the user.
  THEN 'DROP USER ' + quotename(db.name)+ ';'
  WHEN db.sid <> sv.sid   --orphaned user with mathcing name, fix the user:
  THEN 'ALTER USER ' + quotename(db.name) + ' WITH LOGIN = ' +sv.name + ';'
  ELSE ''  
END,  

* FROM sys.database_principals db
left outer join sys.server_principals sv
on db.name = sv.name
WHERE db.type_desc IN('SQL_USER','WINDOWS_USER')
  AND db.name NOT IN('dbo','guest','INFORMATION_SCHEMA','sys')