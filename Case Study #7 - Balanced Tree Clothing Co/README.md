# [8-Week SQL Challenge](https://github.com/ndleah/8-Week-SQL-Challenge)
![Star Badge](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=style=flat&color=BC4E99)
[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/ndleah/8-Week-SQL-Challenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/ndleah?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/ndleah)


# 🌲 Case Study #7 - Balanced Tree Clothing Co.
<p align="center">
<img src="/IMG/org-7.png" width=40% height=40%>

## 📕 Table Of Contents
  - 🛠️ [Problem Statement](#problem-statement)
  - 📂 [Dataset](#dataset)
  - 🧙‍♂️ [Case Study Questions](#case-study-questions)
  -  🚀 [Solutions](#-solutions)

## 🛠️ Problem Statement

> Balanced Tree Clothing Company prides themselves on providing an optimised range of clothing and lifestyle wear for the modern adventurer!
> 
> Danny, the CEO of this trendy fashion company has asked you to assist the team’s merchandising teams analyse their sales performance and generate a basic financial report to share with the wider business.

## 📂 Dataset
For this case study there is a total of 4 datasets for this case study. However you will only need to utilise 2 main tables to solve all of the regular questions:

### **```Product Details```**

<details>
<summary>
View table
</summary>

`balanced_tree.product_details` includes all information about the entire range that Balanced Clothing sells in their store.

| "product_id" | "price" | "product_name"                     | "category_id" | "segment_id" | "style_id" | "category_name" | "segment_name" | "style_name"          |
|--------------|---------|------------------------------------|---------------|--------------|------------|-----------------|----------------|-----------------------|
| "c4a632"     | 13      | "Navy Oversized Jeans - Womens"    | 1             | 3            | 7          | "Womens"        | "Jeans"        | "Navy Oversized"      |
| "e83aa3"     | 32      | "Black Straight Jeans - Womens"    | 1             | 3            | 8          | "Womens"        | "Jeans"        | "Black Straight"      |
| "e31d39"     | 10      | "Cream Relaxed Jeans - Womens"     | 1             | 3            | 9          | "Womens"        | "Jeans"        | "Cream Relaxed"       |
| "d5e9a6"     | 23      | "Khaki Suit Jacket - Womens"       | 1             | 4            | 10         | "Womens"        | "Jacket"       | "Khaki Suit"          |
| "72f5d4"     | 19      | "Indigo Rain Jacket - Womens"      | 1             | 4            | 11         | "Womens"        | "Jacket"       | "Indigo Rain"         |
| "9ec847"     | 54      | "Grey Fashion Jacket - Womens"     | 1             | 4            | 12         | "Womens"        | "Jacket"       | "Grey Fashion"        |
| "5d267b"     | 40      | "White Tee Shirt - Mens"           | 2             | 5            | 13         | "Mens"          | "Shirt"        | "White Tee"           |
| "c8d436"     | 10      | "Teal Button Up Shirt - Mens"      | 2             | 5            | 14         | "Mens"          | "Shirt"        | "Teal Button Up"      |
| "2a2353"     | 57      | "Blue Polo Shirt - Mens"           | 2             | 5            | 15         | "Mens"          | "Shirt"        | "Blue Polo"           |
| "f084eb"     | 36      | "Navy Solid Socks - Mens"          | 2             | 6            | 16         | "Mens"          | "Socks"        | "Navy Solid"          |
| "b9a74d"     | 17      | "White Striped Socks - Mens"       | 2             | 6            | 17         | "Mens"          | "Socks"        | "White Striped"       |
| "2feb6b"     | 29      | "Pink Fluro Polkadot Socks - Mens" | 2             | 6            | 18         | "Mens"          | "Socks"        | "Pink Fluro Polkadot" |

</details>

### **```Product Sales```**

<details>
<summary>
View table
</summary>

`balanced_tree.sales` contains product level information for all the transactions made for Balanced Tree including quantity, price, percentage discount, member status, a transaction ID and also the transaction timestamp.

Below is the display of the first 10 rows in this dataset:


| "prod_id" | "qty" | "price" | "discount" | "member" | "txn_id" | "start_txn_time"           |
|-----------|-------|---------|------------|----------|----------|----------------------------|
| "c4a632"  | 4     | 13      | 17         | True     | "54f307" | "2021-02-13 01:59:43.296"  |
| "5d267b"  | 4     | 40      | 17         | True     | "54f307" | "2021-02-13 01:59:43.296"  |
| "b9a74d"  | 4     | 17      | 17         | True     | "54f307" | "2021-02-13 01:59:43.296"  |
| "2feb6b"  | 2     | 29      | 17         | True     | "54f307" | "2021-02-13 01:59:43.296"  |
| "c4a632"  | 5     | 13      | 21         | True     | "26cc98" | "2021-01-19 01:39:00.3456" |
| "e31d39"  | 2     | 10      | 21         | True     | "26cc98" | "2021-01-19 01:39:00.3456" |
| "72f5d4"  | 3     | 19      | 21         | True     | "26cc98" | "2021-01-19 01:39:00.3456" |
| "2a2353"  | 3     | 57      | 21         | True     | "26cc98" | "2021-01-19 01:39:00.3456" |
| "f084eb"  | 3     | 36      | 21         | True     | "26cc98" | "2021-01-19 01:39:00.3456" |
| "c4a632"  | 1     | 13      | 21         | False    | "ef648d" | "2021-01-27 02:18:17.1648" |

</details>


## 🧙‍♂️ Case Study Questions
<p align="center">
<img src="https://media3.giphy.com/media/JQXKbzdLTQJJKP176X/giphy.gif" width=80% height=80%>

### **A. High Level Sales Analysis**

1. What was the total quantity sold for all products?
2. What is the total generated revenue for all products before discounts?
3. What was the total discount amount for all products?


### **B. Transaction Analysis**

1. How many unique transactions were there?
2. What is the average unique products purchased in each transaction?
3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?
4. What is the average discount value per transaction?
5. What is the percentage split of all transactions for members vs non-members?
6. What is the average revenue for member transactions and non-member transactions?

### **C. Product Analysis**

1. What are the top 3 products by total revenue before discount?
2. What is the total quantity, revenue and discount for each segment?
3. What is the top selling product for each segment?
4. What is the total quantity, revenue and discount for each category?
5. What is the top selling product for each category?
6. What is the percentage split of revenue by product for each segment?
7. What is the percentage split of revenue by segment for each category?
8. What is the percentage split of total revenue by category?
9. What is the total transaction “penetration” for each product?
10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?


## 🚀 Solutions
### **A. High Level Sales Analysis**

<details>
<summary>
View solutions
</summary>

**Q1. What was the total quantity sold for all products?**
```sql
--for all products in total
SELECT 
	SUM(qty) AS sale_counts
FROM balanced_tree.sales AS sales;
```

**Result:**
| "sale_counts" |
|---------------|
| 45216         |


```sql
--for each product category
SELECT 
	details.product_name,
	SUM(sales.qty) AS sale_counts
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY sale_counts DESC;
```

**Result:**
| "product_name"                  | "sale_counts" |
|---------------------------------|---------------|
| "Grey Fashion Jacket - Womens"  | 3876          |
| "Navy Oversized Jeans - Womens" | 3856          |
| "Blue Polo Shirt - Mens"        | 3819          |
| "White Tee Shirt - Mens"        | 3800          |
| "Navy Solid Socks - Mens"       | 3792          |


**Q2. What is the total generated revenue for all products before discounts?**
```sql
--for all products in total
SELECT 
	SUM(price * qty) AS nodis_revenue
FROM balanced_tree.sales AS sales;
```

**Result:**
| "nodis_revenue" |
|-----------------|
| 1289453         |




```sql
--for each product category
SELECT 
	details.product_name,
	SUM(sales.qty * sales.price) AS nodis_revenue
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY nodis_revenue DESC;
```

**Result:**
| "product_name"                  | "nodis_revenue" |
|---------------------------------|-----------------|
| "Blue Polo Shirt - Mens"        | 217683          |
| "Grey Fashion Jacket - Womens"  | 209304          |
| "White Tee Shirt - Mens"        | 152000          |
| "Navy Solid Socks - Mens"       | 136512          |
| "Black Straight Jeans - Womens" | 121152          |



**Q3. What was the total discount amount for all products?**
```sql
SELECT 
	SUM(price * qty * discount)/100 AS total_discount
FROM balanced_tree.sales;
```

**Result:**
| "total_discount" |
|------------------|
| 156229           |


</details>

---

### **B. Transaction Analysis**

<details>
<summary>
View solutions
</summary>

**Q1. How many unique transactions were there?**

```sql
SELECT 
	COUNT (DISTINCT txn_id) AS unique_txn
FROM balanced_tree.sales;
```


**Result:**
| "unique_txn" |
|--------------|
| 2500         |





**Q2. What is the average unique products purchased in each transaction?**
```sql
WITH cte_transaction_products AS (
	SELECT
		txn_id,
		COUNT (DISTINCT prod_id) AS product_count
	FROM balanced_tree.sales
	GROUP BY txn_id
)
SELECT
	ROUND(AVG(product_count)) AS avg_unique_products
FROM cte_transaction_products;
```

**Result:**

| "avg_unique_products" |
|-----------------------|
| 6                     |



**Q3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?**
```sql
WITH cte_transaction_revenue AS (
  SELECT
    txn_id,
    SUM(qty * price) AS revenue
  FROM balanced_tree.sales
  GROUP BY txn_id
)
SELECT
   PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY revenue) AS pct_25,
   PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY revenue) AS pct_50,
   PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY revenue) AS pct_75
FROM cte_transaction_revenue;
```

**Result:**
| "pct_25" | "pct_50" | "pct_75" |
|----------|----------|----------|
| 375.75   | 509.5    | 647      |


**Q4. What is the average discount value per transaction?**
```sql
WITH cte_transaction_discounts AS (
	SELECT
		txn_id,
		SUM(price * qty * discount)/100 AS total_discount
	FROM balanced_tree.sales
	GROUP BY txn_id
)
SELECT
	ROUND(AVG(total_discount)) AS avg_unique_products
FROM cte_transaction_discounts;
```

**Result:**
| "avg_unique_products" |
|-----------------------|
| 62                    |


**Q5. What is the percentage split of all transactions for members vs non-members?**
```sql
SELECT 
	ROUND(100 * 
		  COUNT(DISTINCT CASE WHEN member = true THEN txn_id END) / 
		  COUNT(DISTINCT txn_id)
		  , 2) AS member_transaction,
	(100 - ROUND(100 * 
		  COUNT(DISTINCT CASE WHEN member = true THEN txn_id END) / 
		  COUNT(DISTINCT txn_id)
		  , 2)
	 ) AS non_member_transaction
FROM balanced_tree.sales;
```

**Result:**
| "member_transaction" | "non_member_transaction" |
|----------------------|--------------------------|
| 60.00                | 40.00                    |




**Q6. What is the average revenue for member transactions and non-member transactions?**
```sql
WITH cte_member_revenue AS (
  SELECT
    member,
    txn_id,
    SUM(price * qty) AS revenue
  FROM balanced_tree.sales
  GROUP BY 
	member, 
	txn_id
)
SELECT
  member,
  ROUND(AVG(revenue), 2) AS avg_revenue
FROM cte_member_revenue
GROUP BY member;
```

**Result:**
| "member" | "avg_revenue" |
|----------|---------------|
| False    | 515.04        |
| True     | 516.27        |



</details>

---

### **C. Product Analysis**

<details>
<summary>
View solutions
</summary>

**Q1. What are the top 3 products by total revenue before discount?**
```sql
SELECT 
	details.product_name,
	SUM(sales.qty * sales.price) AS nodis_revenue
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY nodis_revenue DESC
LIMIT 3;
```

**Result:**
| "product_name"                 | "nodis_revenue" |
|--------------------------------|-----------------|
| "Blue Polo Shirt - Mens"       | 217683          |
| "Grey Fashion Jacket - Womens" | 209304          |
| "White Tee Shirt - Mens"       | 152000          |




**Q2. What is the total quantity, revenue and discount for each segment?**
```sql
SELECT 
	details.segment_id,
	details.segment_name,
	SUM(sales.qty) AS total_quantity,
	SUM(sales.qty * sales.price) AS total_revenue,
	SUM(sales.qty * sales.price * sales.discount)/100 AS total_discount
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY 
	details.segment_id,
	details.segment_name
ORDER BY total_revenue DESC;
```

**Result:**
| "category_name" | "segment_name" | "category_segment_percentage" |
|-----------------|----------------|-------------------------------|
| "Womens"        | "Jacket"       | 63.79                         |
| "Womens"        | "Jeans"        | 36.21                         |
| "Mens"          | "Shirt"        | 56.87                         |
| "Mens"          | "Socks"        | 43.13                         |



**Q3. What is the top selling product for each segment?**
```sql
SELECT 
	details.segment_id,
	details.segment_name,
	details.product_id,
	details.product_name,
	SUM(sales.qty) AS product_quantity
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY
	details.segment_id,
	details.segment_name,
	details.product_id,
	details.product_name
ORDER BY product_quantity DESC
--Limit to the top 5 best selling products
LIMIT 5;
```

**Result:**
| "segment_id" | "segment_name" | "product_id" | "product_name"                  | "product_quantity" |
|--------------|----------------|--------------|---------------------------------|--------------------|
| 4            | "Jacket"       | "9ec847"     | "Grey Fashion Jacket - Womens"  | 3876               |
| 3            | "Jeans"        | "c4a632"     | "Navy Oversized Jeans - Womens" | 3856               |
| 5            | "Shirt"        | "2a2353"     | "Blue Polo Shirt - Mens"        | 3819               |
| 5            | "Shirt"        | "5d267b"     | "White Tee Shirt - Mens"        | 3800               |
| 6            | "Socks"        | "f084eb"     | "Navy Solid Socks - Mens"       | 3792               |



**Q4. What is the total quantity, revenue and discount for each category?**
```sql
SELECT 
	details.category_id,
	details.category_name,
	SUM(sales.qty) AS total_quantity,
	SUM(sales.qty * sales.price) AS total_revenue,
	SUM(sales.qty * sales.price * sales.discount)/100 AS total_discount
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY 
	details.category_id,
	details.category_name
ORDER BY total_revenue DESC;
```

**Result:**
| "category_id" | "category_name" | "total_quantity" | "total_revenue" | "total_discount" |
|---------------|-----------------|------------------|-----------------|------------------|
| 2             | "Mens"          | 22482            | 714120          | 86607            |
| 1             | "Womens"        | 22734            | 575333          | 69621            |



**Q5. What is the top selling product for each category?**
```sql
SELECT 
	details.category_id,
	details.category_name,
	details.product_id,
	details.product_name,
	SUM(sales.qty) AS product_quantity
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY
	details.category_id,
	details.category_name,
	details.product_id,
	details.product_name
ORDER BY product_quantity DESC
--Limit to the top 5 best selling products
LIMIT 5;
```

**Result:**
| "category_id" | "category_name" | "product_id" | "product_name"                  | "product_quantity" |
|---------------|-----------------|--------------|---------------------------------|--------------------|
| 1             | "Womens"        | "9ec847"     | "Grey Fashion Jacket - Womens"  | 3876               |
| 1             | "Womens"        | "c4a632"     | "Navy Oversized Jeans - Womens" | 3856               |
| 2             | "Mens"          | "2a2353"     | "Blue Polo Shirt - Mens"        | 3819               |
| 2             | "Mens"          | "5d267b"     | "White Tee Shirt - Mens"        | 3800               |
| 2             | "Mens"          | "f084eb"     | "Navy Solid Socks - Mens"       | 3792               |



**Q6. What is the percentage split of revenue by product for each segment?**
```sql
WITH cte_product_revenue AS (
  SELECT
    product_details.segment_id,
    product_details.segment_name,
    product_details.product_id,
    product_details.product_name,
    SUM(sales.qty * sales.price) AS product_revenue
  FROM balanced_tree.sales
  INNER JOIN balanced_tree.product_details
    ON sales.prod_id = product_details.product_id
  GROUP BY
    product_details.segment_id,
    product_details.segment_name,
    product_details.product_id,
    product_details.product_name
)
SELECT
	segment_name,
	product_name,
	ROUND(
    100 * product_revenue /
      SUM(product_revenue) OVER (
        PARTITION BY segment_id),
    	2) AS segment_product_percentage
FROM cte_product_revenue
ORDER BY
	segment_id,
	segment_product_percentage DESC;
```

**Result:**

| "segment_name" | "product_name"                     | "segment_product_percentage" |
|----------------|------------------------------------|------------------------------|
| "Jeans"        | "Black Straight Jeans - Womens"    | 58.15                        |
| "Jeans"        | "Navy Oversized Jeans - Womens"    | 24.06                        |
| "Jeans"        | "Cream Relaxed Jeans - Womens"     | 17.79                        |
| "Jacket"       | "Grey Fashion Jacket - Womens"     | 57.03                        |
| "Jacket"       | "Khaki Suit Jacket - Womens"       | 23.51                        |
| "Jacket"       | "Indigo Rain Jacket - Womens"      | 19.45                        |
| "Shirt"        | "Blue Polo Shirt - Mens"           | 53.60                        |
| "Shirt"        | "White Tee Shirt - Mens"           | 37.43                        |
| "Shirt"        | "Teal Button Up Shirt - Mens"      | 8.98                         |
| "Socks"        | "Navy Solid Socks - Mens"          | 44.33                        |
| "Socks"        | "Pink Fluro Polkadot Socks - Mens" | 35.50                        |
| "Socks"        | "White Striped Socks - Mens"       | 20.18                        |



**Q7. What is the percentage split of revenue by segment for each category?**
```sql
WITH cte_product_revenue AS (
  SELECT
    product_details.segment_id,
    product_details.segment_name,
    product_details.category_id,
    product_details.category_name,
    SUM(sales.qty * sales.price) AS product_revenue
  FROM balanced_tree.sales
  INNER JOIN balanced_tree.product_details
    ON sales.prod_id = product_details.product_id
  GROUP BY
    product_details.segment_id,
    product_details.segment_name,
    product_details.category_id,
    product_details.category_name
)
SELECT
	category_name,
	segment_name,
	ROUND(
    100 * product_revenue /
      SUM(product_revenue) OVER (
        PARTITION BY category_id),
    	2) AS category_segment_percentage
FROM cte_product_revenue
ORDER BY
	category_id,
	category_segment_percentage DESC;
```

**Result:**
| "category_name" | "segment_name" | "category_segment_percentage" |
|-----------------|----------------|-------------------------------|
| "Womens"        | "Jacket"       | 63.79                         |
| "Womens"        | "Jeans"        | 36.21                         |
| "Mens"          | "Shirt"        | 56.87                         |
| "Mens"          | "Socks"        | 43.13                         |


**Q8. What is the percentage split of total revenue by category?**
```sql
SELECT 
   ROUND(100 * SUM(CASE WHEN details.category_id = 1 THEN (sales.qty * sales.price) END) / 
		 SUM(qty * sales.price),
		 2) AS category_1,
   (100 - ROUND(100 * SUM(CASE WHEN details.category_id = 1 THEN (sales.qty * sales.price) END) / 
		 SUM(sales.qty * sales.price),
		 2)
	) AS category_2
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
```

**Result:**
| "category_1" | "category_2" |
|--------------|--------------|
| 44.00        | 56.00        |



**Q9. What is the total transaction “penetration” for each product?**
```sql
WITH product_transactions AS (
  SELECT 
	DISTINCT prod_id,
    COUNT(DISTINCT txn_id) AS product_transactions
  FROM balanced_tree.sales
  GROUP BY prod_id
),
total_transactions AS (
  SELECT
    COUNT(DISTINCT txn_id) AS total_transaction_count
  FROM balanced_tree.sales
)
SELECT
  product_details.product_id,
  product_details.product_name,
  ROUND(
    100 * product_transactions.product_transactions::NUMERIC
      / total_transactions.total_transaction_count,
    2
  ) AS penetration_percentage
FROM product_transactions
CROSS JOIN total_transactions
INNER JOIN balanced_tree.product_details
  ON product_transactions.prod_id = product_details.product_id
ORDER BY penetration_percentage DESC;
```

**Result:**
| "product_id" | "product_name"                     | "penetration_percentage" |
|--------------|------------------------------------|--------------------------|
| "f084eb"     | "Navy Solid Socks - Mens"          | 51.24                    |
| "9ec847"     | "Grey Fashion Jacket - Womens"     | 51.00                    |
| "c4a632"     | "Navy Oversized Jeans - Womens"    | 50.96                    |
| "5d267b"     | "White Tee Shirt - Mens"           | 50.72                    |
| "2a2353"     | "Blue Polo Shirt - Mens"           | 50.72                    |
| "2feb6b"     | "Pink Fluro Polkadot Socks - Mens" | 50.32                    |
| "72f5d4"     | "Indigo Rain Jacket - Womens"      | 50.00                    |
| "d5e9a6"     | "Khaki Suit Jacket - Womens"       | 49.88                    |
| "e83aa3"     | "Black Straight Jeans - Womens"    | 49.84                    |
| "e31d39"     | "Cream Relaxed Jeans - Womens"     | 49.72                    |
| "b9a74d"     | "White Striped Socks - Mens"       | 49.72                    |
| "c8d436"     | "Teal Button Up Shirt - Mens"      | 49.68                    |



**Q10.  What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?**
```sql
-- step 1: check the product_counter...
DROP TABLE IF EXISTS temp_product_combos;
CREATE TEMP TABLE temp_product_combos AS
WITH RECURSIVE input(product) AS (
  SELECT product_id::TEXT FROM balanced_tree.product_details
),
output_table AS (
   SELECT 
    ARRAY[product] AS combo,
    product,
    1 AS product_counter
   FROM input
  
   UNION ALL  -- important to remove duplicates!

   SELECT
    ARRAY_APPEND(output_table.combo, input.product),
    input.product,
    product_counter + 1
   FROM output_table
   INNER JOIN input ON input.product > output_table.product
   WHERE output_table.product_counter <= 2
   )
SELECT * from output_table
WHERE product_counter = 2;

-- step 2
WITH cte_transaction_products AS (
  SELECT
    txn_id,
    ARRAY_AGG(prod_id::TEXT ORDER BY prod_id) AS products
  FROM balanced_tree.sales
  GROUP BY txn_id
),
-- step 3
cte_combo_transactions AS (
  SELECT
    txn_id,
    combo,
    products
  FROM cte_transaction_products
  CROSS JOIN temp_product_combos  -- previously created temp table above!
  WHERE combo <@ products  -- combo is contained in products
),
-- step 4
cte_ranked_combos AS (
  SELECT
    combo,
    COUNT(DISTINCT txn_id) AS transaction_count,
    RANK() OVER (ORDER BY COUNT(DISTINCT txn_id) DESC) AS combo_rank,
    ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT txn_id) DESC) AS combo_id
  FROM cte_combo_transactions
  GROUP BY combo
),
-- step 5
cte_most_common_combo_product_transactions AS (
  SELECT
    cte_combo_transactions.txn_id,
    cte_ranked_combos.combo_id,
    UNNEST(cte_ranked_combos.combo) AS prod_id
  FROM cte_combo_transactions
  INNER JOIN cte_ranked_combos
    ON cte_combo_transactions.combo = cte_ranked_combos.combo
  WHERE cte_ranked_combos.combo_rank = 1
)
-- step 6
SELECT
  product_details.product_id,
  product_details.product_name,
  COUNT(DISTINCT sales.txn_id) AS combo_transaction_count,
  SUM(sales.qty) AS quantity,
  SUM(sales.qty * sales.price) AS revenue,
  ROUND(
    SUM(sales.qty * sales.price * sales.discount / 100),
    2
  ) AS discount,
  ROUND(
    SUM(sales.qty * sales.price * (1 - sales.discount / 100)),
    2
  ) AS net_revenue
FROM balanced_tree.sales
INNER JOIN cte_most_common_combo_product_transactions AS top_combo
  ON sales.txn_id = top_combo.txn_id
  AND sales.prod_id = top_combo.prod_id
INNER JOIN balanced_tree.product_details
  ON sales.prod_id = product_details.product_id
GROUP BY 
	product_details.product_id, 
	product_details.product_name;
```

**Result:**
| "product_id" | "product_name"                 | "combo_transaction_count" | "quantity" | "revenue" | "discount" | "net_revenue" |
|--------------|--------------------------------|---------------------------|------------|-----------|------------|---------------|
| "2a2353"     | "Blue Polo Shirt - Mens"       | 670                       | 2011       | 114627    | 13618.00   | 114627.00     |
| "9ec847"     | "Grey Fashion Jacket - Womens" | 670                       | 2047       | 110538    | 13025.00   | 110538.00     |

</details>

---
<p>&copy; 2021 Leah Nguyen</p>
