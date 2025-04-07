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
    front_image_url VARCHAR(255),  -- Changed from BYTEA to VARCHAR for URL
    back_image_url VARCHAR(255),   -- Changed from BYTEA to VARCHAR for URL
    created_at TIMESTAMP DEFAULT NOW()
);

-- Products and products_bank_cards tables remain unchanged
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



-- DUmmy data 


-- Insert into bank_cards table (25 entries with image URLs)
INSERT INTO bank_cards (bank_name, bank_code, card_type, card_name, card_network, annual_fee, foreign_transaction_fee, rewards_program, petrol_benefits, network_pump, features, front_image_url, back_image_url) VALUES
    ('Chase', 'CHASE001', 'credit', 'Chase Sapphire Preferred', 'visa', 95.00, 0.00, '2x travel, 3x dining', '5% off at Shell', 'Shell', 'Lounge access', 'https://example.com/chase_sapphire_front.jpg', 'https://example.com/chase_sapphire_back.jpg'),
    ('Chase', 'CHASE002', 'debit', 'Chase Freedom Debit', 'visa', 0.00, 1.50, NULL, '2% cashback at Exxon', 'Exxon', 'ATM fee waiver', 'https://example.com/chase_freedom_debit_front.jpg', 'https://example.com/chase_freedom_debit_back.jpg'),
    ('American Express', 'AMEX001', 'credit', 'Amex Platinum', 'mastercard', 550.00, 0.00, '5x points on flights', NULL, NULL, 'EMI options, Travel insurance', 'https://example.com/amex_platinum_front.jpg', 'https://example.com/amex_platinum_back.jpg'),
    ('American Express', 'AMEX002', 'credit', 'Amex Gold', 'mastercard', 250.00, 2.50, '4x dining, 3x groceries', NULL, NULL, 'Dining credits', 'https://example.com/amex_gold_front.jpg', 'https://example.com/amex_gold_back.jpg'),
    ('Bank of America', 'BOFA001', 'credit', 'BofA Travel Rewards', 'visa', 0.00, 0.00, '1.5x points everywhere', '3% off at BP', 'BP', 'No foreign fees', 'https://example.com/bofa_travel_front.jpg', 'https://example.com/bofa_travel_back.jpg'),
    ('Bank of America', 'BOFA002', 'debit', 'BofA Cash Rewards Debit', 'visa', 0.00, 2.00, '1% cashback', NULL, NULL, 'Online banking', 'https://example.com/bofa_cash_debit_front.jpg', 'https://example.com/bofa_cash_debit_back.jpg'),
    ('Citibank', 'CITI001', 'credit', 'Citi Prestige', 'mastercard', 495.00, 0.00, '4x travel', '4% off at Chevron', 'Chevron', 'Concierge service', 'https://example.com/citi_prestige_front.jpg', 'https://example.com/citi_prestige_back.jpg'),
    ('Citibank', 'CITI002', 'prepaid', 'Citi Prepaid Travel', 'visa', 0.00, 3.00, NULL, NULL, NULL, 'Reloadable', 'https://example.com/citi_prepaid_front.jpg', 'https://example.com/citi_prepaid_back.jpg'),
    ('Wells Fargo', 'WF001', 'credit', 'Wells Fargo Propel', 'visa', 0.00, 0.00, '3x dining, travel', '2% off at Mobil', 'Mobil', 'Cell phone protection', 'https://example.com/wf_propel_front.jpg', 'https://example.com/wf_propel_back.jpg'),
    ('Wells Fargo', 'WF002', 'debit', 'Wells Fargo Everyday', 'mastercard', 0.00, 1.00, NULL, NULL, NULL, 'Overdraft protection', 'https://example.com/wf_everyday_front.jpg', 'https://example.com/wf_everyday_back.jpg'),
    ('Chase', 'CHASE003', 'credit', 'Chase Freedom Unlimited', 'visa', 0.00, 3.00, '1.5% cashback', NULL, NULL, 'Purchase protection', 'https://example.com/chase_freedom_unl_front.jpg', 'https://example.com/chase_freedom_unl_back.jpg'),
    ('American Express', 'AMEX003', 'credit', 'Amex Blue Cash', 'mastercard', 0.00, 2.50, '3% groceries', NULL, NULL, 'Cashback rewards', 'https://example.com/amex_blue_cash_front.jpg', 'https://example.com/amex_blue_cash_back.jpg'),
    ('Bank of America', 'BOFA003', 'credit', 'BofA Premium Rewards', 'visa', 95.00, 0.00, '2x travel', '5% off at Shell', 'Shell', 'Travel credits', 'https://example.com/bofa_premium_front.jpg', 'https://example.com/bofa_premium_back.jpg'),
    ('Citibank', 'CITI003', 'credit', 'Citi Double Cash', 'mastercard', 0.00, 3.00, '2% cashback', NULL, NULL, 'No annual fee', 'https://example.com/citi_double_cash_front.jpg', 'https://example.com/citi_double_cash_back.jpg'),
    ('Wells Fargo', 'WF003', 'credit', 'Wells Fargo Platinum', 'visa', 0.00, 0.00, NULL, '3% off at Exxon', 'Exxon', 'Low APR', 'https://example.com/wf_platinum_front.jpg', 'https://example.com/wf_platinum_back.jpg'),
    ('Chase', 'CHASE004', 'prepaid', 'Chase Liquid Prepaid', 'visa', 0.00, 2.00, NULL, NULL, NULL, 'Reloadable', 'https://example.com/chase_liquid_front.jpg', 'https://example.com/chase_liquid_back.jpg'),
    ('American Express', 'AMEX004', 'credit', 'Amex Green', 'mastercard', 150.00, 0.00, '3x travel', NULL, NULL, 'Clear membership', 'https://example.com/amex_green_front.jpg', 'https://example.com/amex_green_back.jpg'),
    ('Bank of America', 'BOFA004', 'debit', 'BofA Advantage', 'visa', 0.00, 1.50, NULL, '2% off at Chevron', 'Chevron', 'Mobile banking', 'https://example.com/bofa_advantage_front.jpg', 'https://example.com/bofa_advantage_back.jpg'),
    ('Citibank', 'CITI004', 'credit', 'Citi Rewards+', 'mastercard', 0.00, 0.00, '2x groceries', NULL, NULL, 'Round-up rewards', 'https://example.com/citi_rewards_plus_front.jpg', 'https://example.com/citi_rewards_plus_back.jpg'),
    ('Wells Fargo', 'WF004', 'credit', 'Wells Fargo Active Cash', 'visa', 0.00, 0.00, '2% cashback', NULL, NULL, 'No annual fee', 'https://example.com/wf_active_cash_front.jpg', 'https://example.com/wf_active_cash_back.jpg'),
    ('Chase', 'CHASE005', 'credit', 'Chase Ink Business', 'visa', 0.00, 0.00, '3% cashback on ads', NULL, NULL, 'Business tools', 'https://example.com/chase_ink_front.jpg', 'https://example.com/chase_ink_back.jpg'),
    ('American Express', 'AMEX005', 'prepaid', 'Amex Serve', 'mastercard', 0.00, 1.00, NULL, NULL, NULL, 'No credit check', 'https://example.com/amex_serve_front.jpg', 'https://example.com/amex_serve_back.jpg'),
    ('Bank of America', 'BOFA005', 'credit', 'BofA Customized Cash', 'visa', 0.00, 0.00, '3% chosen category', '4% off at Mobil', 'Mobil', 'Flexible rewards', 'https://example.com/bofa_custom_cash_front.jpg', 'https://example.com/bofa_custom_cash_back.jpg'),
    ('Citibank', 'CITI005', 'debit', 'Citi Access Checking', 'mastercard', 0.00, 2.00, NULL, NULL, NULL, 'Free ATMs', 'https://example.com/citi_access_front.jpg', 'https://example.com/citi_access_back.jpg'),
    ('Wells Fargo', 'WF005', 'credit', 'Wells Fargo Business Elite', 'visa', 125.00, 0.00, '5x business purchases', NULL, NULL, 'Employee cards', 'https://example.com/wf_business_elite_front.jpg', 'https://example.com/wf_business_elite_back.jpg');

-- Insert into products table (10 entries)
INSERT INTO products (product_name, category) VALUES
    ('iPhone 14', 'electronics'),
    ('Flight Tickets', 'travel'),
    ('Samsung TV', 'electronics'),
    ('Hotel Booking', 'travel'),
    ('Laptop', 'electronics'),
    ('Car Rental', 'travel'),
    ('Headphones', 'electronics'),
    ('Cruise Package', 'travel'),
    ('Smartwatch', 'electronics'),
    ('Concert Tickets', 'entertainment');

-- Insert into products_bank_cards table (30 entries)
INSERT INTO products_bank_cards (card_id, product_id, offer_description) VALUES
    (1, 2, '5% cashback on travel'),
    (1, 4, '10% off hotel bookings'),
    (2, 6, '2% cashback on car rentals'),
    (3, 1, '10% off electronics'),
    (3, 2, '5x points on flights'),
    (4, 7, '15% off headphones'),
    (5, 2, '1.5x points on travel'),
    (6, 3, '5% off Samsung TV'),
    (7, 4, '4% off hotel stays'),
    (8, 5, '10% off laptops'),
    (9, 6, '3x points on car rentals'),
    (10, 8, '5% off cruises'),
    (11, 1, '5% cashback on iPhone'),
    (12, 3, '10% off TVs'),
    (13, 2, '2x points on flights'),
    (14, 5, '5% cashback on laptops'),
    (15, 7, '3% off headphones'),
    (16, 9, '10% off smartwatches'),
    (17, 2, '3x travel points'),
    (18, 4, '2% off hotels'),
    (19, 1, '5% off iPhone'),
    (20, 3, '2% cashback on TVs'),
    (21, 5, '10% off laptops'),
    (22, 8, '5% off cruises'),
    (23, 6, '3% off car rentals'),
    (24, 10, '5% off concert tickets'),
    (25, 2, '5x points on flights'),
    (1, 9, '10% off smartwatches'),
    (3, 5, '15% off laptops'),
    (5, 7, '5% off headphones');
