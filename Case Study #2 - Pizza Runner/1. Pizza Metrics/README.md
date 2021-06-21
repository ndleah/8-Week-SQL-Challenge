[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/nduongthucanh/8-Week-SQL-Challenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/nduongthucanh?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/nduongthucanh)

# [8-Week SQL Challenge](https://github.com/nduongthucanh/8-Week-SQL-Challenge)

# Case Study #2 - Pizza Metrics
<p align="center">
<img src="https://github.com/nduongthucanh/8-Week-SQL-Challenge/blob/main/IMG/org-2.png" width=50% height=50%>

## Table Of Contents
  - [Case Study's Question](#case-studys-questions)
  - [Solution](#solutions)

 <br /> 

## Case Study's Questions

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

 <br /> 

## Solutions

### **Q1. How many pizzas were ordered?**
```sql
SELECT COUNT(*) AS pizza_count
FROM pizza_runner.customer_orders;
```
**Result:**
|pizza_count|
|-----------|
|14         |

**Answer:**

---

### **Q2. How many unique customer orders were made?**
```sql
SELECT COUNT (DISTINCT order_id) AS order_count
FROM pizza_runner.customer_orders;
```

**Result:**
|order_count|
|-----------|
|10         |

---

### **Q3. How many successful orders were delivered by each runner?**
```sql
SELECT
  runner_id,
  COUNT(order_id) AS successful_orders
FROM pizza_runner.runner_orders
WHERE cancellation IS NULL
OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY runner_id
ORDER BY successful_orders DESC;
```

**Result:**
| runner_id | successful_orders |
|-----------|-------------------|
| 1         | 4                 |
| 2         | 3                 |
| 3         | 1                 |

### **Q4. How many of each type of pizza was delivered?**
```SQL
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
```

OR

```SQL
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
```

**Result:**
| pizza_name | pizza_type_count |
|------------|------------------|
| Meatlovers | 9                |
| Vegetarian | 3                |

---

### **Q5. How many Vegetarian and Meatlovers were ordered by each customer?**
```SQL
SELECT
  customer_id,
  SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS meat_lovers,
  SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS vegetarian
FROM pizza_runner.customer_orders
GROUP BY customer_id;
```
**Result:**
| customer_id | meat_lovers | vegetarian |
|-------------|-------------|------------|
| 101         | 2           | 1          |
| 103         | 3           | 1          |
| 104         | 3           | 0          |
| 105         | 0           | 1          |
| 102         | 2           | 1          |

---

### **Q6. What was the maximum number of pizzas delivered in a single order?**
```SQL
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
 ``` 
**Result:**
| max_count |
|-----------|
| 3         |


### **Q7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**
```SQL
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
```

**Result:**
| customer_id | changes | no_change |
|-------------|---------|-----------|
| 101         | 0       | 2         |
| 102         | 0       | 3         |
| 103         | 3       | 3         |
| 104         | 2       | 2         |
| 105         | 1       | 1         |

---

### **Q8. How many pizzas were delivered that had both exclusions and extras?**
```SQL
SELECT
  SUM(CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1 ELSE 0 END) as pizza_count
FROM pizza_runner.customer_orders
INNER JOIN pizza_runner.runner_orders
  ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.cancellation IS NULL
  OR runner_orders.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
```  
**Result:**
| pizza_count |
|-------------|
| 1           |

---

### **Q9. What was the total volume of pizzas ordered for each hour of the day?**
```SQL
SELECT
  DATE_PART('hour', order_time::TIMESTAMP) AS hour_of_day,
  COUNT(*) AS pizza_count
FROM pizza_runner.customer_orders
WHERE order_time IS NOT NULL
GROUP BY hour_of_day
ORDER BY hour_of_day;
```


### **Q10. What was the volume of orders for each day of the week?**
```SQL
SELECT
  TO_CHAR(order_time, 'Day') AS day_of_week,
  COUNT(*) AS pizza_count
FROM pizza_runner.customer_orders
GROUP BY 
  day_of_week, 
  DATE_PART('dow', order_time)
ORDER BY day_of_week;
```