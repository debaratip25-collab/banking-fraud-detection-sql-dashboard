DELIMITER //

CREATE TRIGGER trg_flag_insert
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.amount >= 200000 THEN
        INSERT INTO risk_events(txn_id,rule_code,severity,details)
        VALUES (NEW.txn_id,'AMT_THRESH','HIGH','Txn >= 200000');
    END IF;
END //

DELIMITER ;
