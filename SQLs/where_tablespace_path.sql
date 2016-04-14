
set linesize 300
set pagesize 100

column FILE_NAME format a70
column USER_BLOCKS format a10
column FILE_ID format a20
column TABLESPACE_NAME format a30

SELECT * FROM dba_data_files;


