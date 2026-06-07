-- bloco_01.sql
-- Objetivo: cadastrar um novo apoiador e registrar uma contribuicao inicial para
-- uma missao ativa. Executar apos a carga de dados.

SET SERVEROUTPUT ON;

DECLARE
  v_id_usuario        TB_USUARIO.ID_USUARIO%TYPE := 'USR-BLOCO-01';
  v_nome_usuario      TB_USUARIO.NM_USUARIO%TYPE := 'Teste Bloco Um';
  v_email_usuario     TB_USUARIO.EM_USUARIO%TYPE := 'teste.bloco01@starforge.local';
  v_hash_usuario      TB_USUARIO.SEN_HASH_USUARIO%TYPE := 'hash_teste_bloco_01';
  v_role_usuario      TB_USUARIO.RL_USUARIO%TYPE := 'USER';
  v_id_contribuicao   TB_CONTRIBUICAO.ID_CONTRIBUICAO%TYPE := 'CONTRIB-BLOCO-01';
  v_id_missao         TB_MISSAO.ID_MISSAO%TYPE;
  v_cd_missao         TB_MISSAO.CD_MISSAO%TYPE;
  v_id_tier           TB_TIER.ID_TIER%TYPE;
  v_vl_min_tier       TB_TIER.VL_MIN_TIER%TYPE;
  v_qtd_email         NUMBER;
  v_qtd_contribuicoes NUMBER;
  e_email_ja_existe   EXCEPTION;
BEGIN
  SELECT COUNT(*)
    INTO v_qtd_email
    FROM TB_USUARIO
   WHERE EM_USUARIO = v_email_usuario;

  IF v_qtd_email > 0 THEN
    RAISE e_email_ja_existe;
  END IF;

  SELECT ID_TIER, VL_MIN_TIER
    INTO v_id_tier, v_vl_min_tier
    FROM TB_TIER
   WHERE NM_TIER = 'APOIADOR';

  SELECT ID_MISSAO, CD_MISSAO
    INTO v_id_missao, v_cd_missao
    FROM TB_MISSAO
   WHERE STT_MISSAO = 'ATIVA'
     AND CD_MISSAO = 'AMZ-01';

  INSERT INTO TB_USUARIO (
    ID_USUARIO, NM_USUARIO, EM_USUARIO, SEN_HASH_USUARIO, STT_USUARIO, RL_USUARIO, DT_CADST_USUARIO
  ) VALUES (
    v_id_usuario, v_nome_usuario, v_email_usuario, v_hash_usuario, 'ATIVO', v_role_usuario, SYSDATE
  );

  INSERT INTO TB_CONTRIBUICAO (
    ID_CONTRIBUICAO, VL_CONTRIBUICAO, STT_CONTRIBUICAO, MTD_PGT_CONTRIBUICAO,
    DT_CONTRIBUICAO, TB_USUARIO_ID_USUARIO, TB_MISSAO_ID_MISSAO, TB_TIER_ID_TIER
  ) VALUES (
    v_id_contribuicao, v_vl_min_tier, 'PENDENTE', 'PIX',
    SYSDATE, v_id_usuario, v_id_missao, v_id_tier
  );

  FOR fase IN (
    SELECT ID_FASE_MISSAO, STT_FASE
      FROM TB_FASE_MISSAO
     WHERE TB_MISSAO_ID_MISSAO = v_id_missao
     ORDER BY NMR_FASE_MISSAO
  ) LOOP
    IF fase.STT_FASE = 'AGUARDANDO' THEN
      UPDATE TB_FASE_MISSAO
         SET STT_FASE = 'EM ANDAMENTO',
             PCT_FASE_MISSAO = 1
       WHERE ID_FASE_MISSAO = fase.ID_FASE_MISSAO;
      EXIT;
    END IF;
  END LOOP;

  DELETE FROM TB_CONTRIBUICAO
   WHERE TB_USUARIO_ID_USUARIO = v_id_usuario
     AND STT_CONTRIBUICAO = 'PENDENTE'
     AND DT_CONTRIBUICAO < SYSDATE - 90;

  SELECT COUNT(*)
    INTO v_qtd_contribuicoes
    FROM TB_CONTRIBUICAO
   WHERE TB_USUARIO_ID_USUARIO = v_id_usuario;

  IF v_qtd_contribuicoes = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Sucesso: usuario criado e contribuicao pendente registrada para ' || v_cd_missao);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Atencao: quantidade inesperada de contribuicoes para o novo usuario.');
  END IF;

  COMMIT;
EXCEPTION
  WHEN e_email_ja_existe THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: ja existe usuario com o e-mail informado.');
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: missao ativa ou tier APOIADOR nao encontrado.');
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: chave ou e-mail duplicado.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada inesperada: ' || SQLERRM);
END;
/
