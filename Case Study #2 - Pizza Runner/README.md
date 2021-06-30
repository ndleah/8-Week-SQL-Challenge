![Star Badge](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=style=flat&color=BC4E99)
[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/nduongthucanh/8-Week-SQL-Challenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/nduongthucanh?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/nduongthucanh)

# [8-Week SQL Challenge](https://github.com/nduongthucanh/8-Week-SQL-Challenge)

# Case Study #2 - Pizza Runner
<p align="center">
<img src="https://github.com/nduongthucanh/8-Week-SQL-Challenge/blob/main/IMG/org-2.png" width=50% height=50%>

## Table Of Contents
  - [Problem Statement](#problem-statement)
  - [Dataset](#dataset)
  - [Case Study Questions](#case-study-questions)
    - [Pizza Metrics](#pizza-metrics)
    - [Runner and Customer Experience](#runner-and-customer-experience)
    - [Ingredient Optimisation](#ingredient-optimisation)
    - [Pricing and Ratings](#pricing-and-ratings)
  - [Solutions](#solutions)
 <br /> 

## Problem Statement

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so **Pizza Runner** was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

 <br /> 

## Dataset
Danny has shared with you 6 key datasets for this case study:

* ### **```runners```**

The runners table shows the **```registration_date```** for each new runner.

|runner_id|registration_date|
|---------|-----------------|
|1        |1/1/2021         |
|2        |1/3/2021         |
|3        |1/8/2021         |
|4        |1/15/2021        |


 <br /> 

* ### **```customer_orders```**

Customer pizza orders are captured in the **```customer_orders```** table with 1 row for each individual pizza that is part of the order.

|order_id|customer_id|pizza_id|exclusions|extras|order_time        |
|--------|---------|--------|----------|------|------------------|
|1  |101      |1       |          |      |44197.75349537037 |
|2  |101      |1       |          |      |44197.79226851852 |
|3  |102      |1       |          |      |44198.9940162037  |
|3  |102      |2       |          |*null* |44198.9940162037  |
|4  |103      |1       |4         |      |44200.558171296296|
|4  |103      |1       |4         |      |44200.558171296296|
|4  |103      |2       |4         |      |44200.558171296296|
|5  |104      |1       |null      |1     |44204.87533564815 |
|6  |101      |2       |null      |null  |44204.877233796295|
|7  |105      |2       |null      |1     |44204.88922453704 |
|8  |102      |1       |null      |null  |44205.99621527778 |
|9  |103      |1       |4         |1, 5  |44206.47429398148 |
|10 |104      |1       |null      |null  |44207.77417824074 |
|10 |104      |1       |2, 6      |1, 4  |44207.77417824074 |


 <br /> 

* ### **```runner_orders```**

After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The **```distance```** and **```duration```** fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

|order_id|runner_id|pickup_time|distance  |duration|cancellation      |
|--------|---------|-----------|----------|--------|------------------|
|1       |1        |1/1/2021 18:15|20km      |32 minutes|                  |
|2       |1        |1/1/2021 19:10|20km      |27 minutes|                  |
|3       |1        |1/3/2021 0:12|13.4km    |20 mins |*null*             |
|4       |2        |1/4/2021 13:53|23.4      |40      |*null*             |
|5       |3        |1/8/2021 21:10|10        |15      |*null*             |
|6       |3        |null       |null      |null    |Restaurant Cancellation|
|7       |2        |1/8/2020 21:30|25km      |25mins  |null              |
|8       |2        |1/10/2020 0:15|23.4 km   |15 minute|null              |
|9       |2        |null       |null      |null    |Customer Cancellation|
|10      |1        |1/11/2020 18:50|10km      |10minutes|null              |

 <br /> 

* ### **```pizza_names```**

|pizza_id|pizza_name|
|--------|----------|
|1       |Meat Lovers|
|2       |Vegetarian|

 <br /> 

 *  ### **```pizza_recipes```**

Each **```pizza_id```** has a standard set of **```toppings```** which are used as part of the pizza recipe.

|pizza_id|toppings |
|--------|---------|
|1       |1, 2, 3, 4, 5, 6, 8, 10| 
|2       |4, 6, 7, 9, 11, 12| 
 <br /> 

  *  ### **```pizza_toppings```**

This table contains all of the **```topping_name```** values with their corresponding **```topping_id```** value.

|topping_id|topping_name|
|----------|------------|
|1         |Bacon       | 
|2         |BBQ Sauce   | 
|3         |Beef        |  
|4         |Cheese      |  
|5         |Chicken     |     
|6         |Mushrooms   |  
|7         |Onions      |     
|8         |Pepperoni   | 
|9         |Peppers     |   
|10        |Salami      | 
|11        |Tomatoes    | 
|12        |Tomato Sauce|

 <br /> 

## Case Study Questions
<p align="center">
<img src="https://media3.giphy.com/media/JQXKbzdLTQJJKP176X/giphy.gif" width=80% height=80%>

This case study has LOTS of questions - they are broken up by area of focus including:
- Pizza Metrics
- Runner and Customer Experience
- Ingredient Optimisation
- Pricing and Ratings

---

### 1. **Pizza Metrics**
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

### 2. **Runner and Customer Experience**
1. How many runners signed up for each 1 week period? (i.e. week starts **```2021-01-01```**)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

### 3. **Ingredient Optimisation**
1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the **```customers_orders```** table in the format of one of the following:
   * ```Meat Lovers```
   * ```Meat Lovers - Exclude Beef```
   * ```Meat Lovers - Extra Bacon```
   * ```Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers```

5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the **```customer_orders```** table and add a 2x in front of any relevant ingredients
    * For example: ```"Meat Lovers: 2xBacon, Beef, ... , Salami"```
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

### 4. **Pricing and Ratings**
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
     * ```customer_id```
     * ```order_id```
     * ```runner_id```
     * ```rating```
     * ```order_time```
     * ```pickup_time```
     * ```Time between order and pickup```
     * ```Delivery duration```
     * ```Average speed```
     * ```Total number of pizzas```
5. f a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

 <br /> 

## Solutions
*UPDATING*
