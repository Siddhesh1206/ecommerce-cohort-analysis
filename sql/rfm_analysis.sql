-- ============================================================
-- RFM CUSTOMER SEGMENTATION ANALYSIS
-- Project: E-commerce Cohort Analysis
-- Database: ecommerce_db
-- ============================================================


-- ============================================================
-- 1. RECENCY
-- Calculate how recently each customer made a purchase.
-- Lower recency = more recent purchase.
-- ============================================================

WITH recency_data AS (
    SELECT 
        customer_id,
        MAX(invoice_date) AS last_purchase_date,

        (
            SELECT MAX(invoice_date)
            FROM clean_transactions
        ) + INTERVAL '1 day'
        - MAX(invoice_date) AS recency

    FROM clean_transactions
    GROUP BY customer_id
)


-- ============================================================
-- 2. FREQUENCY
-- Calculate how many unique orders each customer made.
-- ============================================================

, frequency_data AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT invoice) AS frequency

    FROM clean_transactions
    GROUP BY customer_id
)


-- ============================================================
-- 3. MONETARY
-- Calculate the total amount spent by each customer.
-- ============================================================

, monetary_data AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS monetary

    FROM clean_transactions
    GROUP BY customer_id
)


-- ============================================================
-- 4. RFM SCORES
-- Combine Recency, Frequency and Monetary.
-- NTILE(5) divides customers into five groups.
--
-- Frequency:
-- Higher frequency = higher score
--
-- Recency:
-- Lower number of days since purchase = better score
--
-- Monetary:
-- Higher spending = higher score
-- ============================================================

, rfm_scores AS (
    SELECT 
        r.customer_id,
        r.recency,
        f.frequency,
        m.monetary,

        NTILE(5) OVER (
            ORDER BY f.frequency
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY r.recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY m.monetary
        ) AS monetary_score

    FROM recency_data AS r

    JOIN frequency_data AS f
        ON r.customer_id = f.customer_id

    JOIN monetary_data AS m
        ON r.customer_id = m.customer_id
)


-- ============================================================
-- 5. CUSTOMER SEGMENTATION
--
-- Champions:
-- Recently active, frequent and high-spending customers.
--
-- Potential Loyalists:
-- Recently active and frequent customers who have
-- lower monetary value.
--
-- At Risk:
-- Customers who have not purchased recently but have
-- demonstrated reasonable frequency or monetary value.
--
-- Lost:
-- Remaining customers who do not fit the above groups.
-- ============================================================

, customer_segments AS (
    SELECT
        *,

        recency_score
        + frequency_score
        + monetary_score AS rfm_score,

        CASE 

            WHEN recency_score >= 3
                 AND frequency_score >= 4
                 AND monetary_score >= 4
            THEN 'Champions'


            WHEN recency_score >= 3
                 AND frequency_score >= 4
                 AND monetary_score < 4
            THEN 'Potential Loyalist'


            WHEN recency_score <= 3
                 AND (
                     frequency_score >= 3
                     OR monetary_score >= 3
                 )
            THEN 'At Risk'


            ELSE 'Lost'

        END AS customer_segment

    FROM rfm_scores
)


-- ============================================================
-- 6. CUSTOMER-LEVEL RFM OUTPUT
-- One row per customer.
--
-- This is the main RFM dataset that can later be used
-- for Power BI analysis.
-- ============================================================

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    rfm_score,
    customer_segment

FROM customer_segments

ORDER BY customer_id;