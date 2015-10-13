/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [LogId]
      ,[ServerName]
      ,[DatabaseName]
      ,[EventType]
      ,[ObjectName]
      ,[ObjectType]
      ,[SqlCommand]
      ,[EventDate]
      ,[LoginName]
      ,[msrepl_tran_version]
  FROM [HDIEventLog].[dbo].[ChangeLog]
  order by 1 desc