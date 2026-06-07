-- teste_relatorio_05.sql
-- Executa o relatorio de desempenho por agencia.

PROMPT Resultado esperado: uma linha por agencia que possui missoes vinculadas.
SELECT COUNT(DISTINCT TB_AGENCIA_ID_AGENCIA) AS agencias_com_missoes FROM TB_MISSAO;

@@../../relatorios/relatorio_05.sql
