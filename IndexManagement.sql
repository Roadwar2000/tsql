Create Table tblIndexUsageInfo(Sno int identity(1,1), Dbname Varchar(100),TableName varchar(100),IndexName Varchar(300),Index_id int,ConstraintType varchar(25),Type_desc varchar(100),IndexKeyColumn Varchar(1000),IncludedColumn Varchar(1000),user_seeks int,user_scans int,user_lookups int,user_update int,IndexUsage int,IndexSizeKB int,IndexUSageToSizeRatio decimal(10,2))
go
CREATE function Uf_GetIndexCol(@index_id int,@tableid int,@isincluded bit)
returns varchar(3000)
As
BEGIN
return (stuff( (select ',' + sc.name 
from sys.columns sc,
sys.index_columns sic,sys.indexes si
where sc.column_id=sic.column_id 
and si.index_id=sic.index_id 
and sc.object_id=sic.object_id 
and si.object_id=sic.object_id 
and sic.is_included_column=@isincluded 
and si.object_id=@tableid and si.index_id=@index_id for xml path('')),1,1,''))
END
GO
Create Function [dbo].[Uf_GetIndexSize](@index_id int,@tableid int)
Returns float
AS
BEGIN
return (select sum(cast(reserved as float))*8192/(1024) 
from sysindexes where indid=@index_id and id=@tableid)
End
GO
Create Proc proc_FilltblIndexUsageInfo
AS
Begin
Truncate table tblIndexUsageInfo
insert into tblIndexUsageInfo 
select distinct db_name(db_id()) DbName,
so.name as 'TableName',ISNULL(si.name,'No Index') as IndexName,
si.index_id,Case When is_primary_key=1 then 'Primary Key Constraint' 
Else 'Index' End ConstraintType, si.type_desc,
dbo.Uf_GetIndexCol(si.index_id,so.object_id,0) As IndexKeyColumn,
dbo.Uf_GetIndexCol(si.index_id,so.object_id,1) As IncludedCols,spi.user_seeks,spi.user_scans,spi.user_lookups,spi.user_updates,(user_seeks+user_scans+user_lookups+user_updates) as 'IndexUsage ',dbo.Uf_GetindexSize(si.index_id,so.object_id) 'IndexSizeKB',
Cast((user_seeks+user_scans+user_lookups+user_updates)/
dbo.Uf_GetindexSize(si.index_id,so.object_id) As decimal(10,2)) As IndexUsagetoSizeRatio
from sys.objects so inner join sys.indexes si 
on so.object_id=si.Object_id inner join sys.dm_db_index_usage_stats spi 
on spi.Object_id=so.Object_id inner join sys.index_columns sic 
on sic.object_id=si.object_id and sic.index_id=si.index_id inner join sys.columns sc 
on sc.Column_id=sic.column_id and sc.object_id=sic.object_id inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS c 
on so.name=c.TABLE_NAME where so.type='u'
END
GO
Create table tblMostUsedIndexes
(
Sno int identity(1,1),
TableName varchar(100),
IndexName varchar(1000),
Index_id int,SchemaName Varchar(100),
TableId int,
IndexUsage int,
IndexUSageToSizeRatio decimal(10,2)
)
GO
Create Proc proc_InsertMostUsedIndexes(@IndexUSageToSizeRatio decimal(10,2),@indexusage int)
As
Begin
insert into tblMostUsedIndexes 
select b.TableName,b.IndexName,
(select index_id from sys.indexes where name=b.IndexName) As Index_id,ss.name As Schemaname,object_id(tablename),IndexUsage,IndexUSageToSizeRatio
from tblIndexUsageInfo b,sys.tables st,sys.schemas ss 
where (b.indexusage>=@indexUsage Or IndexUSageToSizeRatio>=@IndexUSageToSizeRatio) 
and st.name=tablename and st.schema_id=ss.schema_id 
and b.indexname not in (select indexname from tblMostUsedIndexes)
group by b.indexname,b.tablename,ss.name,b.IndexUSageToSizeRatio,b.indexusage
End
GO
--Execute proc_InsertMostUsedIndexes 10.00,100
GO
Create Proc proc_RebuildSelectedIndexes
As
BEGIN
SET NOCOUNT ON /* Code to Rebuild or Reorganise index */
Declare @Schema varchar(200),@Tablename varchar(200)
Declare @indexName varchar(400),@Qry varchar(1000),@RecCount int 
Declare @avg_frag decimal,@dbid int,@ObjectId int
Declare @IndexCount int,@TotalRec int,@Index_type varchar(50)
Declare @IndexRebuildCount int,@IndexReorgCount int,@IxOpr varchar(10)
Declare @index_id int
Set @IndexRebuildCount = 0
Set @IndexReorgCount = 0
set @IxOpr=''
set @dbid=db_id()
select @RecCount=sno from tblMostUsedIndexes
set @TotalRec=@RecCount
While(@RecCount>0) 
BEGIN 
select @Schema=schemaname,@TableName=TableName,@ObjectId=tableid,
@index_id=index_id 
from tblMostUsedIndexes 
where sno=@RecCount
SELECT IDENTITY(int,1,1) as Sno,a.[name] IndexName,avg_fragmentation_in_percent as avg_frag,
type_desc,a.index_id 
into #temp_2
FROM sys.dm_db_index_physical_stats(@dbid, @objectid, @index_id, NULL , 'Limited') as b 
join sys.indexes as a on a.object_id = b.object_id 
AND a.index_id = b.index_id and a.index_id>0 select @IndexCount=sno from #temp_2
While(@IndexCount>0)
BEGIN
select @avg_frag=avg_frag,@IndexName=indexname,@Index_Type=type_desc
from #temp_2 
where sno=@IndexCount
IF(@avg_frag<=20) 
BEGIN 
set @Qry='Alter index ' + @IndexName + ' ON ' + @Schema + '.' + @TableName + ' REORGANIZE;'
Set @IndexReorgCount=@IndexReorgCount + 1
set @IxOpr='REORGANIZE'
END
IF(@avg_frag>20) 
BEGIN 
set @Qry='Alter index ' + @IndexName + ' ON ' + @Schema + '.' + @TableName + ' REBUILD;'
Set @IndexRebuildCount = @IndexRebuildCount + 1 
set @IxOpr='REBUILD'
END 
print @qry
EXECUTE(@qry)
set @IndexCount=@IndexCount-1
END
drop table #temp_2
set @RecCount=@RecCount - 1 
END
SET NOCOUNT OFF
END
GO
Create table tblUnusedIndexes
(
UnusedIndid int identity(1,1),
Schemaname varchar(100),
tablename varchar(100),
IndexName varchar(500),
IndexUsage int,
IndexUsageToSizeRatio decimal(10,2),IndexKey varchar(1000),
IncludedCol varchar(1000),
ConstraintType varchar(1000),IndexSizeKB int,
DropQry varchar(4000),
IndexStatus varchar(20) default 'Active')
GO
Create Procedure proc_FilltblUnusedIndexes(@IndexUsageToSizeRatio decimal(10,2),@indexusage int)
As
Begin
insert into tblUnusedIndexes
(
Schemaname,
tablename,
IndexName,
IndexUsage,
IndexUsageToSizeRatio,
IndexKey,
IncludedCol,ConstraintType,
IndexSizeKB,
DropQry
)-- Indexes that does not exist in sys.dm_db_index_usage_stats
select ss.name SchemaName,so.name as TableName,
ISNULL(si.name,'NoIndex') as IndexName,0 IndexUsage,0 IndexUsageToSizeRatio,
dbo.Uf_GetIndexCol(si.index_id,so.object_id,0) As IndexKey,dbo.Uf_GetIndexCol(si.index_id,so.object_id,1) As IncludedCol,
Case When is_primary_key=1 then 'Primary Key Constraint' Else 'Index' End ConstraintType,
dbo.Uf_GetIndexSize(si.index_id,so.object_id) As IndexSizeInKB,
Case When (is_primary_key=1) then ('alter table ' + so.name + ' drop constraint ' + si.name) Else ('Drop Index ' + ss.name + '.' + so.name + '.' + si.name) End As DropQry
from sys.objects so inner join sys.indexes si on so.object_id=si.Object_id
inner join sys.schemas ss on ss.schema_id=so.schema_id
where not exists 
(select * from sys.dm_db_index_usage_stats spi 
where si.object_id=spi.object_id and si.index_id=spi.index_id)
and so.type='U' and ss.schema_id<>4 and si.index_id>0
and si.name not in (select indexname from tblUnusedIndexes)
union 
-- Indexes that doesn't satisfy the Indexusage criteria.select ss.name,b.TableName,b.IndexName,b.IndexUsage ,b.IndexUsageToSizeRatio,dbo.Uf_GetIndexCol(b.index_id,object_id(b.tablename),0) As IndexKey,dbo.Uf_GetIndexCol(b.index_id,object_id(b.tablename),1) As IncludedCol,b.ConstraintType,
dbo.Uf_GetIndexSize(b.index_id,object_id(b.tablename)) As IndexSizeInKB,Case b.ConstraintType When 'Index' 
then ('Drop Index ' + ss.name + '.' + b.TableName + '.' + b.IndexName) Else ('alter table ' + b.TableName + ' drop constraint ' + b.IndexName) End DropQry
from tblIndexUsageInfo b,sys.tables st,sys.schemas ss
where (b.indexusage<=@indexUsage Or IndexUsageToSizeRatio<=@IndexUsageToSizeRatio) and st.name=tablename and st.schema_id=ss.schema_id
and b.indexname not in (select indexname from tblUnusedIndexes)
group by b.indexname,b.tablename,ss.name,ss.schema_id,
b.ConstraintType,b.index_id,b.indexusage,b.IndexUsageToSizeRatio
END
GO
Create Proc proc_DropUnusedIndex
@UnusedIndID int
As
Begin
Declare @SqlStr Varchar(4000)
select @SqlStr=DropQry 
from tblunusedindexes 
where UnusedIndid=@UnusedIndID
BEGIN TRAN
BEGIN TRY
Execute(@SqlStr)
Update tblunusedindexes 
Set IndexStatus='Dropped' 
where UnusedIndID=@UnusedIndID
END TRY
BEGIN CATCH
select ERROR_MESSAGE() as ErrorMessage
IF @@TRANCOUNT > 0 
ROLLBACK TRANSACTION;
END CATCH
IF @@TRANCOUNT > 0 
COMMIT TRANSACTION
print 'Index dropped Successfully'
END
GO
Create table tblMissingIndexes (Sno int identity(1,1),DatabaseName varchar(100),tablename varchar(200),Significance decimal(10,0),CreateIndexStatement varchar(8000),
Status varchar(20) default ('NotCreated'))
GO
Create procedure proc_FindMisisngIndexes
As
BEGIN
insert into tblMissingIndexes(DatabaseName,tablename,
Significance,Createindexstatement)select db_name(sid.database_id),sid.statement,(avg_total_user_cost * avg_user_impact) * (user_scans + user_seeks) 
As Significance,dbo.fn_CreateIndexStmt
(
sid.statement,
sid.equality_columns,
sid.inequality_columns,
sid.included_columns)from sys.dm_db_missing_index_details sid,
sys.dm_db_missing_index_group_stats sigs,
sys.dm_db_missing_index_groups sig where sig.index_group_handle=sigs.group_handle and sid.index_handle=sig.index_handle
order by significance desc
END
GO
Create function fn_CreateIndexStmt(
@statement varchar(1000),
@Equalitycols varchar(1000),
@InEqualitycols varchar(1000),
@Includedcols varchar(1000)
)
Returns varchar(5000)
AS
Begin
Declare @str varchar(5000),@tablename varchar(100)
set @tablename=substring(substring(@statement,charindex('.',@statement)+1,len(@statement)),charindex('.',substring(@statement,charindex('.',@statement)+1,len(@statement)))+1,len(substring(@statement,charindex('.',@statement)+1,len(@statement))))
set @Includedcols=Replace(Replace(@Includedcols,']',''),'[','')
set @Equalitycols=Replace(Replace(Replace(@Equalitycols,']',''),', ','_'),'[','')
set @InEqualitycols=Replace(Replace(Replace(@InEqualitycols,']',''),', ','_'),'[','')
set @str='Create Index Ix_' + replace(replace(@tablename,']',''),'[','') 
set @str=Case WHEN @Equalitycols is NULL THEN @str ELSE (@str + '_' + ISNULL(@Equalitycols,'')) END
set @str=Case WHEN @InEqualitycols is NULL THEN @str ELSE (@str + '_' + ISNULL(@InEqualitycols,'')) END 
set @str=@str + ' ON ' + @statement + '(' + CASE WHEN @Equalitycols IS NULL THEN '' ELSE replace(ISNULL(@Equalitycols,''),'_',',') END + CASE WHEN @InEqualitycols IS NULL THEN '' ELSE ',' + replace(ISNULL(@InEqualitycols,''),'_',',') END+')'
set @str=Case WHEN @Includedcols is NULL THEN @str ELSE @str + 'Include (' + ISNULL(@Includedcols,'') + ')' END
return @str
END
GO
Create Procedure proc_CreateMissingIndexes
@significance decimal(10,0)
AS
Begin
Declare @Count int,@SqlStr varchar(8000)
set @SqlStr=''
Select Identity(int,1,1) AS Sno,CreateIndexStatement 
into #temp
from tblmissingindexes 
where significance>@significance
select @count=count(*) 
from #temp
While(@count>=0)
Begin
select @SqlStr=CreateIndexStatement from #temp where sno=@count
update tblmissingindexes 
set Status='Created' where sno=@count
exec(@sqlStr)
set @count=@Count - 1
END
END