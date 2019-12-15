select ID, nome
from CLIENTE

intersect

select distinct CLIENTE.id, CLIENTE.nome
from PEDIDO join CLIENTE on (CLIENTE.id = PEDIDO.cliente)
where pedido.emissao >= '2019-09-01'
  and pedido.emissao <= '2019-09-05'
order by nome;

select ID, nome
from CLIENTE

intersect

select distinct CLIENTE.id, CLIENTE.nome
from PEDIDO join CLIENTE on (CLIENTE.id = PEDIDO.cliente)
where pedido.valor > 9950
order by nome;

select ID, nome
from CLIENTE

except

select distinct CLIENTE.id, CLIENTE.nome
from PEDIDO join CLIENTE on (CLIENTE.id = PEDIDO.cliente)
where pedido.emissao >= '2019-09-01'
  and pedido.emissao <= '2019-09-05' 
order by nome;

select ID, nome
from CLIENTE

except

select distinct CLIENTE.id, CLIENTE.nome
from PEDIDO join CLIENTE on (CLIENTE.id = PEDIDO.cliente)
order by nome;

select ID, nome
from CLIENTE
where exists (select 1
				from PEDIDO
				where CLIENTE.id = PEDIDO.cliente
				  and pedido.emissao between '2019-09-01' and '2019-09-05'
				order by CLIENTE.ID);

select ID, nome
from CLIENTE
where not exists (select 1
				from PEDIDO
				where CLIENTE.id = PEDIDO.cliente
				  and pedido.emissao between '2019-09-01' and '2019-09-05'
				order by CLIENTE.ID);
	                