-- teste_bloco_04.sql
-- Valida o bloco_04: recalculo de status da missao e excecao para missao sem fases.

SET SERVEROUTPUT ON;

PROMPT Cenario de sucesso: fases completas devem manter/concluir a missao.
UPDATE TB_FASE_MISSAO
   SET PCT_FASE_MISSAO = 100,
       STT_FASE = 'CONCLUIDO'
 WHERE TB_MISSAO_ID_MISSAO = 'MIS-007';
COMMIT;

@@../../blocos-anonimos/bloco_04.sql

PROMPT Evidencia apos sucesso:
SELECT m.ID_MISSAO, m.CD_MISSAO, m.STT_MISSAO, ROUND(AVG(f.PCT_FASE_MISSAO), 2) AS progresso_medio
  FROM TB_MISSAO m
  JOIN TB_FASE_MISSAO f ON f.TB_MISSAO_ID_MISSAO = m.ID_MISSAO
 WHERE m.ID_MISSAO = 'MIS-007'
 GROUP BY m.ID_MISSAO, m.CD_MISSAO, m.STT_MISSAO;

PROMPT Cenario de excecao: remover fases em transacao deve acionar tratamento.
SAVEPOINT antes_sem_fases;
DELETE FROM TB_FASE_MISSAO WHERE TB_MISSAO_ID_MISSAO = 'MIS-007';
@@../../blocos-anonimos/bloco_04.sql

PROMPT As fases devem permanecer porque o bloco executou ROLLBACK.
SELECT COUNT(*) AS total_fases_mis_007
  FROM TB_FASE_MISSAO
 WHERE TB_MISSAO_ID_MISSAO = 'MIS-007';
