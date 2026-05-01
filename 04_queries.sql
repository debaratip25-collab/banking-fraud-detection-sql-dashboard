-- All transactions
SELECT * FROM transactions;

-- Customer-wise summary
SELECT c.full_name, SUM(t.amount) total_amount
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.full_name;

-- Account balances
SELECT account_id,
SUM(CASE 
    WHEN txn_type='credit' THEN amount
    ELSE -amount
END) balance
FROM transactions
GROUP BY account_id;

-- Daily volume
SELECT DATE(txn_ts) day, COUNT(*) txn_count, SUM(amount) total
FROM transactions
GROUP BY day;