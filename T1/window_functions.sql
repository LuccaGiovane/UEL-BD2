PROMPT ========== CONSULTA 1: RANKING DE MÍDIAS MAIS COMPRADAS ==========

SELECT
    midia_id,
    total_por_midia,
    RANK() OVER (ORDER BY total_por_midia DESC) AS rank_por_valor
FROM (
    SELECT
        c.midia_id,
        SUM(c.valor) OVER (PARTITION BY c.midia_id) AS total_por_midia
    FROM
        luccagomes.compra c
)
ORDER BY
    rank_por_valor;


PROMPT ========== CONSULTA 2: DIFERENÇA ENTRE COMPRAS CONSECUTIVAS ==========

SELECT
    c.usuario_id,
    c.dt_compra,
    LAG(c.dt_compra) OVER (
        PARTITION BY c.usuario_id
        ORDER BY c.dt_compra
    ) AS compra_anterior,
    (c.dt_compra - LAG(c.dt_compra) OVER (
        PARTITION BY c.usuario_id
        ORDER BY c.dt_compra
    )) AS dias_entre_compras
FROM
    luccagomes.compra c
ORDER BY
    c.usuario_id,
    c.dt_compra;

PROMPT ========== FIM DO SCRIPT DE WINDOW FUNCTIONS ==========
