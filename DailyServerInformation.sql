-----------------------    Server Information    -------------------------------
if object_id('tempdb..#tmp') is not null
                  drop table #tmp
 
if object_id('tempdb..#tmp2') is not null
                  drop table #tmp2
                                    
if object_id('tempdb..#DriveTable') is not null
                  drop table #DriveTable
 
create table #tmp(      id int not null identity(1, 1), result varchar(255))
insert into #tmp exec master.dbo.xp_cmdshell 'systeminfo'
 
create table #tmp2(     id int not null identity(1, 1), result varchar(255))
insert into #tmp2 exec xp_cmdshell 'dir j:\*.sqb /o-d /n'
 
create table #DriveTable (Drive varchar(1),[MB Free] int)
insert into #DriveTable Exec xp_fixeddrives
 
declare @osname   varchar(100)
declare @databaseCount integer
declare @cpu varchar(100)
declare @freespace integer
declare @backupPath varchar(100)
declare @datadrive char(1)
declare @dataspace integer
declare @actualspace as varchar(20)
 
set @datadrive ='F:\'
 
select @backupPath ='L:\Backups'
 
SELECT @freespace =([MB Free]/1024) FROM #DriveTable where Drive in ( 
select distinct left(physical_device_name,1) 'Backup' from msdb.dbo.backupmediafamily)
 
SELECT @dataspace =([MB Free]/1024) FROM #DriveTable where Drive = @datadrive
 
select @databaseCount = count(*) from master.dbo.sysdatabases
select @cpu = replace(result,'Processor(s):              ','')  from #tmp where id = 16
select @osname = replace(result,'OS Name:                   ','')  from #tmp where id = 3
 
 
select @@servername 'Server Name', @osname 'OS Version', replace(substring(@@version,22,4),' ','') 'SQL Version', SERVERPROPERTY('productversion') 'Build', SERVERPROPERTY ('productlevel') 'Service Pack Version', SERVERPROPERTY ('edition') 'Type', @cpu 'CPUs', @databaseCount 'Databases', ' ' 'Replication',  @dataspace 'Total Free Space for Data Drive in GB' ,  @freespace 'Total Free Space for Backup Drive in GB',@backupPath 'Red Gate backup folder','' 'Retention days', '' 'Backup Mins', '' 'Link Servers'
 
 
 
-----------------------    Jobs Information    -------------------------------
use msdb
go
select  j.name as 'Job Name', 
            CONVERT(VARCHAR(10), a.run_requested_date, 101) 'Starting Date',
            CONVERT(VARCHAR(8), a.run_requested_date, 108) 'Starting Time',
            CONVERT(VARCHAR(8),(a.stop_execution_date - a.start_execution_date),  108)  'Duration',
            h.message as 'Error Message',
            h.server as 'Server',
            case
            when h.run_status = 0 then 'Job Failed'
            when h.run_status = 1 then 'Job Succeeded'
            end as 'Job Status'
 
from dbo.sysjobs j inner join dbo.sysjobhistory h on j.job_id = h.job_id 
inner join dbo.sysjobactivity a on  j.job_id =a.job_id and h.run_date =convert(varchar(8),a.run_requested_date,112) 
where h.step_name ='(Job outcome)' and h.run_status=0
and h.run_date =convert(varchar(8),getdate()-1,112) 
 
 
-----------------------    Database backup Information    -------------------------------
 
declare @database varchar(50)
declare @sql varchar(5000)
declare @qtr integer
declare @backupPath varchar(100)
 
select @backupPath ='L:\Backups'
 
if object_id('tempdb..#temp1') is not null
                  drop table #temp1
 
create table #temp1 (
                  server_name [varchar](50) NULL, 
                  database_name [varchar](50) NULL, 
                  backup_start_date datetime NULL, 
                  backup_finish_date datetime NULL, 
                  compress_size [varchar](20) NULL,
                  backup_size [varchar](20) NULL,
                  backup_path [varchar](100) NULL, 
                  [description] [varchar](400) NULL, 
                  [user_name][varchar](50) NULL
) on [PRIMARY]
 
 
if object_id('tempdb..#temp2') is not null
                  drop table #temp2
 
create table #temp2 (
      [dbname] [varchar](100) NULL
) on [PRIMARY]
 
insert into #temp2 ([dbname])
select [name] from master.dbo.sysdatabases where name not in ('master','tempdb','model','msdb','distribution')
 
declare @criteria as varchar(100)
declare rs1 cursor for 
select [dbname]  from #temp2
 
open rs1
fetch next from rs1 into @database
 
while @@Fetch_Status = 0      
begin
 
            set @criteria = '%FULL_(local)_' + @database + '_'+ convert(varchar(8),getdate()-1,112) +'%'
 
            --set @sql = ' insert into #temp ([State],[Quarter],[Claim_Category],[Program_Code],[File_Type]) select ''' + @database + ''', ''' + cast(@qtr as char(1)) + ''',''FFS'   + ''',''MCAID'',''SAMP'''    
            --print @sql
            --exec(@sql)
            insert into #temp1 (
                                          server_name, 
                                          database_name, 
                                          backup_start_date, 
                                          backup_finish_date, 
                                          compress_size,
                                          backup_size,
                                          backup_path,
                                          [description], 
                                          [user_name]) 
                                          
            select                        server_name, 
                                          database_name, 
                                          backup_start_date, 
                                          backup_finish_date, 
                                          (select 
                                                      case 
                                                      when len(replace(replace(substring(result, 21, 19),',',''),' ','')) < 7 then cast(round(cast(replace(substring(result, 21, 19),',','') as float)/cast(1000  as float),2) as varchar(20)) + ' KB'
                                                      when len(replace(replace(substring(result, 21, 19),',',''),' ','')) > 6 and len(replace(replace(substring(result, 21, 19),',',''),' ','')) < 10 then cast(round(cast(replace(substring(result, 21, 19),',','') as float)/cast(1000000  as float),2) as varchar(20)) + ' MB'
                                                      when len(replace(replace(substring(result, 21, 19),',',''),' ','')) > 9 then cast(round(cast(replace(substring(result, 21, 19),',','') as float)/cast(1000000000 as float),2) as varchar(20))  + 'GB'
                                                      end  
                                          from #tmp2 where  result like @criteria),
 
                                          --(select top 1  round(cast(replace(substring(result, 21, 19),',','') as float)/cast(1000000000 as float),2)  from #tmp2 where  result like @criteria),
                                          case
                                          when len(backup_size) < 7 then cast(round(backup_size /cast(1000 AS float),2) as varchar(20)) + ' KB' 
                                          when len(backup_size) > 6 and len(backup_size) < 10 then cast(round(backup_size /cast(1000000 as float),2) as varchar(20)) + ' MB' 
                                          when len(backup_size) > 9 then cast(round(backup_size /cast(1000000000 as float),2) as varchar(20)) + ' GB' 
                                          end, 
                                          --backup_size /1048576 ,
                                          @backupPath,
                                          [description], 
                                          [user_name]
                         
            from msdb.dbo.backupset
            where database_name = @database and backup_start_date between dateadd(hh, -24, getdate()) and getdate()
            and type = 'D'
            order by backup_set_id desc
 
            print @database
fetch next from rs1 into @database
end
close rs1
deallocate rs1
 
select      server_name, 
            database_name, 
            backup_start_date, 
            backup_finish_date, 
            compress_size 'compress size',
            backup_size 'backup size' ,
            @backupPath 'back path',
            [description], 
            [user_name] 
            
from #temp1  --where backup_finish_date < GETDATE() - 1
