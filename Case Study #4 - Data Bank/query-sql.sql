/**************************
CASE STUDY #4 - Data Bank
***************************/

/**************************
A. Customer Nodes Exploration
**************************/

--1. How many unique nodes are there on the Data Bank system?
SELECT COUNT(DISTINCT node_id) AS node_counts
FROM data_bank.customer_nodes;

--2. What is the number of nodes per region?
SELECT
	regions.region_name,
	COUNT(DISTINCT customer_nodes.node_id) AS node_counts
FROM data_bank.regions
INNER JOIN data_bank.customer_nodes
ON regions.region_id = customer_nodes.region_id
GROUP BY regions.region_name;


--3. How many customers are allocated to each region?
SELECT
	regions.region_name,
	COUNT(DISTINCT customer_nodes.customer_id) AS customer_counts
FROM data_bank.regions
INNER JOIN data_bank.customer_nodes
ON regions.region_id = customer_nodes.region_id
GROUP BY regions.region_name;


--4. How many days on average are customers reallocated to a different node?


--5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

/**************************
B. Customer Transactions
**************************/

/**************************
B. Customer Transactions
**************************/

--1. What is the unique count and total amount for each transaction type?
SELECT 
	txn_type,
	COUNT(txn_type) AS unique_count,
	SUM(txn_amount) AS total_amount
FROM data_bank.customer_transactions
GROUP BY txn_type;

--2. What is the average total historical deposit counts and amounts for all customers?
WITH cte_deposit AS (
	SELECT 
		customer_id,
		COUNT(txn_type) AS deposit_count,
		SUM(txn_amount) AS deposit_amount
	FROM data_bank.customer_transactions
	WHERE txn_type = 'deposit'
	GROUP BY customer_id
)
SELECT 
	AVG(deposit_count) AS avg_deposit_count,
	AVG(deposit_amount) AS avg_deposit_amount
FROM cte_deposit;

--3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
WITH cte_customer AS (
	SELECT
		EXTRACT(MONTH FROM txn_date) AS month_part,
		TO_CHAR(txn_date, 'Month') AS month,
		customer_id,
		SUM(CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS deposit_count,
		SUM(CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END) AS purchase_count,
		SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS withdrawal_count
	FROM data_bank.customer_transactions
	GROUP BY
		EXTRACT(MONTH FROM txn_date),
		TO_CHAR(txn_date, 'Month'),
		customer_id
)
SELECT 
	month,
	COUNT(customer_id) AS customer_count
FROM cte_customer
WHERE deposit_count > 1 AND (purchase_count >= 1 OR withdrawal_count >= 1)
GROUP BY 
	month_part,
	month
ORDER BY month_part;


--4. What is the closing balance for each customer at the end of the month?
--5. What is the percentage of customers who increase their closing balance by more than 5%? 