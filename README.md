# E-commerce Cohort Analysis

I am using PostgreSQL to analyse customer purchasing behaviour from an e-commerce dataset.

The main focus of this project is customer cohorts and retention — grouping customers based on when they first purchased and then looking at how many of them returned in the following months.

## What I've done so far

- Cleaned the raw transaction data
- Removed records with missing customer IDs
- Removed cancelled transactions
- Removed invalid quantity and price values
- Created a cleaned transaction view
- Identified each customer's first purchase month
- Calculated monthly customer activity
- Calculated cohort month indexes
- Calculated customer retention
- Created a cohort retention matrix

## Tools

- PostgreSQL
- pgAdmin 4
- SQL

## Project Structure

```text
ecommerce-cohort-analysis/
│
├── data/
│
├── sql/
│   ├── data_cleaning.sql
│   └── cohort_analysis.sql
│
└── README.md