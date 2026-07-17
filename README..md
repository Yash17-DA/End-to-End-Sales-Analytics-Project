# Northwind Traders – Data Analysis Project

End-to-end data analysis project built on the Northwind Traders dataset (2022–2024), covering everything from raw messy data to a Power BI dashboard.

## Tech Stack

- Microsot SQL Server SSMS (staging + views)
- Python (pandas, pyodbc, SQLAlchemy)
- Power BI (data modeling, DAX,)

## Pipeline

1. **Raw data (messy)** – Source data exported and deliberately corrupted with nulls, inconsistent formats, and duplicates.
2. **Staging in SQL Server** – Loaded as-is into a loose staging schema (all columns as `NVARCHAR`, nulls allowed) so no data is lost at the ingestion stage.
3. **Cleaning in Python** – Used `pandas` to clean and normalize the data: dropped rows missing critical IDs, backfilled missing operational fields (like region codes) with `'Unknown'`, stripped whitespace, and fixed broken characters using regex.
4. **Push clean data back** – Used `SQLAlchemy` and `pyodbc` to bulk load the cleaned tables back into SQL Server.
5. **Views in SQL Server** – Built views on top of the clean tables using `ISNULL()`/`COALESCE()` so the reporting layer never queries raw tables directly, and any null that slips through upstream still gets handled safely.
6. **Power BI** – Connected to the Microsoft SQL Server views, modeled the data into a star schema, and built the report in Import Mode.

## Business Problems Solved

### 1. Discount Impact Analysis
**Question:** Is discounting actually driving volume, or just cutting into margin?

Net revenue grew sharply from $150.16K in 2022 to $534.39K in 2023, then settled at $336.07K in 2024. Margin erosion actually improved over the same period — down from 7.89% in 2022 to around 6.29–6.22% in 2023 and 2024 — so the business got better at controlling how much margin discounts were eating into.

Looking at the discount bands, though, most order volume was concentrated in the 0–5% discount range. Discounts above 15% didn't produce a meaningful lift in volume — those orders would likely have happened anyway at a lower discount. Full-price orders (0% discount) were actually the biggest revenue driver, bringing in $324.9K in 2023 alone (over 60% of that year's net revenue). Red Wine (Bordeaux) was the top product by revenue across all three years.

### 2. Shipping & Fulfillment Performance
**Question:** How reliable is order fulfillment, and where are the bottlenecks?

On-time delivery looked healthy on the surface — consistently around 95–96% across all three years. But average processing delay told a different story it went from 44 days in 2022 to nearly 81 days in 2023, and close to 100 days in 2024. So orders were technically shipped "on time" against their required date, but the whole process was getting slower internally each year.

Freight cost followed a similar pattern — up from $7.08K in 2022 to a peak of $28.23K in 2023, before settling at $17.43K in 2024. Looking at it by country, the bottleneck moved around each year: Portugal and Venezuela had the longest delays in 2022, Poland had an extreme spike in 2023 (average 357 days, likely a customs or distribution issue), and by 2024 the slowdowns had shifted to Germany, Italy, and Switzerland. This points to internal fulfillment/warehouse issues rather than any one carrier being at fault  United Package, Federal Shipping, and Speedy Express all stayed fairly stable in their on time rates.

### 3. Employee / Sales Representative Performance
**Question:** How is performance and workload distributed across the sales team?

Average order value grew steadily $1.23K in 2022, up to $1.53K in 2023, and $1.57K in 2024  suggesting the team moved toward larger deals over time. Margaret Peacock was the top revenue earner in 2022 and 2023 (reaching $103.07K in 2023), but Andrew Fuller took the top spot in 2024 with $68.6K.

One thing that stood out in 2022 representative were both closing good deals, Highest 29 orders were Closed by Margaret Peacock contributing $36.6k Net Revenue & Lowest 8 orders were closed by Steven Buchanan contributing $8k Net Revenue. In 2023, Margaret Peacock Climbs from 29 orders in 2022 to 66 orders contributing $103k Net Revenue & Steven Buchanan Climbs from 8 orders in 2022 to 15 orders in 2023 making good improvement and contributing $22k Net Revenue but still has the lowest Net Revenue contribution. In 2024 Andrew Fuller was top performer employee closing 32 orders contributing $68k Net Revenue & Lowest 17 orders were closed by Michael Suyama contributing $13k Net Revenue.

### 4. Customer RFM Segmentation
**Question:** Who are the most valuable customers, and who's at risk of churning?

Active customers grew from 62 in 2022 to 85 in 2023 , and the "Champions" segment (high frequency, high value) nearly tripled to 57 accounts (about a third of the customer base) that year. By 2024, active accounts settled at 79, with most of the base shifting into the "Loyal" tier.

The more important finding was in the At Risk segment. In 2022, at-risk customers made up a fair share of the customer count and around $31.9K in exposed revenue. By 2023, that exposure had tripled to about $105K. In 2024, the number of at-risk accounts shrank to just a couple of customers but they represented roughly $85.9K, about a quarter of that year's total revenue. In other words, revenue risk had become heavily concentrated in a very small number of accounts, including QUICK, one of the biggest revenue contributors, which moved into the at-risk tier by 2024  worth flagging as a retention priority.

## Repository Structure

```
|-- 1.Raw Data/   # Raw, unformatted source data schemas.
|-- 2.Notebook/Data_Cleaning.ipynb    # Python cleaning & ingestion script.
|-- 3.Clean Production Data/   # Automated CSV backups post-Python scrubbing.
|-- 4.SQL Script/ # Decoupled reporting layer view definitions.
|-- 5.Power BI Dashboard/ commercial_intelligence_model.pbix  # High performance Power BI Dashboard.
|-- 6.Assets/ # Screenshots Production dashboard captures.

```

## Notes

Built on the public Northwind sample dataset. Raw data was intentionally modified to include realistic data quality issues — it doesn't represent any real company or transactions.


