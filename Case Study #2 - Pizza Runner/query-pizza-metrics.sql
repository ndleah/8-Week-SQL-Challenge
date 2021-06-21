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
FROM pizza_runner.customer_orders;

/*Result:
|pizza_count|
|-----------|
|14         |
*/

+──────────────+
| pizza_count  |
+──────────────+
| 14           |
+──────────────+


-- 2. How many unique customer orders were made?
SELECT COUNT (DISTINCT order_id) AS order_count
FROM pizza_runner.customer_orders;

/*Result:
|order_count|
|-----------|
|10         |
*/

+──────────────+
| order_count  |
+──────────────+
| 10           |
+──────────────+



DROP TABLE IF EXISTS pizza_runner.runner_orders;
CREATE TABLE pizza_runner.runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO pizza_runner.runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-02 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
select * from pizza_runner.runner_orders;
--
--
UPDATE pizza_runner.runner_orders
SET 
  pickup_time = 
    CASE WHEN pickup_time = '' 
    OR pickup_time = 'null' THEN NULL 
    ELSE pickup_time END
    ,
  distance = 
    CASE WHEN distance = '' 
    OR distance = 'null' THEN NULL 
    ELSE distance END
    ,
  duration = 
    CASE WHEN duration = '' 
    OR duration = 'null' THEN NULL 
    ELSE duration END
    ,
  cancellation = 
    CASE WHEN cancellation = '' 
    OR cancellation = 'null' THEN NULL 
    ELSE cancellation END
  
RETURNING *;

-- 3. How many successful orders were delivered by each runner?
SELECT
  runner_id,
  COUNT(order_id) AS successful_orders
FROM pizza_runner.runner_orders
WHERE cancellation IS NULL
OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY runner_id
ORDER BY successful_orders DESC;

/*Result:
| runner_id | successful_orders |
|-----------|-------------------|
| 1         | 4                 |
| 2         | 3                 |
| 3         | 1                 |
*/

+────────────+────────────────────+
| runner_id  | successful_orders  |
+────────────+────────────────────+
| 1          | 4                  |
| 2          | 3                  |
| 3          | 1                  |
+────────────+────────────────────+

-- 4. How many of each type of pizza was delivered?
SELECT
  pizza_names.pizza_name,
  COUNT(customer_orders.*) AS pizza_type_count
FROM pizza_runner.customer_orders
INNER JOIN pizza_runner.pizza_names
   ON customer_orders.pizza_id = pizza_names.pizza_id
INNER JOIN pizza_runner.runner_orders
   ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation IS NULL
OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY pizza_names.pizza_name
ORDER BY pizza_names.pizza_name;

--OR
SELECT
  pizza_names.pizza_name,
  COUNT(customer_orders.*) AS pizza_type_count
FROM pizza_runner.customer_orders
INNER JOIN pizza_runner.pizza_names
   ON customer_orders.pizza_id = pizza_names.pizza_id
WHERE EXISTS (
  SELECT 1 FROM pizza_runner.runner_orders
   WHERE runner_orders.order_id = customer_orders.order_id
   AND (
    runner_orders.cancellation IS NULL
    OR runner_orders.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
  )
)
GROUP BY pizza_names.pizza_name
ORDER BY pizza_names.pizza_name;

/*Result:
| pizza_name | pizza_type_count |
|------------|------------------|
| Meatlovers | 9                |
| Vegetarian | 3                |
*/

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
FROM pizza_runner.customer_orders
GROUP BY customer_id;

/*Result:
| customer_id | meat_lovers | vegetarian |
|-------------|-------------|------------|
| 101         | 2           | 1          |
| 103         | 3           | 1          |
| 104         | 3           | 0          |
| 105         | 0           | 1          |
| 102         | 2           | 1          |
*/

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
    customer_orders.order_id,
    COUNT(customer_orders.pizza_id) AS pizza_count
  FROM pizza_runner.customer_orders
  INNER JOIN pizza_runner.runner_orders
    ON customer_orders.order_id = runner_orders.order_id
  WHERE 
    runner_orders.cancellation IS NULL
    OR runner_orders.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
  GROUP BY customer_orders.order_id) AS mycount;
  
/*Result:
| max_count |
|-----------|
| 3         |
*/

+────────────+
| max_count  |
+────────────+
| 3          |
+────────────+

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
  customer_orders.customer_id,
  SUM (CASE WHEN customer_orders.exclusions IS NOT NULL OR customer_orders.extras IS NOT NULL THEN 1 ELSE 0 END) AS changes,
  SUM (CASE WHEN customer_orders.exclusions IS NULL OR customer_orders.extras IS NULL THEN 1 ELSE 0 END) AS no_change
FROM pizza_runner.customer_orders
INNER JOIN pizza_runner.runner_orders
  ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.cancellation IS NULL
  OR runner_orders.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY customer_id
ORDER BY customer_id;

/*Result:
| customer_id | changes | no_change |
|-------------|---------|-----------|
| 101         | 0       | 2         |
| 102         | 0       | 3         |
| 103         | 3       | 3         |
| 104         | 2       | 2         |
| 105         | 1       | 1         |
*/
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
  SUM(CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1 ELSE 0 END) as pizza_count
FROM pizza_runner.customer_orders
INNER JOIN pizza_runner.runner_orders
  ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.cancellation IS NULL
  OR runner_orders.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
  
/*Result:
| pizza_count |
|-------------|
| 1           |
*/

+──────────────+
| pizza_count  |
+──────────────+
| 1            |
+──────────────+

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT
  DATE_PART('hour', order_time::TIMESTAMP) AS hour_of_day,
  COUNT(*) AS pizza_count
FROM pizza_runner.customer_orders
WHERE order_time IS NOT NULL
GROUP BY hour_of_day
ORDER BY hour_of_day;



-- 10. What was the volume of orders for each day of the week?
SELECT
  TO_CHAR(order_time, 'Day') AS day_of_week,
  COUNT(*) AS pizza_count
FROM pizza_runner.customer_orders
GROUP BY 
  day_of_week, 
  DATE_PART('dow', order_time)
ORDER BY day_of_week;