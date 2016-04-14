
#!/bin/bash


lookup=$1


sqlplus -S dqueiroz/12qw09po@pg5ba << EOF


column DETIPOSRV HEADING 'Serviço'
column DEIP format a15
column NMEXECUTAVEL format a15
set linesize 300


SELECT * FROM saj.epadbalancocarga WHERE DEIP='$lookup';
exit;


EOF

