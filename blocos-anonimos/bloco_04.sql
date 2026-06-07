-- bloco_04.sql
-- Objetivo: recalcular o status da missao conforme o percentual medio das fases.

SET SERVEROUTPUT ON;

DECLARE
  v_id_missao       TB_MISSAO.ID_MISSAO%TYPE := 'MIS-007';
  v_cd_missao       TB_MISSAO.CD_MISSAO%TYPE;
  v_status_atual    TB_MISSAO.STT_MISSAO%TYPE;
  v_media_fases     NUMBER;
  v_qtd_fases       NUMBER;
  v_novo_status     TB_MISSAO.STT_MISSAO%TYPE;
  e_sem_fases       EXCEPTION;
BEGIN
  SELECT CD_MISSAO, STT_MISSAO
    INTO v_cd_missao, v_status_atual
    FROM TB_MISSAO
   WHERE ID_MISSAO = v_id_missao;

  SELECT COUNT(*), AVG(PCT_FASE_MISSAO)
    INTO v_qtd_fases, v_media_fases
    FROM TB_FASE_MISSAO
   WHERE TB_MISSAO_ID_MISSAO = v_id_missao;

  IF v_qtd_fases = 0 THEN
    RAISE e_sem_fases;
  ELSIF v_media_fases = 100 THEN
    v_novo_status := 'CONCLUIDA';
  ELSIF v_media_fases >= 20 THEN
    v_novo_status := 'ATIVA';
  ELSE
    v_novo_status := 'CRIACAO';
  END IF;

  FOR fase IN (
    SELECT ID_FASE_MISSAO, PCT_FASE_MISSAO
      FROM TB_FASE_MISSAO
     WHERE TB_MISSAO_ID_MISSAO = v_id_missao
  ) LOOP
    IF fase.PCT_FASE_MISSAO = 100 THEN
      UPDATE TB_FASE_MISSAO
         SET STT_FASE = 'CONCLUIDO'
       WHERE ID_FASE_MISSAO = fase.ID_FASE_MISSAO;
    END IF;
  END LOOP;

  UPDATE TB_MISSAO
     SET STT_MISSAO = v_novo_status
   WHERE ID_MISSAO = v_id_missao;

  DELETE FROM TB_CONTRIBUICAO
   WHERE TB_MISSAO_ID_MISSAO = v_id_missao
     AND STT_CONTRIBUICAO = 'PENDENTE'
     AND DT_CONTRIBUICAO < SYSDATE - 180;

  DBMS_OUTPUT.PUT_LINE('Sucesso: missao ' || v_cd_missao || ' alterada de ' ||
                       v_status_atual || ' para ' || v_novo_status);
  COMMIT;
EXCEPTION
  WHEN e_sem_fases THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: missao sem fases cadastradas.');
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: missao nao encontrada.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada inesperada: ' || SQLERRM);
END;
/
