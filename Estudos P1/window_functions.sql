PROMPT ================== WINDOW FUNCTION: SUM ==================

SELECT
    p.id,
    p.name AS product_name,
    b.name AS brand_name,
    p.sold_units,
    --OVER(): Define a "janela" (conjunto de linhas) sobre a qual a função será aplicada
    -- PARTITION BY p.brand_id: Agrupa os produtos por marca.
    -- ORDER BY p.id: Ordena os produtos dentro de cada marca pelo id.
    -- SUM(p.sold_units) OVER (...): Calcula a soma acumulada das unidades vendidas por marca.
    SUM(p.sold_units) OVER (PARTITION BY p.brand_id ORDER BY p.id) AS cumulative_sold
FROM
    estudos_product p
JOIN
    estudos_brand b ON p.brand_id = b.id;    

PROMPT ================== WINDOW FUNCTION: RANK ==================

SELECT
    p.id,
    p.name AS product_name,
    b.name AS brand_name,
    p.sold_units,
    -- RANK() OVER (...): Atribui um ranking aos produtos com base nas unidades vendidas (sold_units), em ordem decrescente.
    -- PARTITION BY p.brand_id: O ranking é reiniciado para cada marca.
    RANK() OVER (PARTITION BY p.brand_id ORDER BY p.id) AS rank
FROM
    estudos_product p
JOIN 
    estudos_brand b ON p.brand_id = b.id;


PROMPT ================== Window Frame Definido por Intervalo de Valores ==================

SELECT
    p.id,
    p.name AS product_name,
    b.name AS brand_name,
    p.sold_units,
    AVG(p.sold_units) OVER (
        PARTITION BY p.brand_id
        ORDER BY p.id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg
FROM 
    estudos_product p
JOIN 
    estudos_brand b ON p.brand_id = b.id;