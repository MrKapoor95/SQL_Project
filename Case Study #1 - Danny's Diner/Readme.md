# Danny's Diner Restaurent

## Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.
Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.
***

## Problem Statement
* Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

* He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

* Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!
***

📁 DATASETS
Danny has shared with you 3 key datasets for this case study:

1. SALES
<details>
  <summary>View Table</summary>
  The sales table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.
|customer_id	| order_date |	product_id |
| :---: 	| :---: | :---:  | :---: |
| A |	2021-01-01 |	1 |
| A |	2021-01-01 |	2 |
| A |	2021-01-07 |	2 |
| A |	2021-01-10 |	3 |
| A |	2021-01-11 |	3 |
| A |	2021-01-11 |	3 |
| B |	2021-01-01 |	2 |
| B |	2021-01-02 |	2 |
| B |	2021-01-04 |	1 |
| B |	2021-01-11 |	1 |
| B |	2021-01-16 |	3 |
| B |	2021-02-01 |	3 |
| C |	2021-01-01 |	3 |
| C	| 2021-01-01 |	3 |
| C	| 2021-01-07 |	3 |
</details>

2. MENU
View Table
3. MEMBERS
View Table
💬 CASE STUDY QUESTIONS
What is the total amount each customer spent at the restaurant?
How many days has each customer visited the restaurant?
What was the first item from the menu purchased by each customer?
What is the most purchased item on the menu and how many times was it purchased by all customers?
Which item was the most popular for each customer?
Which item was purchased first by the customer after they became a member?
Which item was purchased just before the customer became a member?
What is the total items and amount spent for each member before they became a member?
If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
🎯 INSIGHTS GENERATED
Ramen was the most favorite dish/ ordered item by all the customers with ordered 8 times.
Customer with Id 'A' ordered the most while Customer with ID 'B' spent the least amount
Customer with Id 'B' visited more in the restaurant i.e., 6 times.






### Danny has shared with you 3 key datasets for this case study:

* sales
* menu
* members
```SQL
CREATE SCHEMA dannys_diner;
USE dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
```

[DBFiddle Link For Schema](https://www.db-fiddle.com/f/2rM8RAnq7h5LLDTzZiRWcd/138)

You can inspect the entity relationship diagram and example data below.

<img src="https://github.com/MrKapoor95/SQL_Project/blob/main/Case%20Study%20%231%20-%20Danny's%20Diner/CaseStudy%201%20Schema.png" width=50% height=50%>


***

## Case Study Questions

I am using MySQL for querying the following case study questions.

### 1 What is the total amount each customer spent at the restaurant?

```sql
SELECT
	s.customer_id,	sum(m.price) as "amount"
FROM 
	dannys_diner.sales as s
JOIN 
	dannys_diner.menu as m on s.product_id = m.product_id
GROUP BY 
	s.customer_id
ORDER BY 
	Amount DESC;
```
Output
| customer_id    | amount   |
| :---:   | :---: |
| A | 76  |
| B | 74  |
| C | 36  |

### 2 How many days has each customer visited the restaurant?

```sql
SELECT 
	s.customer_id, count(DISTINCT s.order_date) as "count"
FROM
    dannys_diner.sales as s
GROUP BY 
	s.customer_id
ORDER BY 
	 s.customer_id;

```
Output
| customer_id    | count   |
| :---:   | :---: |
| A | 4  |
| B | 6  |
| C | 2  |

3 What was the first item from the menu purchased by each customer?

```sql
SELECT
	s.customer_id,
    m.product_name
FROM 
	dannys_diner.sales as s
JOIN 
	dannys_diner.menu as m
    on s.product_id = m.product_id
GROUP BY 
	s.customer_id;
```
Output
| customer_id    | product_id   |
| :---:   | :---: |
| A | sushi  |  
| B | curry  |
| C | ramen  |

4 What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
SELECT 
	m.product_name, count(s.product_id) as order_count
FROM 
	dannys_diner.sales as s
INNER JOIN 
	dannys_diner.menu as m ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY order_count desc
limit 1;
```
Using Rank()
```sql
SELECT product_name, order_count
FROM (
	SELECT
	m.product_name, count(s.product_id) as order_count,
    RANK() OVER(ORDER BY s.product_id DESC) as order_rank
	FROM 
	dannys_diner.sales as s
	INNER JOIN 
	dannys_diner.menu as m ON s.product_id=m.product_id
	GROUP BY m.product_name) as item_count
WHERE order_rank = 1;
```
Output
| product_name    | order_count   |
| :---:   | :---: |
| ramen | 8  | 


5 Which item was the most popular for each customer?

```sql
SELECT 
	customer_id, product_name
FROM
	(SELECT 
		s.customer_id, s.product_id, m.product_name, count(s.product_id) as order_count,
   		rank() OVER(PARTITION BY s.customer_id ORDER BY count(s.product_id) DESC) as ranking
	FROM 
		dannys_diner.sales as s
	INNER JOIN 
		dannys_diner.menu as m ON s.product_id=m.product_id
	GROUP BY s.customer_id, s.product_id) as order_ranking
WHERE ranking = 1
ORDER BY customer_id
;
```
Output
| customer_id    | product_name   |
| :---:   | :---: |
| A | ramen  |  
| B | curry  |
| B | sushi  |
| B | ramen  |
| C | ramen  |

6 Which item was purchased first by the customer after they became a member?

```sql
SELECT 
	customer_id, product_name
FROM
	(SELECT 
		s.customer_id, s.product_id, m.product_name, s.order_date ,
		rank() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) as ranking
	FROM 
		dannys_diner.menu as m 
	JOIN 
		dannys_diner.sales as s ON s.product_id=m.product_id
	JOIN 
		dannys_diner.members as mb ON s.customer_id=mb.customer_id
	WHERE 
		s.order_date >=mb.join_date) as order_ranking
where ranking=1 ;
```
Output
| customer_id    | product_name   |
| :---:   | :---: |
| A | curry  |  
| B | sushi  |

7 Which item was purchased just before the customer became a member?

```sql
SELECT 
	customer_id, product_name
FROM
	(SELECT 
		s.customer_id, s.product_id, m.product_name, s.order_date ,
		rank() OVER(PARTITION BY s.customer_id ORDER BY s.order_date desc) as ranking
	FROM 
		dannys_diner.menu as m 
	JOIN 
		dannys_diner.sales as s ON s.product_id=m.product_id
	JOIN 
		dannys_diner.members as mb ON s.customer_id=mb.customer_id
	WHERE 
		s.order_date < mb.join_date) as order_ranking
where ranking=1 ;
```
Output
| customer_id    | product_name   |
| :---:   | :---: |
| A | sushi  |  
| A | curry  |  
| B | sushi  |

8 What is the total items and amount spent for each member before they became a member?

```sql
SELECT 
	s.customer_id,
	COUNT(s.product_id) AS item_count,
	SUM(m.price) AS amount
FROM 
	dannys_diner.menu AS m
JOIN 
	dannys_diner.sales AS s ON s.product_id = m.product_id
JOIN 
	dannys_diner.members AS mb ON s.customer_id = mb.customer_id
WHERE
	s.order_date < mb.join_date
GROUP BY 
	s.customer_id ;
```
Output
| customer_id    | item_count   | Amount   |
| :---:   | :---: | :---: |
| B | 3  | 40  |  
| A | 2  | 25  |  

9 If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql
SELECT 
	customer_id, sum(points) as Total_Points
FROM
	(SELECT customer_id, product_name, amount, 
	  	CASE WHEN product_name="sushi" THEN amount*20 ELSE amount*10 END as Points
	 FROM
	       (SELECT 
			s.customer_id,
			m.product_name,
			SUM(m.price) AS amount
		FROM 
			dannys_diner.menu AS m
		JOIN 
			dannys_diner.sales AS s ON s.product_id = m.product_id
		GROUP BY customer_id, m.product_name) 
		as amount_spent) 
	as points
GROUP BY customer_id ;
```
Output
| customer_id    | Total_points   |
| :---:   | :---: |
| A | 860  |  
| A | 940  |  
| B | 360  |

10 In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

```sql
SELECT 
	s.customer_id,
	SUM(CASE 
		WHEN (s.order_date >= mb.join_date) AND (s.order_date <= "2021-01-31") THEN  price*20
            	WHEN (s.order_date < mb.join_date) AND (m.product_name="sushi") THEN price*20 ELSE price*10
	    END) as Points
FROM 
	dannys_diner.menu AS m
JOIN 
	dannys_diner.sales AS s ON s.product_id = m.product_id
JOIN 
	dannys_diner.members AS mb ON s.customer_id = mb.customer_id
GROUP BY s.customer_id ;
```
Output
| customer_id    | Total_points   |
| :---:   | :---: |
| A | 1060  |  
| B | 1370  | 
