USE [Dell_CMDB]
GO
CREATE USER [HDI\SQL-CLMGTD01-DELL_CMDB-R] FOR LOGIN [HDI\SQL-CLMGTD01-DELL_CMDB-R]
GO
EXEC sp_addrolemember N'db_datareader', N'HDI\SQL-CLMGTD01-DELL_CMDB-R'
GO
CREATE USER [HDI\SQL-CLMGTD01-DELL_CMDB-RW] FOR LOGIN [HDI\SQL-CLMGTD01-DELL_CMDB-RW]
GO
EXEC sp_addrolemember N'db_datareader', N'HDI\SQL-CLMGTD01-DELL_CMDB-RW'
GO
EXEC sp_addrolemember N'db_datawriter', N'HDI\SQL-CLMGTD01-DELL_CMDB-RW'
GO
CREATE USER [HDI\SQL-CLMGTD01-DELL_CMDB-O] FOR LOGIN [HDI\SQL-CLMGTD01-DELL_CMDB-O]
GO
EXEC sp_addrolemember N'db_owner', N'HDI\SQL-CLMGTD01-DELL_CMDB-O'
GO

select *
from sys.database_principals
where type_desc='DATABASE_ROLE' and is_fixed_role <> 1 and name <> 'public'