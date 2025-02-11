-- -------------------------------------------------------------------------
-- Criação das tabelas no schema luccagomes
-- -------------------------------------------------------------------------

--------------------------------------------------------------------------
-- TABELA USUARIO
--------------------------------------------------------------------------
CREATE TABLE luccagomes.usuario (
    id          NUMBER GENERATED ALWAYS AS IDENTITY,
    nome        VARCHAR2(255)    NOT NULL,
    login       VARCHAR2(255)    NOT NULL,
    senha       VARCHAR2(255)    NOT NULL,
    nasc        DATE             NOT NULL,
    ativo       CHAR(1)          DEFAULT 'Y'  NOT NULL,
      -- 'Y' = ativo, 'N' = inativo

    CONSTRAINT pk_usuario PRIMARY KEY (id),
    CONSTRAINT uk_usuario_login UNIQUE (login)
);

--------------------------------------------------------------------------
-- TABELA IDIOMA
--------------------------------------------------------------------------
CREATE TABLE luccagomes.idioma (
    id       NUMBER GENERATED ALWAYS AS IDENTITY,
    idioma   VARCHAR2(24) NOT NULL,

    CONSTRAINT pk_idioma PRIMARY KEY (id),
    CONSTRAINT uk_idioma UNIQUE (idioma)
);

--------------------------------------------------------------------------
-- TABELA GENERO
--------------------------------------------------------------------------
CREATE TABLE luccagomes.genero (
    id       NUMBER GENERATED ALWAYS AS IDENTITY,
    genero   VARCHAR2(24) NOT NULL,

    CONSTRAINT pk_genero PRIMARY KEY (id),
    CONSTRAINT uk_genero UNIQUE (genero)
);

--------------------------------------------------------------------------
-- TABELA MIDIA
--------------------------------------------------------------------------
CREATE TABLE luccagomes.midia (
    id            NUMBER GENERATED ALWAYS AS IDENTITY,
    titulo        VARCHAR2(255) NOT NULL,
    sinopse       CLOB,
    avaliacao     NUMBER(3,2),
    poster        VARCHAR2(255),
    atores        VARCHAR2(255),
    dt_lancamento DATE NOT NULL,
    valor         NUMBER(10,2) NOT NULL,
    duracao       NUMBER,        -- exclusivo de filme
    temporadas    NUMBER,        -- exclusivo de série
    ativo         CHAR(1)  DEFAULT 'Y' NOT NULL,
      -- 'Y' = ativo, 'N' = inativo

    CONSTRAINT pk_midia PRIMARY KEY (id),
    CONSTRAINT ck_filme_ou_serie CHECK (
        (
          duracao IS NULL
          AND temporadas IS NOT NULL
        )
        OR
        (
          duracao IS NOT NULL
          AND temporadas IS NULL
        )
    )
);

--------------------------------------------------------------------------
-- TABELA IDIOMAS_DA_MIDIA
--------------------------------------------------------------------------
CREATE TABLE luccagomes.idiomas_da_midia (
    midia_id   NUMBER,
    idioma_id  NUMBER,

    CONSTRAINT pk_idiomas_da_midia PRIMARY KEY (midia_id, idioma_id),
    CONSTRAINT fk_midia_tem_idioma FOREIGN KEY (midia_id)
        REFERENCES luccagomes.midia(id),
    CONSTRAINT fk_idioma_da_midia FOREIGN KEY (idioma_id)
        REFERENCES luccagomes.idioma(id)
);

--------------------------------------------------------------------------
-- TABELA GENEROS_DA_MIDIA
--------------------------------------------------------------------------
CREATE TABLE luccagomes.generos_da_midia (
    midia_id   NUMBER,
    genero_id  NUMBER,

    CONSTRAINT pk_generos_da_midia PRIMARY KEY (midia_id, genero_id),
    CONSTRAINT fk_midia_tem_genero FOREIGN KEY (midia_id)
        REFERENCES luccagomes.midia(id),
    CONSTRAINT fk_genero_da_midia FOREIGN KEY (genero_id)
        REFERENCES luccagomes.genero(id)
);

--------------------------------------------------------------------------
-- TABELA NOTA_FISCAL
--------------------------------------------------------------------------
CREATE TABLE luccagomes.nota_fiscal (
    usuario_id   NUMBER,
    valor_total  NUMBER(10,2) NOT NULL,
    dt_pagamento TIMESTAMP DEFAULT SYSTIMESTAMP,

    CONSTRAINT pk_nota_fiscal PRIMARY KEY (usuario_id, dt_pagamento),
    CONSTRAINT fk_usuario_possui FOREIGN KEY (usuario_id)
        REFERENCES luccagomes.usuario(id)
);

--------------------------------------------------------------------------
-- TABELA ALUGUEL
--------------------------------------------------------------------------
CREATE TABLE luccagomes.aluguel (
    usuario_id  NUMBER,
    midia_id    NUMBER,
    dt_inicio   TIMESTAMP DEFAULT SYSTIMESTAMP,
    dt_expira   TIMESTAMP DEFAULT (SYSTIMESTAMP + INTERVAL '30' DAY) NOT NULL,
    valor       NUMBER(10,2) NOT NULL,

    CONSTRAINT pk_aluguel PRIMARY KEY (usuario_id, midia_id, dt_inicio),
    CONSTRAINT fk_usuario_alugou FOREIGN KEY (usuario_id, dt_inicio)
        REFERENCES luccagomes.nota_fiscal (usuario_id, dt_pagamento),
    CONSTRAINT fk_midia_foi_alugada FOREIGN KEY (midia_id)
        REFERENCES luccagomes.midia (id),
    CONSTRAINT ck_dt_aluguel CHECK (dt_inicio < dt_expira),
    CONSTRAINT ck_valor_aluguel_positivo CHECK (valor > 0)
);

--------------------------------------------------------------------------
-- TABELA COMPRA
--------------------------------------------------------------------------
CREATE TABLE luccagomes.compra (
    usuario_id  NUMBER,
    midia_id    NUMBER,
    dt_compra   TIMESTAMP,
    valor       NUMBER(10,2) NOT NULL,

    CONSTRAINT pk_comprou PRIMARY KEY (usuario_id, midia_id),
    CONSTRAINT fk_usuario_comprou FOREIGN KEY (usuario_id, dt_compra)
        REFERENCES luccagomes.nota_fiscal (usuario_id, dt_pagamento),
    CONSTRAINT fk_midia_foi_comprada FOREIGN KEY (midia_id)
        REFERENCES luccagomes.midia (id),
    CONSTRAINT ck_valor_compra_positivo CHECK (valor > 0)
);