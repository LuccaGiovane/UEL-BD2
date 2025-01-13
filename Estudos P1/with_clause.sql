PROMPT ==================  WITH ==================

WITH total_vendas_por_marca AS (
    SELECT b.name AS brand_name, SUM(p.sold_units) AS total_sold
    FROM estudos_brand b
    JOIN estudos_product p ON b.id = p.brand_id
    GROUP BY b.name
)
SELECT brand_name, total_sold
FROM total_vendas_por_marca
WHERE total_sold > 2000;

PROMPT ==================  WITH RECURSIVE ==================

WITH cte_hierarquia (id, name, manager_id) AS (
    --Anchor(caso base): Seleciona o gerente inicial (Alice)
    SELECT id, name, manager_id
    FROM estudos_employee
    WHERE id = 1 -- ID do gerente inicial

    UNION ALL

    -- Recursao: Seleciona os subordinados do nível anterior
    SELECT e.id, e.name, e.manager_id
    FROM estudos_employee e
    JOIN cte_hierarquia h ON e.manager_id = h.id
)
SELECT * FROM cte_hierarquia;