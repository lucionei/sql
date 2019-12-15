2 - Invertam a ordem, os meses ficam nas linhas e os status nas colunas
3 - Substituam o status do exercício 1 por clientes, totais por clientes mês a mês.

select desc_status as status, 
	   sum(case when mes = 1 then total else 0.00 end) as janeiro,
	   sum(case when mes = 2 then total else 0.00 end) as fevereiro,
	   sum(case when mes = 3 then total else 0.00 end) as marco,
	   sum(case when mes = 4 then total else 0.00 end) as abril,
	   sum(case when mes = 5 then total else 0.00 end) as maio,
	   sum(case when mes = 6 then total else 0.00 end) as junho,
	   sum(case when mes = 7 then total else 0.00 end) as julho,
	   sum(case when mes = 8 then total else 0.00 end) as agosto,
	   sum(case when mes = 9 then total else 0.00 end) as setembro,
	   sum(case when mes = 10 then total else 0.00 end) as outrubro,
	   sum(case when mes = 11 then total else 0.00 end) as novembro,
	   sum(case when mes = 12 then total else 0.00 end) as dezembro
from (
	select extract(month from emissao) as mes,
		   status.descricao as desc_status,
		   sum(pedido.valor) as total
	from pedido join status on pedido.status = status.id
	group by mes, desc_status
	order by 1,2
) as tab
group by desc_status
order by 1;

select case mes 
		  when 1 then 'JANEIRO'
		  when 2 then 'FEVEREIRO'
		  when 3 then 'MARÇO'
		  when 4 then 'ABRIL'
		  when 5 then 'MAIO'
		  when 6 then 'JUNHO'
		  when 7 then 'JULHO'
		  when 8 then 'AGOSTO'
		  when 9 then 'SETEMBRO'
		  when 10 then 'OUTUBRO'
		  when 11 then 'NOVEMBRO'
		  else 'DEZEMBRO'
	   end as mes_do_ano,
	   sum(case when desc_status = 'ABERTO' then total else 0.00 end) as aberto,
	   sum(case when desc_status = 'CANCELADO' then total else 0.00 end) as cancelado,
	   sum(case when desc_status = 'FATURADO' then total else 0.00 end) as faturado,
	   sum(case when desc_status = 'FECHADO' then total else 0.00 end) as fechado,
	   sum(case when desc_status = 'PENDENTE' then total else 0.00 end) as pendente
from (
	select extract(month from emissao) as mes,
		   status.descricao as desc_status,
		   pedido.valor as total
	from pedido join status on pedido.status = status.id
	order by 1,2
) as tab
group by mes
order by mes;

select grupo, 
	   sum(case dia when 1 then total else 0 end) as domingo,
	   sum(case dia when 2 then total else 0 end) as segunda,
	   sum(case dia when 3 then total else 0 end) as terca,
	   sum(case dia when 4 then total else 0 end) as quarta,
	   sum(case dia when 5 then total else 0 end) as quinta,
	   sum(case dia when 6 then total else 0 end) as sexta,
	   sum(case dia when 7 then total else 0 end) as sabado
from (
	select cast(to_char(emissao, 'D') as integer) dia, grupo.descricao as grupo, sum(quantidade * valor_unitario) as total
	from pedido join
		 pedido_item on (pedido_item.pedido = pedido.id) join
		 produto on (produto.id = pedido_item.produto) join
		 grupo on (grupo.id = produto.grupo)
	group by dia, grupo.descricao	 
) as tab
group by grupo

select grupo, 
       sum(case dia when 1 then total else 0 end) as domingo,
       sum(case dia when 2 then total else 0 end) as segunda,
       sum(case dia when 3 then total else 0 end) as terca,
       sum(case dia when 4 then total else 0 end) as quarta,
       sum(case dia when 5 then total else 0 end) as quinta,
       sum(case dia when 6 then total else 0 end) as sexta,
       sum(case dia when 7 then total else 0 end) as sabado
from (
    select cast(to_char(emissao, 'D') as integer) dia, grupo.descricao as grupo, (quantidade * valor_unitario) as total
    from pedido join
         pedido_item on (pedido_item.pedido = pedido.id) join
         produto on (produto.id = pedido_item.produto) join
         grupo on (grupo.id = produto.grupo)    
		 where exists(select 1
		 				from status
					   where status.id = pedido.status
					   	 and status.descricao = 'FATURADO')
) as tab
group by grupo

==================================================================
Tabelas temporárias
==================================================================
PREPARE pedidos_recentes(date) AS
  SELECT * FROM pedido WHERE emissao >= $1;
 
CREATE TEMP TABLE pedidos_recentes AS
  EXECUTE pedidos_recentes('2002-01-01');
  
 select *
 from pedidos_recentes;