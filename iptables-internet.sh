#!/bin/bash



iptables -F
iptables -P INPUT DROP
iptables -p OUTPUT DROP
iptables -P FORWARD DROP




iptables  -A  OUTPUT  -p  udp  -s  192.168.0.100  -d  0/0  --dport  53  -j  ACCEPT
iptables  -A  INPUT  -p  udp  -s  0/0  -d  192.168.0.100  --sport  53  -j   ACCEPT
#iptables  -A  OUTPUT -p  icmp  -s  192.168.0.100  -d  0/0  --icmp-type 8  -j  ACCEPT
#iptables  -A  INPUT  -p  icmp -s  0/0 -d 192.168.0.100 --icmp-type 0  -j  ACCEPT
iptables  -A  OUTPUT  -p  tcp  -s  192.168.0.100  -d  0/0  --dport  80  -j  ACCEPT
iptables  -A  INPUT  -p  tcp  -s  0/0  -d  192.168.0.100  --sport  80  -j  ACCEPT


iptables  -A  OUTPUT  -p  tcp  -s  192.168.0.100  -d  0/0  --dport  443  -j  ACCEPT
iptables  -A  INPUT  -p  tcp  -s  0/0  -d  192.168.0.100  --sport  443  -j  ACCEPT



