#!/bin/bash

lookup=$1

sqlplus -S dqueiroz/12qw09po@pg5ba << EOF

set linesize 300
set pagesize 100

column CDPROCESSO format a20
column NUNIVELDEPEND CLEAR 
column NUPROCESSO format a20


SELECT CDPROCESSO,NUNIVELDEPEND,NUPROCESSO FROM saj.efpgprocesso WHERE NUPROCESSO='$lookup' and nuniveldepend=0;

exit;


EOF

