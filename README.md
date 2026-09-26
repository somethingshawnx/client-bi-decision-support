# Client Business Intelligence & Decision Support Platform

## Overview

An end-to-end Business Intelligence and Decision Support solution developed for a simulated retail client, NovaRetail.

The platform transforms raw transaction data into structured relational data, performs business analysis using SQL, and presents interactive insights through Power BI dashboards.

## Business Problem

NovaRetail generates a large volume of retail transaction data but needs a centralized analytical solution to understand:

- Revenue and profitability performance
- Regional performance
- Product and category contribution
- Customer contribution
- Discount and profitability relationships
- Business trends over time

## Business Objectives

The solution was designed to:

- Clean and validate raw transaction data
- Identify and isolate multiple data structures present in the source file
- Transform transactional data into a relational database model
- Perform business analysis using SQL
- Develop interactive Power BI dashboards
- Translate analytical results into management-oriented insights

## Technology Stack

- Python
- Pandas
- NumPy
- MySQL
- SQL
- Power BI
- DAX
- Git
- GitHub

## Solution Architecture

Raw CSV
→ Python Data Cleaning
→ MySQL RDBMS
→ SQL Analysis
→ Power BI Semantic Model
→ Interactive Dashboards
→ Business Insights

## Data Engineering

During initial data profiling, the source CSV contained 10,800 rows.

The first 9,994 rows represented transaction records, while additional records contained separate People and Returns information.

The transaction data was therefore isolated before analytical processing.

Data validation included:

- Duplicate transaction detection
- Missing-value analysis
- Date validation
- Numeric type conversion
- Quantity validation
- Discount range validation
- Shipping-date validation

The final analytical dataset contained 9,994 transaction records with validated dates and numeric business fields.

## Database Design

The transactional dataset was transformed into a relational structure containing:

### Customers

Stores customer and geographic information.

### Products

Stores product, category and sub-category information.

### Orders

Stores order dates, shipping information and customer relationships.

### Order Items

Stores product-level transaction measures including:

- Sales
- Quantity
- Discount
- Profit

## SQL Analysis

The analytical layer answers the following business questions:

1. What is the overall business performance?
2. Which regions generate the highest sales?
3. Which regions have the highest profit margins?
4. Which product categories drive profitability?
5. Which products generate the highest sales?
6. Which customers contribute the most revenue and profit?
7. How are discount levels associated with profitability?
8. How does business performance change over time?
9. Which sub-categories require profitability investigation?

## Power BI Dashboards

### 1. Executive Overview

Provides:

- Total Sales
- Total Profit
- Profit Margin
- Total Orders
- Sales and Profit Trend
- Sales by Region
- Profit by Category

### 2. Regional & Profitability Analysis

Provides:

- Sales by Region
- Profit Margin by Region
- Profit by Sub-Category
- Top 10 Products by Sales
- Discount vs Profitability

### 3. Customer & Product Insights

Provides:

- Sales by Customer Segment
- Profit by Customer Segment
- Top 10 Customers by Sales
- Top 10 Customers by Profit
- Top 10 Products by Profit

## Key Analytical Findings

- West generated the highest regional sales and profit in the analyzed dataset.
- East recorded the highest regional profit margin.
- Furniture generated substantial sales but had significantly lower profitability than Technology and Office Supplies.
- Higher discount bands were associated with progressively lower profitability in the dataset.
- Customer and product concentration can be examined through the Top 10 revenue and profit views.

## Business Value

The solution enables management to:

- Monitor business performance
- Compare regional performance
- Identify profitability issues
- Investigate product and category performance
- Understand customer contribution
- Evaluate discount-related profitability patterns
- Support data-driven decision making

## Project Structure

```text
client-bi-decision-support/
│
├── data/
│   ├── superstore.csv
│   └── superstore_clean.csv
│
├── python/
│   ├── data_cleaning.py
│   └── load_to_mysql.py
│
├── sql/
│   ├── schema.sql
│   └── analysis.sql
│
├── powerbi/
│   └── client_dashboard.pbix
│
├── docs/
│   └── business_requirements.md
│
└── README.md