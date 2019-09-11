select ID, nome
from CLIENTE

except

select distinct CLIENTE.id, CLIENTE.nome
from PEDIDO join CLIENTE on (CLIENTE.id = PEDIDO.cliente)
order by nome;

select ID, nome
from CLIENTE

intersect

select distinct CLIENTE.id, CLIENTE.nome
from PEDIDO join CLIENTE on (CLIENTE.id = PEDIDO.cliente)
order by nome;	

select ID, nome
from CLIENTE
where exists (select 1
				from PEDIDO
				where CLIENTE.id = PEDIDO.cliente
				order by CLIENTE.ID);

select ID, nome
from CLIENTE
where not exists (select 1
				from PEDIDO
				where CLIENTE.id = PEDIDO.cliente
				order by CLIENTE.ID);
	                