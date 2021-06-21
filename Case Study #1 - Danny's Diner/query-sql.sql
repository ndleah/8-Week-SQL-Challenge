/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- 1. What is the total amount each customer spent at the restaurant?
SELECT 
	sales.customer_id,
  SUM(menu.price) AS total_spent
FROM dannys_diner.sales
JOIN dannys_diner.menu
	ON sales.product_id = menu.product_id
GROUP BY customer_id
ORDER BY customer_id;

--Result:
+──────────────+──────────────+
| customer_id  | total_spent  |
+──────────────+──────────────+
| A            | 76           |
| B            | 74           |
| C            | 36           |
+──────────────+──────────────+

-- 2. How many days has each customer visited the restaurant?
SELECT
  customer_id,
  COUNT (DISTINCT order_date) AS visited_days
FROM dannys_diner.sales
GROUP BY customer_id;

--Result:
+──────────────+───────────────+
| customer_id  | visited_days  |
+──────────────+───────────────+
| A            | 4             |
| B            | 6             |
| C            | 2             |
+──────────────+───────────────+

-- 3. What was the first item from the menu purchased by each customer?
WITH cte_order AS (
  SELECT
    sales.customer_id,
    menu.product_name,
    ROW_NUMBER() OVER(
     PARTITION BY sales.customer_id
      ORDER BY 
        sales.order_date,  
        sales.product_id
    ) AS item_order
    FROM dannys_diner.sales
    JOIN dannys_diner.menu
    ON sales.product_id = menu.product_id
)
SELECT * FROM cte_order
WHERE item_order = 1;

--Result:
+──────────────+───────────────+─────────────+
| customer_id  | product_name  | item_order  |
+──────────────+───────────────+─────────────+
| A            | sushi         | 1           |
| B            | curry         | 1           |
| C            | ramen         | 1           |
+──────────────+───────────────+─────────────+

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT
  menu.product_name,
  COUNT(sales.product_id) AS order_count
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
GROUP BY
  menu.product_name
ORDER BY order_count DESC
LIMIT 1;

--Result:
+─────────────+───────────────+──────────────+
| product_id  | product_name  | order_count  |
+─────────────+───────────────+──────────────+
| 3           | ramen         | 8            |
+─────────────+───────────────+──────────────+

-- 5. Which item was the most popular for each customer?
WITH cte_order_count AS (
  SELECT
    sales.customer_id,
    menu.product_name,
    COUNT(*) as order_count
  FROM dannys_diner.sales
  JOIN dannys_diner.menu
    ON sales.product_id = menu.product_id
  GROUP BY 
    customer_id,
    product_name
  ORDER BY
    customer_id,
    order_count DESC
),
cte_popular_rank AS (
  SELECT 
    *,
    RANK() OVER(PARTITION BY customer_id ORDER BY order_count DESC) AS rank
  FROM cte_order_count
)
SELECT * FROM cte_popular_rank
WHERE rank = 1;

--Result:
+──────────────+───────────────+──────────────+───────+
| customer_id  | product_name  | order_count  | rank  |
+──────────────+───────────────+──────────────+───────+
| A            | ramen         | 3            | 1     |
| B            | ramen         | 2            | 1     |
| B            | curry         | 2            | 1     |
| B            | sushi         | 2            | 1     |
| C            | ramen         | 3            | 1     |
+──────────────+───────────────+──────────────+───────+


-- Before answering question 6-10, I created a membership_validation table to validate only those customers joining in the membership program:
DROP TABLE IF EXISTS membership_validation;
CREATE TEMP TABLE membership_validation AS
SELECT
   sales.customer_id,
   sales.order_date,
   menu.product_name,
   menu.price,
   members.join_date,
   CASE WHEN sales.order_date >= members.join_date
     THEN 'X'
     ELSE ''
     END AS membership
FROM dannys_diner.sales
 INNER JOIN dannys_diner.menu
   ON sales.product_id = menu.product_id
 LEFT JOIN dannys_diner.members
   ON sales.customer_id = members.customer_id
  WHERE join_date IS NOT NULL
  ORDER BY 
    customer_id,
    order_date;

-- 6. Which item was purchased first by the customer after they became a member?
--Note: In this question, the orders made during the join date are counted within the first order as well
WITH cte_first_after_mem AS (
  SELECT 
    customer_id,
    product_name,
  	order_date,
    RANK() OVER(
    PARTITION BY customer_id
    ORDER BY order_date) AS purchase_order
  FROM membership_validation
  WHERE membership = 'X'
)
SELECT * FROM cte_first_after_mem
WHERE purchase_order = 1;

--Result:
+──────────────+───────────────+───────────────────────────+─────────────────+
| customer_id  | product_name  | order_date                | purchase_order  |
+──────────────+───────────────+───────────────────────────+─────────────────+
| A            | curry         | 2021-01-07T00:00:00.000Z  | 1               |
| B            | sushi         | 2021-01-11T00:00:00.000Z  | 1               |
+──────────────+───────────────+───────────────────────────+─────────────────+

-- 7. Which item was purchased just before the customer became a member?
WITH cte_last_before_mem AS (
  SELECT 
    customer_id,
    product_name,
  	order_date,
    RANK() OVER(
    PARTITION BY customer_id
    ORDER BY order_date DESC) AS purchase_order
  FROM membership_validation
  WHERE membership = ''
)
SELECT * FROM cte_last_before_mem
--since we used the ORDER BY DESC in the query above, the order 1 would mean the last date before the customer join in the membership
WHERE purchase_order = 1;

--Result:
+──────────────+───────────────+───────────────────────────+─────────────────+
| customer_id  | product_name  | order_date                | purchase_order  |
+──────────────+───────────────+───────────────────────────+─────────────────+
| A            | sushi         | 2021-01-01T00:00:00.000Z  | 1               |
| A            | curry         | 2021-01-01T00:00:00.000Z  | 1               |
| B            | sushi         | 2021-01-04T00:00:00.000Z  | 1               |
+──────────────+───────────────+───────────────────────────+─────────────────+

-- 8. What is the total items and amount spent for each member before they became a member?
WITH cte_spent_before_mem AS (
  SELECT 
    customer_id,
    product_name,
    price
  FROM membership_validation
  WHERE membership = ''
)
SELECT 
	customer_id,
  SUM(price) AS total_spent,
  COUNT(*) AS total_items
FROM cte_spent_before_mem
GROUP BY customer_id
ORDER BY customer_id;

--Result:
+──────────────+──────────────+──────────────+
| customer_id  | total_spent  | total_items  |
+──────────────+──────────────+──────────────+
| A            | 25           | 2            |
| B            | 40           | 3            |
+──────────────+──────────────+──────────────+

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT
  customer_id,
  SUM(
  CASE WHEN product_name = 'sushi'
  THEN (price * 20)
  ELSE (price * 10)
  END
  ) AS total_points
FROM membership_validation
GROUP BY customer_id
ORDER BY customer_id;

--Result:
+──────────────+───────────────+
| customer_id  | total_points  |
+──────────────+───────────────+
| A            | 860           |
| B            | 940           |
+──────────────+───────────────+

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
--create temp table for days validation within the first week membership
DROP TABLE IF EXISTS membership_first_week_validation;
CREATE TEMP TABLE membership_first_week_validation AS 
WITH cte_valid AS (
SELECT
  customer_id,
  order_date,
  product_name,
  price,
  COUNT(*) AS order_count,
  CASE WHEN order_date BETWEEN join_date AND (join_date + 6)
  THEN 'X'
  ELSE ''
  END AS within_first_week
FROM membership_validation
GROUP BY 
	customer_id,
  order_date,
  product_name,
  price,
  join_date
 ORDER BY
 	customer_id,
  order_date
)
SELECT * FROM cte_valid
WHERE order_date < '2021-02-01';
--inspect the table result
SELECT * FROM membership_first_week_validation;

--Result:
+──────────────+───────────────────────────+───────────────+────────+──────────────+────────────────────+
| customer_id  | order_date                | product_name  | price  | order_count  | within_first_week  |
+──────────────+───────────────────────────+───────────────+────────+──────────────+────────────────────+
| A            | 2021-01-01T00:00:00.000Z  | curry         | 15     | 1            |                    |
| A            | 2021-01-01T00:00:00.000Z  | sushi         | 10     | 1            |                    |
| A            | 2021-01-07T00:00:00.000Z  | curry         | 15     | 1            | X                  |
| A            | 2021-01-10T00:00:00.000Z  | ramen         | 12     | 1            | X                  |
| A            | 2021-01-11T00:00:00.000Z  | ramen         | 12     | 2            | X                  |
| B            | 2021-01-01T00:00:00.000Z  | curry         | 15     | 1            |                    |
| B            | 2021-01-02T00:00:00.000Z  | curry         | 15     | 1            |                    |
| B            | 2021-01-04T00:00:00.000Z  | sushi         | 10     | 1            |                    |
| B            | 2021-01-11T00:00:00.000Z  | sushi         | 10     | 1            | X                  |
| B            | 2021-01-16T00:00:00.000Z  | ramen         | 12     | 1            |                    |
+──────────────+───────────────────────────+───────────────+────────+──────────────+────────────────────+

--create temp table for points calculation only in the first week of membership
DROP TABLE IF EXISTS membership_first_week_points;
CREATE TEMP TABLE membership_first_week_points AS 
WITH cte_first_week_count AS (
  SELECT * FROM membership_first_week_validation
  WHERE within_first_week = 'X'
)
SELECT
  customer_id,
  SUM(
  CASE WHEN within_first_week = 'X'
  THEN (price * order_count * 20)
  ELSE (price * order_count * 10)
  END
  ) AS total_points
FROM cte_first_week_count
GROUP BY customer_id;
--inspect table results
SELECT * FROM membership_first_week_points;

--Result:
+──────────────+───────────────+
| customer_id  | total_points  |
+──────────────+───────────────+
| A            | 1020          |
| B            | 200           |
+──────────────+───────────────+

--create temp table for points calculation excluded the first week membership (before membership + after the first week membership)
DROP TABLE IF EXISTS membership_non_first_week_points;
CREATE TEMP TABLE membership_non_first_week_points AS 
WITH cte_first_week_count AS (
  SELECT * FROM membership_first_week_validation
  WHERE within_first_week = ''
)
SELECT
  customer_id,
  SUM(
  CASE WHEN product_name = 'sushi'
  THEN (price * order_count * 20)
  ELSE (price * order_count * 10)
  END
  ) AS total_points
FROM cte_first_week_count
GROUP BY customer_id;
--inspect table results
SELECT * FROM membership_non_first_week_points;

--Result:
+──────────────+───────────────+
| customer_id  | total_points  |
+──────────────+───────────────+
| A            | 350           |
| B            | 620           |
+──────────────+───────────────+


--perform table union to aggregate our points value from both point calculation tables, then use SUM aggregate function to get our result
WITH cte_union AS (
  SELECT * FROM membership_first_week_points
  UNION
  SELECT * FROM membership_non_first_week_points
)
SELECT
  customer_id,
  SUM(total_points)
FROM cte_union
GROUP BY customer_id
ORDER BY customer_id;

--Result:
+──────────────+──────+
| customer_id  | SUM  |
+──────────────+──────+
| A            | 1370 |
| B            | 820  |
+──────────────+──────+
