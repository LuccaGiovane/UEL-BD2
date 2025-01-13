-- Verificar se a tabela já existe e eliminá-la
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE produtos_nike';
    EXECUTE IMMEDIATE 'DROP TABLE produtos_adidas';
    EXECUTE IMMEDIATE 'DROP TABLE produtos_puma';
EXCEPTION
    WHEN OTHERS THEN
        -- Ignorar o erro se a tabela não existir
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

PROMPT ================== Temporary Table (PRODUTOS NIKE) ==================
CREATE TABLE produtos_nike AS
SELECT * FROM estudos_product WHERE
brand_id = 1;

SELECT * FROM produtos_nike;

PROMPT ================== Temporary Table (PRODUTOS ADIDAS) ==================
CREATE TABLE produtos_adidas AS
SELECT * FROM estudos_product WHERE
brand_id = 2;

SELECT * FROM produtos_adidas;

PROMPT ================== Temporary Table (PRODUTOS PUMA) ==================
CREATE TABLE produtos_puma AS
SELECT * FROM estudos_product WHERE
brand_id = 3;

SELECT * FROM produtos_puma;