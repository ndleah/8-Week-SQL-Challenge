# [8-Week SQL Challenge](https://github.com/ndleah/8-Week-SQL-Challenge)
![Star Badge](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=style=flat&color=BC4E99)
[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/ndleah/8-Week-SQL-Challenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/ndleah?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/ndleah)


# 🥑 Case Study #3 - Foodie-Fi
<p align="center">
<img src="https://github.com/ndleah/8-Week-SQL-Challenge/blob/main/IMG/org-3.png" width=40% height=40%>

## 📕 Table Of Contents
  - 🛠️ [Problem Statement](#problem-statement)
  - 📂 [Dataset](#dataset)
  - 🧙‍♂️ [Case Study Questions](#case-study-questions)
  - 🚀 [Solutions](#-solutions)

## 🛠️ Problem Statement

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

## 📂 Dataset
Danny has shared with you 2 key datasets for this case study:

### **```plan```**

<details>
<summary>
View table
</summary>

The plan table shows which plans customer can choose to join Foodie-Fi when they first sign up.

* **Trial:** can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel

* **Basic plan:** limited access and can only stream user videos
* **Pro plan** no watch time limits and video are downloadable with 2 subscription options: **monthly** and **annually**


| "plan_id" | "plan_name"     | "price" |
|-----------|-----------------|---------|
| 0         | "trial"         | 0.00    |
| 1         | "basic monthly" | 9.90    |
| 2         | "pro monthly"   | 19.90   |
| 3         | "pro annual"    | 199.00  |
| 4         | "churn"         | NULL    |


</details>


### **```subscriptions```**


<details>
<summary>
View table
</summary>

Customer subscriptions show the exact date where their specific ```plan_id``` starts.

If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the ```start_date``` in the ```subscriptions``` table will reflect the date that the actual plan changes.

In this part, I will display the first 20 rows of this dataset since the original one is super long:


| "customer_id" | "plan_id" | "start_date" |
|---------------|-----------|--------------|
| 1             | 0         | "2020-08-01" |
| 1             | 1         | "2020-08-08" |
| 2             | 0         | "2020-09-20" |
| 2             | 3         | "2020-09-27" |
| 3             | 0         | "2020-01-13" |
| 3             | 1         | "2020-01-20" |
| 4             | 0         | "2020-01-17" |
| 4             | 1         | "2020-01-24" |
| 4             | 4         | "2020-04-21" |
| 5             | 0         | "2020-08-03" |
| 5             | 1         | "2020-08-10" |
| 6             | 0         | "2020-12-23" |
| 6             | 1         | "2020-12-30" |
| 6             | 4         | "2021-02-26" |
| 7             | 0         | "2020-02-05" |
| 7             | 1         | "2020-02-12" |
| 7             | 2         | "2020-05-22" |
| 8             | 0         | "2020-06-11" |
| 8             | 1         | "2020-06-18" |
| 8             | 2         | "2020-08-03" |


</details>


## 🧙‍♂️ Case Study Questions

1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of **```trial```** plan **```start_date```** values for our dataset - use the start of the month as the group by value
3. What plan **```start_date```** values occur after the year 2020 for our dataset? Show the breakdown by count of events for each **```plan_name```**
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 **```plan_name```** values at **```2020-12-31```**?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

## 🚀 Solutions

**Q1. How many customers has Foodie-Fi ever had?**
```SQL
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM foodie_fi.subscriptions;
```


| total_customers |
|-------------------|
| 1000              |


**Q2. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each ```plan_name**

```SQL
SELECT EXTRACT(MONTH FROM start_date) AS months, COUNT(*)
FROM foodie_fi.subscriptions
WHERE plan_id = 0
GROUP BY months
ORDER BY months;
```

months | count 
-------|-------
   1 |    88
   2 |    68
   3 |    94
   4 |    81
   5 |    88
   6 |    79
   7 |    89
   8 |    88
   9 |    87
  10 |    79
  11 |    75
  12 |    84



**Q3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name**
```SQL
SELECT plan_id, COUNT(*)
FROM foodie_fi.subscriptions
WHERE start_date > '2020-01-01'::DATE
GROUP BY plan_id
ORDER BY plan_id;
```

plan_id | count 
--------|-------
 0 |   997
 1 |   546
  2 |   539
 3 |   258
   4 |   307

---

**Q4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?**
```SQL
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
```

num_churned | percent_churned 
-------------|-----------------
  307 |            30.7



**Q5. How many customers have churned straight after their initial free trial what percentage is this rounded to the nearest whole number?**
```SQL
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
```


  direct_churner | percent_churned 
 ----------------|-----------------
 92 |             9.2


**Q6. What is the number and percentage of customer plans after their initial free trial?**
```SQL
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
```

plan_id | total_conversions | num | percent_directly_converted 
-------------|-------------------|-----|----------------------------
   1 |               546 | 546 |                     100.00
   2 |               325 | 539 |                      60.30
   3 |                37 | 258 |                      14.34
   4 |                92 | 307 |                      29.97


**Q7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?**
```SQL
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
```

 plan_id | customers | percent 
 ---------|-----------|---------
   0 |        19 |    1.90
   1 |       224 |   22.40
   2 |       326 |   32.60
   3 |       195 |   19.50
   4 |       235 |   23.50


**Q8. How many customers have upgraded to an annual plan in 2020?**
```SQL
SELECT COUNT(DISTINCT customer_id)
FROM next_plan_cte
WHERE next_plan=3 AND EXTRACT(YEAR FROM start_date) = '2020';
```

|count |
|------|
|253 |

**Q9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?**
```SQL
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
```

|avg_days_to_upgrade|
|-------------------|
|104.62             |


**Q10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)**
```SQL
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
```

|  30-day-range  |  count  |
|----------------|---------|
| 0-30         | 48      |
| 30-60        | 25      |
| 60-90        | 33      |
| 90-120       | 35      |
| 120-150      | 43      |
| 150-180      | 35      |
| 180-210      | 27      |
| 210-240      | 4       |
| 240-270      | 5       |
| 270-300      | 1       |
| 300-330      | 1       |
| 330-360      | 1       |



**Q11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?**

```SQL
SELECT COUNT(*) AS customers_downgraded
FROM next_plan_cte
WHERE plan_id=2 AND next_plan=1;
```
|customers_downgraded|
|--------------------|
| 0                  |

---
<p>&copy; 2021 Leah Nguyen</p>
