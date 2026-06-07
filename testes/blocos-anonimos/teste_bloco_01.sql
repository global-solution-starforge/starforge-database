-- teste_bloco_01.sql
-- Valida o bloco_01: sucesso no cadastro e excecao por e-mail duplicado.

SET SERVEROUTPUT ON;

PROMPT Cenario de sucesso: removendo registros de teste anteriores.
DELETE FROM TB_CONTRIBUICAO WHERE ID_CONTRIBUICAO = 'CONTRIB-BLOCO-01';
DELETE FROM TB_USUARIO WHERE ID_USUARIO = 'USR-BLOCO-01';
COMMIT;

@@../../blocos-anonimos/bloco_01.sql

PROMPT Evidencia apos sucesso:
SELECT u.ID_USUARIO, u.EM_USUARIO, u.RL_USUARIO, c.ID_CONTRIBUICAO, c.STT_CONTRIBUICAO, c.VL_CONTRIBUICAO
  FROM TB_USUARIO u
  JOIN TB_CONTRIBUICAO c ON c.TB_USUARIO_ID_USUARIO = u.ID_USUARIO
 WHERE u.ID_USUARIO = 'USR-BLOCO-01';

PROMPT Cenario de excecao: executar novamente deve acusar e-mail existente.
@@../../blocos-anonimos/bloco_01.sql
