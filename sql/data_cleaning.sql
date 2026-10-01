-- E-commerce Cohort Analysis
-- Data cleaning and initial data checks


-- 1. Check the raw dataset

SELECT COUNT(*) AS total_raw_rows
FROM raw_online_retail;


SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS rows_with_customer_id,
    COUNT(*) - COUNT(customer_id) AS missing_customer_id
FROM raw_online_retail;


-- Check cancellation records

SELECT COUNT(*) AS cancellation_rows
FROM raw_online_retail
WHERE invoice LIKE 'C%';


-- Check invalid quantities and prices

SELECT COUNT(*) AS negative_quantity_rows
FROM raw_online_retail
WHERE quantity < 0;


SELECT COUNT(*) AS zero_quantity_rows
FROM raw_online_retail
WHERE quantity = 0;


SELECT COUNT(*) AS negative_price_rows
FROM raw_online_retail
WHERE price < 0;


SELECT COUNT(*) AS zero_price_rows
FROM raw_online_retail
WHERE price = 0;


-- 2. Create a cleaned transaction view

CREATE OR REPLACE VIEW clean_transactions AS
SELECT
    invoice,
    stock_code,
    description,
    quantity,
    invoice_date,
    price,
    customer_id,
    country,
    quantity * price AS total_amount
FROM raw_online_retail
WHERE
    customer_id IS NOT NULL
    AND quantity > 0
    AND price > 0
    AND invoice NOT LIKE 'C%';


-- 3. Check the cleaned dataset

SELECT COUNT(*) AS clean_row_count
FROM clean_transactions;


SELECT
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_line_item_value
FROM clean_transactions;


SELECT
    COUNT(DISTINCT customer_id) AS total_unique_customers,
    MIN(invoice_date) AS earliest_order,
    MAX(invoice_date) AS latest_order
FROM clean_transactions;