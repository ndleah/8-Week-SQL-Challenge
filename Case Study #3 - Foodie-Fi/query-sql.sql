-- 1. How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM foodie_fi.subscriptions;

-- Query Results

--  total_customers 
-- -----------------
--             1000


-- 2. What is the monthly distribution of trial plan start_date values for our
--    dataset - use the start of the month as the group by value

SELECT EXTRACT(MONTH FROM start_date) AS months, COUNT(*)
FROM foodie_fi.subscriptions
WHERE plan_id = 0
GROUP BY months
ORDER BY months;

-- Query Results

--  months | count 
-- --------+-------
--       1 |    88
--       2 |    68
--       3 |    94
--       4 |    81
--       5 |    88
--       6 |    79
--       7 |    89
--       8 |    88
--       9 |    87
--      10 |    79
--      11 |    75
--      12 |    84


-- 3.  What plan start_date values occur after the year 2020 for our dataset? Show the 
--     breakdown by count of events for each plan_name

SELECT plan_id, COUNT(*)
FROM foodie_fi.subscriptions
WHERE start_date > '2020-01-01'::DATE
GROUP BY plan_id
ORDER BY plan_id;

-- Query Results

--  plan_id | count 
-- ---------+-------
--        0 |   997
--        1 |   546
--        2 |   539
--        3 |   258
--        4 |   307


-- 4.  What is the customer count and percentage of customers who have churned rounded 
--     to 1 decimal place?

DROP TABLE IF EXISTS total_count;
CREATE TEMP TABLE total_count AS (
    SELECT COUNT(DISTINCT customer_id) AS num
    FROM foodie_fi.subscriptions
);

WITH churn_count AS (
    SELECT COUNT(DISTINCT customer_id) AS num
    FROM foodie_fi.subscriptions
    WHERE plan_id = 4
)
SELECT churn_count.num AS num_churned,
       churn_count.num::FLOAT  / total_count.num::FLOAT *100 AS percent_churned
FROM churn_count, total_count;

-- Query Results

--  num_churned | percent_churned 
-- -------------+-----------------
--          307 |            30.7


-- 5. How many customers have churned straight after their initial free trial
--  - what percentage is this rounded to the nearest whole number?

DROP TABLE IF EXISTS next_plan_cte;
CREATE TEMP TABLE next_plan_cte AS(
    SELECT *, 
        LEAD(plan_id, 1) 
        OVER(PARTITION BY customer_id ORDER BY start_date) as next_plan
    FROM foodie_fi.subscriptions
);

WITH direct_churner_cte AS (
    SELECT COUNT(DISTINCT customer_id) AS direct_churner
    FROM next_plan_cte
    WHERE plan_id = 0 AND next_plan = 4
)

SELECT direct_churner, direct_churner::FLOAT/num::FLOAT * 100 AS percent_churned
FROM direct_churner_cte, total_count;

-- Query Results

--  direct_churner | percent_churned 
-- ----------------+-----------------
--              92 |             9.2


-- 6. What is the number and percentage of customer plans after their initial free trial?

DROP TABLE IF EXISTS current_plan_count;
CREATE TEMP TABLE current_plan_count AS (
    SELECT plan_id, COUNT(DISTINCT customer_id) AS num
    FROM foodie_fi.subscriptions
    GROUP BY plan_id
);

WITH conversions AS (
    SELECT next_plan, COUNT(*) AS total_conversions
    FROM next_plan_cte
    WHERE next_plan IS NOT NULL AND plan_id = 0
    GROUP BY next_plan
    ORDER BY next_plan
)

SELECT current_plan_count.plan_id, total_conversions, num,
        ROUND(CAST(total_conversions::FLOAT / num::FLOAT * 100 AS NUMERIC), 2) AS percent_directly_converted
FROM current_plan_count JOIN conversions
    ON current_plan_count.plan_id = conversions.next_plan;

-- Query Results

--  plan_id | total_conversions | num | percent_directly_converted 
-- ---------+-------------------+-----+----------------------------
--        1 |               546 | 546 |                     100.00
--        2 |               325 | 539 |                      60.30
--        3 |                37 | 258 |                      14.34
--        4 |                92 | 307 |                      29.97


-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

WITH next_date_cte AS (
    SELECT *,
            LEAD (start_date, 1) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_date
    FROM foodie_fi.subscriptions
),
customers_on_date_cte AS (
    SELECT plan_id, COUNT(DISTINCT customer_id) AS customers
    FROM next_date_cte
    WHERE (next_date IS NOT NULL AND ('2020-12-31'::DATE > start_date AND '2020-12-31'::DATE < next_date))
        OR (next_date IS NULL AND '2020-12-31'::DATE > start_date)
    GROUP BY plan_id
)

SELECT plan_id, customers, ROUND(CAST(customers::FLOAT / num::FLOAT * 100 AS NUMERIC), 2) AS percent
FROM customers_on_date_cte, total_count;

-- Query Results

-- The number of customers on 2020-12-31

--  plan_id | customers | percent 
-- ---------+-----------+---------
--        0 |        19 |    1.90
--        1 |       224 |   22.40
--        2 |       326 |   32.60
--        3 |       195 |   19.50
--        4 |       235 |   23.50


-- 8. How many customers have upgraded to an annual plan in 2020?

SELECT COUNT(DISTINCT customer_id)
FROM next_plan_cte
WHERE next_plan=3 AND EXTRACT(YEAR FROM start_date) = '2020';

-- Query Results

--  count 
-- -------
--    253


-- 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

-- This will only find the average of people who have upgraded to annual plan
WITH join_date AS (
    SELECT customer_id, start_date 
    FROM foodie_fi.subscriptions 
    WHERE plan_id = 0
),
pro_date AS (
    SELECT customer_id, start_date AS upgrade_date 
    FROM foodie_fi.subscriptions 
    WHERE plan_id = 3
)

SELECT ROUND(AVG(upgrade_date - start_date), 2) AS avg_days_to_upgrade
FROM join_date JOIN pro_date
    ON join_date.customer_id = pro_date.customer_id;

-- Query Results

--  avg_days_to_upgrade 
-- ---------------------
--               104.62


-- 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

WITH join_date AS (
    SELECT customer_id, start_date 
    FROM foodie_fi.subscriptions 
    WHERE plan_id = 0
),
pro_date AS (
    SELECT customer_id, start_date AS upgrade_date 
    FROM foodie_fi.subscriptions 
    WHERE plan_id = 3
),
bins AS (
    SELECT WIDTH_BUCKET(upgrade_date - start_date, 0, 360, 12) AS avg_days_to_upgrade
    FROM join_date JOIN pro_date
        ON join_date.customer_id = pro_date.customer_id
)


SELECT ((avg_days_to_upgrade - 1)*30 || '-' || (avg_days_to_upgrade)*30) AS "30-day-range", COUNT(*)
FROM bins
GROUP BY avg_days_to_upgrade
ORDER BY avg_days_to_upgrade;

-- Query Results

--  30-day-range | count 
-- --------------+-------
--  0-30         |    48
--  30-60        |    25
--  60-90        |    33
--  90-120       |    35
--  120-150      |    43
--  150-180      |    35
--  180-210      |    27
--  210-240      |     4
--  240-270      |     5
--  270-300      |     1
--  300-330      |     1
--  330-360      |     1


-- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

SELECT COUNT(*) AS customers_downgraded
FROM next_plan_cte
WHERE plan_id=2 AND next_plan=1;

-- Query Results

--  customers_downgraded 
-- ----------------------
--              0