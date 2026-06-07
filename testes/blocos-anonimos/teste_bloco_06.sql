-- teste_bloco_06.sql
-- Valida o bloco_06: promocao/revisao de tier e excecao para contribuicao reembolsada.

SET SERVEROUTPUT ON;

PROMPT Cenario de sucesso: valor 180 deve ficar no tier OPERATIVO.
UPDATE TB_CONTRIBUICAO
   SET STT_CONTRIBUICAO = 'CONFIRMADO',
       VL_CONTRIBUICAO = 180,
       TB_TIER_ID_TIER = 'TIER-APO'
 WHERE ID_CONTRIBUICAO = 'CONTRIB-008';
COMMIT;

@@../../blocos-anonimos/bloco_06.sql

PROMPT Evidencia apos sucesso:
SELECT c.ID_CONTRIBUICAO, c.VL_CONTRIBUICAO, c.STT_CONTRIBUICAO, t.NM_TIER
  FROM TB_CONTRIBUICAO c
  JOIN TB_TIER t ON t.ID_TIER = c.TB_TIER_ID_TIER
 WHERE c.ID_CONTRIBUICAO = 'CONTRIB-008';

PROMPT Cenario de excecao: contribuicao reembolsada nao pode ser promovida.
UPDATE TB_CONTRIBUICAO
   SET STT_CONTRIBUICAO = 'REEMBOLSADO'
 WHERE ID_CONTRIBUICAO = 'CONTRIB-008';
COMMIT;

@@../../blocos-anonimos/bloco_06.sql

UPDATE TB_CONTRIBUICAO
   SET STT_CONTRIBUICAO = 'CONFIRMADO',
       TB_TIER_ID_TIER = 'TIER-OPR'
 WHERE ID_CONTRIBUICAO = 'CONTRIB-008';
COMMIT;
