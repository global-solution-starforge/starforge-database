-- relatorio_04.sql
-- Objetivo: listar naves desbloqueadas no hangar e seus comandantes apoiadores.
-- Instrucao: executar apos dados/carga_100_registros.sql.

SELECT
  h.ID_HANGAR AS id_hangar,
  h.STATUS_NAVE_HANGAR AS status_hangar,
  h.DT_DESBLQ_NAVE_HANGAR AS data_desbloqueio,
  h.NM_GRAVADO_HANGAR AS nome_gravado,
  n.NM_NAVE AS nave,
  n.CLS_NAVE AS classe_nave,
  m.CD_MISSAO AS codigo_missao,
  u.NM_USUARIO AS usuario,
  c.VL_CONTRIBUICAO AS valor_contribuicao
FROM TB_HANGAR h
JOIN TB_NAVE n ON n.ID_NAVE = h.TB_NAVE_ID_NAVE
JOIN TB_MISSAO m ON m.ID_MISSAO = n.TB_MISSAO_ID_MISSAO
JOIN TB_CONTRIBUICAO c ON c.ID_CONTRIBUICAO = h.TB_CONTRIB_ID_CONTRIB
JOIN TB_USUARIO u ON u.ID_USUARIO = c.TB_USUARIO_ID_USUARIO
ORDER BY h.STATUS_NAVE_HANGAR, h.DT_DESBLQ_NAVE_HANGAR DESC, h.ID_HANGAR;
