DELIMITER //

CREATE PROCEDURE registrar_compra(
    IN p_id_ingresso INT,
    IN p_id_compra INT,
    IN p_quantidade INT
)
BEGIN
    DECLARE v_data_evento DATETIME;

    SELECT e.data_hora INTO v_data_evento
    FROM ingresso i
    JOIN evento e ON i.fk_id_evento = e.id_evento
    WHERE i.id_ingresso = p_id_ingresso;

    IF DATE(v_data_evento) < CURDATE() THEN
        delete from ingresso_compra where fk_id_compra = p_id_compra
        delete from compra where id_compra = p_id_compra
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERRO PROCEDURE - Não é possível comprar ingressos para eventos passados';
    END IF;

    INSERT INTO ingresso_compra (fk_id_ingresso, fk_id_compra, quantidade)
    VALUES (p_id_ingresso, p_id_compra, p_quantidade);
END//

DELIMITER ;