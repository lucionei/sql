delete from curso.teste;

delete from <schema>.<tabela>
where <condição> [returning *];

insert into curso.cidade values
(null, 'FLORIANÓPOLIS', 'SC');

insert into curso.cidade(descricao, uf) values( 'GASPAR', 'SC');
insert into curso.cidade select * from cidade;

insert into curso.cidade (descricao, uf) values
    ('FLORIANÓPOLIS', 'SC'),
    ('GASPAR', 'SC');

update curso.cidade set uf = 'SC' where id = 1;    

update pedido
set valor = (select sum((quantidade * valor_unitario) - ((quantidade * valor_unitario)* (perc_desconto/100)))
			   from pedido_item
			  where pedido_item.pedido = pedido.id);

update conta_receber
   set valor = (select valor_parcela
				from (
				select documento as pedido, 
					   round((select pedido.valor from pedido where pedido.id = parcelas.documento)/qtde_parcelas, 2) as valor_parcela
				 from (
					select distinct documento, 
						   count(*) over (partition by documento order by documento) as qtde_parcelas
					  from conta_receber
				  order by documento
				) as parcelas
				) as tab where pedido = conta_receber.documento);

alter table produto add column valor numeric(14,2);

update produto
set valor = (select distinct valor_unitario from pedido_item where pedido_item.produto = produto.id);

commit;

CREATE FUNCTION um(valor integer) RETURNS integer AS $$
    SELECT valor;
$$ LANGUAGE SQL;

SELECT um();

drop function um;

create or replace function 
reajusta_valor_produto(percentual numeric, tipo char(1), filtro integer) 
returns void as $$
   update produto
	set valor = valor * (1 + (percentual/100))
	where (produto.id  = case tipo
						   when 'P' then filtro
						   else -1
						 end
			or
		   produto.grupo = case tipo
						   		when 'G' then filtro
						   		else -1
							end
			or
		   produto.sub_grupo = case tipo
						   	  	 when 'S' then filtro
							  	 else -1
							   end)
$$ language SQL;

SELECT reajusta_valor_produto(10.00, 'P', 1);

create or replace procedure reajusta_valor_produto(percentual numeric, tipo char(1), filtro integer)
language SQL
as $$
   update produto
	set valor = valor * (1 + (percentual/100))
	where (produto.id  = case tipo
						   when 'P' then filtro
						   else -1
						 end
			or
		   produto.grupo = case tipo
						   		when 'G' then filtro
						   		else -1
							end
			or
		   produto.sub_grupo = case tipo
						   	  	 when 'S' then filtro
							  	 else -1
							   end)
$$;

call reajusta_valor_produto(10.00, 'P', 1);

create procedure <nome_procedure>(<param> <tipo>, <param> <tipo>)
language SQL
as $$
  ....
$$;

call <nome_procedire>(<param>, <param>);

create index idx_pedido_emissao on pedido (emissao);
create index idx_conta_receber_emissao on conta_receber (emissao);

SET enable_seqscan = OFF;

explain select *
from pedido
where emissao >= '2000-08-01';

commit;

drop table curso.cliente;
alter table cliente drop constraint fk_cliente_cidade;
drop sequence cidade_id_seq cascade; 
drop view vw_pedidos;

ALTER SEQUENCE public.seq_cliente RESTART WITH 1;