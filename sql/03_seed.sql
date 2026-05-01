CREATE TABLE seq_100 (
    n INT PRIMARY KEY
);

INSERT INTO seq_100 (n)
VALUES 
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
(41),(42),(43),(44),(45),(46),(47),(48),(49),(50),
(51),(52),(53),(54),(55),(56),(57),(58),(59),(60),
(61),(62),(63),(64),(65),(66),(67),(68),(69),(70),
(71),(72),(73),(74),(75),(76),(77),(78),(79),(80),
(81),(82),(83),(84),(85),(86),(87),(88),(89),(90),
(91),(92),(93),(94),(95),(96),(97),(98),(99),(100);

-- Customers (50)
INSERT INTO customers
SELECT 
    1000 + n,
    CONCAT(
        ELT(1 + FLOOR(RAND(n)*5),'Asha','Rohit','Priya','Amit','Neha'),
        ' ',
        ELT(1 + FLOOR(RAND(n*2)*5),'Sharma','Verma','Patel','Singh','Gupta')
    ),
    DATE_SUB(CURDATE(), INTERVAL (20 + FLOOR(RAND(n)*20)) YEAR),
    ELT(1 + FLOOR(RAND(n*3)*2),'VERIFIED','PENDING'),
    NOW()
FROM seq_100 WHERE n <= 50;

-- Branches
INSERT INTO branches VALUES
(101,'Mumbai Central','Mumbai','HDFC000101'),
(102,'Delhi Main','Delhi','HDFC000102'),
(103,'Bangalore Hub','Bangalore','HDFC000103'),
(104,'Kolkata Branch','Kolkata','HDFC000104');

-- Accounts
INSERT INTO accounts
SELECT
    50000 + n,
    1000 + n,
    ELT(1 + FLOOR(RAND(n)*2),'SAVINGS','CURRENT'),
    'ACTIVE',
    NOW(),
    101 + FLOOR(RAND(n)*4)
FROM seq_100 WHERE n <= 50;

-- Transactions (200+)
INSERT INTO transactions (
    txn_id, account_id, amount, currency, txn_type, channel,
    merchant_id, geo_lat, geo_lon, txn_ts, device_id
)
SELECT
    900000 + (@rownum := @rownum + 1) AS txn_id,
    
    50000 + FLOOR(RAND(a.n*b.n)*50),
    
    CASE
        WHEN RAND(a.n*b.n) < 0.7 THEN ROUND(RAND()*5000,2)
        WHEN RAND(a.n*b.n) < 0.9 THEN ROUND(5000 + RAND()*20000,2)
        ELSE ROUND(50000 + RAND()*100000,2)
    END,
    
    'INR',
    
    ELT(1 + FLOOR(RAND()*4),'debit','credit','transfer','atm'),
    ELT(1 + FLOOR(RAND()*4),'upi','atm','pos','netbanking'),
    
    NULL,
    
    CASE WHEN RAND() < 0.5 THEN 19.07 ELSE 28.61 END,
    CASE WHEN RAND() < 0.5 THEN 72.87 ELSE 77.20 END,
    
    NOW() - INTERVAL FLOOR(RAND()*30) DAY,
    
    CONCAT('dev', FLOOR(RAND()*1000))

FROM seq_100 a
JOIN seq_100 b
JOIN (SELECT @rownum := 0) r
LIMIT 220;
