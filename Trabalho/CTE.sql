PROMPT ========== CONSULTA NAO RECURSIVA (WITH) ==========

-- Descrição:
--   Esta consulta exemplifica o uso de CTE não recursiva para:
--     1) Calcular quantas mídias existem em cada gênero (cte_gen_count).
--     2) Calcular quantas mídias existem em cada idioma (cte_idioma_count).
--   Em seguida, fazemos um SELECT final que mostra o "top 3" gêneros e 
--   o "top 3" idiomas com mais mídias cadastradas, para ilustrar 
--   como podemos utilizar múltiplas CTEs na mesma consulta.

WITH 
  cte_gen_count AS (
    SELECT 
      g.genero, 
      COUNT(gdm.midia_id) AS total_midia
    FROM 
      luccagomes.genero g
      LEFT JOIN luccagomes.generos_da_midia gdm 
             ON gdm.genero_id = g.id
    GROUP BY 
      g.genero
  ),
  cte_idioma_count AS (
    SELECT 
      i.idioma, 
      COUNT(idm.midia_id) AS total_midia
    FROM 
      luccagomes.idioma i
      LEFT JOIN luccagomes.idiomas_da_midia idm
             ON idm.idioma_id = i.id
    GROUP BY 
      i.idioma
  )

SELECT
    'Gênero'          AS tipo,
    genero            AS nome,
    total_midia
FROM
    (
      SELECT genero, total_midia
      FROM cte_gen_count
      ORDER BY total_midia DESC
      FETCH FIRST 3 ROWS ONLY   -- top 3 gêneros
    )
UNION ALL
SELECT
    'Idioma'          AS tipo,
    idioma            AS nome,
    total_midia
FROM
    (
      SELECT idioma, total_midia
      FROM cte_idioma_count
      ORDER BY total_midia DESC
      FETCH FIRST 3 ROWS ONLY   -- top 3 idiomas
    )
ORDER BY 
    tipo DESC, 
    total_midia DESC;

PROMPT ========== FIM DA CONSULTA NAO RECURSIVA ==========


PROMPT 
PROMPT ========== CONSULTA RECURSIVA (WITH RECURSIVE) ==========

-- Descrição:
--   Nesta consulta, é gerado uma lista de dias (datas) que compreendem
--   o intervalo mínimo e máximo de "dt_inicio" na tabela ALUGUEL. 
--   Em seguida, para cada dia, mostraremos quantos aluguéis começaram
--   naquele dia. 


WITH cte_calendario (dia, dia_fim) AS (
    -- 1) Âncora: pega a data mínima de dt_inicio e a data máxima de dt_inicio
    SELECT 
        TRUNC(MIN(a.dt_inicio)) AS dia,
        TRUNC(MAX(a.dt_inicio)) AS dia_fim
    FROM 
        luccagomes.aluguel a

    UNION ALL

    -- 2) Passo recursivo: avança o dia + 1, até alcançar dia_fim
    SELECT 
        dia + 1,
        dia_fim
    FROM 
        cte_calendario
    WHERE 
        (dia + 1) <= dia_fim
)
SELECT 
    c.dia,
    COUNT(a.usuario_id) AS total_alugueis_no_dia
FROM 
    cte_calendario c
    LEFT JOIN luccagomes.aluguel a 
           ON TRUNC(a.dt_inicio) = c.dia
GROUP BY 
    c.dia
ORDER BY 
    c.dia;

PROMPT ========== FIM DA CONSULTA RECURSIVA ==========