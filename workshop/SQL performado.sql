/*Criar temporárias*/                        
SELECT relac_msc.ano_exerc, contas.i_entidades, contas.i_contas, relac_msc.mascara
INTO #temp_conta_relac
FROM sapo.contas 
JOIN sapo.relac_msc ON relac_msc.i_entidades = contas.i_entidades AND
                       relac_msc.codigo = contas.i_contas              
WHERE tipo = 1
AND tipoequivalencia = 'M';

SELECT relac_msc.ano_exerc, relac_msc.i_entidades, relac_msc.codigo, relac_msc.mascara, relac_msc.i_detalhe_especif_rec
INTO #temp_recurso
FROM sapo.relac_msc
WHERE tipo = 5 
  AND tipoequivalencia = 'M';

SELECT relac_msc.ano_exerc, relac_msc.i_entidades,  relac_msc.codigo, relac_msc.mascara
INTO #temp_natureza_receita
FROM sapo.relac_msc
WHERE tipo = 2 AND tipoequivalencia = 'M';

SELECT relac_msc.ano_exerc, relac_msc.i_entidades, relac_msc.codigo, relac_msc.mascara
INTO #temp_sub_funcao
FROM sapo.relac_msc
WHERE tipo = 4 AND tipoequivalencia = 'M';

SELECT relac_msc.ano_exerc, relac_msc.i_entidades, relac_msc.codigo, relac_msc.mascara
INTO #temp_natureza_despesa
FROM sapo.relac_msc
WHERE tipo = 3 AND tipoequivalencia = 'M';

SELECT relac_msc.ano_exerc, relac_msc.i_entidades, relac_msc.mde, relac_msc.codigo, relac_msc.ano_desp, relac_msc.asps
INTO #temp_asps
FROM sapo.relac_msc
WHERE tipo = 6 AND tipoequivalencia = 'M';

/*resultado final*/
SELECT ano_exerc,			
			i_entidades,
			i_contas_correntes,    
			data_lancamento,
			MascaraConta = (SELECT FIRST(mascara)
							          FROM #temp_conta_relac 
							         WHERE i_entidades = tab.i_entidades
							           AND i_contas = tab.i_contas 
                         AND ano_exerc = tab.ano_exerc
                    ORDER BY 1),
			PoderOrgao = componente1,
			Superavit = IF i_contas_correntes IN (39,41,45) THEN componente2 endif,
			DividaConsolidada = IF i_contas_correntes IN (40,45) THEN componente3 endif,
			FonteRecurso = IF i_contas_correntes IN (41,44,46) THEN 
                              (SELECT FIRST(mascara)
								                 FROM #temp_recurso
								                WHERE ano_exerc = tab.ano_exerc AND
										                  i_entidades = tab.i_entidades AND
										                  codigo = componente3 AND 
										                  sapo.dbf_setmascara(STRING(CAST(i_detalhe_especif_rec AS VARCHAR(100)) ),'00') =  sapo.dbf_setmascara(STRING(componente4),'00')
                             ORDER BY 1)  
                     ELSE IF i_contas_correntes IN (42,43) THEN 
                              (SELECT FIRST(mascara)
            								     FROM #temp_recurso
            								    WHERE ano_exerc = tab.ano_exerc AND
            										      i_entidades = tab.i_entidades AND
            										      codigo = componente2 AND     
            										      CAST(i_detalhe_especif_rec AS VARCHAR(100)) = componente3  
            							   ORDER BY 1) 
                    ELSE IF i_contas_correntes IN (45) THEN 
                           (SELECT FIRST(mascara)
								              FROM #temp_recurso
								             WHERE ano_exerc = tab.ano_exerc AND
										               i_entidades = tab.i_entidades AND
										               codigo = componente4 AND      
										               CAST(i_detalhe_especif_rec AS VARCHAR(100)) = componente5  
										      ORDER BY 1)
                    endif endif endif,
       DetalhamentoFonteRecurso = IF i_contas_correntes IN (41,44,46) THEN 
                                          (SELECT FIRST(mascara)
                          								   FROM #temp_recurso
                          								  WHERE ano_exerc = tab.ano_exerc AND
                              									  i_entidades = tab.i_entidades AND
                              									  codigo = componente4 
                              					 ORDER BY 1) 
                                  ELSE IF i_contas_correntes IN (42,43) THEN 
                                          (SELECT FIRST(mascara)
                          								   FROM #temp_recurso
                          								  WHERE ano_exerc = tab.ano_exerc AND
                          										    i_entidades = tab.i_entidades AND
                          										    codigo = componente3 
                          							 ORDER BY 1)
                                  ELSE IF i_contas_correntes IN (45) THEN 
                                          (SELECT FIRST(mascara)
                          							     FROM #temp_recurso
                          								  WHERE ano_exerc = tab.ano_exerc AND
                          										    i_entidades = tab.i_entidades AND
                          										    codigo = componente5 
                          							 ORDER BY 1)
                                  endif endif endif,
			NaturezaReceita = IF i_contas_correntes IN (43) THEN 
          								(SELECT FIRST(mascara)
          								   FROM #temp_natureza_receita
          								  WHERE ano_exerc = tab.ano_exerc AND
          										    i_entidades = tab.i_entidades AND
          										    codigo = componente4
                         ORDER BY 1)
          							  endif,
			FuncaoSubfuncao = IF i_contas_correntes IN (44,46) THEN 
          								 (SELECT FIRST(mascara) 
          									FROM #temp_sub_funcao
          								   WHERE ano_exerc = tab.ano_exerc AND
          										     i_entidades = tab.i_entidades AND
          										     codigo = componente2
                          ORDER BY 1)
          							  endif,     
			NaturezaDespesa = IF i_contas_correntes IN (44) THEN 
        								 (SELECT FIRST(mascara) 
        									  FROM #temp_natureza_despesa
        								   WHERE ano_exerc = tab.ano_exerc AND
        										     i_entidades = tab.i_entidades AND
        										     LEFT(codigo,8) = componente5
                        ORDER BY 1)
                              ELSE IF i_contas_correntes IN (46) THEN     
                        (SELECT FIRST(mascara) 
        									 FROM #temp_natureza_despesa
        								  WHERE ano_exerc = tab.ano_exerc AND
        										    i_entidades = tab.i_entidades AND
        										    LEFT(codigo,8) = componente5
                       ORDER BY 1)
        							  endif endif,          							                         
      InscricaoRestosPagar = IF i_contas_correntes IN (46) THEN componente7 endif,     
      MDEASPS = IF i_contas_correntes IN (44,46) THEN 
                         (SELECT IF mde = 'S' THEN 1 ELSE IF asps = 'S' THEN 2 ELSE 0 endif endif 
        									  FROM #temp_asps
        								   WHERE ano_exerc = tab.ano_exerc AND
        										     i_entidades = tab.i_entidades AND
        										     codigo||ano_desp = componente6
                         ORDER BY 1)
                endif,
      SaldoAnterior,
			MovimentoDebito,
			MovimentoCredito,
			SaldoFinal
FROM (
	SELECT 	lcc.ano_exerc,			
			lcc.i_entidades,
			lcc.i_contas_correntes,
			lanc.i_contas,
			data_lancamento,
			componente1,
      componente2,
      componente3,
      componente4,
      componente5,
      componente6,     
      componente7, 
			SaldoAnterior = ISNULL(IF (lanc.data_lancamento < a_data_ini OR lanc.lanc_inicial = '*') THEN 
										 IF lanc.tipo_lancamento = 'D' THEN 
											lanc.valor_lancamento 
										 ELSE (lanc.valor_lancamento * -1) endif 
									  ELSE 0.00 endif,0),
			MovimentoDebito = ISNULL(IF (lanc.data_lancamento >= a_data_ini AND lanc.data_lancamento <= a_data_fin AND ISNULL(lanc_inicial,'E') <> '*') THEN
										 IF lanc.tipo_lancamento = 'D' THEN 
											lanc.valor_lancamento 
										 ELSE 0.00 endif endif,0),
			MovimentoCredito = ISNULL(IF (lanc.data_lancamento >= a_data_ini AND lanc.data_lancamento <= a_data_fin AND ISNULL(lanc_inicial,'E') <> '*') THEN
										 IF lanc.tipo_lancamento = 'C' THEN 
											lanc.valor_lancamento 
										 ELSE 0.00 endif endif,0),
			SaldoFinal = SaldoAnterior + MovimentoDebito - MovimentoCredito        
	  FROM sapo.lancamentos_contas_correntes  lcc 
	  JOIN sapo.lancamentos lanc ON lanc.ano_exerc = lcc.ano_exerc AND
									lanc.i_entidades = lcc.i_entidades AND
									lanc.i_lancamentos = lcc.i_lancamentos
	 WHERE EXISTS(SELECT 1 
					FROM sapo.contas_correntes 
				   WHERE ano_exerc = lcc.ano_exerc 
					 AND i_entidades = lcc.i_entidades 
					 AND i_contas_correntes = lcc.i_contas_correntes
					 AND i_contas_correntes_lotes = 3
				  )
		 AND lanc.ano_exerc = a_exercicio
) AS tab