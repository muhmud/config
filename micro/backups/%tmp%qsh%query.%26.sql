
select job_identifier, scheduled_timestamp, status, status_timestamp, message from job where job_identifier like '/olap/%';


update job
  set status = 'QUEUED',
      scheduled_timestamp = now()
where job_identifier = '/olap/ops11/incremental';