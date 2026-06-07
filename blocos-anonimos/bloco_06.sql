-- bloco_06.sql
-- Objetivo: promover contribuicoes de alto valor para o tier adequado.

SET SERVEROUTPUT ON;

DECLARE
  v_id_contribuicao TB_CONTRIBUICAO.ID_CONTRIBUICAO%TYPE := 'CONTRIB-008';
  v_valor           TB_CONTRIBUICAO.VL_CONTRIBUICAO%TYPE;
  v_status          TB_CONTRIBUICAO.STT_CONTRIBUICAO%TYPE;
  v_id_tier_atual   TB_TIER.ID_TIER%TYPE;
  v_id_tier_novo    TB_TIER.ID_TIER%TYPE;
  v_nm_tier_novo    TB_TIER.NM_TIER%TYPE;
  v_contador        NUMBER := 0;
  e_contrib_reembolsada EXCEPTION;
BEGIN
  SELECT VL_CONTRIBUICAO, STT_CONTRIBUICAO, TB_TIER_ID_TIER
    INTO v_valor, v_status, v_id_tier_atual
    FROM TB_CONTRIBUICAO
   WHERE ID_CONTRIBUICAO = v_id_contribuicao;

  IF v_status = 'REEMBOLSADO' THEN
    RAISE e_contrib_reembolsada;
  END IF;

  CASE
    WHEN v_valor >= 500 THEN v_nm_tier_novo := 'COMANDANTE';
    WHEN v_valor >= 150 THEN v_nm_tier_novo := 'OPERATIVO';
    ELSE v_nm_tier_novo := 'APOIADOR';
  END CASE;

  SELECT ID_TIER
    INTO v_id_tier_novo
    FROM TB_TIER
   WHERE NM_TIER = v_nm_tier_novo;

  LOOP
    v_contador := v_contador + 1;
    EXIT WHEN v_contador >= 1;
  END LOOP;

  IF v_id_tier_atual <> v_id_tier_novo THEN
    UPDATE TB_CONTRIBUICAO
       SET TB_TIER_ID_TIER = v_id_tier_novo
     WHERE ID_CONTRIBUICAO = v_id_contribuicao;
    DBMS_OUTPUT.PUT_LINE('Sucesso: contribuicao promovida para ' || v_nm_tier_novo);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Contribuicao ja esta no tier correto: ' || v_nm_tier_novo);
  END IF;

  DELETE FROM TB_HANGAR
   WHERE STATUS_NAVE_HANGAR = 'PENDENTE'
     AND TB_CONTRIB_ID_CONTRIB = v_id_contribuicao
     AND v_nm_tier_novo <> 'COMANDANTE';

  COMMIT;
EXCEPTION
  WHEN e_contrib_reembolsada THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: contribuicao reembolsada nao pode ser promovida.');
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: contribuicao ou tier nao encontrado.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada inesperada: ' || SQLERRM);
END;
/
