-- Averaging 500MB/sec on Database I/O
set statistics io on
set statistics time on
go
--USE [TempResults]
--GO
--CREATE TABLE [dbo].[C00083P036_001_Global_Days_1_Alex5](
--	[Linekey] [bigint] NULL,
--	[CodePaid] [varchar](5) NULL
--) ON [PRIMARY]
--GO
--USE COMM_QueryDev
--GO
--SET SHOWPLAN_ALL ON;
--go
SET SHOWPLAN_XML ON
GO
--			INSERT Tempresults.dbo.C00083P036_001_Global_Days_1_Alex5
			SELECT TOP (100) PERCENT
			    		goodLines.Linekey,goodLines.CodePaid
			into		Tempresults.dbo.C00083P036_001_Global_Days_1_Alex7
			FROM		COVENTRY_MASTER.dbo.DETAIL goodLines
			left join	COVENTRY_MASTER.dbo.HEADER goodHdr
			ON			goodHdr.HDIAssignedHeaderPK=goodLines.HDIAssignedHeaderPK
			WHERE		2=2
			AND			goodLines.NetPaidAmt	>	0.00
			AND			goodLines.RecordType	=	'P'
			AND			goodHdr.EngineCode		IN	('4','6')							
			AND			goodLines.CLAIM_STATUS	=	'PAID'
			AND			EXISTS( SELECT	TOP (20) PERCENT	*
								FROM		_AlextmpRVUs							rvus
								WHERE		rvus.Procedure_Code				=	goodLines.CodePaid
								AND			rvus.modifier					=	CASE
																				WHEN	CodeModifierPaid1 IN ('26','TC','53')
																				THEN	CodeModifierPaid1
																				WHEN	CodeModifierPaid2 IN ('26','TC','53')
																				THEN	CodeModifierPaid2															
																				WHEN	CodeModifierPaid3 IN ('26','TC','53')
																				THEN	CodeModifierPaid3															
																				WHEN	CodeModifierPaid4 IN ('26','TC','53')
																				THEN	CodeModifierPaid4															
																				WHEN	CodeModifierPaid5 IN ('26','TC','53')
																				THEN	CodeModifierPaid5
																				ELSE	''
																				END								
								AND			rvus.global_period				IN	('000','010','090')
								AND			ISNULL(rvus.Active_Status,'')	<>	'C'		ORDER BY 	procedure_code
						)						

go
--SET SHOWPLAN_ALL OFF;
--go
SET SHOWPLAN_XML OFF
GO