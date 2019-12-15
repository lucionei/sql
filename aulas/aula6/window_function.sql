select pedido.id, 
	   pedido.emissao, 
	   produto.descricao,
	   grupo.descricao,
	   sum(quantidade * valor_unitario) over (partition by produto.grupo) as total_por_grupo,
	   row_number() over (partition by produto.grupo) as sequencial
	from pedido join
	 pedido_item on (pedido_item.pedido = pedido.id) join
	 produto on (produto.id = pedido_item.id) join
	 grupo on (grupo.id = produto.grupo);

select id, emissao, valor, rank() over (order by emissao) as rank
from pedido;

select id, emissao, valor, dense_rank() over (order by emissao) as dense_rank
from pedido;

select id, emissao, cume_dist() over (order by emissao) relativo
from pedido;