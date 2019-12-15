  select pedido, 
	     produto.id, 
	     produto.descricao, 
	     sum(quantidade * valor_unitario) as valor_bruto, 
	     sum((quantidade * valor_unitario) * (perc_desconto / 100)) as valor_desconto,
	     sum((quantidade * valor_unitario) - ((quantidade * valor_unitario) * (perc_desconto / 100))) as valor_liquido
    into tab_aux_pedido_produto 
    from pedido_item join
         produto on(produto.id = pedido_item.produto)
group by pedido,  produto.id, produto.descricao;

select *
  from tab_aux_pedido_produto join
	   pedido on (pedido.id = tab_aux_pedido_produto.pedido)
 where to_char(pedido.emissao, 'yyyy') = '2019'
   and exists(select 1
  				from status	
  			   where status.id = pedido.status
  			  	 and status.descricao = 'FATURADO');

copy cidade(descricao)
to '/home/lucionei/dev/sql/cidade.csv' WITH NULL AS 'null' delimiter ';' csv header;

copy tab_aux_cidade
from '/home/lucionei/dev/sql/cidade.csv' WITH NULL AS 'null' delimiter ';' csv header;                     