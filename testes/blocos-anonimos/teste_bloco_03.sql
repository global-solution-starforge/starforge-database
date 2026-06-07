-- teste_bloco_03.sql
-- Valida o bloco_03: reembolso de missao falha e excecao para missao ativa.

SET SERVEROUTPUT ON;

PROMPT Cenario de sucesso: recolocando uma contribuicao da missao falha como confirmada.
UPDATE TB_MISSAO SET STT_MISSAO = 'FALHOU' WHERE ID_MISSAO = 'MIS-010';
UPDATE TB_CONTRIBUICAO
   SET STT_CONTRIBUICAO = 'CONFIRMADO'
 WHERE ID_CONTRIBUICAO = 'CONTRIB-028';
COMMIT;

@@../../blocos-anonimos/bloco_03.sql

PROMPT Evidencia apos sucesso:
SELECT ID_CONTRIBUICAO, STT_CONTRIBUICAO
  FROM TB_CONTRIBUICAO
 WHERE TB_MISSAO_ID_MISSAO = 'MIS-010'
 ORDER BY ID_CONTRIBUICAO;

PROMPT Cenario de excecao: missao nao falha nao deve ser reembolsada.
UPDATE TB_MISSAO SET STT_MISSAO = 'ATIVA' WHERE ID_MISSAO = 'MIS-010';
COMMIT;

@@../../blocos-anonimos/bloco_03.sql

UPDATE TB_MISSAO SET STT_MISSAO = 'FALHOU' WHERE ID_MISSAO = 'MIS-010';
COMMIT;
