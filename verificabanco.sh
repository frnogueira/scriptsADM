<?
$banco = "nome_do_banco_de_dados";
$usuario = "nome_de_usuario_criado";
$senha = "senha_atribuida_para_o_bd";
$hostname = "servidor_de_banco_de_dados";
$conn = mysql_connect($hostname,$usuario,$senha); mysql_select_db($banco) or die( "Não foi possível conectar ao banco MySQL");
if (!$conn) {echo "Não foi possível conectar ao banco MySQL.
"; exit;}
else {echo "Parabéns!! A conexão ao banco de dados ocorreu normalmente!.
";}
mysql_close(); 
?>
