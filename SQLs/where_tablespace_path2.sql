
set linesize 300
set pagesize 100

column name format a70

SELECT tablespace_name,name,status,bytes/1024/1024 "Megas" FROM v$DATAFILE_HEADER;


