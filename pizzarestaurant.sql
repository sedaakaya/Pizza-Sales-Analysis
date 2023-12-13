CREATE DATABASE pizza_sales;

USE pizza_sales;

CREATE TABLE orders (
	order_id INT PRIMARY KEY,
    date TEXT,
    time TEXT
    );
    
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
             
CREATE TABLE order_details (
   order_details_id INT PRIMARY KEY,
   order_id INT,
   pizza_id TEXT,
   quantity INT
   )
   
   
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_details.csv'
INTO TABLE order_details
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM orders
SELECT * FROM order_details
SELECT * FROM pizzas
SELECT * FROM pizza_types

CREATE VIEW pizza_details AS
SELECT p.pizza_id, p.pizza_type_id,p.price,p.size,pt.name,pt.category,pt.ingredients
FROM pizzas p
JOIN pizza_types pt
ON pt.pizza_type_id=p.pizza_type_id;

SELECT * FROM pizza_details

ALTER TABLE orders
MODIFY date DATE;

ALTER TABLE orders
MODIFY time TIME;

-- TOTAL REVENUE --

SELECT ROUND(SUM(od.quantity * p.price),2) AS total_revenue 
FROM order_details od
JOIN pizza_details p 
ON od.pizza_id = p.pizza_id;

-- TOTAL NUMBER OF PİZZAS SOLD ----

 SELECT SUM(quantity) AS pizzas_sold
 FROM order_details
 

-- TOTAL ORDERS ----

SELECT COUNT(DISTINCT(order_id)) AS total_orders
FROM orders

-- -----------

CREATE VIEW order_price_details AS
SELECT od.order_details_id, od.order_id,od.pizza_id,od.quantity, p.pizza_type_id,p.size,p.price
FROM order_details AS od
JOIN pizzas p
ON od.pizza_id=p.pizza_id;

SELECT * FROM order_price_details

-- AVERAGE ORDER VALUE ---
SELECT SUM(od.quantity*p.price)/COUNT(DISTINCT(od.order_id)) AS avg_value
FROM order_details AS od
JOIN pizzas p
ON od.pizza_id=p.pizza_id

-- AVERAGE NUMBER OF PİZZAS PER ORDER

SELECT ROUND(SUM(quantity)/COUNT(DISTINCT(order_id)),0) AS avg_num_piz
FROM order_price_details


-- TOTAL REVENUE AND NUMBER OF ORDERS PER CATEGORY

SELECT ROUND(SUM(quantity*price),2) AS total_revenue, pt.category, COUNT(DISTINCT(opd.order_id)) AS Number_order
FROM order_price_details AS opd
JOIN pizza_types pt
ON opd.pizza_type_id=pt.pizza_type_id
GROUP BY pt.category;

-- TOTAL REVENUE AND NUMBER OF ORDERS PER SİZE

SELECT ROUND(SUM(quantity*price),2) AS total_revenue, size, COUNT(DISTINCT(order_id)) AS number_order_per_size
FROM order_price_details
GROUP BY size
ORDER BY total_revenue DESC;


-- HOURLY,DAILY AND MONTHLY TREND IN ORDERS AND REVENUE OF PIZZA
-- HOURLY
SELECT
 CASE 
   WHEN HOUR(o.time) BETWEEN 9 AND 12 THEN 'Late Morning'
   WHEN HOUR(o.time) BETWEEN 12 AND 15 THEN 'Lunch'
   WHEN HOUR(o.time) BETWEEN 15 AND 18 THEN 'Mid Afternoon'
   WHEN HOUR(o.time) BETWEEN 18 AND 21 THEN 'Dinner'
   WHEN HOUR(o.time) BETWEEN 21 AND 23 THEN 'Late Dinner'
   ELSE 'Others'
   END AS meal_time,
   COUNT(DISTINCT(o.order_id)) AS total_orders
FROM order_details AS od
JOIN orders o
ON od.order_id = o.order_id
GROUP BY meal_time
ORDER BY total_orders DESC;

-- DAILY

SELECT DAYNAME(o.date) AS day_name,
COUNT(DISTINCT(o.order_id)) AS total_orders
FROM order_details AS od
JOIN orders o
ON od.order_id = o.order_id
GROUP BY day_name
ORDER BY total_orders DESC;

-- MONTHLY

SELECT MONTHNAME(o.date) AS month_name,
COUNT(DISTINCT(o.order_id)) AS total_orders
FROM order_details AS od
JOIN orders o
ON od.order_id = o.order_id
GROUP BY month_name
ORDER BY total_orders DESC;

-- Most Ordered Pizza ---------------
SELECT COUNT(od.order_id) AS most_ordered_pizza,pd.name
FROM pizza_details AS pd
JOIN order_details od
ON pd.pizza_id = od.pizza_id
GROUP BY pd.name
ORDER BY most_ordered_pizza DESC
LIMIT 1;


-- TOP 5 PİZZAS BY REVENUE -----

SELECT SUM(od.quantity*pd.price) AS total_revenue_per_pizza, pd.name
FROM pizza_details AS pd
JOIN order_details od
ON pd.pizza_id = od.pizza_id
GROUP BY pd.name
ORDER BY total_revenue_per_pizza DESC
LIMIT 5;

-- TOP PİZZAS BY SALE ---------
SELECT SUM(od.quantity) AS most_sales_pizza,pd.name
FROM pizza_details AS pd
JOIN order_details od
ON pd.pizza_id = od.pizza_id
GROUP BY pd.name
ORDER BY  most_sales_pizza DESC
LIMIT 3;







 










 