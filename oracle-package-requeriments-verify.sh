#!/bin/bash
# script: oracle-package-requeriments-verify.sh
# autor:  Dionatas Queiroz
# site: http://www.tjba.jus.br
# data: 2016-03-31
# versao: 1.0
# alvo: oracle-xe-11.2.0-1.0.x86_64 & Oracle Linux Server 7
clear
echo '+----------------------------------------------------------------------+'
echo '| Oracle Package Requeriments Verify 1.0                               |'
echo '| Para:                                                                |'
echo '|    oracle-xe-11.2.0-1.0.x86_64                                       |'
echo '|    Quick Start Guide oracle 11g                                      |'
echo '+----------------------------------------------------------------------+'
echo ''
echo 'binutils-2.23.52.0.1-12.el7.x86_64'
rpm -q binutils.x86_64
echo ''
echo 'compat-libcap1-1.10-3.el7.x86_64'
rpm -q compat-libstdc++-33.x86_64
echo ''
echo 'gcc-4.8.2-3.el7.x86_64'
rpm -q gcc.x86_64
echo ''
echo 'gcc-c++-4.8.2-3.el7.x86_64'
rpm -q gcc-c++.x86_64
echo ''
echo 'glibc-2.17-36.el7.i686'
rpm -q glibc.x86_64
echo ''
echo 'glibc-2.17-36.el7.x86_64 '
rpm -q glibc.i686
echo ''
echo 'glibc-devel-2.17-36.el7.x86_64'
rpm -q glibc-devel.x86_64
echo ''
echo 'glibc-devel-2.17-36.el7.i686'
rpm -q glibc-devel.i686
echo ''
echo 'ksh'
rpm -q ksh.x86_64
echo ''
echo 'libaio-0.3.109-9.el7.x86_64 '
rpm -q libaio.x86_64
echo ''
echo 'libaio-0.3.109-9.el7.i686 '
rpm -q libaio.i686
echo ''
echo 'libaio-devel-0.3.109-9.el7.x86_64'
rpm -q libaio-devel.x86_64
echo ''
echo 'libaio-devel-0.3.109-9.el7.i686'
rpm -q libaio-devel.i386
echo ''
echo 'libgcc-4.8.2-3.el7.x86_64'
rpm -q libgcc.x86_64
echo ''
echo 'libgcc-4.8.2-3.el7.i686'
rpm -q libgcc.i386
echo ''
echo 'libstdc++-4.8.2-3.el7.x86_64'
rpm -q libstdc++.x86_64
echo ''
echo 'libstdc++-4.8.2-3.el7.i686'
rpm -q libstdc++.i686
echo ''
echo 'libstdc++-devel-4.8.2-3.el7.x86_64'
rpm -q libstdc++.x86_64
echo ''
echo 'libstdc++-devel-4.8.2-3.el7.i686'
rpm -q libstdc++.i686
echo ''
echo 'libXi-1.7.2-1.el7.i686'
rpm -q libXi.i686
echo ''
echo 'libXi-1.7.2-1.el7.x86_64'
rpm -q libXi.x86_64
echo ''
echo 'libXtst-1.2.2-1.el7.i686'
rpm -q libXtst.i686
echo ''
echo 'libXtst-1.2.2-1.el7.x86_64'
rpm -q libXtst.x86_64
echo ''
echo 'make-3.82-19.el7.x86_64'
rpm -q make.x86_64
echo ''
echo 'sysstat-10.1.5-1.el7.x86_64'
rpm -q sysstat.x86_64
echo ''
echo '+------------------------------------------------------------------------------+'
echo '| Packages for Oracle Linux 7 and Red Hat Enterprise Linux 7 must be installed |'
echo '| https://docs.oracle.com/cd/E11882_01/install.112/e24326.pdf                                                       |'
echo '+------------------------------------------------------------------------------+'

