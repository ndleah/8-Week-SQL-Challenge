[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/nduongthucanh/8-Week-SQL-Challenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/nduongthucanh?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/nduongthucanh)

# [8-Week SQL Challenge](https://github.com/nduongthucanh/8-Week-SQL-Challenge)

# Case Study #4 - Customer Nodes Exploration
<p align="center">
<img src="https://github.com/nduongthucanh/8-Week-SQL-Challenge/blob/main/IMG/org-4.png" width=50% height=50%>


## 🧙‍♂️ Case Study's Questions

1. How many unique nodes are there on the Data Bank system?
2. What is the number of nodes per region?
3. How many customers are allocated to each region?
4. How many days on average are customers reallocated to a different node?
5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

 <br /> 

## 🚀 Solutions

### **Q1. How many unique nodes are there on the Data Bank system?**

```sql
SELECT COUNT(DISTINCT node_id) AS node_counts
FROM data_bank.customer_nodes;
```

| "node_count" |
|--------------|
| 5            |

### **Q2. What is the number of nodes per region?**

```sql
SELECT
	regions.region_name,
	COUNT(DISTINCT customer_nodes.node_id) AS node_counts
FROM data_bank.regions
INNER JOIN data_bank.customer_nodes
ON regions.region_id = customer_nodes.region_id
GROUP BY regions.region_name;
```

| "region_name" | "node_counts" |
|---------------|---------------|
| "Africa"      | 5             |
| "America"     | 5             |
| "Asia"        | 5             |
| "Australia"   | 5             |
| "Europe"      | 5             |

### **Q3. How many customers are allocated to each region?**

```sql
SELECT
	regions.region_name,
	COUNT(DISTINCT customer_nodes.customer_id) AS customer_counts
FROM data_bank.regions
INNER JOIN data_bank.customer_nodes
ON regions.region_id = customer_nodes.region_id
GROUP BY regions.region_name;
```

| "region_name" | "customer_counts" |
|---------------|-------------------|
| "Africa"      | 102               |
| "America"     | 105               |
| "Asia"        | 95                |
| "Australia"   | 110               |
| "Europe"      | 88                |


4.

---
<p>&copy; 2021 Leah Nguyen</p>


