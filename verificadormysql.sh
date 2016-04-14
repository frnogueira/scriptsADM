
#!/bin/bash

ver_banco=`ps -ef|grep mysql|grep -v grep|tr -s " " ":"|cut -d: -f2 |wc -l `
if [ ${ver_banco} -gt 0 ]; then
   echo "Banco ativo"
   exit 0
else
 echo "Atenção -> Banco fora do ar"
 exit 1
fi

