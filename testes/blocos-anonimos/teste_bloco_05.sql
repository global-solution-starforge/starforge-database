-- teste_bloco_05.sql
-- Valida o bloco_05: inativacao cadastral e excecao quando ha contribuicao confirmada.

SET SERVEROUTPUT ON;

PROMPT Cenario de sucesso: usuario ativo sem contribuicoes confirmadas deve ser inativado.
UPDATE TB_USUARIO SET STT_USUARIO = 'ATIVO' WHERE ID_USUARIO = 'USR-021';
UPDATE TB_CONTRIBUICAO
   SET STT_CONTRIBUICAO = 'REEMBOLSADO'
 WHERE ID_CONTRIBUICAO = 'CONTRIB-030';
COMMIT;

@@../../blocos-anonimos/bloco_05.sql

PROMPT Evidencia apos sucesso:
SELECT ID_USUARIO, NM_USUARIO, STT_USUARIO
  FROM TB_USUARIO
 WHERE ID_USUARIO = 'USR-021';

PROMPT Cenario de excecao: usuario ativo com contribuicao confirmada nao deve ser inativado.
UPDATE TB_USUARIO SET STT_USUARIO = 'ATIVO' WHERE ID_USUARIO = 'USR-021';
UPDATE TB_CONTRIBUICAO
   SET STT_CONTRIBUICAO = 'CONFIRMADO'
 WHERE ID_CONTRIBUICAO = 'CONTRIB-030';
COMMIT;

@@../../blocos-anonimos/bloco_05.sql

UPDATE TB_CONTRIBUICAO
   SET STT_CONTRIBUICAO = 'REEMBOLSADO'
 WHERE ID_CONTRIBUICAO = 'CONTRIB-030';
COMMIT;
