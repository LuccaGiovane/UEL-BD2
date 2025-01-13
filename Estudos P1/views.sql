PROMPT ==================  VIEW ==================

CREATE OR REPLACE VIEW estudos_total_vendas AS SELECT  -- Cria a view estudos_total_vendas
b.name AS brand_name, -- seleciona o nome da marca
SUM(p.sold_units) AS total_sold  -- calcula a soma das unidades vendidas
FROM estudos_brand b JOIN estudos_product p ON b.id = p.brand_id -- faz o join das tabelas 'b' e 'p'
GROUP BY b.name; -- agrupando o resultado pelo nome da marca

SELECT * FROM estudos_total_vendas;

PROMPT ==================  MATERIALIZED VIEW ==================

BEGIN
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW luccagomes.estudos_total_vendas_mv';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -12003 THEN  -- ORA-12003: materialized view does not exist 
            RAISE;
        END IF;
END;
/

CREATE MATERIALIZED VIEW estudos_total_vendas_mv
BUILD IMMEDIATE 
REFRESH ON DEMAND 
AS SELECT b.name AS brand_name,
SUM(p.sold_units) AS total_sold 
FROM estudos_brand b JOIN estudos_product p ON b.id = p.brand_id 
GROUP BY b.name;

SELECT * FROM estudos_total_vendas_mv;

PROMPT ==================  Inserindo um novo produto  ==================

-- Inserir um novo produto para testar a atualização da materialized view
INSERT INTO estudos_product (id, name, brand_id, sold_units) VALUES ('P006', 'Nova Linha Nike', 1, 2000);

-- Commit para salvar a alteração
COMMIT;

PROMPT ==================  Chamando as views  ==================

PROMPT View Normal:
SELECT * FROM estudos_total_vendas;

PROMPT Materialized View:
SELECT * FROM estudos_total_vendas_mv;

PROMPT ==================  Atualizando a Materialized View  ==================
BEGIN
    DBMS_MVIEW.REFRESH('estudos_total_vendas_mv');  -- use o nome correto da sua MV
END;
/

SELECT * FROM estudos_total_vendas_mv;