# project_API

![ API ](images/download.jpg)

- [Project Introduction](#Project-Introduction)
- [Data Source](#data-source)
- [Data Processing](#Data-Processing)
     - [Renaming Columns](#Renaming-Columns)
     - [Converting Column Names to Lowercase](#Converting-Column-Names-to-Lowercase)

## Retail Sales Data Analysis - AIP Project

 # Project Introduction
  - This project aims to analyze retail sales data extracted from Kaggle
    The goal is to clean, process, and store the data in a SQL database to facilitate future analysis and reporting

# Data Source
- The dataset was obtained from Kaggle and contains retail sales information for the years 2022 and 2023 
- The original dataset includes the following columns:
- Order Id, Order Date, Ship Mode, Segment, Country, City, State, Postal Code, Region, Category, Sub Category, Product Id, Cost Price, List Price, Quantity, Discount Percent

# Data Processing
- 3.1 Renaming Columns
 ```
 Some column names were modified for better clarity and usability.
 df.rename(columns={'Ship Mode': 'ship_mode', 'Order ID': 'order_id',
 'Order Date':'order_date','Postal Code':'postal_code',
 'Sub Category':'sub_category','Cost Price':'cost_price',
 'List Price':'list_price','Discount Percent':'discount_percent'}, inplace=True)
 ```

 - 3.2 Converting Column Names to Lowercase
  ```
All column names were converted to lowercase for consistency:
df.columns = df.columns.str.lower()
  ```

 - 3.3 Creating New Columns

```
New columns were derived to calculate discount, sale price, and profit using the following formulas:
df['discount'] = df['list_price'] * df['discount_percent'] * 0.01
df['sale_price'] = df['list_price'] - df['discount']
df['profit'] = df['sale_price'] - df['cost_price']
```









