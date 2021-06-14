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

/*Result:
| customer_id | total_spent |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |
*/

-- 2. How many days has each customer visited the restaurant?
SELECT
  customer_id,
  COUNT (DISTINCT order_date) AS visited_days
FROM dannys_diner.sales
GROUP BY customer_id;

/*Result:
|customer_id|visited_days|
|-----------|------------|
|A          |4           |
|B          |6           |
|C          |2           |
*/

-- 3. What was the first item from the menu purchased by each customer?
WITH cte_order AS (
  SELECT
    sales.customer_id,
    menu.product_name,
    ROW_NUMBER() OVER(
      PARTITION BY sales.customer_id
      ORDER BY 
        sales.customer_id,
        sales.order_date) AS item_order
  FROM dannys_diner.sales
  JOIN dannys_diner.menu
    ON sales.product_id = menu.product_id
  )
SELECT * FROM cte_order
WHERE item_order = 1;

/*Result:
|customer_id|product_name|item_order|
|-----------|------------|----------|
|A          |sushi       |1         |
|B          |curry       |1         |
|C          |ramen       |1         |
*/

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

/*Result:
|product_id|product_name|order_count|
|----------|------------|-----------|
|3         |ramen       |8          |
*/


-- 5. Which item was the most popular for each customer?
DROP TABLE IF EXISTS customer_order_count;
CREATE TEMP TABLE customer_order_count AS 
WITH cte_customer_rank AS (
  SELECT
    sales.customer_id,
    menu.product_name,
    COUNT(menu.*) AS order_count
  FROM dannys_diner.sales
  JOIN dannys_diner.menu
    ON sales.product_id = menu.product_id
  GROUP BY 
    sales.customer_id,
    menu.product_name
  ORDER BY 
    customer_id,
    order_count DESC
  )
SELECT 
  customer_id,
  product_name,
  ROW_NUMBER() OVER(
    PARTITION BY customer_id
    ORDER BY 
      customer_id,
      order_count DESC) AS item_rank
FROM cte_customer_rank;

--select only the most purchased item by each customer by sorting item_rank = 1
SELECT
  customer_id,
  product_name,
  item_rank
FROM customer_order_count
WHERE item_rank = 1;

/*Result:
|customer_id|product_name|item_rank|
|-----------|------------|---------|
|A          |ramen       |1        |
|B          |ramen       |1        |
|C          |ramen       |1        |
*/

-- 6. Which item was purchased first by the customer after they became a member?
DROP TABLE IF EXISTS after_membership_sales;
CREATE TEMP TABLE after_membership_sales AS
WITH cte_rank AS (
  SELECT
    sales.customer_id,
    sales.order_date,
    menu.product_name,
    members.join_date,
    CASE WHEN sales.order_date >= members.join_date 
    THEN 'X' 
    ELSE ''
    END AS membership_validation
  FROM dannys_diner.sales
  INNER JOIN dannys_diner.menu
   ON sales.product_id = menu.product_id
  LEFT JOIN dannys_diner.members
    ON sales.customer_id = members.customer_id
  )
SELECT * FROM cte_rank;
--UPDATING
SELECT * FROM after_membership_sales;

-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
