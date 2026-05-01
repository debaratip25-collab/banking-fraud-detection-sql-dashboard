-- High value
CREATE OR REPLACE VIEW v_high_value_txn AS
SELECT txn_id,'HIGH_AMT','HIGH','Txn > 50000'
FROM transactions
WHERE amount > 50000;

-- Velocity
CREATE OR REPLACE VIEW v_velocity AS
SELECT txn_id,'VELOCITY','MED','Multiple txns/day'
FROM transactions
WHERE account_id IN (
    SELECT account_id
    FROM transactions
    GROUP BY account_id, DATE(txn_ts)
    HAVING COUNT(*) >= 3
);

-- Insert flags
INSERT IGNORE INTO risk_events(txn_id,rule_code,severity,details)
SELECT * FROM v_high_value_txn;

INSERT IGNORE INTO risk_events(txn_id,rule_code,severity,details)
SELECT * FROM v_velocity;