/* --------------------
   Case Study Questions:
   Runner and Customer Experience
   --------------------*/

--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
--4. What was the average distance travelled for each customer?
--5. What was the difference between the longest and shortest delivery times for all orders?
--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
--7. What is the successful delivery percentage for each runner?


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

