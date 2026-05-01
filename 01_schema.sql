CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY,
    full_name VARCHAR(120),
    dob DATE,
    kyc_status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(80),
    city VARCHAR(60),
    ifsc VARCHAR(20)
);

CREATE TABLE accounts (
    account_id BIGINT PRIMARY KEY,
    customer_id BIGINT,
    account_type VARCHAR(20),
    status VARCHAR(20),
    opened_at TIMESTAMP,
    branch_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE merchants (
    merchant_id BIGINT PRIMARY KEY,
    name VARCHAR(120),
    category VARCHAR(40),
    country CHAR(2)
);

CREATE TABLE transactions (
    txn_id BIGINT PRIMARY KEY,
    account_id BIGINT,
    amount DECIMAL(14,2),
    currency CHAR(3),
    txn_type VARCHAR(20),
    channel VARCHAR(20),
    merchant_id BIGINT NULL,
    geo_lat DECIMAL(9,6),
    geo_lon DECIMAL(9,6),
    txn_ts TIMESTAMP,
    device_id VARCHAR(64),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id)
);

CREATE TABLE risk_events (
    risk_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    txn_id BIGINT,
    rule_code VARCHAR(20),
    severity VARCHAR(10),
    details TEXT,
    flagged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (txn_id) REFERENCES transactions(txn_id)
);

CREATE INDEX idx_txn_account_ts ON transactions(account_id, txn_ts);
CREATE INDEX idx_txn_amount ON transactions(amount);