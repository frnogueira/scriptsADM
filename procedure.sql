DELIMITER $$

CREATE procedure InserirVenda(cdv int,dt date,tot float)
BEGIN
    insert into tbl_vendas(cod_venda,data,total) 
    values(cdv,dt,tot); 
END$$

DELIMITER ;
