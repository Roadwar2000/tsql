	declare @JobToRun varchar(200), @jobid uniqueidentifier, @result int, @stop_date datetime;

	set @stop_date = NULL;

	-- Name of the Job to be executed, this could be a parameter to this procedure
	set @JobToRun = 'HDIAuditLogins';

	select @jobid = job_id 
	from msdb..sysjobs 
	where name = @JobToRun;

	-- Execute the Job using it's name
	EXEC MSDB..SP_Start_Job @Job_Name = @JobToRun;

	--Monitor the job until is completes
	while @stop_date IS NULL
	begin
		select top 1 @stop_date = stop_execution_date
		from msdb..sysjobactivity
		where job_id =@jobid
		order by run_requested_date desc
	end

	--Determine the final status of the job 0=failure,1=success,3=cancelled
	select top 1 @result = run_status 
	from msdb..sysjobhistory 
	where job_id = @jobid 
	order by instance_id desc;

	return @result;
