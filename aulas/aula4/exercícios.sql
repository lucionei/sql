BETWEEN
1 - Elabore um SQL que liste todos os itens dos pedidos com código de 100 até 150.
select *
from pedido_item
where id between 100 and 150;

2 - Elabore um SQL que liste todos os pedidos com emissão entre setembro e outubro.
select *
from pedido
where to_char(emissao, ) between '2019-09-01' and '2019-10-31';

3 - Elabore um SQL que liste todos os clientes que não compraram entre 20/12 e 31/12.
select *
from cliente
where not exists(select 1
				   from pedido
				  where pedido.cliente = cliente.id
				    and emissao between '2019-12-20' and '2019-12-31');

4 - Elabore um SQL que liste todos pedidos que não tenham emissão entre os meses de agosto e novembro, use to_char().		    
select *
from pedido
where to_char(emissao, 'MM') not between '08' and '11';

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

[NOT] IN, [NOT] LIKE, [NOT] ILIKE
1 - Elabore um SQL que liste todos os pedidos exceto os com códigos 100,101,102,103.
select * 
from pedido
where id not in (100,101,102,103);

2 - Elabore um SQL que liste todos os pedidos dos clientes da cidade TUBARÃO (use LIKE).
select * 
from pedido join 
	 cliente on (cliente.id = pedido.cliente) join
	 cidade on (cliente.cidade = cidade.id)
where upper(cidade.descricao) like 'TUBA%';

3 - Elabore um SQL que liste todos os pedidos dos clientes com nome iniciado com J.
select * 
from pedido join 
	 cliente on (cliente.id = pedido.cliente)
where upper(cliente.nome) like 'J%';

4 - Elabore um SQL que liste todos os pedidos dos clientes que não são de TUBARÃO e que não tenham a letra A no nome.
select * 
from pedido join 
	 cliente on (cliente.id = pedido.cliente) join
	 cidade on (cidade.id = cliente.cidade)
where upper(cidade.descricao) not like 'TUBA%' 
  and upper(cliente.nome) not like '%A%';

5 - Elabore um SQL que liste todos os clientes que tenham a letra i no nome
select *
from cliente
where upper(nome) like '%I%'

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

... LIKE - PATTERN

1 - Elabore uma consulta usando PATTERN que liste todos os pedidos com ID iniciando em 2 e terminando em 8 com um dígito entre eles.
select *
from pedido
where cast(id as varchar) like '2_8';
2 - Elabore uma consulta usando PATTERN que liste todos os pedidos dos meses de outrubro de todos os anos.
select *
from  pedido
where to_char(emissao, 'DD/MM/YYYY') like '__/10/____'
order by emissao;

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Expressões regulares

1 - Elabore um SQL que liste os clientes com nomes iniciados com a letra J.
select *
from cliente
where upper(nome) ~* '^J.*$'

select *
from cliente
where upper(nome) ~* '^J[a-z][A-Z]{0,}.*$'

2 - Elabore um SQL que liste os clientes com email com o padrão palavra.palavra@palavra.org
select *
from cliente
where email ~*'^[a-z]{1,}\.[a-z]{1,}\@[a-z]{1,}\.org$';
