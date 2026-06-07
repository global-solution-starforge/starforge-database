-- bloco_03.sql
-- Objetivo: processar reembolsos de uma missao com falha e remover pendencias de hangar.

SET SERVEROUTPUT ON;

DECLARE
  v_id_missao       TB_MISSAO.ID_MISSAO%TYPE := 'MIS-010';
  v_cd_missao       TB_MISSAO.CD_MISSAO%TYPE;
  v_status_missao   TB_MISSAO.STT_MISSAO%TYPE;
  v_total_processado NUMBER := 0;
  v_total_reembolsado NUMBER;
  e_missao_nao_falhou EXCEPTION;
BEGIN
  SELECT CD_MISSAO, STT_MISSAO
    INTO v_cd_missao, v_status_missao
    FROM TB_MISSAO
   WHERE ID_MISSAO = v_id_missao;

  IF v_status_missao <> 'FALHOU' THEN
    RAISE e_missao_nao_falhou;
  END IF;

  FOR contribuicao IN (
    SELECT ID_CONTRIBUICAO, STT_CONTRIBUICAO
      FROM TB_CONTRIBUICAO
     WHERE TB_MISSAO_ID_MISSAO = v_id_missao
  ) LOOP
    IF contribuicao.STT_CONTRIBUICAO <> 'REEMBOLSADO' THEN
      UPDATE TB_CONTRIBUICAO
         SET STT_CONTRIBUICAO = 'REEMBOLSADO'
       WHERE ID_CONTRIBUICAO = contribuicao.ID_CONTRIBUICAO;
      v_total_processado := v_total_processado + 1;
    ELSE
      v_total_processado := v_total_processado;
    END IF;
  END LOOP;

  DELETE FROM TB_HANGAR
   WHERE STATUS_NAVE_HANGAR = 'PENDENTE'
     AND TB_CONTRIB_ID_CONTRIB IN (
       SELECT ID_CONTRIBUICAO
         FROM TB_CONTRIBUICAO
        WHERE TB_MISSAO_ID_MISSAO = v_id_missao
          AND STT_CONTRIBUICAO = 'REEMBOLSADO'
     );

  SELECT COUNT(*)
    INTO v_total_reembolsado
    FROM TB_CONTRIBUICAO
   WHERE TB_MISSAO_ID_MISSAO = v_id_missao
     AND STT_CONTRIBUICAO = 'REEMBOLSADO';

  IF v_total_reembolsado > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Sucesso: reembolsos revisados para ' || v_cd_missao ||
                         '. Atualizados agora: ' || v_total_processado);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Atencao: nenhuma contribuicao encontrada para reembolso.');
  END IF;

  COMMIT;
EXCEPTION
  WHEN e_missao_nao_falhou THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: somente missoes com status FALHOU podem ser reembolsadas.');
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: missao informada nao existe.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada inesperada: ' || SQLERRM);
END;
/
