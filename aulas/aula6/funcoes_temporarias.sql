deallocate pedidos_recentes;

PREPARE pedidos_recentes(date) AS
  SELECT * FROM pedido WHERE emissao >= $1;
 
EXECUTE pedidos_recentes('2019-01-01');

PREPARE soma(numeric, numeric) AS
  SELECT $1 + $2;
 
EXECUTE soma(1, 1);

PREPARE multiplicacao(numeric, numeric) AS
  SELECT $1 * $2;
 
EXECUTE multiplicacao(2, 2);

PREPARE divisao(numeric, numeric) AS
  SELECT $1 / case $2 when 0 then 1 else $2 end;
 
EXECUTE divisao(2, 2);

PREPARE subtracao(numeric, numeric) AS
  SELECT $1 - $2;
 
EXECUTE subtracao(2, 2);

PREPARE percentual(numeric) AS
  SELECT $1 / 100;
 
EXECUTE percentual(5);

PREPARE pedidos_pendentes(date, date) AS
  SELECT *
    from pedido
    where emissao between $1 and $2;
   
   execute pedidos_pendentes('2019-01-01', '2019-12-31');