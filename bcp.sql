DECLARE @query varchar(8000), @BCPCmd varchar(8000), @separator varchar(1), @file_path varchar(1000), @tmpStr varchar(1000), @result int

SET @separator = ' '
SET @query = 'select ''this is my text to be written via BCP'' '
-- change file_path to a path on your server
SET @file_path = '\\myserver\nickstest\'

-- create file_path if it doesnt exist
SET @tmpStr = 'MD ' + @file_path
EXEC master.dbo.xp_cmdshell @tmpStr

SET @file_path = @file_path + 'filetest-' + replace(convert(varchar(10), getdate(), 103), '/', '') + '.txt'

SET @BCPCmd='bcp "' + @query + '" queryout ' + @file_path + ' -T -c -t "' + @separator + '"'
EXEC master..xp_cmdshell @BCPCmd