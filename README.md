# project_API

![ API ](images/download.jpg)

- [Project Introduction](#Project-Introduction)
- [Data Source](#data-source)
- [Data Processing](#Data-Processing)
     - [Renaming Columns](#Renaming-Columns)
     - [Converting Column Names to Lowercase](#Converting-Column-Names-to-Lowercase)
     - [Converting Order Date Data Type](#Converting-Order-Date-Data-Type)
     - [Dropping Unnecessary Columns](#Dropping-Unnecessary-Columns)
- [Saving and Uploading Data to SQL](#Saving-and-Uploading-Data-to-SQL)
- [Data-Analysis-using-SQL](#Data-Analysis-using-SQL)
     - [Top 10 Best-Selling Products](#Top10Best-SellingProducts)
     - [Top 5 Best-Selling Products in Each Region](#Top5Best-SellingProductsinEachRegion)
     - [Month-over-Month Sales Growth Comparison (2022 vs 2023)](#Month-over-MonthSalesGrowthComparison (2022 vs 2023))
     - [identifies the month with the highest sales for each product category](#identifiesthemonthwiththehighestsalesforeachproductcategory)

## Retail Sales Data Analysis - AIP Project

 # Project Introduction
  - This project aims to analyze retail sales data extracted from Kaggle
    The goal is to clean, process, and store the data in a SQL database to facilitate future analysis and reporting

# Data Source
- The dataset was obtained from Kaggle and contains retail sales information for the years 2022 and 2023 
- The original dataset includes the following columns:
- Order Id, Order Date, Ship Mode, Segment, Country, City, State, Postal Code, Region, Category, Sub Category, Product Id, Cost Price, List Price, Quantity, Discount Percent

# Data Processing
## 3.1 Renaming Columns
 ```
 Some column names were modified for better clarity and usability.
 df.rename(columns={'Ship Mode': 'ship_mode', 'Order ID': 'order_id',
 'Order Date':'order_date','Postal Code':'postal_code',
 'Sub Category':'sub_category','Cost Price':'cost_price',
 'List Price':'list_price','Discount Percent':'discount_percent'}, inplace=True)
 ```

## 3.2 Converting Column Names to Lowercase
  ```
All column names were converted to lowercase for consistency:
df.columns = df.columns.str.lower()
  ```

 ## 3.3 Creating New Columns

```
New columns were derived to calculate discount, sale price, and profit using the following formulas:
df['discount'] = df['list_price'] * df['discount_percent'] * 0.01
df['sale_price'] = df['list_price'] - df['discount']
df['profit'] = df['sale_price'] - df['cost_price']
```

## 3.4 Converting Order Date Data Type
```
The order date was converted to the `datetime` format using the following command:
df['order_date'] = pd.to_datetime(df['order_date'], format='%Y-%m-%d')
```
## Dropping Unnecessary Columns
```
The following columns were removed as they were no longer needed: `list_price`, `cost_price`, `discount_percent`.
df.drop(columns=['list_price', 'cost_price', 'discount_percent'], inplace=True)
```
# Saving and Uploading Data to SQL

 ## Saving Cleaned Data to CSV
```
The cleaned data was saved to a CSV file using the following script:
try:
    df.to_csv('orders/orders_clean.csv', index=False)
    print('✅ File saved successfully!')
except Exception as e:
    print('❌ Error saving file:', e)
```
 # Uploading Data to MySQL
 ```
The SQLAlchemy library was used to upload the data to a MySQL database.
from sqlalchemy import create_engine

engine = create_engine("mysql+pymysql://root:123456789@localhost:3306/data_kaggle")

try:
    df.to_sql('df_orders', con=engine, index=False, if_exists='append')
    print("✅ Connected to the database successfully")
except Exception as e:
    print("❌ Connection to the database failed", e)
```

# Data Analysis using SQL
 ## Top 10 Best-Selling Products
```
Finding the top 10 highest revenue-generating products:
SELECT product_id, SUM(sale_price) AS sales 
FROM df_orders 
GROUP BY product_id 
ORDER BY sales DESC 
LIMIT 10;
```
- ![Cleaned](images/top10highestproducts.png)
- [Code](codes/findTop10Products.sql)

 ## 5.2 Top 5 Best-Selling Products in Each Region
```
WITH cte AS (
    SELECT region, product_id, SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY region, product_id
)
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY sales DESC) AS rn
    FROM cte
) AS ranked_data
WHERE rn <= 5;
```
- ![](images/FindTop5HighestSellingProducts.png)
- [Code](codes/findTop5HighestSellingProducts.sql)

 ## 5.3 Month-over-Month Sales Growth Comparison (2022 vs 2023)
 ```
WITH cte AS (
    SELECT 
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT 
    order_month,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte 
GROUP BY order_month
ORDER BY order_month;
```
- ![](images/FindMonthOverMonth.png)
- [Code](codes/FindMonthOverMonth.sql)

## 5.4 identifies the month with the highest sales for each product category

```
WITH cte AS (
    SELECT 
        category, 
        DATE_FORMAT(order_date, '%Y%m') AS order_year_month,
        SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY category, DATE_FORMAT(order_date, '%Y%m')
)
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC) AS rn
    FROM cte
) AS a
WHERE rn = 1;
```
- ![](images/ForEachMonthSales.png)
- [Code](codes/ForEachMonthSales.sql)









