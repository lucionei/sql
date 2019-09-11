SELECT EXTRACT( DOW FROM CURRENT_DATE) AS DiaSemanaN,
CASE EXTRACT( DOW FROM CURRENT_DATE)
WHEN 0 THEN 'Domingo'
WHEN 1 THEN 'Segunda'
WHEN 2 THEN 'Terça'
WHEN 3 THEN 'Quarta'
WHEN 4 THEN 'Quinta'
WHEN 5 THEN 'Sexta'
WHEN 6 THEN 'Sábado'
END AS DiaSemana

SELECT CASE EXTRACT( DOW FROM "PEDIDO".emissao)
	   WHEN 0 THEN 'Domingo'
	   WHEN 1 THEN 'Segunda'
	   WHEN 2 THEN 'Terça'
	   WHEN 3 THEN 'Quarta'
	   WHEN 4 THEN 'Quinta'
	   WHEN 5 THEN 'Sexta'
	   WHEN 6 THEN 'Sábado'
	   END AS dia_semana,
count(*) as quantidade
FROM "PEDIDO"
group by 1
