CREATE SCHEMA if not exists dannys_diner;
USE dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'), ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'), ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'), ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'), ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),  ('C', '2021-01-01', '3'),
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
  
  /* --------------------
   Case Study Questions
   --------------------*/
   
## 1. What is the total amount each customer spent at the restaurant?
SELECT
	s.customer_id,
    sum(m.price) as "amount"
FROM 
	dannys_diner.sales as s
JOIN 
	dannys_diner.menu as m
    on s.product_id = m.product_id
GROUP BY 
	s.customer_id
ORDER BY 
	Amount DESC;
  
## 2. How many days has each customer visited the restaurant?
SELECT 
	s.customer_id, count(DISTINCT s.order_date) as "count"
FROM
    dannys_diner.sales as s
GROUP BY 
	s.customer_id
ORDER BY 
	 s.customer_id;
     
## 3. What was the first item from the menu purchased by each customer?
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
					## OR
SELECT customer_id, product_name, item_rank
FROM
	(
	SELECT 
		customer_id, 
		order_date, 
		product_name, DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date) as item_rank
	FROM 
		dannys_diner.sales as s
	INNER JOIN 
		dannys_diner.menu as m ON s.product_id=m.product_id
	) as rank_table
WHERE 
	rank_table.item_rank>1
GROUP BY 
	customer_id ;
    
 ## 4. What is the most purchased item on the menu and how many times was it purchased by all customers?   
SELECT 
	m.product_name, count(s.product_id) as order_count
FROM 
	dannys_diner.sales as s
INNER JOIN 
	dannys_diner.menu as m ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY order_count desc
limit 1;
				## or
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

## 5. Which item was the most popular for each customer? 

SELECT customer_id, product_name
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

## 6 Which item was purchased first by the customer after they became a member?
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

## 7. Which item was purchased just before the customer became a member?
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

## 8. What is the total items and amount spent for each member before they became a member?
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

## 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
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
;

## 10 In the first week after a customer joins the program (including their join date) they earn 2x points 
##           on all items, not just sushi - how many points do customer A and B have at the end of January?
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

## All tables
SELECT * FROM sales;
SELECT * FROM members;
SELECT * FROM menu;