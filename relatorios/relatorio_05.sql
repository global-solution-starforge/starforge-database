-- relatorio_05.sql
-- Objetivo: analisar desempenho de agencias por quantidade de missoes e arrecadacao.
-- Instrucao: executar apos dados/carga_100_registros.sql.

SELECT
  a.NM_AGENCIA AS agencia,
  COUNT(DISTINCT m.ID_MISSAO) AS total_missoes,
  COUNT(c.ID_CONTRIBUICAO) AS total_contribuicoes,
  NVL(SUM(c.VL_CONTRIBUICAO), 0) AS valor_total_contribuido,
  NVL(SUM(CASE WHEN c.STT_CONTRIBUICAO = 'CONFIRMADO' THEN c.VL_CONTRIBUICAO ELSE 0 END), 0) AS valor_confirmado,
  ROUND(NVL(AVG(c.VL_CONTRIBUICAO), 0), 2) AS ticket_medio
FROM TB_AGENCIA a
JOIN TB_MISSAO m ON m.TB_AGENCIA_ID_AGENCIA = a.ID_AGENCIA
LEFT JOIN TB_CONTRIBUICAO c ON c.TB_MISSAO_ID_MISSAO = m.ID_MISSAO
GROUP BY a.NM_AGENCIA
ORDER BY valor_confirmado DESC, total_missoes DESC;
