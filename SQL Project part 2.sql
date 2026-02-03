
-- Level 1: Basics 

-- 1. Retrieve customer names and emails for email marketing

select name, email from customers;

-- 2. View complete product catalog with all available details 

select * from products;

-- 3. List all unique product categories 

select distinct(category) from products;

-- 4. Show all products priced above ₹1,000 

select * from products where price>1000;

-- 5. Display products within a mid-range price bracket (₹2,000 to ₹5,000) 

select * from products where price between 2000 and 5000;

-- 6. Fetch data for specific customer IDs (e.g., from loyalty program list) 

select * from customers where customer_id in (7,14,17,11,24);

-- 7. Identify customers whose names start with the letter ‘A’ 

select * from customers where name like 'A%';

-- 8. List electronics products priced under ₹3,000 

select name, category, price from products where category = "Electronics" and price<3000;

-- 9.  Display product names and prices in descending order of price 

select name, price from products order by price desc;

-- 10. Display product names and prices, sorted by price and then by name 

select name, price from products order by price , name ;


-- Level 2: Filtering and Formatting 

-- 1. Retrieve orders where customer information is missing (possibly due to data migration or deletion) 

select * from orders as o left join customers as c on c.customer_id= o.customer_id where c.customer_id is null;

-- 2.  Display customer names and emails using column aliases for frontend readability

select name as customer_name, email as customer_email from customers;

-- 3. Calculate total value per item ordered by multiplying quantity and item price 

select *, quantity*item_price as Total_value from order_items;

-- 4. Combine customer name and phone number in a single column

select concat(name," - ",phone) as Contact_list from customers;

-- 5. Extract only the date part from order timestamps for date-wise reporting 

select order_id,customer_id, status, date(order_date)as _Date_, total_amount  from orders;

-- 6. List products that do not have any stock left 

select name from products where stock_quantity is null;


-- Level 3: Aggregations 

-- 1. Count the total number of orders placed

select count(order_id) as Total_Orders from orders;

-- 2. Calculate the total revenue collected from all orders 

select sum(total_amount) as Total_Revenue from orders;

-- 3. Calculate the average order value 

select round(avg(total_amount),2) as Avg_Order_Value from orders;

-- 4. Count the number of customers who have placed at least one order 

select count(distinct customer_id) as _Count_ from orders; 

-- 5. Find the number of orders placed by each customer 

select customer_id, count(order_id) as Total_Orders from orders group by customer_id;

-- 6. Find total sales amount made by each customer 

select customer_id, sum(total_amount) as Total_Sales from orders group by customer_id ;

-- 7. List the number of products sold per category

select p.category, sum(oi.quantity) as Total_Quantity_Sold from products p inner join order_items oi on p.product_id = oi.product_id
group by p.category;

-- 8. Find the average item price per category 

select p.category , round(avg(oi.item_price),2) as Avg_Item_price from products p inner join order_items oi on p.product_id = oi.product_id
group by p.category;

-- 9. Show number of orders placed per day 

select dayname(order_date) as Day_name , count(order_id) as total_order_placed from orders group by dayname(order_date);

-- 10. List total payments received per payment method 

select method as Payment_Method, sum(amount_paid) as Total_payment from payments group by method;


-- Level 4: Multi-Table Queries (JOINS) 

-- 1.  Retrieve order details along with the customer name (INNER JOIN) 

select o.order_id, c.name, o.status, o.order_date, o.total_amount from orders o inner join customers c on
o.customer_id = c.customer_id;

-- 2. Get list of products that have been sold (INNER JOIN with order_items) 

select distinct p.name, p.category, oi.item_price from products as p inner join order_items as oi on p.product_id = oi.product_id;

-- 3. List all orders with their payment method (INNER JOIN) 

select o.order_id, p.method, o.total_amount from orders as o inner join payments as p on o.order_id = p.order_id;

-- 4. Get list of customers and their orders (LEFT JOIN)

select c.customer_id, c.name, o.order_id, o.status, o.total_amount from customers as c left join orders as o on c.customer_id = o.customer_id;

-- 5. List all products along with order item quantity (LEFT JOIN) 

select p.name, p.category, p.price, oi.quantity from products as p left join order_items as oi on p.product_id = oi.product_id;

-- 6. List all payments including those with no matching orders (RIGHT JOIN) 

select p.payment_id, o.order_id, p.method, p. amount_paid, o.status from orders as o right join payments as p on o.order_id = p.order_id;

-- 7. Combine data from three tables: customer, order, and payment 

select c.customer_id, c.name, c.email, o.order_id, o.order_date, o.status, p.amount_paid, p.method from 
customers as c inner join orders as o on c.customer_id = o.customer_id inner join payments as p on o.order_id = p.order_id;


-- Level 5: Subqueries (Inner Queries) 

-- 1. List all products priced above the average product price 

select product_id, name as product_name, category, price from products where price >
(select avg(price) from products);

-- 2. Find customers who have placed at least one order 

select customer_id, name as customer_name from customers where customer_id in
(select customer_id from orders);

-- 3. Show orders whose total amount is above the average for that customer

select order_id, customer_id, status, total_amount from orders where total_amount>
(select avg(total_amount) from orders);

SELECT 
    o.order_id,
    o.customer_id,
    o.status,
    o.total_amount
FROM orders o
WHERE o.total_amount > (
    SELECT AVG(o2.total_amount)
    FROM orders o2
    WHERE o2.customer_id = o.customer_id
);

-- 4. Display customers who haven’t placed any orders 

select customer_id, name from customers where customer_id not in
(select customer_id from orders);

-- 5. Show products that were never ordered 

select product_id, name, category from products where product_id not in
(select product_id from order_items);

-- 6. Show highest value order per customer 

SELECT order_id, customer_id, status, total_amount FROM orders o WHERE total_amount =
( SELECT MAX(o2.total_amount) FROM orders o2 WHERE o2.customer_id = o.customer_id );

-- 7. Highest Order Per Customer (Including Names) 

select o.order_id, c.customer_id, c.name, o.status, o.total_amount from orders o inner join customers c on o.customer_id = c.customer_id
where o.total_amount = (select max(o2.total_amount) from orders o2 where o2.customer_id = o.customer_id);


-- Level 6: Set Operations 

-- 1. List all customers who have either placed an order or written a product review 

select distinct c.customer_id, c.name from customers c left join orders o on c.customer_id = o.customer_id 
left join product_reviews pr on o.customer_id = pr.customer_id where o.customer_id is not null or pr.customer_id is not null;

-- 2. List all customers who have placed an order as well as reviewed a product [intersect not supported] 

select distinct c.customer_id, c.name from customers c left join orders o on c.customer_id = o.customer_id 
left join product_reviews pr on o.customer_id = pr.customer_id where o.customer_id is not null and pr.customer_id is not null;
