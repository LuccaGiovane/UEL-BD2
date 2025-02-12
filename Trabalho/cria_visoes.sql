PROMPT ========== CRIANDO/RECRIANDO VIEW (VISÃO COMPUTADA) ==========

-- 1) Criando (ou recriando) uma visão simples que retorna
--    somente as mídias ativas. 
--    "Computada" significa que não armazena em disco as linhas;
--    ela reflete as alterações na tabela base em tempo real.

CREATE OR REPLACE VIEW luccagomes.vw_midia_ativa AS
SELECT 
    id,
    titulo,
    dt_lancamento,
    valor,
    avaliacao,
    poster,
    atores
FROM 
    luccagomes.midia
WHERE 
    ativo = 'Y';


PROMPT ========== EXEMPLO DE USO DA VIEW (CONSULTA) ==========

-- Verificando quantas mídias ativas temos no momento
SELECT COUNT(*) AS total_midia_ativa
  FROM luccagomes.vw_midia_ativa;


PROMPT ========== FAZENDO ATUALIZACAO QUE AFETA A VIEW ==========

DECLARE
    v_id_midia NUMBER;
BEGIN
    -- Pegamos 1 mídia que esteja ativa
    SELECT id
      INTO v_id_midia
      FROM luccagomes.midia
     WHERE ativo = 'Y'
       AND ROWNUM = 1;  -- pega a primeira que encontrar

    -- Desativa essa mídia (muda de Y para N)
    UPDATE luccagomes.midia
       SET ativo = 'N'
     WHERE id = v_id_midia;

    COMMIT;

    DBMS_OUTPUT.put_line(
       'Midia ' || v_id_midia || ' foi desativada. Verifique a vw_midia_ativa.'
    );
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line('Nenhuma mídia ativa encontrada para desativar.');
END;
/

-- Agora, se consultarmos novamente a view, essa mídia não aparecerá mais (caso exista)
SELECT id, titulo
  FROM luccagomes.vw_midia_ativa
 WHERE ROWNUM <= 5;  -- Exibe até as 5 primeiras mídias ativas


PROMPT ========== CRIANDO/RECRIANDO MATERIALIZED VIEW (SEM FILTRO) ==========

BEGIN
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW luccagomes.mv_compras_resumo';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -12003 THEN  -- ORA-12003: materialized view does not exist 
            RAISE;
        END IF;
END;
/

CREATE MATERIALIZED VIEW luccagomes.mv_compras_resumo
BUILD IMMEDIATE
REFRESH ON DEMAND
AS
SELECT
    c.usuario_id,
    COUNT(*)     AS total_compras,
    SUM(c.valor) AS valor_total
FROM
    luccagomes.compra c
GROUP BY
    c.usuario_id;



PROMPT ========== EXEMPLO DE USO DA MATERIALIZED VIEW ==========

-- Consulta a MV para ver quantas compras por usuário
SELECT * FROM luccagomes.mv_compras_resumo
ORDER BY usuario_id;


PROMPT ========== EXEMPLO DE ATUALIZACAO QUE AFETA O CONTEUDO DA MV ==========

DECLARE
    v_usuario   NUMBER;
    v_dt_pag    TIMESTAMP;
    v_midia     NUMBER;
BEGIN
    -- 1) Pegamos algum usuario_id e dt_pagamento que existam em nota_fiscal
    SELECT usuario_id, dt_pagamento
      INTO v_usuario, v_dt_pag
      FROM luccagomes.nota_fiscal
     WHERE ROWNUM = 1;

    -- 2) Pegamos alguma midia que ESTE USUÁRIO ainda NÃO comprou
    SELECT m.id
      INTO v_midia
      FROM luccagomes.midia m
     WHERE ROWNUM = 1
       AND NOT EXISTS (
           SELECT 1
             FROM luccagomes.compra c
            WHERE c.usuario_id = v_usuario
              AND c.midia_id   = m.id
       );

    -- 3) Insere uma nova compra na tabela base (compra),
    --    usando esse usuário, essa mídia e a data de pagamento acima
    INSERT INTO luccagomes.compra (usuario_id, midia_id, dt_compra, valor)
    VALUES (v_usuario, v_midia, v_dt_pag, 40);

    COMMIT;

    DBMS_OUTPUT.put_line('Inserida compra do usuario ' || v_usuario
        || ' na midia ' || v_midia
        || ' no dt_pagamento ' || v_dt_pag
        || ' com valor R$40');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line(
            'Não foi possível inserir compra: não há nota_fiscal, midia ou ' ||
            'todas as mídias já foram compradas por esse usuário.'
        );
END;
/

-- 4) Consulta novamente a MV (sem REFRESH) para ver se já atualizou
--    (não vai atualizar até fazermos o REFRESH, pois é "REFRESH ON DEMAND")
SELECT * FROM luccagomes.mv_compras_resumo
ORDER BY usuario_id;


PROMPT ========== REALIZANDO O REFRESH MANUAL DA MV ==========

-- forçar o refresh para a MV recalcular.
EXEC DBMS_MVIEW.REFRESH('luccagomes.mv_compras_resumo');

-- 5) Consulta após o REFRESH
SELECT * FROM luccagomes.mv_compras_resumo
ORDER BY usuario_id;
/
