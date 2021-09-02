/**************************
CASE STUDY #7 - Balanced Tree Clothing Co.
***************************/


/**************************
A. High Level Sales Analysis
***************************/

--1. What was the total quantity sold for all products?
--for all products in total
SELECT 
	SUM(qty) AS sale_counts
FROM balanced_tree.sales AS sales;
--for each product category
SELECT 
	details.product_name,
	SUM(sales.qty) AS sale_counts
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY sale_counts DESC;

--2. What is the total generated revenue for all products before discounts?
--for all products in total
SELECT 
	SUM(price * qty) AS nodis_revenue
FROM balanced_tree.sales AS sales;
--for each product category
SELECT 
	details.product_name,
	SUM(sales.qty * sales.price) AS nodis_revenue
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY nodis_revenue DESC;

--3. What was the total discount amount for all products?
SELECT 
	SUM(price * qty * discount)/100 AS total_discount
FROM balanced_tree.sales;

/**************************
--B. Transaction Analysis
***************************/

--1. How many unique transactions were there?
SELECT 
	COUNT (DISTINCT txn_id) AS unique_txn
FROM balanced_tree.sales;

--2. What is the average unique products purchased in each transaction?
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

--3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?
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

--4. What is the average discount value per transaction?
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

--5. What is the percentage split of all transactions for members vs non-members?
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

--6. What is the average revenue for member transactions and non-member transactions?
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

/**************************
c. Product Analysis
***************************/

--1. What are the top 3 products by total revenue before discount?
SELECT 
	details.product_name,
	SUM(sales.qty * sales.price) AS nodis_revenue
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY nodis_revenue DESC
LIMIT 3;

--2. What is the total quantity, revenue and discount for each segment?
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

--3. What is the top selling product for each segment?
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

--4. What is the total quantity, revenue and discount for each category?
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

--5. What is the top selling product for each category?
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

--6. What is the percentage split of revenue by product for each segment?
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

--7. What is the percentage split of revenue by segment for each category?
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

--8. What is the percentage split of total revenue by category?
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

--9. What is the total transaction “penetration” for each product? 
/* penetration = number of transactions where at least 1 quantity 
	of a product was purchased divided by total number of transactions */
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

--10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
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
