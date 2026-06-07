-- relatorio_01.sql
-- Objetivo: analisar arrecadacao confirmada por missao, agencia e organizacao.
-- Instrucao: executar apos dados/carga_100_registros.sql.

SELECT
  m.CD_MISSAO AS codigo_missao,
  m.NM_MISSAO AS nome_missao,
  a.NM_AGENCIA AS agencia,
  o.NM_ORGANIZACAO AS organizacao,
  m.VL_META_MISSAO AS meta_financeira,
  NVL(SUM(CASE WHEN c.STT_CONTRIBUICAO = 'CONFIRMADO' THEN c.VL_CONTRIBUICAO ELSE 0 END), 0) AS valor_confirmado,
  ROUND(
    NVL(SUM(CASE WHEN c.STT_CONTRIBUICAO = 'CONFIRMADO' THEN c.VL_CONTRIBUICAO ELSE 0 END), 0)
    / m.VL_META_MISSAO * 100,
    2
  ) AS percentual_meta
FROM TB_MISSAO m
JOIN TB_AGENCIA a ON a.ID_AGENCIA = m.TB_AGENCIA_ID_AGENCIA
JOIN TB_ORGANIZACAO o ON o.ID_ORGANIZACAO = m.TB_ORGANIZACAO_ID_ORGANIZACAO
LEFT JOIN TB_CONTRIBUICAO c ON c.TB_MISSAO_ID_MISSAO = m.ID_MISSAO
GROUP BY
  m.CD_MISSAO,
  m.NM_MISSAO,
  a.NM_AGENCIA,
  o.NM_ORGANIZACAO,
  m.VL_META_MISSAO
ORDER BY valor_confirmado DESC, percentual_meta DESC;
