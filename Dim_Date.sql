--Create the tables
BEGIN TRY
 DROP TABLE [dim_Date]
END TRY
BEGIN CATCH
 --DO NOTHING
END CATCH
CREATE TABLE [dbo].[dim_Date](
 --[ID] [int] IDENTITY(1,1) NOT NULL--Use this line if you just want an autoincrementing counter AND COMMENT BELOW LINE
 [ID] [int] NOT NULL--TO MAKE THE ID THE YYYYMMDD FORMAT USE THIS LINE AND COMMENT ABOVE LINE.
 , [Date] [datetime] NOT NULL
 , [Day] [char](2) NOT NULL
 , [DaySuffix] [varchar](4) NOT NULL
 , [DayOfWeek] [varchar](9) NOT NULL
 , [DOWInMonth] [TINYINT] NOT NULL
 , [DayOfYear] [int] NOT NULL
 , [WeekOfYear] [tinyint] NOT NULL
 , [WeekOfMonth] [tinyint] NOT NULL
 , [Month] [char](2) NOT NULL
 , [MonthName] [varchar](9) NOT NULL
 , [Quarter] [tinyint] NOT NULL
 , [QuarterName] [varchar](6) NOT NULL
 , [Year] [char](4) NOT NULL
 , [StandardDate] [varchar](10) NULL
 , [HolidayText] [varchar](50) NULL
 CONSTRAINT [PK_dim_Date] PRIMARY KEY CLUSTERED 
 (
 [ID] ASC
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
 ) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
BEGIN TRY
 DROP TABLE [dim_Time]
END TRY
BEGIN CATCH
 --DO NOTHING
END CATCH
CREATE TABLE [dbo].[dim_Time](
 [ID] [int] IDENTITY(1,1) NOT NULL,
 [Time] [char](8) NOT NULL,
 [Hour] [char](2) NOT NULL,
 [MilitaryHour] [char](2) NOT NULL,
 [Minute] [char](2) NOT NULL,
 [Second] [char](2) NOT NULL,
 [AmPm] [char](2) NOT NULL,
 [StandardTime] [char](11) NULL,
 CONSTRAINT [PK_dim_Time] PRIMARY KEY CLUSTERED 
 (
 [ID] ASC
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 ) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

--Populate Date dimension
PRINT convert(varchar,getdate(),113) --To see the exact run time.
TRUNCATE TABLE dim_Date

--IF YOU ARE USING THE YYYYMMDD format for the primary key then you need to comment out this line.
--DBCC CHECKIDENT (dim_Date, RESEED, 60000) --In case you need to add earlier dates later.

DECLARE @tmpDOW TABLE (DOW INT, Cntr INT)--Table for counting DOW occurance in a month
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(1,0)--Used in the loop below
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(2,0)
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(3,0)
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(4,0)
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(5,0)
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(6,0)
INSERT INTO @tmpDOW(DOW, Cntr) VALUES(7,0)

DECLARE @StartDate datetime
 , @EndDate datetime
 , @Date datetime
 , @WDofMonth INT
 , @CurrentMonth INT
 
SELECT @StartDate = '1/1/2010'
 , @EndDate = '1/1/2020'--Non inclusive. Stops on the day before this.
 , @CurrentMonth = 1 --Counter used in loop below.

SELECT @Date = @StartDate

WHILE @Date < @EndDate
 BEGIN
 
 IF DATEPART(MONTH,@Date) <> @CurrentMonth 
 BEGIN
 SELECT @CurrentMonth = DATEPART(MONTH,@Date)
 UPDATE @tmpDOW SET Cntr = 0
 END

 UPDATE @tmpDOW
 SET Cntr = Cntr + 1
 WHERE DOW = DATEPART(DW,@DATE)

 SELECT @WDofMonth = Cntr
 FROM @tmpDOW
 WHERE DOW = DATEPART(DW,@DATE) 

 INSERT INTO dim_Date
 (
 [ID],--TO MAKE THE ID THE YYYYMMDD FORMAT UNCOMMENT THIS LINE... Comment for autoincrementing.
 [Date]
 , [Day]
 , [DaySuffix]
 , [DayOfWeek]
 , [DOWInMonth]
 , [DayOfYear]
 , [WeekOfYear]
 , [WeekOfMonth] 
 , [Month]
 , [MonthName]
 , [Quarter]
 , [QuarterName]
 , [Year]
 )
 SELECT CONVERT(VARCHAR,@Date,112), --TO MAKE THE ID THE YYYYMMDD FORMAT UNCOMMENT THIS LINE COMMENT FOR AUTOINCREMENT
 @Date [Date]
 , DATEPART(DAY,@DATE) [Day]
 , CASE 
 WHEN DATEPART(DAY,@DATE) IN (11,12,13) THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'th'
 WHEN RIGHT(DATEPART(DAY,@DATE),1) = 1 THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'st'
 WHEN RIGHT(DATEPART(DAY,@DATE),1) = 2 THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'nd'
 WHEN RIGHT(DATEPART(DAY,@DATE),1) = 3 THEN CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'rd'
 ELSE CAST(DATEPART(DAY,@DATE) AS VARCHAR) + 'th' 
 END AS [DaySuffix]
 , CASE DATEPART(DW, @DATE)
 WHEN 1 THEN 'Sunday'
 WHEN 2 THEN 'Monday'
 WHEN 3 THEN 'Tuesday'
 WHEN 4 THEN 'Wednesday'
 WHEN 5 THEN 'Thursday'
 WHEN 6 THEN 'Friday'
 WHEN 7 THEN 'Saturday'
 END AS [DayOfWeek]
 , @WDofMonth [DOWInMonth]--Occurance of this day in this month. If Third Monday then 3 and DOW would be Monday.
 , DATEPART(dy,@Date) [DayOfYear]--Day of the year. 0 - 365/366
 , DATEPART(ww,@Date) [WeekOfYear]--0-52/53
 , DATEPART(ww,@Date) + 1 -
 DATEPART(ww,CAST(DATEPART(mm,@Date) AS VARCHAR) + '/1/' + CAST(DATEPART(yy,@Date) AS VARCHAR)) [WeekOfMonth]
 , DATEPART(MONTH,@DATE) [Month]--To be converted with leading zero later. 
 , DATENAME(MONTH,@DATE) [MonthName]
 , DATEPART(qq,@DATE) [Quarter]--Calendar quarter
 , CASE DATEPART(qq,@DATE) 
 WHEN 1 THEN 'First'
 WHEN 2 THEN 'Second'
 WHEN 3 THEN 'Third'
 WHEN 4 THEN 'Fourth'
 END AS [QuarterName]
 , DATEPART(YEAR,@Date) [Year]

 SELECT @Date = DATEADD(dd,1,@Date)
 END

--You can replace this code by editing the insert using my functions dbo.DBA_fnAddLeadingZeros
UPDATE dbo.dim_Date
 SET [DAY] = '0' + [DAY]
 WHERE LEN([DAY]) = 1

UPDATE dbo.dim_Date
 SET [MONTH] = '0' + [MONTH]
 WHERE LEN([MONTH]) = 1

UPDATE dbo.dim_Date
 SET STANDARDDATE = [MONTH] + '/' + [DAY] + '/' + [YEAR]

--Add HOLIDAYS --------------------------------------------------------------------------------------------------------------
--THANKSGIVING --------------------------------------------------------------------------------------------------------------
--Fourth THURSDAY in November.
UPDATE DIM_DATE
SET HolidayText = 'Thanksgiving Day'
WHERE [MONTH] = 11 
 AND [DAYOFWEEK] = 'Thursday' 
 AND [DOWInMonth] = 4
GO

--CHRISTMAS -------------------------------------------------------------------------------------------
UPDATE dbo.dim_Date
SET HolidayText = 'Christmas Day'
WHERE [MONTH] = 12 AND [DAY] = 25

--4th of July ---------------------------------------------------------------------------------------------
UPDATE dbo.dim_Date
SET HolidayText = 'Independance Day'
WHERE [MONTH] = 7 AND [DAY] = 4

-- New Years Day ---------------------------------------------------------------------------------------------
UPDATE dbo.dim_Date
SET HolidayText = 'New Year''s Day'
WHERE [MONTH] = 1 AND [DAY] = 1

--Memorial Day ----------------------------------------------------------------------------------------
--Last Monday in May
UPDATE dbo.dim_Date
SET HolidayText = 'Memorial Day'
FROM dim_Date
WHERE ID IN 
 (
 SELECT MAX([ID])
 FROM dbo.dim_Date
 WHERE [MonthName] = 'May'
 AND [DayOfWeek] = 'Monday'
 GROUP BY [YEAR], [MONTH]
 )
--Labor Day -------------------------------------------------------------------------------------------
--First Monday in September
UPDATE dbo.dim_Date
SET HolidayText = 'Labor Day'
FROM dim_Date
WHERE ID IN 
 (
 SELECT MIN([ID])
 FROM dbo.dim_Date
 WHERE [MonthName] = 'September'
 AND [DayOfWeek] = 'Monday'
 GROUP BY [YEAR], [MONTH]
 )

-- Valentine's Day ---------------------------------------------------------------------------------------------
UPDATE dbo.dim_Date
SET HolidayText = 'Valentine''s Day'
WHERE [MONTH] = 2 AND [DAY] = 14

-- Saint Patrick's Day -----------------------------------------------------------------------------------------
UPDATE dbo.dim_Date
SET HolidayText = 'Saint Patrick''s Day'
WHERE [MONTH] = 3 AND [DAY] = 17
GO
--Martin Luthor King Day ---------------------------------------------------------------------------------------
--Third Monday in January starting in 1983
UPDATE dim_Date
SET HolidayText = 'Martin Luthor King Jr Day'
WHERE [MONTH] = 1--January
 AND [Dayofweek] = 'Monday'
 AND [YEAR] >= 1983--When holiday was official
 AND [DOWInMonth] = 3--Third X day of current month.
GO
--President's Day ---------------------------------------------------------------------------------------
--Third Monday in February.
UPDATE dim_Date
SET HolidayText = 'President''s Day'--select * from dim_date
WHERE [MONTH] = 2--February
 AND [Dayofweek] = 'Monday'
 AND [DOWInMonth] = 3--Third occurance of a monday in this month.
GO
--Mother's Day ---------------------------------------------------------------------------------------
--Second Sunday of May
UPDATE dim_Date
SET HolidayText = 'Mother''s Day'--select * from dim_date
WHERE [MONTH] = 5--May
 AND [Dayofweek] = 'Sunday'
 AND [DOWInMonth] = 2--Second occurance of a monday in this month.
GO
--Father's Day ---------------------------------------------------------------------------------------
--Third Sunday of June
UPDATE dim_Date
SET HolidayText = 'Father''s Day'--select * from dim_date
WHERE [MONTH] = 6--June
 AND [Dayofweek] = 'Sunday'
 AND [DOWInMonth] = 3--Third occurance of a monday in this month.
GO
--Halloween 10/31 ----------------------------------------------------------------------------------
UPDATE dbo.dim_Date
SET HolidayText = 'Halloween'
WHERE [MONTH] = 10 AND [DAY] = 31
--Election Day--------------------------------------------------------------------------------------
--The first Tuesday after the first Monday in November.
BEGIN TRY
 drop table #tmpHoliday
END TRY 
BEGIN CATCH
 --do nothing
END CATCH

CREATE TABLE #tmpHoliday(ID INT IDENTITY(1,1), DateID int, Week TINYINT, YEAR CHAR(4), DAY CHAR(2))

INSERT INTO #tmpHoliday(DateID, [YEAR],[DAY])
 SELECT [id], [YEAR], [DAY]
 FROM dbo.dim_Date
 WHERE [MONTH] = 11
 AND [Dayofweek] = 'Monday'
 ORDER BY YEAR, DAY

DECLARE @CNTR INT, @POS INT, @STARTYEAR INT, @ENDYEAR INT, @CURRENTYEAR INT, @MINDAY INT

SELECT @CURRENTYEAR = MIN([YEAR])
 , @STARTYEAR = MIN([YEAR])
 , @ENDYEAR = MAX([YEAR])
FROM #tmpHoliday

WHILE @CURRENTYEAR <= @ENDYEAR
 BEGIN
 SELECT @CNTR = COUNT([YEAR])
 FROM #tmpHoliday
 WHERE [YEAR] = @CURRENTYEAR

 SET @POS = 1

 WHILE @POS <= @CNTR
 BEGIN
 SELECT @MINDAY = MIN(DAY)
 FROM #tmpHoliday
 WHERE [YEAR] = @CURRENTYEAR
 AND [WEEK] IS NULL

 UPDATE #tmpHoliday
 SET [WEEK] = @POS
 WHERE [YEAR] = @CURRENTYEAR
 AND [DAY] = @MINDAY

 SELECT @POS = @POS + 1
 END

 SELECT @CURRENTYEAR = @CURRENTYEAR + 1
 END

UPDATE DT
SET HolidayText = 'Election Day'
FROM dbo.dim_Date DT
JOIN #tmpHoliday HL
 ON (HL.DateID + 1) = DT.ID
WHERE [WEEK] = 1

DROP TABLE #tmpHoliday
GO
--------------------------------------------------------------------------------------------------------
PRINT CONVERT(VARCHAR,GETDATE(),113)--USED FOR CHECKING RUN TIME.

--Load time data for every second of a day
DECLARE @Time DATETIME

SET @TIME = CONVERT(VARCHAR,'12:00:00 AM',108)

TRUNCATE TABLE dim_Time

WHILE @TIME <= '11:59:59 PM'
 BEGIN
 INSERT INTO dbo.dim_Time([Time], [Hour], [MilitaryHour], [Minute], [Second], [AmPm])
 SELECT CONVERT(VARCHAR,@TIME,108) [Time]
 , CASE 
 WHEN DATEPART(HOUR,@Time) > 12 THEN DATEPART(HOUR,@Time) - 12
 ELSE DATEPART(HOUR,@Time) 
 END AS [Hour]
 , CAST(SUBSTRING(CONVERT(VARCHAR,@TIME,108),1,2) AS INT) [MilitaryHour]
 , DATEPART(MINUTE,@Time) [Minute]
 , DATEPART(SECOND,@Time) [Second]
 , CASE 
 WHEN DATEPART(HOUR,@Time) >= 12 THEN 'PM'
 ELSE 'AM'
 END AS [AmPm]

 SELECT @TIME = DATEADD(second,1,@Time)
 END

UPDATE dim_Time
SET [HOUR] = '0' + [HOUR]
WHERE LEN([HOUR]) = 1

UPDATE dim_Time
SET [MINUTE] = '0' + [MINUTE]
WHERE LEN([MINUTE]) = 1

UPDATE dim_Time
SET [SECOND] = '0' + [SECOND]
WHERE LEN([SECOND]) = 1

UPDATE dim_Time
SET [MilitaryHour] = '0' + [MilitaryHour]
WHERE LEN([MilitaryHour]) = 1

UPDATE dim_Time
SET StandardTime = [Hour] + ':' + [Minute] + ':' + [Second] + ' ' + AmPm
WHERE StandardTime is null
AND HOUR <> '00'

UPDATE dim_Time
SET StandardTime = '12' + ':' + [Minute] + ':' + [Second] + ' ' + AmPm
WHERE [HOUR] = '00'

--dim_date indexes---------------------------------------------------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [IDX_dim_Date_Date] ON [dbo].[dim_Date] 
(
[Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Date_Day] ON [dbo].[dim_Date] 
(
[Day] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Date_DayOfWeek] ON [dbo].[dim_Date] 
(
[DayOfWeek] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Date_DOWInMonth] ON [dbo].[dim_Date] 
(
[DOWInMonth] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Date_DayOfYear] ON [dbo].[dim_Date] 
(
[DayOfYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Date_WeekOfYear] ON [dbo].[dim_Date] 
(
[WeekOfYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Date_WeekOfMonth] ON [dbo].[dim_Date] 
(
[WeekOfMonth] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Date_Month] ON [dbo].[dim_Date] 
(
[Month] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Date_MonthName] ON [dbo].[dim_Date] 
(
[MonthName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Date_Quarter] ON [dbo].[dim_Date] 
(
[Quarter] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Date_QuarterName] ON [dbo].[dim_Date] 
(
[QuarterName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Date_Year] ON [dbo].[dim_Date] 
(
[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Time_HolidayText] ON [dbo].[dim_Date] 
(
[HolidayText] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

--dim_Time indexes
CREATE UNIQUE NONCLUSTERED INDEX [IDX_dim_Time_Time] ON [dbo].[dim_Time] 
(
[Time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Time_Hour] ON [dbo].[dim_Time] 
(
[Hour] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Time_MilitaryHour] ON [dbo].[dim_Time] 
(
[MilitaryHour] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Time_Minute] ON [dbo].[dim_Time] 
(
[Minute] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Time_Second] ON [dbo].[dim_Time] 
(
[Second] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Time_AmPm] ON [dbo].[dim_Time] 
(
[AmPm] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_dim_Time_StandardTime] ON [dbo].[dim_Time] 
(
[StandardTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

PRINT convert(varchar,getdate(),113)--USED FOR CHECKING RUN TIME.

--USAGE EXAMPLES:
--Join date and time and give all records for a specific date and time.--------------------
DECLARE @DATETIME DATETIME --select * from dim_date
SET @DATETIME = '07/30/1976 4:01:02 PM'

SELECT [DiffDays] = DATEDIFF(dd,[DATE],GETDATE())
 , [DiffYears] = DATEDIFF(dd,[DATE],GETDATE()) / 365.242199
 ,*, [StandardDateTime] = STANDARDDATE + ' ' + STANDARDTIME
FROM dim_Date DT
JOIN dim_Time TM
 ON TM.TIME = CONVERT(VARCHAR,@DATETIME,108)
WHERE DATE = CONVERT(VARCHAR,@DATETIME,101)
-------------------------------------------------------------------------------------------
--GET MONTH AND YEAR WHERE IT HAS MORE THAN 4 FRIDAYS
SELECT Month, Year, MAX(DOWInMonth)
FROM dim_Date
WHERE [DAYOFWEEK] = 'FRIDAY' 
 AND YEAR IN (2008, 2009)
GROUP BY YEAR, MONTH
HAVING MAX(DOWInMonth) > 4
ORDER BY YEAR, MONTH

--Get the number of days per year.
SELECT YEAR, COUNT(DAY) [days]
FROM dim_Date
GROUP BY YEAR

--Get paydays where 1/2/2009 is a payday and paydays are biweekly
SELECT CAST((DATEDIFF(dd,'1/2/2009',DATE) / 14.00) AS VARCHAR) [DiffFromStart], *
FROM dim_Date
WHERE DAYOFWEEK = 'Friday'
AND DATE >= '1/2/2001'--Starting at this date
AND (DATEDIFF(dd,'1/2/2009',DATE) / 14.0) = ROUND((DATEDIFF(dd,'1/2/2009',DATE) / 14.0),0)

--Month and year where we get three paydays in one month from 2009 on... 
SELECT MONTH, YEAR
FROM dim_Date
WHERE DATE >= '1/2/2009'
AND (DATEDIFF(dd,'1/2/2009',DATE) / 14.0) = ROUND((DATEDIFF(dd,'1/2/2009',DATE) / 14.0),0)
GROUP BY MonthName, Month, Year
HAVING COUNT(DAY) >= 3
ORDER BY YEAR, MONTH

