#!/bin/bash
clear

echo "--------------------------------------------------------------------------------------------" 
echo "Configurando acesso Variaveis de Ambiente e LOG"
echo "--------------------------------------------------------------------------------------------" 

DATE=`date +%Y%m%d`
LOG=/var/log/servidor-$DATE.log

DIR=$(pwd)
echo "" > $LOG


if [ ! -e /etc/apt/apt.conf ]; then
cat $DIR/apt.conf > /etc/apt/apt.conf >>  $LOG
fi

if [ ! -e /etc/apt/apt.conf.ORIGINAL ]; then
    mv /etc/apt/apt.conf /etc/apt/apt.conf.ORIGINAL >>  $LOG
else
    mv /etc/apt/apt.conf /etc/apt/apt.conf.$DATE >>  $LOG
fi

cat $DIR/apt.conf > /etc/apt/apt.conf

export DEBIAN_FRONTEND=noninteractive

alias cp="cp -f"
alias mv="mv -f"

export http_proxy="http://kraken.tj.ba.gov.br:80"
export ftp_proxy="http://kraken.tj.ba.gov.br:80"
export https_proxy="http://kraken.tj.ba.gov.br:80"


echo "Variaveis de Ambiente e LOG configurado"  >>  $LOG

apt-get update -y  >>  $LOG

function  Ntp(){
echo "--------------------------------------------------------------------------------------------" 
echo "Sincronizando o horario"
echo "--------------------------------------------------------------------------------------------" 

apt-get install ntpdate -y  >>  $LOG
apt-get autoremove -y  >>  $LOG
echo " " >>  $LOG
echo " " >>  $LOG

echo "Favor Informar o nome do servidor de NTP"
read ntp
ntpdate $ntp >>  $LOG
echo "Horario do servidor Sincronizado" >>  $LOG
echo " " >>  $LOG
echo " " >>  $LOG
}


function  Update(){
echo "--------------------------------------------------------------------------------------------" 
echo "Atualizando o SO"
echo "--------------------------------------------------------------------------------------------" 

apt-get upgrade -y  >>  $LOG
apt-get autoremove -y  >>  $LOG

echo "Atualizacao realizado com Sucesso" >>  $LOG
echo " " >>  $LOG
echo " " >>  $LOG
}


function  Essenciais(){
echo "--------------------------------------------------------------------------------------------" 
echo "Instalando pacotes Essenciais para o SO"
echo "--------------------------------------------------------------------------------------------" 

apt-get install vim telnet iotop tcpdump locate traceroute htop mtr iptraf mlocate gcc make -y  >>  $LOG
apt-get autoremove -y  >>  $LOG
echo "Pacotes essenciais instalados com Sucesso" >>  $LOG
echo " " >>  $LOG
echo " " >>  $LOG
}


function  Seguranca(){
echo "--------------------------------------------------------------------------------------------" 
echo "Instalando pacotes de Seguranca para o SO"
echo "--------------------------------------------------------------------------------------------" 

# Configuração de timeout de login e log de comandos
echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Configuracao de Timeout de login e log de comandos" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

if [ ! -e /etc/profile.ORIGINAL ]; then
    mv /etc/profile /etc/profile.ORIGINAL >>  $LOG
else
    mv /etc/profile /etc/profile.$DATE >>  $LOG
fi
cp $DIR/profile /etc/profile >>  $LOG
chmod 644 /etc/profile >>$LOG

echo "Criando pastas de sistemas"
mkdir /backup
mkdir /scripts
chmod o= /backup
chmod o= /scripts
chown -R :g-admlinux /backup/
chown -R :g-admlinux /scripts/

touch /backup/teste
touch /scripts/teste

groupadd administradores

apt-get install chkrootkit rkhunter logcheck snoopy apticron debsecan -y  >>  $LOG
apt-get autoremove -y  >>  $LOG
apt-get install git-core gitk -y  >>  $LOG
#apt-get install etckeeper -y >>  $LOG

if [ ! -e /etc/logcheck/logcheck.conf.ORIGINAL ]; then
    mv /etc/logcheck/logcheck.conf /etc/logcheck/logcheck.conf.ORIGINAL >>  $LOG
else
    mv /etc/logcheck/logcheck.conf /etc/logcheck/logcheck.conf.$DATE >>  $LOG
fi

cp $DIR/logcheck.conf /etc/logcheck/


#echo "Configurando o etckeeper." >> $LOG
#grep "#AVOID_SPECIAL_FILE_WARNING=1" /etc/etckeeper/etckeeper.conf > /dev/null
#if [ ! $? = 0 ]; then
#    sed -i "s/#AVOID_SPECIAL_FILE_WARNING=1/AVOID_SPECIAL_FILE_WARNING=1/g" /etc/etckeeper/etckeeper.conf
#    sed -i "s/#AVOID_DAILY_AUTOCOMMITS=1/AVOID_DAILY_AUTOCOMMITS=1/g" /etc/etckeeper/etckeeper.conf
#    sed -i "s/#AVOID_COMMIT_BEFORE_INSTALL=1/AVOID_COMMIT_BEFORE_INSTALL=1/g" /etc/etckeeper/etckeeper.conf
#fi

sed -i "s/EMAIL="root"/EMAIL="admlinux@tjba.jus.br"/g" /etc/apticron/apticron.conf 

debsecan

cp $DIR/gitignore /.gitignore

git config --global user.name $(hostname -f)
git config --global user.email 'admlinux@tjba.jus.br'
git config --global core.editor "vim"

echo "Inicializacao do repositorio." >> $LOG

cd / 

#etckeeper init 
#etckeeper commit "Importacao Inicial"
git init 
git add . 
git commit -a -m "teste" 

rm /backup/teste
rm /scripts/teste

git commit -a -m "remoção dos arquivos teste" 

cd $DIR

#echo "Configuracao do envio de notificacoes." >> $LOG
#cp -f $DIR/post-commit /.git/hooks/post-commit >> $LOG
#chmod +x /.git/hooks/post-commit >> $LOG
#cp -f $DIR/etckeeper /etc/cron.daily/etckeeper >> $LOG
#chmod +x /etc/cron.daily/etckeeper >> $LOG
#cp -f $DIR/10report-installed-packages /etc/etckeeper/post-install.d/10report-installed-packages >> $LOG
#chmod +x /etc/etckeeper/post-install.d/10report-installed-packages >> $LOG
#if [ ! -e /etc/etckeeper/post-install.d/50vcs-commit.ORIGINAL ]; then
#    mv /etc/etckeeper/post-install.d/50vcs-commit /etc/etckeeper/post-install.d/50vcs-commit.ORIGINAL >> $LOG
#fi
#cp -f $DIR/50vcs-commit /etc/etckeeper/post-install.d/50vcs-commit >> $LOG
#chmod +x /etc/etckeeper/post-install.d/50vcs-commit >> $LOG

echo "Mudando permissoes dos aplicativos" >>  $LOG
chown :administradores /usr/bin/wget
chown :administradores /bin/nc.traditional
chown :administradores /usr/bin/telnet.netkit

chmod o= /usr/bin/wget
chmod o= /bin/nc.traditional
chmod o= /usr/bin/telnet.netkit

echo "Removendo pacotes desnecesarios"
apt-get remove --purge ftp -y >> $LOG
       
echo "Pacotes de Seguranca instalados com Sucesso" >>  $LOG
echo " " >>  $LOG
echo " " >>  $LOG

}


function  Monitoramento(){
echo "--------------------------------------------------------------------------------------------" 
echo "Instalando pacotes de Monitoramento para o SO"
echo "--------------------------------------------------------------------------------------------" 

INIT_ZABBIX_AGENT="/etc/init.d/zabbix-agent"
if [ -e $INIT_ZABBIX_AGENT ]; then
echo "Já existe um Zabbix Agent Instalado. Faça uma atualização manual"

fi

Debian=$(cat /etc/issue|grep Debian|wc -l)
CentOS=$(cat /etc/issue|grep CentOS|wc -l)
RedHat=$(cat /etc/issue|grep Red|wc -l)
Fedora=$(cat /etc/issue|grep Fedora|wc -l)

SO_FOUND=0


function checkProcedimento() {

	if [ $? -eq 0 ]; then
		echo " [ OK ] "
	fi

	if [ $? -gt 0 ]; then
		echo " Erro, abortando instalação/configuração"
		
	fi

sleep 3
}


if [ $Debian -gt 0 ]; then

SO_FOUND=1

Debian_Version=$(cat /etc/debian_version |cut -d. -f1)

echo "Obtendo o pacote para configuração do repositório: " 

if [ $Debian_Version -eq 8 ]; then
wget --quiet http://repo.zabbix.com/zabbix/2.4/debian/pool/main/z/zabbix-release/zabbix-release_2.4-1+jessie_all.deb >>  $LOG
echo -n "Configurando repositorio: ";
dpkg -i zabbix-release_2.4-1+jessie_all.deb >>  $LOG
checkProcedimento
fi

if [ $Debian_Version -eq 7 ]; then
wget --quiet http://repo.zabbix.com/zabbix/2.4/debian/pool/main/z/zabbix-release/zabbix-release_2.4-1+wheezy_all.deb >>  $LOG
echo -n "Configurando repositorio: ";
dpkg -i zabbix-release_2.4-1+wheezy_all.deb >>  $LOG
checkProcedimento
fi

if [ $Debian_Version -lt 7 ]; then
echo -e "\e[01;33mEsse Debian é mais antigo que o Wheezy, deseja cancelar a instalação? Pressione Control+C, caso contrário espere que irá continuar\e[00m"
sleep 10
wget --quiet http://repo.zabbix.com/zabbix/2.4/debian/pool/main/z/zabbix-release/zabbix-release_2.4-1+wheezy_all.deb >>  $LOG
echo -n "Configurando repositorio: ";
dpkg -i zabbix-release_2.4-1+wheezy_all.deb >>  $LOG
checkProcedimento
fi

fi

if [ $CentOS -gt 0 ]; then

SO_FOUND=1

echo -n "Configurando repositorio: ";

CentoOS_Version=$(cat /etc/centos-release|awk '{print $3}'|cut -d. -f1)

if [ $CentoOS_Version -eq 6 ];then
	rpm -i --quiet http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm >>  $LOG
	checkProcedimento
fi

if [ $CentoOS_Version -eq 5 ];then
	rpm -i --quiet http://repo.zabbix.com/zabbix/2.4/rhel/5/x86_64/zabbix-get-2.4.5-1.el5.x86_64.rpm >>  $LOG
	checkProcedimento
fi

if [ $CentoOS_Version -lt 5 ];then
	echo "Abortando instalação" 
fi


echo -n "Instalando Zabbix Agent: "
yum install zabbix-agent -y >>  $LOG
checkProcedimento

echo -n "Configurando inicialização automática: "
chkconfig zabbix-agent on
checkProcedimento

fi


if [ $RedHat -gt 0 ]; then

SO_FOUND=1

echo -n "Configurando repositorio: ";

RedHat_Version=$(cat /etc/redhat-release |awk '{print $7}'|cut -d. -f1)

if [ $RedHat_Version -eq 6 ];then
        rpm -i --quiet http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm >>  $LOG
        checkProcedimento
fi

if [ $RedHat_Version -eq 5 ];then
        rpm -i --quiet http://repo.zabbix.com/zabbix/2.4/rhel/5/x86_64/zabbix-get-2.4.5-1.el5.x86_64.rpm >>  $LOG
        checkProcedimento
fi

if [ $RedHat_Version -lt 5 ];then
        echo "Abortando instalação" 
       
fi


echo -n "Instalando Zabbix Agent: "
yum install zabbix-agent -y >>  $LOG
checkProcedimento

echo -n "Configurando inicialização automática: "
chkconfig zabbix-agent on
checkProcedimento

fi


if [ $SO_FOUND -eq 0 ]; then
echo "Sistema Operacional não identificado"
/bin/mail -s "O Servidor não instalou o Zabbix Agent" admlinux@tjba.jus.br < /etc/issue

fi

echo ""
echo ""
echo "#### Iniciando configuração do Zabbix Agent ###"
echo ""
sleep 5

echo -n "Realizando o backup do arquivo de configuração original: "
cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf_BCK_ORIG_$(date +%Y%m%d)
checkProcedimento

EXISTE_WGET=$(whereis wget|grep /usr/bin/wget|wc -l)

if [ $EXISTE_WGET -eq 0 ]; then

        if [ $Debian -gt 0 ]; then
		echo -n "WGET não existe neste servidor, iniciando a instalação: "
                apt-get install wget -y >>  $LOG
                checkProcedimento
        else
		echo -n "WGET não existe neste servidor, iniciando a instalação: "
                yum install wget -y >>  $LOG
                checkProcedimento
        fi

fi

if [ $EXISTE_WGET -eq 1 ]; then
echo "Wget instalado: OK"
sleep 3
fi

echo -n "Copiando arquivo de configuração padrão: "
wget --quiet http://noc.tj.ba.gov.br/arquivo/zabbix_agentd.conf.template -O /etc/zabbix/zabbix_agentd.conf >>  $LOG
checkProcedimento

echo -n "Configurando nome do arquivo de configuração do zabbix agent: "
sed 's/SERVIDOR/'$(hostname -s).tjba.jus.br'/g' -i /etc/zabbix/zabbix_agentd.conf 
checkProcedimento

echo -n "Reiniciando Zabbix Agent: "

if [ $Debian -gt 0 ]; then
/etc/init.d/zabbix-agent restart
checkProcedimento
fi

if [ $Debian -eq 0 ]; then
/etc/init.d/zabbix-agent start
checkProcedimento
fi

apt-get autoremove -y  >>  $LOG
echo "Pacotes de Monitoramento instalados com Sucesso" >>  $LOG
echo " " >>  $LOG
echo " " >>  $LOG
}


function  AdSO(){

Ntp

echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Instanlando os pacotes" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG
apt-get -y install sudo samba >>  $LOG
apt-get -y install krb5-user libpam-krb5 winbind libpam-winbind libnss-winbind >>  $LOG 



#################
##### LOGIN #####
#################
# Configuração de mensagem de logon
echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Configurando mensagem de Logon" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

if [ ! -e /etc/motd.ORIGINAL ]; then
    mv /etc/motd /etc/motd.ORIGINAL >>  $LOG
else
    mv /etc/motd /etc/motd.$DATE >>  $LOG
fi
cp $DIR/motd /etc/motd >>  $LOG

# Configuração de timeout de login e log de comandos
echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Configuracao de Timeout de login e log de comandos" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

if [ ! -e /etc/profile.ORIGINAL ]; then
    mv /etc/profile /etc/profile.ORIGINAL >>  $LOG
else
    mv /etc/profile /etc/profile.$DATE >>  $LOG
fi
cp $DIR/profile /etc/profile >>  $LOG
chmod 644 /etc/profile >>$LOG

# Configuração da mensagem de screen
echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Configurando mensagem de screen">>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

if [ ! -e /etc/issue.ORIGINAL ]; then
    cp /etc/issue /etc/issue.ORIGINAL >>  $LOG
else
    cp /etc/issue /etc/issue.$DATE >>  $LOG
    cp /etc/issue.ORIGINAL /etc/issue 
fi

echo "Bem-vindo ao Linux TJBA Server em (\l)." >> /etc/issue


## Configuração de clearScreen no logout 
echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Configurando mensagem de clearscreen" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

if [ ! -e /etc/skel/.bash_logout ];then
    mv /etc/skel/.bash_logout /etc/skel/.bash_logout.ORIGINAL >>  $LOG
else
    mv /etc/skel/.bash_logout /etc/skel/.bash_logout.$DATE >>  $LOG
fi
cp $DIR/bash_logout /etc/skel/.bash_logout >>  $LOG

echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Atualizando o SSHD_CONFIG" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

if [ ! -e /etc/ssh/sshd_config.ORIGINAL ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.ORIGINAL >>  $LOG
else
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$DATE >>  $LOG
    cp  /etc/ssh/sshd_config.ORIGINAL /etc/ssh/sshd_config
fi

groupadd convidados

echo "UseDNS no" >> /etc/ssh/sshd_config
echo "AllowGroups g-admlinux convidados" >> /etc/ssh/sshd_config
sed -i "s/Port 22/Port 5000/g" /etc/ssh/sshd_config


echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Atualizando o KRB5.CONF" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

if [ ! -e /etc/krb5.conf.ORIGINAL ]; then
    cp /etc/krb5.conf /etc/krb5.conf.ORIGINAL >>  $LOG
else
    cp /etc/krb5.conf /etc/krb5.conf.$DATE >>  $LOG
fi

$(cat krb5.conf > /etc/krb5.conf) >>  $LOG

echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Atualizando o NSSWITCH.CONF" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

if [ ! -e /etc/nsswitch.conf.ORIGINAL ]; then
    cp /etc/nsswitch.conf /etc/nsswitch.conf.ORIGINAL >>  $LOG
else
    cp /etc/nsswitch.conf /etc/nsswitch.conf.$DATE >>  $LOG
fi

$(cat nsswitch.conf > /etc/nsswitch.conf) >>  $LOG

echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Atualizando o SMB.CONF" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

if [ ! -e /etc/samba/smb.conf.ORIGINAL ]; then
    cp /etc/samba/smb.conf /etc/samba/smb.conf.ORIGINAL >>  $LOG
else
    cp /etc/samba/smb.conf /etc/samba/smb.conf.$DATE >>  $LOG
fi

$(cat $DIR/smb.conf >/etc/samba/smb.conf) >>  $LOG


echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Diretorio PAN" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG 

mv /etc/pam.d /etc/pam.d_old
cp -pfa $DIR/pam.d /etc/pam.d


echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Reiniciando os servicos SAMBA e WINBIND" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

/etc/init.d/samba restart >>  $LOG
/etc/init.d/winbind restart >>  $LOG

echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Adicionando a maquina no dominio" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

echo "Insira o nome do seu usuario para adionar o servidor no dominio" 
read user

echo "Insira o Ip do servidor de dominio" 
read server
net ads join -U $user -S $server

echo "Execultando o KINIT" 
kinit $user 

echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Reiniciando os servicos SAMBA,SSH e WINBIND" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

/etc/init.d/samba restart >>  $LOG
/etc/init.d/winbind restart >>  $LOG

echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Configurando o arquivo SUDOES com os Grupos do AD" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

if [ ! -e /etc/sudoers.ORIGINAL ]; then
    cp /etc/sudoers /etc/sudoers.ORIGINAL >>  $LOG
else
    cp /etc/sudoers /etc/sudoers.$DATE >>  $LOG
    cp /etc/sudoers.ORIGINAL /etc/sudoers    
fi

echo "Cmnd_Alias      NOTVISUDO=/usr/sbin/visudo" >> /etc/sudoers 
echo "Cmnd_Alias      NOTSU=/bin/su" >> /etc/sudoers 
echo "%g-admlinux ALL=NOPASSWD:ALL, !NOTSU, !NOTVISUDO" >> /etc/sudoers 


echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Habilitando o servico de SAMBA, WINBIND e SSH na inicializacao" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

/etc/init.d/ssh restart >>  $LOG

echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Gerando uma consulta no AD" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

wbinfo -g >>  $LOG

smbcontrol winbind offline
wbinfo --online-status
smbcontrol winbind online
wbinfo --online-status

cp $DIR/etc/security/pam_winbind.conf /etc/security/

service winbind stop
service samba stop
net cache flush
service samba start
service winbind start

echo "Maquina adicionada no Dominio com Sucesso" >>  $LOG
echo " " >>  $LOG
echo " " >>  $LOG
}


function  Email(){

apt-get install postfix mailutils -y  >>  $LOG


echo "#######################################################"
echo "CONFIGURAR O POSTIFIX"
echo "#######################################################"
if [ ! -e /etc/postfix/main.cf.ORIGINAL ]; then
    cp /etc/postfix/main.cf /etc/postfix/main.cf.ORIGINAL >>  $LOG
else
    cp /etc/postfix/main.cf /etc/postfix/main.cf.$DATE >>  $LOG
    cp /etc/postfix/main.cf.ORIGINAL /etc/postfix/main.cf
fi

cp  ./main.cf /etc/postfix/main.cf
cp  ./sender_canonical /etc/postfix/

echo "root    $(hostname -f)@tjba.jus.br" > /etc/postfix/sender_canonical
echo "*       smtp:10.10.2.248" >> /etc/postfix/transport
/usr/sbin/postmap hash:/etc/postfix/sender_canonical
/usr/sbin/postmap hash:/etc/postfix/transport
service postfix restart
echo "#######################################################"
echo "CONFGURAÇÕES TERMINADAS, APLICANDO EM TEMPO DE EXECUÇÃO"
echo "#######################################################"

echo " " >>  $LOG
echo " " >>  $LOG
}


function  Syslog(){

if [ ! -e /etc/rsyslog.conf.ORIGINAL ]; then
    cp /etc/rsyslog.conf /etc/rsyslog.conf.ORIGINAL >>  $LOG
else
    cp /etc/rsyslog.conf /etc/rsyslog.conf.$DATE >>  $LOG
    cp /etc/rsyslog.conf.ORIGINAL /etc/rsyslog.conf  
fi

echo "*.warn 				@serverlog.tj.ba.gov.br:514" >> /etc/rsyslog.conf
echo "security.info 			@serverlog.tjba.jus.br:514" >> /etc/rsyslog.conf
echo "auth.info 			@serverlog.tjba.jus.br:514" >> /etc/rsyslog.conf
echo "\$WorkDirectory 			/var/lib/rsyslog" >> /etc/rsyslog.conf
echo "\$ActionQueueFileName 		fwdRule1" >> /etc/rsyslog.conf
echo "\$ActionQueueMaxDiskSpace 	1g" >> /etc/rsyslog.conf
echo "\$ActionQueueSaveOnShutdown 	on" >> /etc/rsyslog.conf
echo "\$ActionQueueType 		LinkedList" >> /etc/rsyslog.conf
echo "\$ActionResumeRetryCount 		-1" >> /etc/rsyslog.conf

/etc/init.d/rsyslog restart  >>  $LOG
}

function  TunningSO(){

echo "--------------------------------------------------------------------------------------------" >>  $LOG
echo "Otimizando o SO" >>  $LOG
echo "--------------------------------------------------------------------------------------------" >>  $LOG

if [ ! -e /etc/sysctl.conf.ORIGINAL ]; then
    cp /etc/sysctl.conf /etc/sysctl.conf.ORIGINAL >>  $LOG
else
    cp /etc/sysctl.conf /etc/sysctl.conf.$DATE >>  $LOG
    cp /etc/sysctl.conf.ORIGINAL /etc/sysctl.conf 
fi
 
cat ./sysctl >> /etc/sysctl.conf

if [ ! -e /etc/security/limits.conf.ORIGINAL ]; then
    cp /etc/security/limits.conf /etc/security/limits.conf.ORIGINAL >>  $LOG
else
    cp /etc/security/limits.conf /etc/security/limits.conf.$DATE >>  $LOG
fi


cat $DIR/limits >> /etc/security/limits.conf

/sbin/sysctl -p  >>  $LOG
}


function  Menu(){
clear
echo "--------------------------------------------------------------------------------------------" 
echo -e "\033[1;33m Menu "
echo "--------------------------------------------------------------------------------------------" 
echo -e "\033[1;33m 1 - Ajusta horario do servidor  \033[0m "
echo -e "\033[1;33m 2 - Update  \033[0m "
echo -e "\033[1;33m 3 - Instalar pacotes Essencial  \033[0m "
echo -e "\033[1;33m 4 - Instalar pacotes de Seguranca  \033[0m "
echo -e "\033[1;33m 5 - Instalar pacotes de Monitoramento  \033[0m "
echo -e "\033[1;33m 6 - Adicioner maquina no Dominio  \033[0m "
echo -e "\033[1;33m 7 - Instalando e configurando o Postfix  \033[0m "
echo -e "\033[1;33m 8 - Configurando o Syslog  \033[0m "
echo -e "\033[1;33m 9 - TunningSO  \033[0m "
echo -e "\033[1;33m 99 - Instalando Tudo  \033[0m "
echo -e "\033[1;33m 100 - Sair  \033[0m "

echo -e "\033[1;33m Digite a opcao \033[0m"

read condicao
}

function  Sair(){
cat $LOG |  logger -t serverInstall -p auth.info
exit 0
}

function  Tudo(){
Update
Essenciais
Seguranca
Monitoramento
AdSO
Email
Syslog
TunningSO
}

Syslog
Menu
while [ $condicao ]

do

		case $condicao in

		  1) Ntp;;	  
		  2) Update ;;		  
		  3) Essenciais ;;		
		  4) Seguranca ;;
		  5) Monitoramento ;;
		  6) AdSO ;;
		  7) Email ;;
		  8) Syslog ;;
		  9) TunningSO ;;
		  99) Tudo ;;
		  100) Sair ;;

		 esac

Menu
done