-- schema.sql
CREATE TABLE bank_cards (
    card_id SERIAL PRIMARY KEY,
    bank_name VARCHAR(255) NOT NULL,
    bank_code VARCHAR(50),
    card_type VARCHAR(10) NOT NULL CHECK (card_type IN ('debit', 'credit', 'prepaid')),
    card_name VARCHAR(255) NOT NULL,
    card_network VARCHAR(50) NOT NULL CHECK (card_network IN ('visa', 'mastercard', 'plux', 'food')),
    annual_fee DECIMAL(10,2) DEFAULT 0.00,
    foreign_transaction_fee DECIMAL(5,2) DEFAULT 0.00,
    rewards_program TEXT,
    petrol_benefits TEXT,
    network_pump TEXT,
    features TEXT,
    front_image BYTEA,
    back_image BYTEA,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(50)
);

CREATE TABLE products_bank_cards (
    card_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    offer_description TEXT,
    PRIMARY KEY (card_id, product_id),
    FOREIGN KEY (card_id) REFERENCES bank_cards(card_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

INSERT INTO bank_cards (bank_name, bank_code, card_type, card_name, card_network, annual_fee, rewards_program, petrol_benefits, features) VALUES
    ('Chase', 'CHASE001', 'credit', 'Chase Sapphire', 'visa', 95.00, '2x travel, 3x dining', '5% off at Shell', 'Lounge access'),
    ('American Express', 'AMEX001', 'credit', 'Amex Platinum', 'mastercard', 550.00, '5x points', NULL, 'EMI options');

INSERT INTO products (product_name, category) VALUES
    ('iPhone', 'electronics'),
    ('flight tickets', 'travel');

INSERT INTO products_bank_cards (card_id, product_id, offer_description) VALUES
    (1, 2, '5% cashback on travel'),
    (2, 1, '10% off electronics');