
echo “Limpando Cache…”

echo 3 > /proc/sys/vm/drop_caches
sysctl -w vm.drop_caches=3

clear

echo “Limpeza do Cache efetuada com sucesso”


