ALTER TABLE transactions
ADD CONSTRAINT chk_amount CHECK (amount > 0);

CREATE TABLE currency_ref (
    code CHAR(3) PRIMARY KEY
);

INSERT INTO currency_ref VALUES ('INR'), ('USD'), ('EUR');

ALTER TABLE transactions
ADD CONSTRAINT fk_currency
FOREIGN KEY (currency) REFERENCES currency_ref(code);
