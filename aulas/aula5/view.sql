create or replace view vw_cliente as 
select cliente.id, cliente.nome, cliente.nome_fantasia, cidade.descricao as desc_cidade
from cliente join
	 cidade on (cidade.id = cliente.cidade);

create or replace view vw_pedidos as
  select pedido_item.pedido, 
	     pedido.emissao,
	     status.descricao,
	     sum((quantidade * valor_unitario) - ((quantidade * valor_unitario) * (perc_desconto / 100))) as valor_liquido
    from pedido_item join
         pedido on(pedido.id = pedido_item.pedido) join
         status on (status.id = pedido.status)
group by pedido, pedido.emissao, status.descricao;     

CREATE or replace RECURSIVE VIEW public.nums_1_100 (n) AS
    VALUES (1)
    UNION ALL
    SELECT n+1 FROM nums_1_100 WHERE n < 100;    
