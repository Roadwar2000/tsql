USE TempWork
GO
--Replace NULL with keywords of the ReportManager's Report Path, 
--if reports from any specific path are to be downloaded
DECLARE @FilterReportPath AS VARCHAR(500) = NULL 
 
--Replace NULL with the keyword matching the Report File Name,
--if any specific reports are to be downloaded
DECLARE @FilterReportName AS VARCHAR(500) = NULL
 
--Replace this path with the Server Location where you want the
--reports to be downloaded..
DECLARE @OutputPath AS VARCHAR(500) = 'X:\RDLs'
 
--Used to prepare the dynamic query
DECLARE @TSQL AS NVARCHAR(MAX)
 
--Reset the OutputPath separator.
SET @OutputPath = REPLACE(@OutputPath,'\','/')
 
--Simple validation of OutputPath; this can be changed as per ones need.
IF LTRIM(RTRIM(ISNULL(@OutputPath,''))) = ''
BEGIN
  SELECT 'Invalid Output Path'
END
ELSE
BEGIN
   --Prepare the query for download.
   /*
   Please note the following points -
   1. The BCP command could be modified as per ones need. E.g. Providing UserName/Password, etc.
   2. Please update the SSRS Report Database name. Currently, it is set to default - [ReportServer]
   3. The BCP does not create missing Directories. So, additional logic could be implemented to handle that.
   4. SSRS stores the XML items (Report RDL and Data Source definitions) using the UTF-8 encoding. 
      It just so happens that UTF-8 Unicode strings do not NEED to have a BOM and in fact ideally would not have one. 
      However, you will see some report items in your SSRS that begin with a specific sequence of bytes (0xEFBBBF). 
      That sequence is the UTF-8 Byte Order Mark. It’s character representation is the following three characters, “ï»¿”. 
      While it is supported, it can cause problems with the conversion to XML, so it is removed.
   */
   --SET @TSQL = STUFF((
   SELECT 
                      'EXEC master..xp_cmdshell ''bcp "' +
                      ' SELECT' +
                      ' CONVERT(VARCHAR(MAX),' +
                      ' CASE' +
                      ' WHEN LEFT(C.Content,3) = 0xEFBBBF THEN STUFF(C.Content,1,3,'''''''')'+
                      ' ELSE C.Content'+
                      ' END)' +
                      ' FROM' +
                      ' [ReportServer].[dbo].[Catalog] CL ' +
                      ' CROSS APPLY (SELECT CONVERT(VARBINARY(MAX),CL.Content) Content) C' +
                      ' WHERE' +
                      ' CL.ItemID = ''''' + CONVERT(VARCHAR(MAX), CL.ItemID) + ''''' " queryout "' + @OutputPath + CL.PATH 
					  -- +'/'+ CL.Name 
					  + '.rdl" ' + '-T -c -x'''
					  as L,
					  CL.Path
					  -- REPLACE(CL.PATH,'/','\')
--					SELECT *
INTO RDLs
                    FROM
                      [ReportServer].[dbo].[Catalog] CL
                    WHERE not cl.path like '%beta%' and 
                      CL.[Type] = 2 --Report
                      AND '/' + CL.[Path] + '/' LIKE COALESCE('%/%' + @FilterReportPath + '%/%', '/' + CL.[Path] + '/')
                      AND CL.Name LIKE COALESCE('%' + @FilterReportName + '%', CL.Name)
--                    FOR XML PATH('')
					--), 1,1,'')
  
  --SELECT @TSQL
--  print len(@TSQL)
  --Execute the Dynamic Query
  --EXEC SP_EXECUTESQL @TSQL
END
