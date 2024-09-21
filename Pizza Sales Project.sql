CREATE DATABASE Pizzahut;

USE Pizzahut

-----------------------------------------------------------------------------------------
-- TABLE NAMES---------
SELECT table_name
FROM INFORMATION_SCHEMA.TABLES

SELECT * FROM Pizzas
SELECT * FROM Pizza_types
SELECT * FROM Orders
SELECT * FROM Order_details

---------------------------------------------------------------------
--1].----Retrieve the total number of orders placed.----

SELECT COUNT(*) AS total_Number_Orders FROM Orders;

-----------------------------------------------------------------------------

--2].-----Calculate the total revenue generated from pizza sales.------

SELECT ROUND(sum(O_S.quantity * p.price),2) AS Total_revenue
FROM Order_details O_S
INNER JOIN 
Pizzas p
ON O_S.pizza_id=p.pizza_id;

------------------------------------------------------------------------------------------

--3].-------Identify the highest-priced pizza.------

SELECT P_t.name,p.price as Highest_Price 
FROM Pizza_types P_t
INNER JOIN
Pizzas p
ON p.pizza_type_id = p_t.pizza_type_id
WHERE p.price=(SELECT MAX(Price)FROM Pizzas);

--------------------------------------------------------------------------------------------------

--4]------Identify the most common pizza size ordered.----------

SELECT Pizzas.size,COUNT(Order_details.order_id) AS Common_Pizza
FROM Pizzas
INNER JOIN 
Order_details
ON Pizzas.pizza_id=Order_details.pizza_id
GROUP BY Pizzas.size
ORDER BY Common_Pizza DESC;

-------------------------------------------------------------------------------------------
--5]----List the top 5 most ordered pizza types along with their quantities.---

SELECT  TOP 5 Pizza_types.name,  SUM(Order_details.quantity) AS quantity
FROM Pizza_types 
JOIN Pizzas
ON Pizza_types.pizza_type_id=Pizzas.Pizza_type_id
join Order_details
ON Order_details.pizza_id=Pizzas.pizza_id
GROUP BY Pizza_types.name
ORDER BY quantity Desc;

------------------------------------------------------------------------------

--6]-----------Join the necessary tables to find the total quantity of each pizza category ordered.-----------------

SELECT Pizza_types.category,
sum(Order_details.quantity) AS TOTAL_QTY
FROM Pizza_types
JOIN 
Pizzas
ON Pizza_types.pizza_type_id=Pizzas.pizza_type_id
JOIN
Order_details
ON Pizzas.pizza_id=Order_details.pizza_id
GROUP BY Pizza_types.category
ORDER BY TOTAL_QTY DESC

------------------------------------------------------------------------------------


--7]-----Join relevant tables to find the category-wise distribution of pizzas.-----


SELECT Category, COUNT(name) AS Categorical_count 
FROM Pizza_types
GROUP BY Category;

--------------------------------------------------------------------------------

--8]---Group the orders by date and calculate the average number of pizzas ordered per day.----


SELECT ROUND(AVG(quantity),0) AS Average_Order_Pizza FROM 
(SELECT Orders.date,SUM(Order_details.quantity) AS quantity
FROM Orders
INNER JOIN 
Order_details
ON Orders.order_id=Order_details.order_id
GROUP BY Orders.date) AS Order_quantity;

----------------------------------------------------------------------------

--9]-----Determine the top 3 most ordered pizza types based on revenue.------

SELECT  TOP 3 Pizza_types.name, SUM(Pizzas.price*Order_details.quantity)AS Revenue
FROM Pizza_types
JOIN
Pizzas
ON Pizza_types.pizza_type_id=Pizzas.pizza_type_id
JOIN 
Order_details
ON Pizzas.pizza_id=Order_details.pizza_id
GROUP BY Pizza_types.name
ORDER BY Revenue DESC;

---------------------------------------------------------------------------------

--10]----Calculate the percentage contribution of each pizza type to total revenue.---

SELECT Pizza_types.category,
CONCAT(ROUND(SUM(Order_details.quantity * Pizzas.price) / 
(SELECT ROUND(SUM(Order_details.quantity * Pizzas.price), 2) AS total_sales
FROM Order_details
JOIN Pizzas 
ON Pizzas.pizza_id = Order_details.pizza_id) 
* 100, 2), '%') AS Percentagewise_revenue
FROM Pizza_types
JOIN Pizzas 
ON Pizza_types.pizza_type_id = Pizzas.pizza_type_id
JOIN Order_details 
ON Order_details.pizza_id = Pizzas.pizza_id
GROUP BY 
Pizza_types.category
ORDER BY 
Percentagewise_revenue DESC;

----------------------------------------------------------------------------------------------------------------------
