-- teste_relatorio_01.sql
-- Executa o relatorio de arrecadacao por missao.

PROMPT Resultado esperado: uma linha por missao, com valor confirmado e percentual da meta.
SELECT COUNT(*) AS total_missoes_esperadas FROM TB_MISSAO;

@@../../relatorios/relatorio_01.sql
