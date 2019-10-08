	SELECT 	lcc.ano_exerc,			
			lcc.i_entidades,
			lcc.i_contas_correntes,
			data_lancamento, 
			MascaraConta = (SELECT FIRST(relac_msc.mascara)
							          FROM sapo.contas 
							          JOIN sapo.relac_msc ON relac_msc.ano_exerc = lcc.ano_exerc AND
												     relac_msc.i_entidades = contas.i_entidades AND
												     relac_msc.codigo = contas.i_contas              
							         WHERE contas.i_entidades = lcc.i_entidades
							           AND contas.i_contas = lanc.i_contas 
							           AND tipo = 1),
			PoderOrgao = componente1,
			Superavit = IF i_contas_correntes IN (39,41,45) THEN componente2 endif,
			DividaConsolidada = IF i_contas_correntes IN (40,45) THEN componente3 endif,
			FonteRecurso = IF i_contas_correntes IN (41,44,46) THEN 
                              (SELECT FIRST(relac_msc.mascara)
								                 FROM sapo.relac_msc
								                WHERE relac_msc.ano_exerc = lcc.ano_exerc AND
										                  relac_msc.i_entidades = lcc.i_entidades AND
										                  relac_msc.codigo = componente3 AND 
										                  sapo.dbf_setmascara(STRING(CAST(relac_msc.i_detalhe_especif_rec AS VARCHAR(100)) ),'00') =  sapo.dbf_setmascara(STRING(componente4),'00') AND 
										                  tipo = 5) 
                     ELSE IF i_contas_correntes IN (42,43) THEN 
                              (SELECT FIRST(relac_msc.mascara)
            								     FROM sapo.relac_msc
            								    WHERE relac_msc.ano_exerc = lcc.ano_exerc AND
            										      relac_msc.i_entidades = lcc.i_entidades AND
            										      relac_msc.codigo = componente2 AND     
            										      CAST(relac_msc.i_detalhe_especif_rec AS VARCHAR(100)) = componente3 AND 
            										      tipo = 5) 
                    ELSE IF i_contas_correntes IN (45) THEN 
                           (SELECT FIRST(relac_msc.mascara)
								              FROM sapo.relac_msc
								             WHERE relac_msc.ano_exerc = lcc.ano_exerc AND
										               relac_msc.i_entidades = lcc.i_entidades AND
										               relac_msc.codigo = componente4 AND      
										               CAST(relac_msc.i_detalhe_especif_rec AS VARCHAR(100)) = componente5 AND 
										               tipo = 5)
                    endif endif endif,
       DetalhamentoFonteRecurso = IF i_contas_correntes IN (41,44,46) THEN 
                                          (SELECT FIRST(relac_msc.mascara)
                          								   FROM sapo.relac_msc
                          								  WHERE relac_msc.ano_exerc = lcc.ano_exerc AND
                              										relac_msc.i_entidades = lcc.i_entidades AND
                              										relac_msc.codigo = componente4 AND
                              										tipo = 5) 
                                  ELSE IF i_contas_correntes IN (42,43) THEN 
                                          (SELECT FIRST(relac_msc.mascara)
                          								   FROM sapo.relac_msc
                          								  WHERE relac_msc.ano_exerc = lcc.ano_exerc AND
                          										    relac_msc.i_entidades = lcc.i_entidades AND
                          										    relac_msc.codigo = componente3 AND
                          										    tipo = 5) 
                                  ELSE IF i_contas_correntes IN (45) THEN 
                                          (SELECT FIRST(relac_msc.mascara)
                          								   FROM sapo.relac_msc
                          								  WHERE relac_msc.ano_exerc = lcc.ano_exerc AND
                          										    relac_msc.i_entidades = lcc.i_entidades AND
                          										    relac_msc.codigo = componente5 AND
                          										    tipo = 5)
                                  endif endif endif,
			NaturezaReceita = IF i_contas_correntes IN (43) THEN 
          								(SELECT FIRST(relac_msc.mascara)
          								   FROM sapo.relac_msc
          								  WHERE relac_msc.ano_exerc = lcc.ano_exerc AND
          										relac_msc.i_entidades = lcc.i_entidades AND
          										relac_msc.codigo = componente4 AND
          										tipo = 2)
          							  endif,
			FuncaoSubfuncao = IF i_contas_correntes IN (44,46) THEN 
          								 (SELECT FIRST(relac_msc.mascara) 
          									FROM sapo.relac_msc
          								   WHERE relac_msc.ano_exerc = lcc.ano_exerc AND
          										 relac_msc.i_entidades = lcc.i_entidades AND
          										 relac_msc.codigo = componente2 AND
          										 tipo = 4)
          							  endif,     
			NaturezaDespesa = IF i_contas_correntes IN (44) THEN 
        								 (SELECT FIRST(relac_msc.mascara) 
        									FROM sapo.relac_msc
        								   WHERE relac_msc.ano_exerc = lcc.ano_exerc AND
        										 relac_msc.i_entidades = lcc.i_entidades AND
        										 LEFT(relac_msc.codigo,8) = componente5 AND
        										 tipo = 3)
                              ELSE IF i_contas_correntes IN (46) THEN     
                         (SELECT FIRST(relac_msc.mascara) 
        									FROM sapo.relac_msc
        								   WHERE relac_msc.ano_exerc = lcc.ano_exerc AND
        										 relac_msc.i_entidades = lcc.i_entidades AND
        										 LEFT(relac_msc.codigo,8) = componente5 AND
        										 tipo = 3)
        							  endif endif,          							                         
      InscricaoRestosPagar = IF i_contas_correntes IN (46) THEN componente7 endif,     
      MDEASPS = IF i_contas_correntes IN (44,46) THEN 
                         (SELECT IF relac_msc.mde = 'S' THEN 1 ELSE IF relac_msc.asps = 'S' THEN 2 ELSE 0 endif endif 
        									  FROM sapo.relac_msc
        								   WHERE relac_msc.ano_exerc = lcc.ano_exerc AND
        										     relac_msc.i_entidades = lcc.i_entidades AND
        										     relac_msc.codigo||relac_msc.ano_desp = componente6 AND
        										     tipo = 6)                             
                endif,
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