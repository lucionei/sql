1 - Após criar a estrutura, elabore um SQL que liste todos os representantes, cada um com seu supervisor.
select representante.id, representante.nome, supervisor.nome as nome_supervisor
from representante join
     representante as supervisor on (supervisor.id = representante.id_supervisor);

with recursive <tabela_auxilixar_consulta> as (
   <consulta_nao_recursiva>
  union [all]
  <consulta_recursiva>
) <consulta_final>

with recursive subordinados as (
   select id,
          nome
   from representante
   where upper(nome) = $1

  union all

  select sup.id,
         sup.nome
   from representante sup join 
        subordinados on sup.id_supervisor = subordinados.id
) 
select id, nome
from subordinados;

alter table pedido add representante integer;

update pedido
set representante = 1
where id < 50;

update pedido
set representante = 2
where id between 50 and 200;

update pedido
set representante = 3
where id between 201 and 350;

update pedido
set representante = 4
where id between 351 and 500;

update pedido
set representante = 5
where id between 501 and 700;

update pedido
set representante = 6
where id > 700;

commit;

with recursive subordinados as (
   select id, nome
   from representante
   where upper(nome) = $1

  union all

  select sup.id, sup.nome
   from representante sup join 
        subordinados on (sup.id_supervisor = subordinados.id)
) 
select pedido.id, pedido.emissao, pedido.valor, subordinados.nome
from subordinados join
	 pedido on (pedido.representante = subordinados.id);


CREATE TABLE COMPANY1(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL
);

WITH moved_rows AS (
   DELETE FROM COMPANY
   WHERE
      SALARY >= 30000
   RETURNING *
)
INSERT INTO COMPANY1 (SELECT * FROM moved_rows);

