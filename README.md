# E-commerce Analytics (Olist)

SQL analysis of about 100k orders from the Brazilian marketplace **Olist** (2016–2018), using DuckDB.

## Problem

Imagine you are the analyst at Olist and the head of e-commerce asks you these questions:

1. **How do revenue and orders change over time, and is there seasonality?** This helps with planning stock, staff and marketing around peak periods.
2. **Do late deliveries lead to worse review scores, and how many orders are affected?** This shows whether better logistics would be worth the cost.
3. **How many customers come back for a second order?** This helps decide between spending on retention and spending on acquiring new customers.
4. **Which payment methods do customers use, and how many instalments do they take?** This helps with payment processing costs and checkout design decisions.

## Data

- [Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce): 9 CSV files, loaded into 9 DuckDB tables.

| Table | Rows |
| --- | --- |
| orders | 99,441 |
| customers | 99,441 |
| order_items | 112,650 |
| payments | 103,886 |
| reviews | 99,224 |
| products | 32,951 |
| sellers | 3,095 |
| geolocation | 1,000,163 |
| category (translation) | 71 |

**Data trap:** `customer_id` is created for every order (99,441 distinct values). The real person is `customer_unique_id` (96,096 distinct values), so repeat-customer questions must use `customer_unique_id`.

The data files are not part of the repository. Download them from Kaggle into `data/`.

## SQL analysis

All queries are in the [`sql/`](sql/) folder, one question per file. They are run and explained in [`notebooks/01_sql_queries.ipynb`](notebooks/01_sql_queries.ipynb). Unless noted otherwise, only orders with `order_status = 'delivered'` are counted, and revenue means the item price in BRL (R$), without freight.

| # | File | Question | SQL skills |
| --- | --- | --- | --- |
| 1 | `01_monthly_revenue.sql` | Revenue and orders per month | JOIN, DATE_TRUNC, GROUP BY |
| 2 | `02_top_categories.sql` | Top 10 product categories by revenue | 3-table JOIN, ORDER BY, LIMIT |
| 3 | `03_revenue_by_state.sql` | Orders and average order value by customer state | JOIN, AVG |
| 4 | `04_delivery_time_by_state.sql` | Average and median delivery time by state | DATE_DIFF, NULL handling, MEDIAN |
| 5 | `05_orders_share_late.sql` | Share of orders delivered early, on time or late | CASE WHEN, window share |
| 6 | `06_review_score.sql` | Average review score by delivery status | JOIN, CASE WHEN |
| 7 | `07_customers_share_2orders.sql` | Share of customers with 2+ orders | CTE, COUNT FILTER |
| 8 | `08_payments_share.sql` | Payment method shares and average instalments | CTE, `SUM() OVER ()` |
| 9 | `09_running_revenue.sql` | Running total of revenue | `SUM() OVER (ORDER BY ...)` |
| 10 | `10_top_sellers_state.sql` | Top 3 sellers per state | `RANK() OVER (PARTITION BY ...)` |

### Key findings

1. **Late deliveries hurt reviews the most.** Only 6.8% of delivered orders (6,534) arrived after the estimated date, but late orders received an average review of **2.3 stars**, compared with **4.3** for early orders. Orders delivered exactly on the promised day scored 4.0, so customers seem to reward deliveries that beat the estimate. This is a correlation, not proof of cause.
2. **Strong growth, then a plateau.** Monthly delivered orders grew from 750 in January 2017 to a peak of **7,289 in November 2017**. That month had R$ 988k in revenue, 52% more than October, and Black Friday (24 November 2017) alone had 1,147 orders. In 2018, volume stayed around 6,000 to 7,000 orders per month. The cumulative revenue reached about **R$ 13.2M** by August 2018.
3. **Almost no repeat customers.** Only **3.0%** of customers (2,801 of 93,358) placed 2 or more delivered orders. Growth depends mainly on acquiring new customers.

### Other results

- **Categories:** health_beauty has the highest revenue (R$ 1.26M). watches_gifts is second (R$ 1.21M) with fewer orders, because it has the highest revenue per order (R$ 214).
- **Geography:** São Paulo (SP) brings 38% of revenue (R$ 5.07M from about 40,500 orders) but has the lowest average order value (R$ 125). Smaller north-eastern states order less but spend more per order.
- **Delivery time:** orders to SP arrive in about 8.7 days on average, while remote northern states (AM, AP, RR) wait 26 to 29 days, more than 3 times longer.
- **Payments:** credit card is used in 75.3% of orders, with 3.5 instalments on average. It is followed by boleto (19.5%), voucher (3.7%) and debit card (1.5%).
- **Sellers:** revenue is concentrated. The top seller in SP earned about R$ 227k, and in BA the leader earned more than ten times the second seller.

### Business recommendation

Logistics should come first. Late orders are rare but strongly linked to low ratings, and remote states wait the longest. Possible actions are setting more realistic estimates for remote states, focusing carrier improvements there, and planning capacity ahead of Black Friday. Because repeat purchases are only 3%, a small retention programme, such as a follow-up offer after a well-reviewed first order, has a lot of room to grow.

## How to run

```bash
git clone https://github.com/<your-username>/ecommerce-analytics.git
cd ecommerce-analytics
python -m venv .venv
# Windows: .venv\Scripts\activate    macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
```

1. Download the Olist CSV files from Kaggle into `data/`.
2. Run `notebooks/00_load_data.ipynb` to create `olist.duckdb`.
3. Run `notebooks/01_sql_queries.ipynb` to execute all queries in `sql/`.

## Project structure

```
ecommerce-analytics/
├── data/                  # raw CSV files (not in git)
├── sql/                   # 10 SQL queries, one question per file
├── notebooks/
│   ├── 00_load_data.ipynb     # loads CSV files into DuckDB
│   └── 01_sql_queries.ipynb   # runs the queries and explains the results
├── images/                # charts and schema
├── requirements.txt
└── README.md
```

## Tech stack

Python, DuckDB (SQL), pandas, NumPy, Matplotlib, Jupyter, Git
