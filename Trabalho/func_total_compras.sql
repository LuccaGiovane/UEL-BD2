PROMPT ========== CRIAÇÃO DA FUNÇÃO: FN_TOTAL_COMPRAS ==========

CREATE OR REPLACE FUNCTION luccagomes.fn_total_compras (
    p_usuario_id  IN NUMBER
) 
RETURN NUMBER 
IS
    v_total NUMBER(10,2);
BEGIN
    SELECT NVL(SUM(c.valor), 0)
      INTO v_total
      FROM luccagomes.compra c
     WHERE c.usuario_id = p_usuario_id;

    RETURN v_total;
END;
/

PROMPT ========== CONSULTA QUE INVOCA A FUNÇÃO FN_TOTAL_COMPRAS ==========

SELECT
    u.id AS usuario_id,
    SUBSTR(u.nome, 1, 20) AS nome_usuario,
    luccagomes.fn_total_compras(u.id) AS total_gasto
FROM
    luccagomes.usuario u
ORDER BY
    total_gasto DESC;
