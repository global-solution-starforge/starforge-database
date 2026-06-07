-- relatorio_02.sql
-- Objetivo: identificar quantidade de contribuicoes e ticket medio por tier.
-- Instrucao: executar apos dados/carga_100_registros.sql.

SELECT
  t.NM_TIER AS tier,
  t.VL_MIN_TIER AS valor_minimo,
  COUNT(c.ID_CONTRIBUICAO) AS total_contribuicoes,
  SUM(c.VL_CONTRIBUICAO) AS valor_total,
  ROUND(AVG(c.VL_CONTRIBUICAO), 2) AS ticket_medio,
  MIN(c.VL_CONTRIBUICAO) AS menor_contribuicao,
  MAX(c.VL_CONTRIBUICAO) AS maior_contribuicao
FROM TB_TIER t
JOIN TB_CONTRIBUICAO c ON c.TB_TIER_ID_TIER = t.ID_TIER
GROUP BY
  t.NM_TIER,
  t.VL_MIN_TIER
ORDER BY valor_total DESC;
