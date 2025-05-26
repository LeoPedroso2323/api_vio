CREATE TABLE IF NOT EXISTS resumo_evento (
    id_evento INT PRIMARY KEY,
    total_ingressos INT DEFAULT 0
);


DELIMITER //

CREATE TRIGGER atualizar_total_ingressos
AFTER INSERT ON ingresso_compra
FOR EACH ROW
BEGIN
    DECLARE v_id_evento INT;

    -- Descobrir o id do evento referente ao ingresso comprado
    SELECT fk_id_evento INTO v_id_evento
    FROM ingresso
    WHERE id_ingresso = NEW.fk_id_ingresso;

    -- Verificar se o evento já está na tabela resumo_evento
    IF EXISTS (SELECT 1 FROM resumo_evento WHERE id_evento = v_id_evento) THEN
        -- Atualizar total_ingressos somando a nova quantidade
        UPDATE resumo_evento
        SET total_ingressos = total_ingressos + NEW.quantidade
        WHERE id_evento = v_id_evento;
    ELSE
        -- Inserir novo registro com a quantidade da compra
        INSERT INTO resumo_evento (id_evento, total_ingressos)
        VALUES (v_id_evento, NEW.quantidade);
    END IF;
END;
//

DELIMITER ;

-- UPDATE
DELIMITER //

CREATE TRIGGER atualizar_total_ingressos_update
AFTER UPDATE ON ingresso_compra
FOR EACH ROW
BEGIN
    DECLARE v_id_evento_old INT;
    DECLARE v_id_evento_new INT;

    -- Pega o evento antigo
    SELECT fk_id_evento INTO v_id_evento_old FROM ingresso WHERE id_ingresso = OLD.fk_id_ingresso;

    -- Pega o evento novo
    SELECT fk_id_evento INTO v_id_evento_new FROM ingresso WHERE id_ingresso = NEW.fk_id_ingresso;

    -- Se o evento for o mesmo, ajusta a diferença de quantidade
    IF v_id_evento_old = v_id_evento_new THEN
        UPDATE resumo_evento
        SET total_ingressos = total_ingressos - OLD.quantidade + NEW.quantidade
        WHERE id_evento = v_id_evento_new;

    ELSE
        -- Evento mudou: desconta quantidade antiga do evento antigo
        UPDATE resumo_evento
        SET total_ingressos = total_ingressos - OLD.quantidade
        WHERE id_evento = v_id_evento_old;

        -- Soma quantidade nova no evento novo
        IF EXISTS (SELECT 1 FROM resumo_evento WHERE id_evento = v_id_evento_new) THEN
            UPDATE resumo_evento
            SET total_ingressos = total_ingressos + NEW.quantidade
            WHERE id_evento = v_id_evento_new;
        ELSE
            INSERT INTO resumo_evento (id_evento, total_ingressos)
            VALUES (v_id_evento_new, NEW.quantidade);
        END IF;
    END IF;
END;
//

DELIMITER ;

-- DELETE
DELIMITER //

CREATE TRIGGER atualizar_total_ingressos_delete
AFTER DELETE ON ingresso_compra
FOR EACH ROW
BEGIN
    DECLARE v_id_evento INT;

    SELECT fk_id_evento INTO v_id_evento
    FROM ingresso
    WHERE id_ingresso = OLD.fk_id_ingresso;

    UPDATE resumo_evento
    SET total_ingressos = total_ingressos - OLD.quantidade
    WHERE id_evento = v_id_evento;
END;
//

DELIMITER ;
