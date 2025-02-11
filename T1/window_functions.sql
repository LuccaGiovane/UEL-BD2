PROMPT ========== CONSULTA 1: RANKING DE MÍDIAS MAIS COMPRADAS ==========
SELECT
    midia_id,
    total_por_midia,
    RANK() OVER (ORDER BY total_por_midia DESC) AS rank_por_valor
FROM (
    SELECT
        c.midia_id,
        SUM(c.valor) AS total_por_midia
    FROM
        luccagomes.compra c
    GROUP BY
        c.midia_id
)
ORDER BY
    rank_por_valor;
    

PROMPT ========== CONSULTA 2: DIFERENÇA ENTRE COMPRAS CONSECUTIVAS ==========

SELECT
    usuario_id,
    TO_CHAR(dt_compra, 'DD/MM/YYYY HH24:MI:SS') AS dt_compra,
    SUM(valor) AS total_compra,
    RANK() OVER (ORDER BY SUM(valor) DESC) AS rank_global
FROM
    luccagomes.compra
GROUP BY
    usuario_id,
    dt_compra
ORDER BY
    rank_global;

PROMPT ========== FIM DO SCRIPT DE WINDOW FUNCTIONS ==========
