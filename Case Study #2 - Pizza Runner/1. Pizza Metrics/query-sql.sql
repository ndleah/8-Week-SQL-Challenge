/* --------------------
   Case Study Questions:
   Pizza Metrics
   --------------------*/

-- 1. How many pizzas were ordered?
-- 2. How many unique customer orders were made?
-- 3. How many successful orders were delivered by each runner?
-- 4. How many of each type of pizza was delivered?
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
-- 6. What was the maximum number of pizzas delivered in a single order?
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- 8. How many pizzas were delivered that had both exclusions and extras?
-- 9. What was the total volume of pizzas ordered for each hour of the day?
-- 10. What was the volume of orders for each day of the week?

-- 1. How many pizzas were ordered?
SELECT COUNT(*) AS pizza_count
FROM updated_customer_orders;

--Result:
+──────────────+
| pizza_count  |
+──────────────+
| 14           |
+──────────────+

-- 2. How many unique customer orders were made?
SELECT COUNT (DISTINCT order_id) AS order_count
FROM updated_customer_orders;

--Result:
+──────────────+
| order_count  |
+──────────────+
| 10           |
+──────────────+

-- 3. How many successful orders were delivered by each runner?
SELECT
  runner_id,
  COUNT(order_id) AS successful_orders
FROM updated_runner_orders
WHERE cancellation IS NULL
OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY runner_id
ORDER BY successful_orders DESC;

--Result:
+────────────+────────────────────+
| runner_id  | successful_orders  |
+────────────+────────────────────+
| 1          | 4                  |
| 2          | 3                  |
| 3          | 1                  |
+────────────+────────────────────+

-- 4. How many of each type of pizza was delivered?
SELECT
  pn.pizza_name,
  COUNT(co.*) AS pizza_type_count
FROM updated_customer_orders AS co
INNER JOIN pizza_runner.pizza_names AS pn
   ON co.pizza_id = pn.pizza_id
INNER JOIN pizza_runner.runner_orders AS ro
   ON co.order_id = ro.order_id
WHERE cancellation IS NULL
OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY pn.pizza_name
ORDER BY pn.pizza_name;

--OR
SELECT
  pn.pizza_name,
  COUNT(co.*) AS pizza_type_count
FROM updated_customer_orders AS co
INNER JOIN pizza_runner.pizza_names AS pn
   ON co.pizza_id = pn.pizza_id
WHERE EXISTS (
  SELECT 1 FROM updated_runner_orders AS ro
   WHERE ro.order_id = co.order_id
   AND (
    ro.cancellation IS NULL
    OR ro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
  )
)
GROUP BY pn.pizza_name
ORDER BY pn.pizza_name;

--Result:
+─────────────+───────────────────+
| pizza_name  | pizza_type_count  |
+─────────────+───────────────────+
| Meatlovers  | 9                 |
| Vegetarian  | 3                 |
+─────────────+───────────────────+

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT
  customer_id,
  SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS meat_lovers,
  SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS vegetarian
FROM updated_customer_orders
GROUP BY customer_id;

--Result:
+──────────────+──────────────+─────────────+
| customer_id  | meat_lovers  | vegetarian  |
+──────────────+──────────────+─────────────+
| 101          | 2            | 1           |
| 103          | 3            | 1           |
| 104          | 3            | 0           |
| 105          | 0            | 1           |
| 102          | 2            | 1           |
+──────────────+──────────────+─────────────+

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT MAX(pizza_count) AS max_count
FROM (
  SELECT
    co.order_id,
    COUNT(co.pizza_id) AS pizza_count
  FROM updated_customer_orders AS co
  INNER JOIN updated_runner_orders AS ro
    ON co.order_id = ro.order_id
  WHERE 
    ro.cancellation IS NULL
    OR ro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
  GROUP BY co.order_id) AS mycount;
  
--Result:
+────────────+
| max_count  |
+────────────+
| 3          |
+────────────+

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
  co.customer_id,
  SUM (CASE WHEN co.exclusions IS NOT NULL OR co.extras IS NOT NULL THEN 1 ELSE 0 END) AS changes,
  SUM (CASE WHEN co.exclusions IS NULL OR co.extras IS NULL THEN 1 ELSE 0 END) AS no_change
FROM updated_customer_orders AS co
INNER JOIN updated_runner_orders AS ro
  ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
  OR ro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY co.customer_id
ORDER BY co.customer_id;

--Result:
+──────────────+──────────+────────────+
| customer_id  | changes  | no_change  |
+──────────────+──────────+────────────+
| 101          | 0        | 2          |
| 102          | 0        | 3          |
| 103          | 3        | 3          |
| 104          | 2        | 2          |
| 105          | 1        | 1          |
+──────────────+──────────+────────────+

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT
  SUM(CASE WHEN co.exclusions IS NOT NULL AND co.extras IS NOT NULL THEN 1 ELSE 0 END) as pizza_count
FROM updated_customer_orders AS co
INNER JOIN updated_runner_orders AS ro
  ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
  OR ro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
  
--Result:
+──────────────+
| pizza_count  |
+──────────────+
| 1            |
+──────────────+

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT
  DATE_PART('hour', order_time::TIMESTAMP) AS hour_of_day,
  COUNT(*) AS pizza_count
FROM updated_customer_orders
WHERE order_time IS NOT NULL
GROUP BY hour_of_day
ORDER BY hour_of_day;

--Result:
+──────────────+──────────────+
| hour_of_day  | pizza_count  |
+──────────────+──────────────+
| 11           | 1            |
| 12           | 2            |
| 13           | 3            |
| 18           | 3            |
| 19           | 1            |
| 21           | 3            |
| 23           | 1            |
+──────────────+──────────────+

-- 10. What was the volume of orders for each day of the week?
SELECT
  TO_CHAR(order_time, 'Day') AS day_of_week,
  COUNT(*) AS pizza_count
FROM updated_customer_orders
GROUP BY 
  day_of_week, 
  DATE_PART('dow', order_time)
ORDER BY day_of_week;

--Result:
+──────────────+──────────────+
| day_of_week  | pizza_count  |
+──────────────+──────────────+
| Friday       | 1            |
| Saturday     | 5            |
| Thursday     | 3            |
| Wednesday    | 5            |
+──────────────+──────────────+
