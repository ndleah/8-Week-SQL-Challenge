/**************************
A. Customer Nodes Exploration
**************************/
--1. How many unique nodes are there on the Data Bank system?
SELECT COUNT(DISTINCT node_id) AS node_counts
FROM data_bank.customer_nodes;

--Result:
+───────────────+
| "node_count"  |
+───────────────+
| 5             |
+───────────────+

--2. What is the number of nodes per region?
SELECT
	regions.region_name,
	COUNT(DISTINCT customer_nodes.node_id) AS node_counts
FROM data_bank.regions
INNER JOIN data_bank.customer_nodes
ON regions.region_id = customer_nodes.region_id
GROUP BY regions.region_name;

--Result:
+────────────────+────────────────+
| "region_name"  | "node_counts"  |
+────────────────+────────────────+
| "Africa"       | 5              |
| "America"      | 5              |
| "Asia"         | 5              |
| "Australia"    | 5              |
| "Europe"       | 5              |
+────────────────+────────────────+

--3. How many customers are allocated to each region?
SELECT
	regions.region_name,
	COUNT(DISTINCT customer_nodes.customer_id) AS customer_counts
FROM data_bank.regions
INNER JOIN data_bank.customer_nodes
ON regions.region_id = customer_nodes.region_id
GROUP BY regions.region_name;

--Result:
| "region_name" | "customer_counts" |
|---------------|-------------------|
| "Africa"      | 102               |
| "America"     | 105               |
| "Asia"        | 95                |
| "Australia"   | 110               |
| "Europe"      | 88                |

--4. How many days on average are customers reallocated to a different node?


--5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
