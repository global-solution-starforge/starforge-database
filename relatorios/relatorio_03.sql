-- relatorio_03.sql
-- Objetivo: acompanhar progresso medio das fases por missao e status operacional.
-- Instrucao: executar apos dados/carga_100_registros.sql.

SELECT
  m.CD_MISSAO AS codigo_missao,
  m.NM_MISSAO AS nome_missao,
  m.STT_MISSAO AS status_missao,
  COUNT(f.ID_FASE_MISSAO) AS total_fases,
  ROUND(AVG(f.PCT_FASE_MISSAO), 2) AS progresso_medio,
  SUM(CASE WHEN f.STT_FASE = 'CONCLUIDO' THEN 1 ELSE 0 END) AS fases_concluidas,
  SUM(CASE WHEN f.STT_FASE = 'EM ANDAMENTO' THEN 1 ELSE 0 END) AS fases_em_andamento,
  SUM(CASE WHEN f.STT_FASE = 'AGUARDANDO' THEN 1 ELSE 0 END) AS fases_aguardando
FROM TB_MISSAO m
JOIN TB_FASE_MISSAO f ON f.TB_MISSAO_ID_MISSAO = m.ID_MISSAO
GROUP BY
  m.CD_MISSAO,
  m.NM_MISSAO,
  m.STT_MISSAO
ORDER BY progresso_medio DESC, m.CD_MISSAO;
