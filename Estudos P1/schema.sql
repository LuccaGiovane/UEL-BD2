-- Criar tabela de marcas (brand) com prefixo estudos_
CREATE TABLE estudos_brand (
    id INT PRIMARY KEY,
    name VARCHAR2(50) UNIQUE,
    description VARCHAR2(500)
);

-- Criar tabela de produtos (product) com prefixo estudos_
CREATE TABLE estudos_product (
    id CHAR(5) PRIMARY KEY,
    name VARCHAR2(150),
    brand_id INT,
    sold_units INT,
    CONSTRAINT fk_product_brand FOREIGN KEY (brand_id) REFERENCES estudos_brand (id)
);

-- Criar a tabela de funcionários (employee)
CREATE TABLE estudos_employee (
    id INT PRIMARY KEY,         -- Identificador único do funcionário
    name VARCHAR2(50),          -- Nome do funcionário
    manager_id INT              -- Identificador do gerente (null se for CEO)
);



-- Inserir dados na tabela estudos_brand
INSERT INTO estudos_brand (id, name, description) VALUES (1, 'Nike', 'Marca de esportes');
INSERT INTO estudos_brand (id, name, description) VALUES (2, 'Adidas', 'Marca de calçados');
INSERT INTO estudos_brand (id, name, description) VALUES (3, 'Puma', 'Marca de roupas');

-- Inserir dados na tabela estudos_product
INSERT INTO estudos_product (id, name, brand_id, sold_units) VALUES ('P001', 'Air Max', 1, 1000);
INSERT INTO estudos_product (id, name, brand_id, sold_units) VALUES ('P002', 'Superstar', 2, 1500);
INSERT INTO estudos_product (id, name, brand_id, sold_units) VALUES ('P003', 'Suede Classic', 3, 2000);
INSERT INTO estudos_product (id, name, brand_id, sold_units) VALUES ('P004', 'Air Force', 1, 500);
INSERT INTO estudos_product (id, name, brand_id, sold_units) VALUES ('P005', 'Ultraboost', 2, 1200);

-- Inserir dados na tabela estudos_employee
INSERT INTO estudos_employee (id, name, manager_id) VALUES (1, 'Alice', NULL);  -- CEO
INSERT INTO estudos_employee (id, name, manager_id) VALUES (2, 'Bob', 1);       -- Subordinado de Alice
INSERT INTO estudos_employee (id, name, manager_id) VALUES (3, 'Charlie', 1);   -- Subordinado de Alice
INSERT INTO estudos_employee (id, name, manager_id) VALUES (4, 'David', 2);     -- Subordinado de Bob
INSERT INTO estudos_employee (id, name, manager_id) VALUES (5, 'Eve', 2);       -- Subordinado de Bob
INSERT INTO estudos_employee (id, name, manager_id) VALUES (6, 'Frank', 3);     -- Subordinado de Charlie
INSERT INTO estudos_employee (id, name, manager_id) VALUES (7, 'Grace', 3);     -- Subordinado de Charlie


-- Commit para salvar as alterações
COMMIT;
