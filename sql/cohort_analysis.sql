-- E-commerce Cohort Analysis
-- Customer retention by cohort month


-- 1. Identify each customer's first purchase month

WITH customer_cohorts AS (
    SELECT
        customer_id,
        MIN(DATE_TRUNC('month', invoice_date)) AS cohort_month
    FROM clean_transactions
    GROUP BY customer_id
),

-- 2. Identify the months in which each customer made a purchase

customer_months AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', invoice_date) AS purchase_month
    FROM clean_transactions
),

-- 3. Connect each purchase month to the customer's cohort

customer_activity AS (
    SELECT
        cm.customer_id,
        cc.cohort_month,
        cm.purchase_month,

        (
            EXTRACT(YEAR FROM cm.purchase_month) * 12
            + EXTRACT(MONTH FROM cm.purchase_month)
        )
        -
        (
            EXTRACT(YEAR FROM cc.cohort_month) * 12
            + EXTRACT(MONTH FROM cc.cohort_month)
        ) AS cohort_index

    FROM customer_months AS cm
    JOIN customer_cohorts AS cc
        ON cm.customer_id = cc.customer_id
),

-- 4. Count active customers for each cohort and month

retention_counts AS (
    SELECT
        cohort_month,
        cohort_index,
        COUNT(DISTINCT customer_id) AS retained_customers
    FROM customer_activity
    GROUP BY
        cohort_month,
        cohort_index
),

-- 5. Add the original cohort size

retention_with_size AS (
    SELECT
        cohort_month,
        cohort_index,
        retained_customers,

        FIRST_VALUE(retained_customers) OVER (
            PARTITION BY cohort_month
            ORDER BY cohort_index
        ) AS cohort_size

    FROM retention_counts
),

-- 6. Calculate retention percentage

retention_percentages AS (
    SELECT
        cohort_month,
        cohort_index,

        ROUND(
            retained_customers * 100.0 / cohort_size,
            2
        ) AS retention_percentage

    FROM retention_with_size
)

-- 7. Create the cohort retention table

SELECT
    cohort_month,

    MAX(
        CASE
            WHEN cohort_index = 0
            THEN retention_percentage
        END
    ) AS month_0,

    MAX(
        CASE
            WHEN cohort_index = 1
            THEN retention_percentage
        END
    ) AS month_1,

    MAX(
        CASE
            WHEN cohort_index = 2
            THEN retention_percentage
        END
    ) AS month_2,

    MAX(
        CASE
            WHEN cohort_index = 3
            THEN retention_percentage
        END
    ) AS month_3,

    MAX(
        CASE
            WHEN cohort_index = 4
            THEN retention_percentage
        END
    ) AS month_4,

    MAX(
        CASE
            WHEN cohort_index = 5
            THEN retention_percentage
        END
    ) AS month_5

FROM retention_percentages
GROUP BY cohort_month
ORDER BY cohort_month;