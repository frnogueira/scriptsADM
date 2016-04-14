
#!/bin/bash


sqlplus -S dqueiroz/12qw09po@pg5ba << EOF


column DETIPOSRV format a15
column DEIP format a15
column NMEXECUTAVEL format a15
set linesize 300
set pagesize 100

SELECT * FROM saj.epadbalancocarga order by QTUSUARIOSATV;
exit;


EOF

