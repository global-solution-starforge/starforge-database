-- bloco_05.sql
-- Objetivo: inativar usuarios sem contribuicoes confirmadas e limpar pendencias antigas.

SET SERVEROUTPUT ON;

DECLARE
  v_id_usuario         TB_USUARIO.ID_USUARIO%TYPE := 'USR-021';
  v_nome_usuario       TB_USUARIO.NM_USUARIO%TYPE;
  v_status_usuario     TB_USUARIO.STT_USUARIO%TYPE;
  v_qtd_confirmadas    NUMBER;
  v_qtd_pendentes      NUMBER;
  e_usuario_sem_acao   EXCEPTION;
BEGIN
  SELECT NM_USUARIO, STT_USUARIO
    INTO v_nome_usuario, v_status_usuario
    FROM TB_USUARIO
   WHERE ID_USUARIO = v_id_usuario;

  SELECT COUNT(*)
    INTO v_qtd_confirmadas
    FROM TB_CONTRIBUICAO
   WHERE TB_USUARIO_ID_USUARIO = v_id_usuario
     AND STT_CONTRIBUICAO = 'CONFIRMADO';

  SELECT COUNT(*)
    INTO v_qtd_pendentes
    FROM TB_CONTRIBUICAO
   WHERE TB_USUARIO_ID_USUARIO = v_id_usuario
     AND STT_CONTRIBUICAO = 'PENDENTE';

  IF v_qtd_confirmadas = 0 AND v_status_usuario = 'ATIVO' THEN
    UPDATE TB_USUARIO
       SET STT_USUARIO = 'INATIVO'
     WHERE ID_USUARIO = v_id_usuario;
  ELSIF v_status_usuario = 'INATIVO' THEN
    DBMS_OUTPUT.PUT_LINE('Usuario ja estava inativo.');
  ELSE
    RAISE e_usuario_sem_acao;
  END IF;

  WHILE v_qtd_pendentes > 0 LOOP
    DELETE FROM TB_CONTRIBUICAO
     WHERE ID_CONTRIBUICAO = (
       SELECT MIN(ID_CONTRIBUICAO)
         FROM TB_CONTRIBUICAO
        WHERE TB_USUARIO_ID_USUARIO = v_id_usuario
          AND STT_CONTRIBUICAO = 'PENDENTE'
     );

    SELECT COUNT(*)
      INTO v_qtd_pendentes
      FROM TB_CONTRIBUICAO
     WHERE TB_USUARIO_ID_USUARIO = v_id_usuario
       AND STT_CONTRIBUICAO = 'PENDENTE';
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Sucesso: revisao cadastral concluida para ' || v_nome_usuario);
  COMMIT;
EXCEPTION
  WHEN e_usuario_sem_acao THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: usuario ativo possui contribuicoes confirmadas.');
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: usuario nao encontrado.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada inesperada: ' || SQLERRM);
END;
/
