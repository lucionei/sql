select posicao,
	   descricao_produto,
	   valor_vendido,
	   total_vendido,
	   percentual,
	   percentual_acumualdo,
	   case when percentual_acumualdo <= 80 then 'A'
	   		when percentual_acumualdo <= 95 then 'B'
	   		else 'C'
	   end as classificacao
from (
        WITH vendas(posicao, descricao_produto, valor_vendido, total_vendido) As (
            SELECT
                posicao, 
                descricao_produto,
                valor_vendido,
                SUM(valor_vendido) OVER (PARTITION BY 1) As total_vendido
            FROM (
                select  rank() over (order by valor_vendido desc) as posicao,
                        descricao as descricao_produto,
                        valor_vendido
                    from (
                        select produto.descricao, 
                            sum(quantidade * valor_unitario) as valor_vendido
                        from pedido join
                            pedido_item on (pedido_item.pedido = pedido.id) join
                            produto on (produto.id = pedido_item.produto)
                        where pedido.emissao between '2019-01-01' and '2019-01-01'
                        group by produto.descricao
                        order by valor_vendido desc
                    ) as tab
                ) as tab
	    ),
	    percentuais(posicao, descricao_produto, valor_vendido, total_vendido, percentual) as (
            SELECT posicao, descricao_produto, valor_vendido, total_vendido,
                   (valor_vendido / total_vendido) * 100 As percentual
            FROM vendas
        )
        select posicao, descricao_produto, valor_vendido, total_vendido, percentual,
               (select sum(perc.percentual) 
                  from percentuais as perc 
                 where perc.posicao <= percentuais.posicao) as percentual_acumualdo
        from percentuais
) as tab;

1 - Faça uso dos conhecimentos adquiridos e elabore a curva ABC do faturamento x cliente, pedidos faturados no primeiro trimestre de 2019.
select posicao,
	   nome_cliente,
	   valor_vendido,
	   total_vendido,
	   percentual,
	   percentual_acumualdo,
	   case when percentual_acumualdo <= 80 then 'A'
	   		when percentual_acumualdo <= 95 then 'B'
	   		else 'C'
	   end as classificacao
from (
        WITH vendas(posicao, nome_cliente, valor_vendido, total_vendido) As (
            SELECT
                posicao, 
                nome_cliente,
                valor_vendido,
                SUM(valor_vendido) OVER (PARTITION BY 1) As total_vendido
            FROM (
                select  rank() over (order by valor_vendido desc) as posicao,
                        nome as nome_cliente,
                        valor_vendido
                    from (
                        select cliente.nome, 
                            sum(quantidade * valor_unitario) as valor_vendido
                        from pedido join
                            pedido_item on (pedido_item.pedido = pedido.id) join
                            cliente on (cliente.id = pedido.cliente)
                        where pedido.emissao between '2019-01-01' and '2019-01-31'
                        group by cliente.nome
                        order by valor_vendido desc
                    ) as tab
                ) as tab
	    ),
	    percentuais(posicao, nome_cliente, valor_vendido, total_vendido, percentual) as (
            SELECT posicao, nome_cliente, valor_vendido, total_vendido,
                   (valor_vendido / total_vendido) * 100 As percentual
            FROM vendas
        )
        select posicao, nome_cliente, valor_vendido, total_vendido, percentual,
               (select sum(perc.percentual) 
                  from percentuais as perc 
                 where perc.posicao <= percentuais.posicao) as percentual_acumualdo
        from percentuais
) as tab;

2 - Elabore a curva ABC dos produtos vendidos, com base na quantidade, para análise da rotatividade do estoque, no terceiro trimestre de 2019.
select posicao,
	   descricao_produto,
	   qtde_vendida,
	   total_vendido,
	   percentual,
	   percentual_acumualdo,
	   case when percentual_acumualdo <= 80 then 'A'
	   		when percentual_acumualdo <= 95 then 'B'
	   		else 'C'
	   end as classificacao
from (
        WITH vendas(posicao, descricao_produto, qtde_vendida, total_vendido) As (
            SELECT
                posicao, 
                descricao_produto,
                qtde_vendida,
                SUM(qtde_vendida) OVER (PARTITION BY 1) As total_vendido
            FROM (
                select  rank() over (order by qtde_vendida desc) as posicao,
                        descricao as descricao_produto,
                        qtde_vendida
                    from (
                        select produto.descricao, 
                            sum(quantidade) as qtde_vendida
                        from pedido join
                            pedido_item on (pedido_item.pedido = pedido.id) join
                            produto on (produto.id = pedido_item.produto)
                        where pedido.emissao between '2019-01-01' and '2019-01-01'
                        group by produto.descricao
                        order by qtde_vendida desc
                    ) as tab
                ) as tab
	    ),
	    percentuais(posicao, descricao_produto, qtde_vendida, total_vendido, percentual) as (
            SELECT posicao, descricao_produto, qtde_vendida, total_vendido,
                   (qtde_vendida / total_vendido) * 100 As percentual
            FROM vendas
        )
        select posicao, descricao_produto, qtde_vendida, total_vendido, percentual,
               (select sum(perc.percentual) 
                  from percentuais as perc 
                 where perc.posicao <= percentuais.posicao) as percentual_acumualdo
        from percentuais
) as tab;

3 -  Crie uma função temporária para cada curva ABC criada e teste a execução de cada uma;
prepare curva_abc(date, date) as (
select posicao,
	   descricao_produto,
	   valor_vendido,
	   total_vendido,
	   percentual,
	   percentual_acumualdo,
	   case when percentual_acumualdo <= 80 then 'A'
	   		when percentual_acumualdo > 80 and percentual_acumualdo <= 95 then 'B'
	   		else 'C'
	   end as classificacao
from (
WITH vendas(posicao, descricao_produto, valor_vendido, total_vendido) As (
            SELECT
                posicao, 
                descricao_produto,
                valor_vendido,
                SUM(valor_vendido) OVER (PARTITION BY 1) As total_vendido
            FROM (
                select  rank() over (order by valor_vendido desc) as posicao,
                        descricao as descricao_produto,
                        valor_vendido
                    from (
                        select produto.descricao, 
                            sum(quantidade * valor_unitario) as valor_vendido
                        from pedido join
                            pedido_item on (pedido_item.pedido = pedido.id) join
                            produto on (produto.id = pedido_item.produto)
                        where pedido.emissao between $1 and $2
                        group by produto.descricao
                        order by valor_vendido desc
                    ) as tab
                ) as tab
	    ),
	    percentuais(posicao, descricao_produto, valor_vendido, total_vendido, percentual) as (
            SELECT posicao, descricao_produto, valor_vendido, total_vendido,
                   (valor_vendido / total_vendido) * 100 As percentual
            FROM vendas
        )
        select posicao, descricao_produto, valor_vendido, total_vendido, percentual,
               (select sum(perc.percentual) 
                  from percentuais as perc 
                 where perc.posicao <= percentuais.posicao) as percentual_acumualdo
        from percentuais
) as tab
);

execute curva_abc('2019-01-01', '2019-01-01');

para os demais basta copiar e substituir as datas por $1 e $2.

