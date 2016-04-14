#!/bin/bash
#########################################################################################################
# Nome: deploySelo.sh - VERSAO 2									#
# Autor: Arllen Alves <avbalves@tjba.jus.br>								#
# Data: 2014-09-25 - VERSAO 1										#
# Data: 2014-09-26 - VERSAO 2										#
#													#
#													#
#########################################################################################################
# Script desenvolvido pela equipe linux com o objetivo de facilitar o deploy do sistema Selo Digital,	#
# baseado no atualizaSiga.sh, criado por Dionatas Queiroz <dqueiroz@tjba.jus.br> em 2014-05-03		#
# e no deployselo.sh, criado por Antonio Novaes <anovaes@tjba.jus.br> em 2014-09-19.			#
#													#
# Testado e homologado por Fabio Nogueira <frnogueira@tjba.jus.br>					#
#########################################################################################################

DATA=$(date +%Y%m%d-%H-%M-%S)
JBODIR="/u01/jboss-6.0.0.Final/server"
BKPDIR="/backups"
FILE="seloweb-app-1.0.0.ear"

if [ ! -d $BKPDIR ]; then
	echo "O diretorio de BACKUP nao existe!"
	echo "Criando o diretorio de BACKUP ( $BKPDIR )"
	mkdir $BKPDIR
	sleep 1
fi

if [ ! -d $JBODIR ]; then
	echo "O diretorio do JBOSS ( $JBODIR ) nao existe ou esta incorreto!"
	exit 1
fi

echo -e "Deploy do \e[1mSELO DIGITAL\e[0m \033[31m[1]\e[0m ou do \e[1mSELO DIGITAL CARGA\e[0m \033[31m[2]\e[0m? Digite \033[31m1\e[0m ou \033[31m2\e[0m: "
read VALOR

case $VALOR in
	1)
		echo -e "Informe o diretorio que o novo EAR do \033[31mselodigital\e[0m se encontra: "
		read PATH1
			if [ -z $PATH1 ]; then
				echo "O valor informado nao pode ser nulo!"
				exit 1
			fi
			if [ ! -f $PATH1/$FILE ]; then
				echo "Nao existe $FILE no path informado!"
				exit 1
			else
				echo "Realizando backup da versao atual do SELO DIGITAL"
				cp -af $JBODIR/selodigital01/deploy/$FILE $BKPDIR/$FILE-$DATA
				sleep 2
				echo "Parando a instancia queue"
				kill -9 $(ps aux | grep java | grep queue | awk {'print $2'})
				sleep 2
				echo "Limpando work e temp da instancia queue"
				rm -rf $JBODIR/queue/work/* $JBODIR/queue/temp/*
				sleep 2
				echo "Copiando o novo arquivo de deploy"
				chown jboss. $PATH1/$FILE
				cp -af $PATH1/$FILE $JBODIR/queue/deploy/
				sleep 2
				echo "Subindo a instancia queue"
				/bin/su - jboss -c "/u01/jboss-6.0.0.Final/bin/run.sh -b 0.0.0.0 -c queue -Djboss.jvmRoute=queue -Dwebservice.bind.address=www.tjba.jus.br" &> /dev/null &
				sleep 5
				echo "Parando a instancia selodigital01"
        			kill -9 $(ps aux | grep java | grep selodigital01 | awk {'print $2'})
        			sleep 2
        			echo "Limpando work e temp da instancia selodigital01"
        			rm -rf $JBODIR/selodigital01/work/* $JBODIR/selodigital01/temp/*
        			sleep 2
        			echo "Copiando o novo arquivo de deploy"
        			cp -af $PATH1/$FILE $JBODIR/selodigital01/deploy/
        			sleep 2
        			echo "Subindo a instancia selodigital01"
        			/bin/su - jboss -c "/u01/jboss-6.0.0.Final/bin/run.sh -b 0.0.0.0 -c selodigital01 -Djboss.service.binding.set=ports-01 -Djboss.jvmRoute=selo0101 -Dwebservice.bind.address=www.tjba.jus.br" &> /dev/null &
				sleep 5
        			echo "Parando a instancia selodigital02"
        			kill -9 $(ps aux | grep java | grep selodigital02 | awk {'print $2'})
        			sleep 2
        			echo "Limpando work e temp da instancia selodigital02"
        			rm -rf $JBODIR/selodigital02/work/* $JBODIR/selodigital02/temp/*
        			sleep 2
        			echo "Copiando o novo arquivo de deploy"
        			cp -af $PATH1/$FILE $JBODIR/selodigital02/deploy/
        			sleep 2
      			  	echo "Subindo a instancia selodigital02"
				/bin/su - jboss -c "/u01/jboss-6.0.0.Final/bin/run.sh -b 0.0.0.0 -c selodigital02 -Djboss.service.binding.set=ports-02 -Djboss.jvmRoute=selo0102 -Dwebservice.bind.address=www.tjba.jus.br" &> /dev/null &
		        	sleep 5
        			echo "Parando a instancia selodigital03"
        			kill -9 $(ps aux | grep java | grep selodigital03 | awk {'print $2'})
        			sleep 2
        			echo "Limpando work e temp da instancia selodigital03"
        			rm -rf $JBODIR/selodigital03/work/* $JBODIR/selodigital03/temp/*
        			sleep 2
        			echo "Copiando o novo arquivo de deploy"
        			cp -af $PATH1/$FILE $JBODIR/selodigital03/deploy/
        			sleep 2
        			echo "Subindo a instancia selodigital03"
				/bin/su - jboss -c "/u01/jboss-6.0.0.Final/bin/run.sh -b 0.0.0.0 -c selodigital03 -Djboss.service.binding.set=ports-03 -Djboss.jvmRoute=selo0103 -Dwebservice.bind.address=www.tjba.jus.br" &> /dev/null &
       			 	sleep 5
        			echo "Parando a instancia selodigital04"
        			kill -9 $(ps aux | grep java | grep selodigital04 | awk {'print $2'})
        			sleep 2
        			echo "Limpando work e temp da instancia selodigital04"
        			rm -rf $JBODIR/selodigital04/work/* $JBODIR/selodigital04/temp/*
        			sleep 2
        			echo "Copiando o novo arquivo de deploy"
        			cp -af $PATH1/$FILE $JBODIR/selodigital04/deploy/
        			sleep 2
        			echo "Subindo a instancia selodigital04"
				/bin/su - jboss -c "/u01/jboss-6.0.0.Final/bin/run.sh -b 0.0.0.0 -c selodigital04 -Djboss.service.binding.set=ports-04 -Djboss.jvmRoute=selo0104 -Dwebservice.bind.address=www.tjba.jus.br" &> /dev/null &
       			 	sleep 5
				echo "Deploy do SELO DIGITAL realizado com sucesso!"
				exit 0
			fi
	;;
	2)
		echo -e "Informe o diretorio em que o novo EAR do \033[31mselodigitalCARGA\e[0m se encontra: "
		read PATH2
			if [ -z $PATH2 ]; then
				echo "O valor informado nao pode ser nulo!"
				exit 1
			fi
			if [ ! -f $PATH2/$FILE ]; then
				echo "Nao existe $FILE no path informado!"
				exit 1
			else
        			echo "Realizando backup da versao atual do SELO DIGITAL CARGA"
       			 	cp -af $JBODIR/selodigitalCARGA/deploy/$FILE $BKPDIR/$FILE-CARGA-$DATA
        			sleep 2
        			echo "Parando a instancia selodigitalCARGA"
        			kill -9 $(ps aux | grep java | grep selodigitalCARGA | awk {'print $2'})
        			sleep 2
        			echo "Limpando work e temp da instancia selodigitalCARGA"
        			rm -rf $JBODIR/selodigitalCARGA/work/* $JBODIR/selodigitalCARGA/temp/*
        			sleep 2
        			echo "Copiando o novo arquivo de deploy"
        			chown jboss. $PATH2/$FILE
        			cp -af $PATH2/$FILE $JBODIR/selodigitalCARGA/deploy/
        			sleep 2
#        			echo "Subindo a instancia selodigitalCARGA"
#				/bin/su - jboss -c "/u01/jboss-6.0.0.Final/bin/run.sh -b 0.0.0.0 -c selodigitalCARGA -Djboss.service.binding.set=ports-04 -Djboss.jvmRoute=selocarga -Dwebservice.bind.address=www.tjba.jus.br" &> /dev/null &
#        			sleep 5
				echo "Deploy do SELO DIGITAL CARGA realizado com sucesso!"
				exit 0
			fi
	;;
	*)
		echo "Nenhum valor valido foi informado!"
		exit 1
	;;
esac
