COPY (
    select *
    from CLIENTE
    order by id
) TO '/home/lucionei/dev/sql/cliente.csv' WITH NULL AS 'null' delimiter ';';