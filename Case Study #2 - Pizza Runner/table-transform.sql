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
