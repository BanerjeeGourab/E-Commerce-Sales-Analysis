# E-Commerce Sales Analysis (SQL + Excel)

## Project overview
An entry-level Data Analyst portfolio project using a 1,000-row e-commerce order dataset. The project uses MySQL for querying and Excel for KPI reporting and visual analysis.

## Business questions
- How many orders are shipped, pending, or cancelled?
- What is recognized revenue from shipped orders?
- Which product categories and regions contribute the most shipped revenue?
- How does shipped revenue change month by month?
- How do sales representatives compare on shipped revenue?
- Are there missing values, duplicate order IDs, or invalid quantities/prices?

## Dataset
- **Source file:** `E-Commerce Data Analysis.xlsx`
- **Rows:** 1,000
- **Columns:** Order ID, Order Date, Product Name, Category, Region, Customer ID, Quantity, Unit Price, Status, Sales Representative
- **Order date range:** 2024-01-01 to 2025-06-29
- **Data quality:** No missing cells, duplicate Order IDs, non-positive quantities, or non-positive unit prices were found in the supplied dataset.

## Tools
- MySQL 8.0+
- Microsoft Excel (the workbook can also be imported into Google Sheets)
- SQL: aggregation, conditional aggregation, date grouping, `GROUP BY`, `HAVING`, and sorting
- Excel: formulas, structured tables, KPI cards, and charts

## Business definitions
- **Order Value** = `Quantity × Unit Price` for any order status.
- **Recognized Revenue** = Order Value for `Shipped` orders only. `Pending` and `Cancelled` orders are excluded.
- **Average Shipped Order Value** = Recognized Revenue ÷ number of shipped orders.
- **Cancellation Rate** = Cancelled order records ÷ all order records.
- The dataset does **not** specify a currency, so revenue is reported in the dataset's currency units. The dataset has no cost/profit field, so profit and profit margin are not calculated.
- Each row represents one order record; `Order ID` is unique in the provided file.

## Key findings from this dataset
- Total order records: **1,000**
- Shipped: **605**; Pending: **195**; Cancelled: **200**
- Recognized revenue from shipped orders: **887,097** dataset currency units
- Units in shipped orders: **1,772**
- Average shipped order value: **1,466.28** dataset currency units
- Cancellation rate: **20.0%**
- Highest-revenue category: **Electronics** (772,675 dataset currency units)
- Highest-revenue region: **West** (186,218 dataset currency units)
- Highest-revenue sales representative: **David** (160,105 dataset currency units)

## Files
- `ecommerce_sales_cleaned.csv` — cleaned import file for MySQL
- `ecommerce_sales_analysis.sql` — database/table setup and analysis queries
- `ecommerce_sales_analytics_dashboard.xlsx` — Excel dashboard, detailed summaries, data quality checks, and source data

## How to run the SQL project
1. Open MySQL Workbench and connect to your local MySQL server.
2. Open `ecommerce_sales_analysis.sql` and execute it to create the database and `sales_orders` table.
3. In the Schemas panel, refresh `ecommerce_sales_analysis`.
4. Right-click the `sales_orders` table and select **Table Data Import Wizard**.
5. Choose `ecommerce_sales_cleaned.csv`, map the columns by their names, and complete the import.
6. Run the analysis queries in the SQL script. Run the KPI query only after import is complete.
7. Cross-check recognized revenue against the Excel Dashboard. The SQL and workbook both count only shipped orders as recognized revenue.

## Workbook sheets
- **Dashboard:** KPI cards and charts for monthly revenue, category revenue, regional revenue, and order status mix.
- **Sales Data:** Original columns plus calculated Order Value, Recognized Revenue, and Order Month.
- **Category Analysis:** Shipped revenue and units by category.
- **Region Analysis:** Shipped revenue and units by region.
- **Monthly Trend:** Monthly shipped order counts, units, and revenue.
- **Rep Analysis:** Sales representative performance.
- **Data Quality:** Validation results and limitations.

## Suggested next steps
- Add profit analysis when cost data is available.
- Add discounts, shipping costs, and returns if the business dataset provides them.
- Build a Power BI dashboard and add slicers for time, region, and category.
