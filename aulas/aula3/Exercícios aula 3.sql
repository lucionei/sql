Exercícios:
1 - Liste a quantidade total de pedidos do cliente com nome 'Jack'.
select count(*)
from pedido join cliente on (cliente.id = pedido.cliente)
where cliente.nome = 'Jack';

2 - Liste o valor total de pedidos do cliente com nome 'Idona',faça o cálculo pelos itens.
select sum(pedido_item.quantidade * pedido_item.valor_unitario)
from pedido join 
	 cliente on (cliente.id = pedido.cliente) join
	 pedido_item on (pedido_item.pedido = pedido.id)
where cliente.nome = 'Idona';

3 - Liste a quantidade de pedidos por cliente, liste nome dos clientes e a quantidade de pedidos.
select cliente.nome, count(*)
from pedido join 
	 cliente on (cliente.id = pedido.cliente)
group by cliente.nome;

4 - Liste o valor total de pedidos por cliente, liste nome do cliente e valor total, faça cálculo pelos itens.
select cliente.nome, sum(pedido_item.quantidade * pedido_item.valor_unitario)
from pedido join 
	 cliente on (cliente.id = pedido.cliente) join
	 pedido_item on (pedido_item.pedido = pedido.id)
group by cliente.nome

5 - Liste o valor total de pedidos dos clientes de Tubarão, faça cálculo pelos itens.
select sum(pedido_item.quantidade * pedido_item.valor_unitario)
from pedido join 
	 cliente on (cliente.id = pedido.cliente) join
	 pedido_item on (pedido_item.pedido = pedido.id) join
	 cidade on (cidade.id = cliente.cidade)
where upper(cidade.descricao) = 'TUBARÃO'	

6 - Liste a soma total de pedidos com status FATURADO e subtraia da soma total dos pedidos com status CANCELADO, use estrutura de controle case, faça cálculo pelos itens
	select sum(case upper(status.descricao) 
				 when 'FATURADO' then valor 
				 when 'CANCELADO' then -valor 
			   end)
	  from pedido join status on (status.id = pedido.status)
	 where upper(status.descricao) in ('CANCELADO', 'FATURADO')

7 - Liste os pedidos com status ABERTO e FATURADO (IN, OR, UNION), traga os dados paginados com 20 registros por páginas
select *
from pedido join status on (status.id = pedido.status)
where upper(status.descricao) in ('ABERTO', 'FATURADO');

select *
from pedido join status on (status.id = pedido.status)
where (upper(status.descricao) = 'ABERTO'
 or upper(status.descricao) = 'FATURADO');
 
select *
from pedido join status on (status.id = pedido.status)
where upper(status.descricao) = 'ABERTO'

union

select *
from pedido join status on (status.id = pedido.status)
where upper(status.descricao) = 'FATURADO';

8 - Liste o valor total bruto, valor do desconto e valor total líquido por pedidos de outubro a dezembro, faça cálculo pelos itens, arredonde os valores para 2 cassas decimais
select pedido.id, 
	   round(sum(pedido_item.quantidade * pedido_item.valor_unitario),2) as valor_bruto, 
	   round(sum(((pedido_item.quantidade * pedido_item.valor_unitario) * (pedido_item.perc_desconto / 100))),2) as valor_desconto, 
	   round(sum((pedido_item.quantidade * pedido_item.valor_unitario) - ((pedido_item.quantidade * pedido_item.valor_unitario) * (pedido_item.perc_desconto / 100))),2) valor_liquido
from pedido join pedido_item on (pedido_item.pedido = pedido.id)
where pedido.emissao >= '2019-10-01'
  and pedido.emissao <= '2019-12-31'
group by pedido.id;

9 - Listar o valor total de pedidos por dia de semana, faça cálculo pelos itens:
	dia_semana		valor
	segunda-feira	1,00
	terça-feira		2,00
	…
select case to_char(pedido.emissao, 'D')
		when '1' then 'DOMINGO'
		when '2' then 'SEGUNDA-FEIRA'
		when '3' then 'TERÁ-FEIRA'
		when '4' then 'QUARTA-FEIRA'
		when '5' then 'QUINTA-FEIRA'
		when '6' then 'SEXTA-FEIRA'
		else 'SÁBADO'
	   end as dia_semana, 
	   sum(pedido_item.quantidade * pedido_item.valor_unitario)
from pedido join pedido_item on (pedido_item.pedido = pedido.id)
group by dia_semana	
10 - Liste a quantidade de pedidos por dia de semana, somente a quantidade maior que 1200
	dia_semana		qtde
	segunda-feira	1
	terça-feira		2
	…
select case to_char(pedido.emissao, 'D')
		when '1' then 'DOMINGO'
		when '2' then 'SEGUNDA-FEIRA'
		when '3' then 'TERÁ-FEIRA'
		when '4' then 'QUARTA-FEIRA'
		when '5' then 'QUINTA-FEIRA'
		when '6' then 'SEXTA-FEIRA'
		else 'SÁBADO'
	   end as dia_semana, 
	   count(*)
from pedido join pedido_item on (pedido_item.pedido = pedido.id)
group by dia_semana	
having count(*) > 1200

11 - liste a soma do valor total de contas a receber por pedido no mës de outubro
select pedido.id, sum(conta_receber.valor)
  from pedido join conta_receber on (conta_receber.documento = pedido.id)
 where to_char(pedido.emissao, 'MMYYYY') = '102019'
group by pedido.id;

12 - liste a soma de valor total de contas a receber por cliente nos meses de outubro a dezembro, ordene alfabéticamente
select cliente.nome, sum(conta_receber.valor)
from pedido join 
	 conta_receber on (conta_receber.documento = pedido.id) join
	 cliente on (cliente.id = pedido.cliente)
where pedido.emissao >= '2019-10-01'
  and pedido.emissao <= '2019-12-31'
group by cliente.nome
order by cliente.nome;

13 - repita o exercício 9, mas os dias da semana devem aparecer em colunas
select sum(case to_char(pedido.emissao, 'D') when '1' then (pedido_item.quantidade * pedido_item.valor_unitario) else 0 end) as domingo,
       sum(case to_char(pedido.emissao, 'D') when '2' then (pedido_item.quantidade * pedido_item.valor_unitario) else 0 end) as segunda_feira,
       sum(case to_char(pedido.emissao, 'D') when '3' then (pedido_item.quantidade * pedido_item.valor_unitario) else 0 end) as terca_feira,
       sum(case to_char(pedido.emissao, 'D') when '4' then (pedido_item.quantidade * pedido_item.valor_unitario) else 0 end) as quarta_feira,
       sum(case to_char(pedido.emissao, 'D') when '5' then (pedido_item.quantidade * pedido_item.valor_unitario) else 0 end) as quinta_feira,
       sum(case to_char(pedido.emissao, 'D') when '6' then (pedido_item.quantidade * pedido_item.valor_unitario) else 0 end) as sexta_feira,
       sum(case to_char(pedido.emissao, 'D') when '7' then (pedido_item.quantidade * pedido_item.valor_unitario) else 0 end) as sabado
from pedido join pedido_item on (pedido_item.pedido = pedido.id)