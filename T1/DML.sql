PROMPT ========== INÍCIO DOS TRIGGERS E TESTES (DML.sql) ==========

-------------------------------------------------------------------------------
PROMPT ========== CRIAÇÃO DO TRIGGER PARA AJUSTE AUTOMÁTICO DO VALOR DE COMPRA ==========
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER luccagomes.trg_auto_valor_compra
BEFORE INSERT ON luccagomes.compra
FOR EACH ROW
DECLARE
    v_valor NUMBER(10,2);
BEGIN
    -- Se o valor da compra não for informado (ou for nulo), usar o valor da mídia
    IF :NEW.valor IS NULL THEN
        SELECT m.valor
          INTO v_valor
          FROM luccagomes.midia m
         WHERE m.id = :NEW.midia_id;

        :NEW.valor := v_valor;
    END IF;
END;
/
PROMPT Trigger luccagomes.trg_auto_valor_compra criado com sucesso.

-------------------------------------------------------------------------------
PROMPT ========== CRIAÇÃO DO TRIGGER QUE IMPEDE COMPRA DE MÍDIA INATIVA ==========
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER luccagomes.trg_check_midia_ativa_compra
BEFORE INSERT OR UPDATE ON luccagomes.compra
FOR EACH ROW
DECLARE
    v_ativo CHAR(1);
BEGIN
    SELECT m.ativo
      INTO v_ativo
      FROM luccagomes.midia m
     WHERE m.id = :NEW.midia_id;

    IF v_ativo = 'N' THEN
        RAISE_APPLICATION_ERROR(
            -20001, 
            'ERRO: Não é possível comprar mídia inativa (ID=' || :NEW.midia_id || ').'
        );
    END IF;
END;
/
PROMPT Trigger luccagomes.trg_check_midia_ativa_compra criado com sucesso.

-------------------------------------------------------------------------------
PROMPT ========== INSERINDO DADOS BÁSICOS PARA TESTE ==========
-------------------------------------------------------------------------------

PROMPT Inserindo um usuário (ID gerado pelo IDENTITY):
-- Se 'fulano_login' ou 'fulano_login2' já existirem, mude o valor do login novamente.
INSERT INTO luccagomes.usuario (nome, login, senha, nasc)
VALUES ('teste38', 'login_38', '1234', DATE '1990-01-01');
/

PROMPT Inserindo uma mídia (ID gerado pelo IDENTITY):
INSERT INTO luccagomes.midia (titulo, dt_lancamento, valor, duracao)
VALUES ('Filme Ativo', DATE '2020-01-01', 50.00, 120);
/

PROMPT Criando uma nota_fiscal para esse usuário (valor_total=0):
-- dt_pagamento = SYSTIMESTAMP por default (PRIMARY KEY = (usuario_id, dt_pagamento))
INSERT INTO luccagomes.nota_fiscal (usuario_id, valor_total)
SELECT u.id, 0
  FROM (
       SELECT id
         FROM luccagomes.usuario
        ORDER BY id DESC
       ) u
 WHERE ROWNUM = 1;
/

PROMPT Consultar os dados recém inseridos:
SELECT * FROM luccagomes.usuario;
SELECT * FROM luccagomes.midia;
SELECT * FROM luccagomes.nota_fiscal;

-------------------------------------------------------------------------------
PROMPT ========== TESTES DOS TRIGGERS ==========
-------------------------------------------------------------------------------

PROMPT Tentando comprar com mídia ativa (deve funcionar):
INSERT INTO luccagomes.compra (usuario_id, midia_id, dt_compra, valor)
SELECT
    (SELECT id 
       FROM (SELECT id FROM luccagomes.usuario ORDER BY id DESC)
      WHERE ROWNUM = 1
    ) AS usuario_id,
    (SELECT id
       FROM (SELECT id FROM luccagomes.midia ORDER BY id DESC)
      WHERE ROWNUM = 1
    ) AS midia_id,
    (SELECT dt_pagamento
       FROM (SELECT dt_pagamento FROM luccagomes.nota_fiscal ORDER BY dt_pagamento DESC)
      WHERE ROWNUM = 1
    ) AS dt_compra,
    NULL AS valor
FROM DUAL;
/

PROMPT Consulta para ver se o valor foi preenchido automaticamente:
SELECT *
  FROM luccagomes.compra
 ORDER BY dt_compra DESC;

PROMPT Tornar a mídia inativa e tentar comprar de novo (deve falhar):
UPDATE luccagomes.midia
   SET ativo = 'N'
 WHERE id = (
   SELECT id
     FROM (SELECT id FROM luccagomes.midia ORDER BY id DESC)
    WHERE ROWNUM = 1
 );
/

PROMPT Ao tentar comprar agora, deve disparar o erro -20001:
INSERT INTO luccagomes.compra (usuario_id, midia_id, dt_compra, valor)
SELECT
    (SELECT id 
       FROM (SELECT id FROM luccagomes.usuario ORDER BY id DESC)
      WHERE ROWNUM = 1
    ),
    (SELECT id
       FROM (SELECT id FROM luccagomes.midia ORDER BY id DESC)
      WHERE ROWNUM = 1
    ),
    (SELECT dt_pagamento
       FROM (SELECT dt_pagamento FROM luccagomes.nota_fiscal ORDER BY dt_pagamento DESC)
      WHERE ROWNUM = 1
    ),
    NULL
FROM DUAL;
/

PROMPT Espera-se erro ORA-20001: ERRO: Não é possível comprar mídia inativa.

PROMPT ========== FIM DOS TRIGGERS E TESTES ==========