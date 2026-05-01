-- Risky accounts
CREATE OR REPLACE VIEW v_risky_accounts AS
SELECT account_id, COUNT(*) flags
FROM risk_events re
JOIN transactions t ON re.txn_id = t.txn_id
GROUP BY account_id
ORDER BY flags DESC;

-- Running balance
CREATE OR REPLACE VIEW v_running_balance AS
SELECT 
    account_id,
    txn_id,
    txn_ts,
    SUM(
        CASE 
            WHEN txn_type IN ('credit') THEN amount
            ELSE -amount
        END
    ) OVER (PARTITION BY account_id ORDER BY txn_ts) AS balance
FROM transactions;