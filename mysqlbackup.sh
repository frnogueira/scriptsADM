#!/bin/bash
# Lista e faz backup de todos os bancos MYSQL em localhost
# Por: Gabriel Menezes <admlinux@tjba.jus.br>
# Data: 10 Jan 2013

FLAG="false"

DATA=`date +%Y%m%d`
BACKUPDIR="/opt/mysqlbackup"
SMTP="cronus.tj.ba.gov.br"

if [ ! -d $BACKUPDIR ]
then
mkdir $BACKUPDIR
fi

cd $BACKUPDIR

for database in `mysql --user=root --password=12qwadmmysql09po --execute="SHOW Databases" mysql | egrep -v "information_schema|logs|Database|lost\+found"`
do
	echo Executando backup de $database e comprimindo para $BACKUPDIR/$database-$DATA.tar
	mysqldump --password=12qwadmmysql09po --user=root $database > $BACKUPDIR/$database.sql && tar -zcf $BACKUPDIR/$database-$DATA.tar.gz ./$database.sql && echo Backup $database - OK && rm -f $BACKUPDIR/$database.sql && du -sh $BACKUPDIR/$database-$DATA.tar.gz
	if [ $? -ne 0 ]
        then
        sendemail -f `hostname`@tjba.jus.br -s $SMTP -o message-charset=UTF-8  -u "[MYSQL] ERRO no Backup de $database em `hostname`" -t admlinux@tjba.jus.br < /var/log/mysqlbkp.log &> /dev/null
        FLAG="true"
        fi
	echo
done &> /var/log/mysqlbkp.log

if [ $FLAG != "true" ]
then

# Remove backups antigos
find $BACKUPDIR/ -mtime +8 -exec  rm -f  {} \;

# Informações adicionais a serem enviadas por email
echo "Espaço ocupado em $BACKUPDIR em `hostname`" > /var/log/mysqlbkp.tmp
df -h $BACKUPDIR >> /var/log/mysqlbkp.tmp
echo >> /var/log/mysqlbkp.tmp
echo "Espaço ocupado pelos backups em $BACKUPDIR em `hostname`" >> /var/log/mysqlbkp.tmp
du -sh $BACKUPDIR >> /var/log/mysqlbkp.tmp
echo >> /var/log/mysqlbkp.tmp
echo "###########################################################################" >> /var/log/mysqlbkp.tmp
# Fim informações adicionais

sendemail -f `hostname`@tjba.jus.br -s $SMTP -o message-charset=UTF-8 -u "[MYSQL] Backup `hostname` OK" -t admlinux@tjba.jus.br -m "`cat /var/log/mysqlbkp.tmp /var/log/mysqlbkp.log`" &> /dev/null
fi

rm -f /var/log/mysqlbkp.tmp
