#inicio do Script
#!/bin/bash
##################################
# Script para monitorar processo #
##################################

# nome do processo a ser filtrado
PROCESSO_01=siga01
PROCESSO_02=siga02
# intervalo que sera feita a checagem (em segundos)
INTERVALO=600

while true
do
# numero de cópias do processo rodando
OCORRENCIAS01=$(ps ax | grep $PROCESSO_01 | grep -v grep| wc -l)

if [ $OCORRENCIAS01 -eq 0 ]
then
# Se o numero de processos rodando é 0, executa novamente
# a aplicação e notifica a area de TI

tail -n 100 /opt/jboss/jboss-as/server/siga01/log/server.log > /opt/dados_do_servidor.txt
w >> /opt/dados_do_servidor.txt
free -m >> /opt/dados_do_servidor.txt
iostat -k >> /opt/dados_do_servidor.txt
mail -s "$PROCESSO_01 do servidor $HOSTNAME foi reiniciado" admlinux@tjba.jus.br < /opt/dados_do_servidor.txt

/etc/init.d/jboss-$PROCESSO_01 stop
cd /u01/jboss-eap-5.2.0/jboss-as/server/$PROCESSO_01/
rm -rfv work/* tmp/*
/etc/init.d/jboss-$PROCESSO_01 start
fi

# numero de cópias do processo rodando
OCORRENCIAS02=$(ps ax | grep $PROCESSO_02 | grep -v grep| wc -l)
if [ $OCORRENCIAS02 -eq 0 ]

then
# Se o numero de processos rodando é 0, executa novamente
# a aplicação e notifica a area de TI

tail -n 100 /opt/jboss/jboss-as/server/siga02/log/server.log > /opt/dados_do_servidor.txt
w >> /opt/dados_do_servidor.txt
free -m >> /opt/dados_do_servidor.txt
iostat -k >> /opt/dados_do_servidor.txt
mail -s "$PROCESSO_02 do servidor $HOSTNAME foi reiniciado" admlinux@tjba.jus.br < /opt/dados_do_servidor.txt

/etc/init.d/jboss-$PROCESSO_02 stop
cd /u01/jboss-eap-5.2.0/jboss-as/server/$PROCESSO_02/
rm -rfv work/* tmp/*
/etc/init.d/jboss-$PROCESSO_02 start
fi

# Aguarda o intervalo especificado na variável e executa novamente o script
sleep $INTERVALO

echo "" >  /opt/dados_do_servidor.txt

done
# Fim do Script
