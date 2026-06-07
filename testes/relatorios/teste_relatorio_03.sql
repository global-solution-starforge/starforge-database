-- teste_relatorio_03.sql
-- Executa o relatorio de progresso das fases por missao.

PROMPT Resultado esperado: uma linha por missao com fases cadastradas.
SELECT COUNT(DISTINCT TB_MISSAO_ID_MISSAO) AS missoes_com_fases FROM TB_FASE_MISSAO;

@@../../relatorios/relatorio_03.sql
