DECLARE @exec_id BIGINT

EXEC [SSISDB].[catalog].[create_execution] 
    @package_name=N'Package.dtsx',     --SSIS package name TABLE:(SELECT * FROM [SSISDB].internal.packages)
    @folder_name=N'HDI', --Folder were the package lives TABLE:(SELECT * FROM [SSISDB].internal.folders)
    @project_name=N'SQLtoExcel',--Project name were SSIS package lives TABLE:(SELECT * FROM [SSISDB].internal.projects)
    @use32bitruntime=FALSE, 
    @reference_id=NULL,             --Environment reference, if null then no environment configuration is applied.
    @execution_id=@exec_id OUTPUT   --The paramter is outputed and contains the execution_id of your SSIS execution context.

SELECT @exec_id

SELECT [STATUS]
  FROM [SSISDB].[internal].[operations]
  WHERE operation_id = @exec_id

DECLARE @SSISParam nvarchar(300)  --Some random parameter value, needs to be in sql_variant format

SET @SSISParam = 'benedata'

EXEC [SSISDB].[catalog].[set_execution_parameter_value] 
    @exec_id,  -- The execution_id value we received by calling [create_execution]
    @object_type=30,  --30 is Package Parameters, you can also use 20 for Project parameters or 50 for Environment
    @parameter_name=N'DatabaseNameParm',  --Parameter name
    @parameter_value=@SSISParam

SET @SSISParam = 'dbo.appsettings'

EXEC [SSISDB].[catalog].[set_execution_parameter_value] 
    @exec_id,  -- The execution_id value we received by calling [create_execution]
    @object_type=30,  --30 is Package Parameters, you can also use 20 for Project parameters or 50 for Environment
    @parameter_name=N'TableNameParm',  --Parameter name
    @parameter_value=@SSISParam

SET @SSISParam = 'clcmssqldv1'

EXEC [SSISDB].[catalog].[set_execution_parameter_value] 
    @exec_id,  -- The execution_id value we received by calling [create_execution]
    @object_type=30,  --30 is Package Parameters, you can also use 20 for Project parameters or 50 for Environment
    @parameter_name=N'SQLServerNameParm',  --Parameter name
    @parameter_value=@SSISParam

SET @SSISParam = 'c:\powershell\AppSettings.xlsx'

EXEC [SSISDB].[catalog].[set_execution_parameter_value] 
    @exec_id,  -- The execution_id value we received by calling [create_execution]
    @object_type=30,  --30 is Package Parameters, you can also use 20 for Project parameters or 50 for Environment
    @parameter_name=N'ExcelFileNameParm',  --Parameter name
    @parameter_value=@SSISParam

EXEC [SSISDB].[catalog].[start_execution] @exec_id
