/* --------------------
   Table Transformation
   --------------------*/

-- data type check
--customer_orders
SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'customer_orders';

--Result:
+──────────────────+──────────────+──────────────────────────────+
| table_name       | column_name  | data_type                    |
+──────────────────+──────────────+──────────────────────────────+
| customer_orders  | order_id     | integer                      |
| customer_orders  | customer_id  | integer                      |
| customer_orders  | pizza_id     | integer                      |
| customer_orders  | exclusions   | character varying            |
| customer_orders  | extras       | character varying            |
| customer_orders  | order_time   | timestamp without time zone  |
+──────────────────+──────────────+──────────────────────────────+

| table_name      | column_name | data_type                   |
|-----------------|-------------|-----------------------------|
| customer_orders | order_id    | integer                     |
| customer_orders | customer_id | integer                     |
| customer_orders | pizza_id    | integer                     |
| customer_orders | exclusions  | character varying           |
| customer_orders | extras      | character varying           |
| customer_orders | order_time  | timestamp without time zone |

--runner_orders
SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'runner_orders';

--Result:
+────────────────+──────────────+────────────────────+
| table_name     | column_name  | data_type          |
+────────────────+──────────────+────────────────────+
| runner_orders  | order_id     | integer            |
| runner_orders  | runner_id    | integer            |
| runner_orders  | pickup_time  | character varying  |
| runner_orders  | distance     | character varying  |
| runner_orders  | duration     | character varying  |
| runner_orders  | cancellation | character varying  |
+────────────────+──────────────+────────────────────+

| table_name    | column_name  | data_type         |
|---------------|--------------|-------------------|
| runner_orders | order_id     | integer           |
| runner_orders | runner_id    | integer           |
| runner_orders | pickup_time  | character varying |
| runner_orders | distance     | character varying |
| runner_orders | duration     | character varying |
| runner_orders | cancellation | character varying |


--Update tables

--1. customer_order
/*
Cleaning customer_orders
- Identify records with null or 'null' values
- updating null or 'null' values to ''
- blanks '' are not null because it indicates the customer asked for no extras or exclusions
*/
--Blanks indicate that the customer requested no extras/exclusions for the pizza, whereas null values would be ambiguous on this.

DROP TABLE IF EXISTS updated_customer_orders;
CREATE TEMP TABLE updated_customer_orders AS (
  SELECT
    order_id,
    customer_id,
    pizza_id,
    CASE 
      WHEN exclusions IS NULL 
        OR exclusions LIKE 'null' THEN ''
      ELSE exclusions 
    END AS exclusions,
    CASE 
      WHEN extras IS NULL
        OR extras LIKE 'null' THEN ''
      ELSE extras 
    END AS extras,
    order_time
  FROM pizza_runner.customer_orders
);
SELECT * FROM updated_customer_orders;

--Result:
|order_id|customer_id|pizza_id|exclusions|extras|order_time              |
|--------|-----------|--------|----------|------|------------------------|
|1       |101        |1       |          |      |2020-01-01T18:05:02.000Z|
|2       |101        |1       |          |      |2020-01-01T19:00:52.000Z|
|3       |102        |1       |          |      |2020-01-02T12:51:23.000Z|
|3       |102        |2       |          |      |2020-01-02T12:51:23.000Z|
|4       |103        |1       |4         |      |2020-01-04T13:23:46.000Z|
|4       |103        |1       |4         |      |2020-01-04T13:23:46.000Z|
|4       |103        |2       |4         |      |2020-01-04T13:23:46.000Z|
|5       |104        |1       |          |1     |2020-01-08T21:00:29.000Z|
|6       |101        |2       |          |      |2020-01-08T21:03:13.000Z|
|7       |105        |2       |          |1     |2020-01-08T21:20:29.000Z|
|8       |102        |1       |          |      |2020-01-09T23:54:33.000Z|
|9       |103        |1       |4         |1, 5  |2020-01-10T11:22:59.000Z|
|10      |104        |1       |          |      |2020-01-11T18:34:49.000Z|
|10      |104        |1       |2, 6      |1, 4  |2020-01-11T18:34:49.000Z|
*/

+───────────+──────────────+───────────+─────────────+─────────+───────────────────────────+
| order_id  | customer_id  | pizza_id  | exclusions  | extras  | order_time                |
+───────────+──────────────+───────────+─────────────+─────────+───────────────────────────+
| 1         | 101          | 1         |             |         | 2020-01-01T18:05:02.000Z  |
| 2         | 101          | 1         |             |         | 2020-01-01T19:00:52.000Z  |
| 3         | 102          | 1         |             |         | 2020-01-02T12:51:23.000Z  |
| 3         | 102          | 2         |             |         | 2020-01-02T12:51:23.000Z  |
| 4         | 103          | 1         | 4           |         | 2020-01-04T13:23:46.000Z  |
| 4         | 103          | 1         | 4           |         | 2020-01-04T13:23:46.000Z  |
| 4         | 103          | 2         | 4           |         | 2020-01-04T13:23:46.000Z  |
| 5         | 104          | 1         |             | 1       | 2020-01-08T21:00:29.000Z  |
| 6         | 101          | 2         |             |         | 2020-01-08T21:03:13.000Z  |
| 7         | 105          | 2         |             | 1       | 2020-01-08T21:20:29.000Z  |
| 8         | 102          | 1         |             |         | 2020-01-09T23:54:33.000Z  |
| 9         | 103          | 1         | 4           | 1, 5    | 2020-01-10T11:22:59.000Z  |
| 10        | 104          | 1         |             |         | 2020-01-11T18:34:49.000Z  |
| 10        | 104          | 1         | 2, 6        | 1, 4    | 2020-01-11T18:34:49.000Z  |
+───────────+──────────────+───────────+─────────────+─────────+───────────────────────────+

--2. runner_orders
/*
- pickup time, distance, duration is of the wrong type
- records have nulls in these columns when the orders are cancelled
- convert text 'null' to null values
- units (km, minutes) need to be removed from distance and duration
*/
DROP TABLE IF EXISTS updated_runner_orders;
CREATE TEMP TABLE updated_runner_orders AS (
  SELECT
    order_id,
    runner_id,
    CASE WHEN pickup_time LIKE 'null' THEN null ELSE pickup_time END::timestamp AS pickup_time,
    NULLIF(regexp_replace(distance, '[^0-9.]','','g'), '')::numeric AS distance,
    NULLIF(regexp_replace(duration, '[^0-9.]','','g'), '')::numeric AS duration,
    CASE WHEN cancellation IN ('null', 'NaN', '') THEN null ELSE cancellation END AS cancellation
  FROM pizza_runner.runner_orders);
SELECT * FROM updated_runner_orders;

--Result:
| order_id | runner_id | pickup_time         | distance | duration | cancellation            |
|----------|-----------|---------------------|----------|----------|-------------------------|
| 1        | 1         | 2020-01-01 18:15:34 | 20       | 32       |                         |
| 2        | 1         | 2020-01-01 19:10:54 | 20       | 27       |                         |
| 3        | 1         | 2020-01-02 00:12:37 | 13.4     | 20       |                         |
| 4        | 2         | 2020-01-04 13:53:03 | 23.4     | 40       |                         |
| 5        | 3         | 2020-01-08 21:10:57 | 10       | 15       |                         |
| 6        | 3         |                     |          |          | Restaurant Cancellation |
| 7        | 2         | 2020-01-08 21:30:45 | 25       | 25       |                         |
| 8        | 2         | 2020-01-10 00:15:02 | 23.4     | 15       |                         |
| 9        | 2         |                     |          |          | Customer Cancellation   |
| 10       | 1         | 2020-01-11 18:50:20 | 10       | 10       |                         |
*/

+───────────+────────────+──────────────────────+───────────+───────────+──────────────────────────+
| order_id  | runner_id  | pickup_time          | distance  | duration  | cancellation             |
+───────────+────────────+──────────────────────+───────────+───────────+──────────────────────────+
| 1         | 1          | 2020-01-01 18:15:34  | 20        | 32        |                          |
| 2         | 1          | 2020-01-01 19:10:54  | 20        | 27        |                          |
| 3         | 1          | 2020-01-02 00:12:37  | 13.4      | 20        |                          |
| 4         | 2          | 2020-01-04 13:53:03  | 23.4      | 40        |                          |
| 5         | 3          | 2020-01-08 21:10:57  | 10        | 15        |                          |
| 6         | 3          |                      |           |           | Restaurant Cancellation  |
| 7         | 2          | 2020-01-08 21:30:45  | 25        | 25        |                          |
| 8         | 2          | 2020-01-10 00:15:02  | 23.4      | 15        |                          |
| 9         | 2          |                      |           |           | Customer Cancellation    |
| 10        | 1          | 2020-01-11 18:50:20  | 10        | 10        |                          |
+───────────+────────────+──────────────────────+───────────+───────────+──────────────────────────+

-- data type check
--updated_customer_orders
SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'updated_customer_orders'

--Result:
+──────────────────────────+──────────────+──────────────────────────────+
| table_name               | column_name  | data_type                    |
+──────────────────────────+──────────────+──────────────────────────────+
| updated_customer_orders  | order_id     | integer                      |
| updated_customer_orders  | customer_id  | integer                      |
| updated_customer_orders  | pizza_id     | integer                      |
| updated_customer_orders  | exclusions   | character varying            |
| updated_customer_orders  | extras       | character varying            |
| updated_customer_orders  | order_time   | timestamp without time zone  |
+──────────────────────────+──────────────+──────────────────────────────+


| table_name              | column_name | data_type                   |
|-------------------------|-------------|-----------------------------|
| updated_customer_orders | order_id    | integer                     |
| updated_customer_orders | customer_id | integer                     |
| updated_customer_orders | pizza_id    | integer                     |
| updated_customer_orders | exclusions  | character varying           |
| updated_customer_orders | extras      | character varying           |
| updated_customer_orders | order_time  | timestamp without time zone |

--updated_runner_orders
SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'updated_runner_orders'

--Result:
+────────────────────────+──────────────+──────────────────────────────+
| table_name             | column_name  | data_type                    |
+────────────────────────+──────────────+──────────────────────────────+
| updated_runner_orders  | order_id     | integer                      |
| updated_runner_orders  | runner_id    | integer                      |
| updated_runner_orders  | pickup_time  | timestamp without time zone  |
| updated_runner_orders  | distance     | numeric                      |
| updated_runner_orders  | duration     | numeric                      |
| updated_runner_orders  | cancellation | character varying            |
+────────────────────────+──────────────+──────────────────────────────+

| table_name            | column_name  | data_type                   |
|-----------------------|--------------|-----------------------------|
| updated_runner_orders | order_id     | integer                     |
| updated_runner_orders | runner_id    | integer                     |
| updated_runner_orders | pickup_time  | timestamp without time zone |
| updated_runner_orders | distance     | numeric                     |
| updated_runner_orders | duration     | numeric                     |
| updated_runner_orders | cancellation | character varying           |


/* --------------------
   Case Study Questions:
   Pizza Metrics
   --------------------*/


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

/* --------------------
   Case Study Questions:
   Runner and Customer Experience
   --------------------*/

-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
WITH runner_signups AS (
  SELECT
    runner_id,
    registration_date,
    registration_date - ((registration_date - '2021-01-01') % 7)  AS start_of_week
  FROM pizza_runner.runners
)
SELECT
  start_of_week,
  COUNT(runner_id) AS signups
FROM runner_signups
GROUP BY start_of_week
ORDER BY start_of_week;

--Result:
+───────────────────────────+──────────+
| start_of_week             | signups  |
+───────────────────────────+──────────+
| 2021-01-01T00:00:00.000Z  | 2        |
| 2021-01-08T00:00:00.000Z  | 1        |
| 2021-01-15T00:00:00.000Z  | 1        |
+───────────────────────────+──────────+


| start_of_week            | signups |
|--------------------------|---------|
| 2021-01-01T00:00:00.000Z | 2       |
| 2021-01-08T00:00:00.000Z | 1       |
| 2021-01-15T00:00:00.000Z | 1       |

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
WITH runner_pickups AS (
  SELECT
    ro.runner_id,
    ro.order_id,
    co.order_time,
    ro.pickup_time,
    (pickup_time - order_time) AS time_to_pickup
  FROM updated_runner_orders AS ro
  INNER JOIN updated_customer_orders AS co
    ON ro.order_id = co.order_id
)
SELECT 
  runner_id,
  date_part('minutes', AVG(time_to_pickup)) AS avg_arrival_minutes
FROM runner_pickups
GROUP BY runner_id
ORDER BY runner_id;

--Result:
+────────────+──────────────────────+
| runner_id  | avg_arrival_minutes  |
+────────────+──────────────────────+
| 1          | -4                   |
| 2          | 23                   |
| 3          | 10                   |
+────────────+──────────────────────+

| runner_id | avg_arrival_minutes |
|-----------|---------------------|
| 1         | -4                  |
| 2         | 23                  |
| 3         | 10                  |

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH order_count AS (
  SELECT
    order_id,
    order_time,
    COUNT(pizza_id) AS pizzas_order_count
  FROM updated_customer_orders
  GROUP BY order_id, order_time
), 
prepare_time AS (
  SELECT
    ro.order_id,
    co.order_time,
    ro.pickup_time,
    co.pizzas_order_count,
    (pickup_time - order_time) AS time_to_pickup
  FROM updated_runner_orders AS ro
  INNER JOIN order_count AS co
    ON ro.order_id = co.order_id
  WHERE pickup_time IS NOT NULL
)

SELECT
  pizzas_order_count,
  AVG(time_to_pickup) AS avg_time
FROM prepare_time
GROUP BY pizzas_order_count
ORDER BY pizzas_order_count;

--Result:
+─────────────────────+──────────────────+
| pizzas_order_count  | avg_time         |
+─────────────────────+──────────────────+
| 1                   | 12               |
| 2                   | -6               |
| 3                   | 29               |
+─────────────────────+──────────────────+

| pizzas_order_count | avg_time        |
|--------------------|-----------------|
| 1                  | 12              |
| 2                  | -6              |
| 3                  | 29              |


-- What was the average distance travelled for each runner?
SELECT
  runner_id,
  ROUND(AVG(distance), 2) AS avg_distance
FROM updated_runner_orders
GROUP BY runner_id
ORDER BY runner_id;

--Result:
+────────────+───────────────+
| runner_id  | avg_distance  |
+────────────+───────────────+
| 1          | 15.85         |
| 2          | 23.93         |
| 3          | 10.00         |
+────────────+───────────────+

| runner_id | avg_distance |
|-----------|--------------|
| 1         | 15.85        |
| 2         | 23.93        |
| 3         | 10.00        |

-- What was the difference between the longest and shortest delivery times for all orders?
SELECT
  MAX(duration) - MIN(duration) AS difference
FROM updated_runner_orders;

--Result:
+─────────────+
| difference  |
+─────────────+
| 30          |
+─────────────+

| difference |
|------------|
| 30         |

-- What was the average speed for each runner for each delivery and do you notice any trend for these values?

WITH order_count AS (
  SELECT
    order_id,
    order_time,
    COUNT(pizza_id) AS pizzas_count
  FROM updated_customer_orders
  GROUP BY 
    order_id, 
    order_time
)
  SELECT
    ro.order_id,
    ro.runner_id,
    co.pizzas_count,
    ro.distance,
    ro.duration,
    ROUND(60 * ro.distance / ro.duration, 2) AS speed
  FROM updated_runner_orders AS ro
  INNER JOIN order_count AS co
    ON ro.order_id = co.order_id
  WHERE pickup_time IS NOT NULL
  ORDER BY speed DESC
--Result:
+───────────+────────────+───────────────+───────────+───────────+────────+
| order_id  | runner_id  | pizzas_count  | distance  | duration  | speed  |
+───────────+────────────+───────────────+───────────+───────────+────────+
| 8         | 2          | 1             | 23.4      | 15        | 93.60  |
| 7         | 2          | 1             | 25        | 25        | 60.00  |
| 10        | 1          | 2             | 10        | 10        | 60.00  |
| 2         | 1          | 1             | 20        | 27        | 44.44  |
| 3         | 1          | 2             | 13.4      | 20        | 40.20  |
| 5         | 3          | 1             | 10        | 15        | 40.00  |
| 1         | 1          | 1             | 20        | 32        | 37.50  |
| 4         | 2          | 3             | 23.4      | 40        | 35.10  |
+───────────+────────────+───────────────+───────────+───────────+────────+

| order_id | runner_id | pizzas_count | distance | duration | speed |
|----------|-----------|--------------|----------|----------|-------|
| 8        | 2         | 1            | 23.4     | 15       | 93.60 |
| 7        | 2         | 1            | 25       | 25       | 60.00 |
| 10       | 1         | 2            | 10       | 10       | 60.00 |
| 2        | 1         | 1            | 20       | 27       | 44.44 |
| 3        | 1         | 2            | 13.4     | 20       | 40.20 |
| 5        | 3         | 1            | 10       | 15       | 40.00 |
| 1        | 1         | 1            | 20       | 32       | 37.50 |
| 4        | 2         | 3            | 23.4     | 40       | 35.10 |

/*Finding:
Orders shown in decreasing order of average speed:
While the fastest order only carried 1 pizza and the slowest order carried 3 pizzas,
there is no clear trend that more pizzas slow down the delivery speed of an order.  
*/

-- What is the successful delivery percentage for each runner?
SELECT
  runner_id,
  COUNT(pickup_time) as delivered,
  COUNT(order_id) AS total,
  ROUND(100 * COUNT(pickup_time) / COUNT(order_id)) AS delivery_percent
FROM updated_runner_orders
GROUP BY runner_id
ORDER BY runner_id;

--Result:
+────────────+────────────+────────+─────────────────+
| runner_id  | delivered  | total  | delivery_percent|
+────────────+────────────+────────+─────────────────+
| 1          | 4          | 4      | 100             |
| 2          | 3          | 4      | 75              | 
| 3          | 1          | 2      | 50              |
+────────────+────────────+────────+─────────────────+

| runner_id | delivered | total | delivery_percent |
|-----------|-----------|-------|------------------|
| 1         | 4         | 4     | 100              |
| 2         | 3         | 4     | 75               |
| 3         | 1         | 2     | 50               |