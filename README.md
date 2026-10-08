# E-Commerce Customer & Cohort Analytics

An end-to-end e-commerce analytics project built using **PostgreSQL, SQL, DAX, and Power BI**.

This project transforms more than one million raw retail transaction records into a cleaned analytical dataset, customer cohort retention analysis, RFM customer segmentation, and an interactive three-page Power BI dashboard.

---

## Project Overview

The project analyzes historical e-commerce transactions to answer key business questions:

- How much revenue does the business generate?
- How has revenue changed over time?
- Which countries generate the most revenue?
- How well are newly acquired customers retained?
- Which customer segments generate the most value?
- Which customers may be at risk of becoming inactive?

### Analytics Pipeline

```text
Raw Transaction Data
        ↓
Data Cleaning & Validation
        ↓
Clean Transactions View
        ↓
 ┌───────────────┬─────────────────┐
 │ Cohort        │ RFM             │
 │ Retention     │ Segmentation    │
 └───────────────┴─────────────────┘
        ↓
Power BI Data Model
        ↓
Interactive Dashboard
```

---

## Dataset

The project uses an Online Retail transaction dataset containing more than one million transaction records.

### Key Metrics

| Metric | Result |
|---|---:|
| Raw transaction rows | 1,067,371 |
| Clean transaction rows | 805,531 |
| Removed rows | 261,840 |
| Unique customers | 5,878 |
| Total revenue | €17,743,429.16 |

### Data Cleaning Rules

The analytical dataset excludes:

- Transactions without a `customer_id`
- Transactions where `quantity <= 0`
- Transactions where `price <= 0`
- Cancelled invoices identified by invoice numbers beginning with `C`

A reusable PostgreSQL view named `clean_transactions` was created from the raw staging table.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| PostgreSQL | Data storage and SQL analytics |
| pgAdmin 4 | Database management |
| SQL | Data cleaning, transformation and analysis |
| Power BI | Interactive dashboards and visualization |
| DAX | Power BI measures |
| Git & GitHub | Version control and documentation |
| VS Code | Development environment |

---

# 1. Data Cleaning

The raw dataset was loaded into PostgreSQL as:

```text
raw_online_retail
```

A cleaned analytical view was created:

```text
clean_transactions
```

Line-item revenue is calculated using:

```sql
quantity * price AS total_amount
```

The cleaning process reduced the dataset from **1,067,371 raw rows** to **805,531 valid analytical rows**.

---

# 2. Customer Cohort Retention Analysis

Cohort analysis groups customers according to the month in which they made their first purchase.

### Method

1. Identify each customer's first purchase month.
2. Identify every month in which each customer made a purchase.
3. Calculate the number of months between acquisition and subsequent purchases.
4. Count retained customers for each cohort/month combination.
5. Calculate retention percentage relative to the original cohort size.

The resulting analytical view is:

```text
cohort_retention
```

### Key Retention Metrics

| Metric | Result |
|---|---:|
| Month 1 average retention | 21.17% |
| Month 6 average retention | 17.82% |

The Power BI dashboard presents this analysis as a cohort retention heatmap.

---

# 3. RFM Customer Segmentation

RFM analysis evaluates customers using three dimensions:

### Recency
How recently did the customer make a purchase?

### Frequency
How frequently did the customer purchase?

### Monetary
How much revenue did the customer generate?

Each dimension was scored using five quantiles, producing Recency, Frequency and Monetary scores.

The resulting customer-level view is:

```text
rfm_customer_segments
```

## Customer Segments

### Champions
Recent, frequent and high-value customers.

### Potential Loyalist
Customers showing strong purchasing behaviour but with lower monetary value.

### At Risk
Customers whose purchasing behaviour indicates potential disengagement.

### Lost
Customers with weaker recency and purchasing behaviour.

---

## RFM Results

| Segment | Customers | Revenue | % of Customers | % of Revenue |
|---|---:|---:|---:|---:|
| Champions | 1,707 | €13.77M | 29.04% | 77.62% |
| At Risk | 1,362 | €2.43M | 23.17% | 13.69% |
| Potential Loyalist | 288 | €0.25M | 4.90% | 1.43% |
| Lost | 2,521 | €1.29M | 42.89% | 7.25% |
| **Total** | **5,878** | **€17.74M** | **100%** | **100%** |

---

# 4. Key Business Insights

### Revenue concentration

Champions represent approximately **29% of customers but generate 77.62% of total historical revenue**.

This indicates a strong concentration of revenue among the highest-value customers.

### At-risk customers

Approximately **23% of customers** fall into the At Risk segment and account for around **13.69% of historical revenue**.

This segment represents a potential customer-retention opportunity.

### Lost customers

Lost customers represent approximately **43% of the customer base**, but contribute only around **7.25% of historical revenue**.

### Customer retention

Average retention is:

- **Month 1:** 21.17%
- **Month 6:** 17.82%

This highlights the importance of repeat purchasing and customer retention.

---

# 5. Power BI Dashboard

The project includes a three-page Power BI dashboard.

## Page 1 — E-Commerce Customer & Revenue Overview

Includes:

- Total Revenue
- Total Customers
- Transaction Rows
- Average Revenue per Customer
- Revenue Trend
- Top 10 Countries by Revenue
- Customer Segmentation
- Revenue by Customer Segment

## Page 2 — Customer Cohort Retention

Includes:

- Total Customers
- Month 1 Retention
- Month 6 Retention
- Cohort Retention Heatmap

## Page 3 — RFM Customer Segmentation

Includes:

- Total Customers
- Total Revenue
- Customer Segment Distribution
- Revenue by Customer Segment
- Segment-level customer counts
- Segment revenue contribution

The dashboard uses a custom Power BI theme for consistent styling across all three pages.

---

# 6. SQL Concepts Demonstrated

This project demonstrates practical SQL techniques including:

- `CREATE VIEW`
- `CREATE OR REPLACE VIEW`
- Common Table Expressions (`WITH`)
- `JOIN`
- `GROUP BY`
- `COUNT`
- `COUNT(DISTINCT ...)`
- `SUM`
- `MIN`
- `MAX`
- `DATE_TRUNC`
- `EXTRACT`
- `CASE`
- Conditional aggregation
- Window functions
- `FIRST_VALUE`
- `NTILE`
- Date arithmetic
- Customer-level aggregation
- Cohort analysis
- RFM scoring
- Business segmentation

---

# 7. Project Structure

```text
ecommerce-cohort-analysis/
│
├── README.md
│
├── data/
│   └── README.md
│
├── sql/
│   ├── data_cleaning.sql
│   ├── cohort_analysis.sql
│   └── rfm_analysis.sql
│
└── powerbi/
    └── Ecommerce_Cohot_Analysis.pbix
```

---

# 8. Reproducibility

To reproduce the SQL analysis:

### 1. Create the PostgreSQL database

```text
ecommerce_db
```

### 2. Load the raw Online Retail dataset

The raw data should be loaded into:

```text
raw_online_retail
```

### 3. Run the SQL scripts

Run the scripts in the following order:

```text
sql/data_cleaning.sql
sql/cohort_analysis.sql
sql/rfm_analysis.sql
```

### 4. Connect Power BI

Connect Power BI to the resulting PostgreSQL views:

```text
clean_transactions
cohort_retention
rfm_customer_segments
```

---

# 9. Project Outputs

The project produces:

- A cleaned transaction analytics view
- A customer cohort retention view
- An RFM customer segmentation view
- SQL analysis scripts
- A three-page Power BI dashboard
- Business insights derived from customer behaviour and revenue patterns

---

# 10. Future Improvements

Potential extensions include:

- Customer lifetime value modelling
- Revenue forecasting
- Product-level market basket analysis
- Customer churn prediction using machine learning
- Automated data pipelines
- Scheduled dashboard refreshes
- Natural-language querying of the analytical database
- Cloud data warehouse deployment

---

## Author

**Siddhesh Kadam**

MSc Data & Computational Science

Interested in **Data Analytics, Machine Learning, SQL, and Business Intelligence**.
