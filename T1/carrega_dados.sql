-------------------------------------------------------------------------------
-- carga_dados.sql
-- Script que:
--   1) Cria/recria o procedimento sp_carga_dados
--   2) Executa sp_carga_dados(p_fator)
--
-- Obs.: As tabelas devem existir previamente no schema luccagomes
-------------------------------------------------------------------------------

PROMPT ========== CRIANDO/RECRIANDO O PROCEDIMENTO sp_carga_dados ==========

CREATE OR REPLACE PROCEDURE luccagomes.sp_carga_dados(p_fator IN NUMBER) AS
BEGIN
    -- 1) Limpando as tabelas (apenas DELETE, sem DROP)
    EXECUTE IMMEDIATE 'DELETE FROM luccagomes.idiomas_da_midia';
    EXECUTE IMMEDIATE 'DELETE FROM luccagomes.generos_da_midia';
    EXECUTE IMMEDIATE 'DELETE FROM luccagomes.aluguel';
    EXECUTE IMMEDIATE 'DELETE FROM luccagomes.compra';
    EXECUTE IMMEDIATE 'DELETE FROM luccagomes.nota_fiscal';
    EXECUTE IMMEDIATE 'DELETE FROM luccagomes.midia';
    EXECUTE IMMEDIATE 'DELETE FROM luccagomes.genero';
    EXECUTE IMMEDIATE 'DELETE FROM luccagomes.idioma';
    EXECUTE IMMEDIATE 'DELETE FROM luccagomes.usuario';

    COMMIT;

    DECLARE
        v_count    NUMBER := 1;
        v_limite   NUMBER := 5 * p_fator;  -- base de 5, ajustada pelo fator
    BEGIN
        ----------------------------------------------------------------------
        -- 2) Inserir usuários
        ----------------------------------------------------------------------
        WHILE v_count <= v_limite LOOP
            INSERT INTO luccagomes.usuario (nome, login, senha, nasc, ativo)
            VALUES (
                'Usuario ' || v_count,
                'login' || v_count,
                'senha' || v_count,
                TRUNC(TO_DATE('01/01/1990','DD/MM/YYYY') 
                      + DBMS_RANDOM.value(1,10000)),  -- datas aleatórias
                CASE WHEN MOD(v_count, 2) = 0 THEN 'Y' ELSE 'N' END
            );
            v_count := v_count + 1;
        END LOOP;

        ----------------------------------------------------------------------
        -- 3) Inserir idiomas
        ----------------------------------------------------------------------
        FOR i IN 1..3 LOOP
            INSERT INTO luccagomes.idioma (idioma)
            VALUES ('Idioma_' || i);
        END LOOP;

        ----------------------------------------------------------------------
        -- 4) Inserir gêneros
        ----------------------------------------------------------------------
        FOR i IN 1..3 LOOP
            INSERT INTO luccagomes.genero (genero)
            VALUES ('Genero_' || i);
        END LOOP;

        ----------------------------------------------------------------------
        -- 5) Inserir mídias
        ----------------------------------------------------------------------
        v_count := 1; 
        WHILE v_count <= v_limite LOOP
            INSERT INTO luccagomes.midia 
                (titulo, sinopse, avaliacao, poster, atores, dt_lancamento, 
                 valor, duracao, temporadas, ativo)
            VALUES (
                'Midia ' || v_count,
                'Sinopse da midia ' || v_count,
                ROUND(DBMS_RANDOM.value(0,10),2), 
                'poster' || v_count || '.jpg',
                'Ator_' || v_count || ', Atriz_' || v_count,
                TRUNC(TO_DATE('01/01/2000','DD/MM/YYYY') 
                      + DBMS_RANDOM.value(1,5000)),   -- datas aleatórias
                ROUND(DBMS_RANDOM.value(10,100),2),
                CASE WHEN MOD(v_count,2)=0 THEN ROUND(DBMS_RANDOM.value(90,180))
                     ELSE NULL END,   -- Se par, é filme (duracao != NULL)
                CASE WHEN MOD(v_count,2)=1 THEN TRUNC(DBMS_RANDOM.value(1,6))
                     ELSE NULL END,   -- Se ímpar, é série (temporadas != NULL)
                CASE WHEN MOD(v_count,3)=0 THEN 'N' ELSE 'Y' END
            );
            v_count := v_count + 1;
        END LOOP;

        ----------------------------------------------------------------------
        -- 6) Inserir relacionamentos entre mídias e idiomas
        ----------------------------------------------------------------------
        FOR mid IN (SELECT id FROM luccagomes.midia) LOOP
            INSERT INTO luccagomes.idiomas_da_midia (midia_id, idioma_id)
            VALUES (mid.id, 1);

            -- chance aleatória de inserir um 2º idioma
            IF DBMS_RANDOM.value(0,1) > 0.5 THEN
                INSERT INTO luccagomes.idiomas_da_midia (midia_id, idioma_id)
                VALUES (mid.id, 2);
            END IF;
        END LOOP;

        ----------------------------------------------------------------------
        -- 7) Inserir relacionamentos entre mídias e gêneros
        ----------------------------------------------------------------------
        FOR mid IN (SELECT id FROM luccagomes.midia) LOOP
            INSERT INTO luccagomes.generos_da_midia (midia_id, genero_id)
            VALUES (mid.id, 1);

            -- chance aleatória de inserir um 2º gênero
            IF DBMS_RANDOM.value(0,1) > 0.5 THEN
                INSERT INTO luccagomes.generos_da_midia (midia_id, genero_id)
                VALUES (mid.id, 2);
            END IF;
        END LOOP;

        ----------------------------------------------------------------------
        -- 8) Inserir notas fiscais (2 por usuário ativo)
        ----------------------------------------------------------------------
        FOR usr IN (SELECT id FROM luccagomes.usuario WHERE ativo = 'Y') LOOP
            INSERT INTO luccagomes.nota_fiscal (usuario_id, valor_total)
            VALUES (usr.id, ROUND(DBMS_RANDOM.value(50,300),2));

            INSERT INTO luccagomes.nota_fiscal (usuario_id, valor_total)
            VALUES (usr.id, ROUND(DBMS_RANDOM.value(50,300),2));
        END LOOP;

        ----------------------------------------------------------------------
        -- 9) Inserir alugueis e compras para cada nota fiscal
        ----------------------------------------------------------------------
        FOR nf IN (SELECT usuario_id, dt_pagamento, valor_total 
                   FROM luccagomes.nota_fiscal) LOOP
            -- 9.1) Aluguel (chance ~50%)
            IF DBMS_RANDOM.value(0,1) > 0.5 THEN
                INSERT INTO luccagomes.aluguel 
                    (usuario_id, midia_id, dt_inicio, dt_expira, valor)
                VALUES (
                    nf.usuario_id,
                    (SELECT id FROM (SELECT id FROM luccagomes.midia 
                                     ORDER BY DBMS_RANDOM.value) 
                     WHERE ROWNUM = 1),
                    nf.dt_pagamento, 
                    nf.dt_pagamento + NUMTODSINTERVAL(3,'DAY'), 
                    ROUND(DBMS_RANDOM.value(10,50),2)
                );
            END IF;

            -- 9.2) Compra (chance ~70%)
            IF DBMS_RANDOM.value(0,1) > 0.3 THEN
                INSERT INTO luccagomes.compra 
                    (usuario_id, midia_id, dt_compra, valor)
                VALUES (
                    nf.usuario_id,
                    (SELECT id FROM (SELECT id FROM luccagomes.midia 
                                     ORDER BY DBMS_RANDOM.value) 
                     WHERE ROWNUM = 1),
                    nf.dt_pagamento,
                    ROUND(DBMS_RANDOM.value(15,80),2)
                );
            END IF;
        END LOOP;

        COMMIT;
    END;
END;
/
SHOW ERRORS;

-------------------------------------------------------------------------------
-- Agora invocamos o procedimento
-------------------------------------------------------------------------------
PROMPT ========== EXECUTANDO sp_carga_dados(p_fator) ==========

BEGIN
    ---------------------------------------------------------------------------
    -- Para mudar o fator de escala, altere o número aqui:
    ---------------------------------------------------------------------------
    luccagomes.sp_carga_dados(1);  -- <---- p_fator = 1
END;
/
