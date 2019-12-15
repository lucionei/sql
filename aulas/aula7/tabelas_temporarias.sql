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

create temp table temp_curva_abc as
execute curva_abc('2019-01-01', '2019-01-01');

create temp table <nome_tabela_temporaria> as
    select <colunas> from <tabela> where <condição>;

create temp table <nome_tabela_temporaria> as
    execute <função temporaria>;
