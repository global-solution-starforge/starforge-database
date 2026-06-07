-- bloco_02.sql
-- Objetivo: confirmar pagamento pendente e desbloquear a nave no hangar quando
-- a contribuicao pertence ao tier COMANDANTE.

SET SERVEROUTPUT ON;

DECLARE
  v_id_contribuicao TB_CONTRIBUICAO.ID_CONTRIBUICAO%TYPE := 'CONTRIB-001';
  v_id_hangar       TB_HANGAR.ID_HANGAR%TYPE := 'HGR-BLOCO-02';
  v_valor           TB_CONTRIBUICAO.VL_CONTRIBUICAO%TYPE;
  v_status          TB_CONTRIBUICAO.STT_CONTRIBUICAO%TYPE;
  v_id_missao       TB_MISSAO.ID_MISSAO%TYPE;
  v_id_nave         TB_NAVE.ID_NAVE%TYPE;
  v_nm_usuario      TB_USUARIO.NM_USUARIO%TYPE;
  v_nm_tier         TB_TIER.NM_TIER%TYPE;
  v_qtd_hangar      NUMBER;
  e_pagamento_invalido EXCEPTION;
BEGIN
  SELECT c.VL_CONTRIBUICAO, c.STT_CONTRIBUICAO, c.TB_MISSAO_ID_MISSAO,
         u.NM_USUARIO, t.NM_TIER
    INTO v_valor, v_status, v_id_missao, v_nm_usuario, v_nm_tier
    FROM TB_CONTRIBUICAO c
    JOIN TB_USUARIO u ON u.ID_USUARIO = c.TB_USUARIO_ID_USUARIO
    JOIN TB_TIER t ON t.ID_TIER = c.TB_TIER_ID_TIER
   WHERE c.ID_CONTRIBUICAO = v_id_contribuicao;

  IF v_status = 'REEMBOLSADO' THEN
    RAISE e_pagamento_invalido;
  ELSIF v_status = 'CONFIRMADO' THEN
    DBMS_OUTPUT.PUT_LINE('Contribuicao ja estava confirmada; hangar sera revisado.');
  ELSE
    UPDATE TB_CONTRIBUICAO
       SET STT_CONTRIBUICAO = 'CONFIRMADO'
     WHERE ID_CONTRIBUICAO = v_id_contribuicao;
  END IF;

  SELECT ID_NAVE
    INTO v_id_nave
    FROM TB_NAVE
   WHERE TB_MISSAO_ID_MISSAO = v_id_missao;

  IF v_nm_tier = 'COMANDANTE' AND v_valor >= 500 THEN
    SELECT COUNT(*)
      INTO v_qtd_hangar
      FROM TB_HANGAR
     WHERE TB_CONTRIB_ID_CONTRIB = v_id_contribuicao;

    IF v_qtd_hangar = 0 THEN
      INSERT INTO TB_HANGAR (
        ID_HANGAR, DT_DESBLQ_NAVE_HANGAR, STATUS_NAVE_HANGAR,
        NM_GRAVADO_HANGAR, TB_NAVE_ID_NAVE, TB_CONTRIB_ID_CONTRIB
      ) VALUES (
        v_id_hangar, SYSDATE, 'DESBLOQUEADA',
        SUBSTR(v_nm_usuario, 1, 100), v_id_nave, v_id_contribuicao
      );
    ELSE
      UPDATE TB_HANGAR
         SET DT_DESBLQ_NAVE_HANGAR = NVL(DT_DESBLQ_NAVE_HANGAR, SYSDATE),
             STATUS_NAVE_HANGAR = 'DESBLOQUEADA',
             NM_GRAVADO_HANGAR = SUBSTR(v_nm_usuario, 1, 100)
       WHERE TB_CONTRIB_ID_CONTRIB = v_id_contribuicao;
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('Tier sem direito a desbloqueio de nave.');
  END IF;

  FOR fase IN (
    SELECT ID_FASE_MISSAO, PCT_FASE_MISSAO
      FROM TB_FASE_MISSAO
     WHERE TB_MISSAO_ID_MISSAO = v_id_missao
       AND STT_FASE = 'EM ANDAMENTO'
  ) LOOP
    UPDATE TB_FASE_MISSAO
       SET PCT_FASE_MISSAO = LEAST(100, fase.PCT_FASE_MISSAO + 5)
     WHERE ID_FASE_MISSAO = fase.ID_FASE_MISSAO;
  END LOOP;

  DELETE FROM TB_HANGAR h
   WHERE h.STATUS_NAVE_HANGAR = 'PENDENTE'
     AND EXISTS (
       SELECT 1
         FROM TB_CONTRIBUICAO c
        WHERE c.ID_CONTRIBUICAO = h.TB_CONTRIB_ID_CONTRIB
          AND c.STT_CONTRIBUICAO = 'REEMBOLSADO'
     );

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Sucesso: pagamento confirmado e hangar atualizado.');
EXCEPTION
  WHEN e_pagamento_invalido THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: contribuicao reembolsada nao pode ser confirmada.');
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: contribuicao ou nave da missao nao encontrada.');
  WHEN TOO_MANY_ROWS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada: mais de um registro retornado para consulta unica.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Excecao tratada inesperada: ' || SQLERRM);
END;
/
