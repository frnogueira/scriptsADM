@/home/Dionatas/Modelos/SQLs/where_tablespace_path.sql
@/home/Dionatas/Modelos/SQLs/where_tablespace_path2.sql

select * from v$datafile
select name from v$datafile
select name,status from v$datafile

select * from v$tablespace


alter database datafile '/u01/app/oracle/oradata/XE/XE/datafile/o1_mf_tablespa_cf10m3sl_.dbf' resize 50m;

CREATE tablespace TABLESPACE_ESAJ datafile '/u01/app/oracle/oradata/XE/XE/datafile/tablespace_esaj.dbf'  size 100m autoextend on next 50m maxsize 20g;