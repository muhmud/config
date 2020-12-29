
select * from job where job_identifier like '/olap/%';

show tables;

select status, status_timestamp, message
from job where job_identifier = '/olap/ops11';

select status, status_timestamp, message
from job where job_identifier = '/olap/ops11/incremental';

update job
  set cron = "30 4 * * *",
      payload = '{ "importName": "OLAP_INCREMENTAL", "jdbcUrl": "jdbc:monetdb://ops102-db.staging.ops.aws/olap", "requeue": true }'
where job_identifier = '/olap/ops11/incremental';

update job
  set scheduled_timestamp = now(),
      status = 'QUEUED'
where job_identifier = '/olap/ops11/incremental';

update job
  set scheduled_timestamp = now(),
      status = 'QUEUED'
where job_identifier = '/olap/ops1t/incremental';

select * from job_execution where job_id = 373 order by start_timestamp;

select * from job where job_identifier = '/archive';

select * from job;

insert into job (created_by, modified_by, request_source, request_timestamp, job_identifier,
    scheduled_timestamp, job_type, server_id, database_id, payload, status, status_timestamp,
    message)
  values (current_user, current_user, 'olap', current_timestamp, '/olap/ops1t/incremental', null,
      'OLAP', null, null,
      '{ "importName": "OLAP_INCREMENTAL", "jdbcUrl": "jdbc:monetdb://ops1t.test.ops.aws/olap", "requeue": true }',
      'QUEUED', current_timestamp, 'job queued');

insert into job (created_by, modified_by, request_source, request_timestamp, job_identifier,
    scheduled_timestamp, job_type, server_id, database_id, payload, status, status_timestamp,
    message)
  values (current_user, current_user, 'olap', current_timestamp, '/olap/ops11/incremental', current_timestamp,
      'OLAP', null, null,
      '{ "importName": "OLAP_COMPLETE", "jdbcUrl": "jdbc:monetdb://ops1t.test.ops.aws/olap" }',
      'QUEUED', current_timestamp, 'job queued');

insert into job (created_by, modified_by, request_source, request_timestamp, job_identifier,
    scheduled_timestamp, job_type, server_id, database_id, payload, status, status_timestamp,
    message)
  values (current_user, current_user, 'olap', current_timestamp, '/olap/ops1t/reconciliation', null,
      'OLAP', null, null,
      '{ "importName": "OLAP_PATIENT_BILLING_RECONCILIATION", "jdbcUrl": "jdbc:monetdb://ops1t.test.ops.aws/olap", "requeue": true }',
      'QUEUED', current_timestamp, 'job queued');

select * from job;

update job
  set job_identifier = '/olap/ops1t/complete'
where job_identifier = '/olap/ops11/incremental';

select status, status_timestamp, message
from job
where job_identifier = '/olap/ops1t/incremental';

select status, status_timestamp, message
from job
where job_identifier = '/olap/ops1t/complete';

select status, status_timestamp, message
from job
where job_identifier = '/olap/ops1t/reconciliation';

update job
  set scheduled_timestamp = now(),
      status = 'QUEUED'
where job_identifier = '/olap/ops1t/incremental';

update job
  set scheduled_timestamp = now(),
      status = 'QUEUED'
where job_identifier = '/olap/ops1t/complete';

update job
  set scheduled_timestamp = now(),
      status = 'QUEUED'
where job_identifier = '/olap/ops1t/reconciliation';

update job
  set cron = '0 0 5 * * *'
where job_identifier = '/olap/ops1t/reconciliation';

select * from job;

rename table job to job_tmp;

create table job (
	id bigint auto_increment not null primary key,
  created_by varchar(128) not null,
  created_timestamp timestamp not null default current_timestamp,
  modified_by varchar(128) not null,
  modified_timestamp timestamp not null default current_timestamp,
  request_id varchar(128) null,
  request_source varchar(256) not null,
  request_timestamp timestamp not null,
  job_identifier varchar(256) not null unique,
  cron varchar(128) null,
  last_scheduled_timestamp timestamp null,
  scheduled_timestamp timestamp null,
  job_type varchar(128) not null,
  server_id bigint null,
  database_id bigint null,
  payload json not null,
  execution_id varchar(128) null,
  execution_count int not null default (0),
  exception_count int not null default (0),
  requeued_exception_count int not null default (0),
  requeued_exception_type varchar(256) null,
  status varchar(128) not null,
  status_timestamp timestamp not null,
  message varchar(1024) not null,
  result json null,
  check ((server_id is not null and database_id is null)
      or (server_id is null and database_id is not null)
      or (server_id is null and database_id is null))
);

alter table job add foreign key (status) references job_status (code);
alter table job add foreign key (job_type) references job_type (code);

insert into job (id, created_by, created_timestamp, modified_by, modified_timestamp, request_source,
    request_timestamp, job_identifier, last_scheduled_timestamp, scheduled_timestamp, job_type, server_id,
    database_id, payload, execution_count, exception_count, requeued_exception_count, requeued_exception_type,
    status, status_timestamp, message, result)
  select id, created_by, created_timestamp, modified_by, modified_timestamp, request_source,
    request_timestamp, job_identifier, last_scheduled_timestamp, scheduled_timestamp, job_type, server_id,
    database_id, payload, execution_count, exception_count, requeued_exception_count, requeued_exception_type,
    status, status_timestamp, message, result
  from job_tmp;

rename table job_execution to job_execution_tmp;

drop table job_execution_tmp;

select * from flyway_schema_history;

select * from job_type;
update flyway_schema_history
  set checksum = -1271194971
where version = 2;

show tables;

create table job_execution (
  id bigint auto_increment not null primary key,
  created_by varchar(128) not null,
  created_timestamp timestamp not null default current_timestamp,
  modified_by varchar(128) not null,
  modified_timestamp timestamp not null default current_timestamp,
  job_id bigint not null,
  start_timestamp timestamp not null,
  end_timestamp timestamp not null,
  backoffice_instance_id varchar(128) not null,
  execution_id varchar(128) null,
  status varchar(128) not null,
  message varchar(1024) not null,
  result json null
);
