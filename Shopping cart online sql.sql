

--Data exploration--

select * from customers
select * from orders
select * from products
select * from sales



--1. Different types of products available--

select product_type from products group by Product_type
----Trousers, Jacket, Shirt (3)



--2. Total number of colours available--
select count(distinct colour) from products
----(7)



--3. Total count of cutomers vs sales vs orders vs products--

select count (customer_name) from customers
select count (sales_id) from sales
select count (order_id) from orders
select count (product_id) from products
----1000 vs 5000 vs 1000 vs 1260
----5000 products were sold to 1000 different customers from the 1260 different products available



--4.Total orders made per customer--
select count( order_id)as ordered_times, Customer_name, customers.Customer_id from customers 
   join orders on customers.Customer_id=orders.Customer_id 
   group by Customer_name, customers.Customer_id



--5. Total distinct items bought per customer--
select count(distinct products.product_id), Customer_name from customers 
   join orders on customers.Customer_id=orders.Customer_id 
   join sales on orders.Order_id=sales.Order_id 
   join products on sales.Product_id= products.Product_ID
   group by Customer_name



--4.Total quantity sold per customer--

select sum(Quantity) as quantity, Customer_name from customers 
   join orders on customers.Customer_id=orders.Customer_id 
   join sales on orders.Order_id=sales.Order_id 
   group by Customer_name 


--5. Customers who bought more than 40 products--
select sum(Quantity) as quantity, Customer_name from customers 
   join orders on customers.Customer_id=orders.Customer_id 
   join sales on orders.Order_id=sales.Order_id 
   group by Customer_name having sum(Quantity)>40



--6. Total amount each customer spent on products--

select customer_name, sum(total_price) as amount_spent from customers 
   join orders orders on customers.Customer_id=orders.Customer_id 
   join sales on orders.Order_id=sales.Order_id group by customer_name



--7. Customer who purchased the most items--

select sum(Quantity) as quantity, Customer_name from customers 
   join orders on customers.Customer_id=orders.Customer_id 
   join sales on orders.Order_id=sales.Order_id 
   group by Customer_name order by quantity desc
----Wren Helgass (74)



--8. Customer who spent the most--

select customer_name, sum(total_price) as amount_spent from customers 
   join orders orders on customers.Customer_id=orders.Customer_id 
   join sales on orders.Order_id=sales.Order_id group by customer_name order by amount_spent desc
----Wren Helgass (7632)



--9.Most purchased product--

select products.product_name, sum(sales.quantity)as sold_quantity from products 
   join sales on products.Product_ID= sales.Product_id
   group by product_name order by sold_quantity desc
----Denim(527)






--A. Which products were sold the most in the last month?--
select datepart(month, Order_Date) as MonthName, sum(sales.Quantity) as products_sold, p.Product_name, p.Product_type
   from orders join sales on orders.Order_id=sales.Order_id
   join products as p on sales.Product_id=p.Product_ID
   group by datepart(month, Order_Date), Product_name , Product_type order by month(Order_date) desc, 2 desc
----Cords trousers(37) was sold the most in the month of October i.e the last month just followed by high-waisted(36)



--Name of the most revenue generating product in the last month
	
select datepart(month, Order_Date) as MonthName, sum(sales.Total_price)as total_reveue, p.Product_name, p.Product_type
   from orders join sales on orders.Order_id=sales.Order_id
   join products as p on sales.Product_id=p.Product_ID
   group by datepart(month, Order_Date), Product_name, p.Product_type order by month(Order_date) desc, 2 desc
----High-waisted truosers with revenue of 3564 followed by cords with 3478






--B. How have sales and revenue changed over the past few quarters?--

--1.Revenue changes across all the months--
select datepart(month, order_date) as month , sum(total_price) as total_price, Revenu=
case
when sum(total_price) >= 100000 then 'Larger Revenue'
when sum(total_price) <100000 then 'Smaller Revenue'
else 'null'
end
from orders 
   join sales on orders.Order_id= sales.Order_id
   group by datepart(month, order_date) order by 1 desc

----This year had good and bad months equally
----The last two months generated relatively less revenue than the months before--



--2.Sales prformance over past few months--
select datepart(month, order_date) as month , sum(Quantity) as total_quantity, sales=
case
when sum(Quantity) >= 1000 then 'Sold more than 1000 products'
when sum(Quantity)  <1000  then 'Sold under 1000 products'
else 'null'
end
from orders 
   join sales on orders.Order_id= sales.Order_id
   group by datepart(month, order_date) order by 1 desc

----It can be obeserved that the months with less sales made relatively less revenue
----But except for June--






--C. Uderstanding customer demographics and their preferences?--

--1. Age group with the highest purchasing price--

select customers.age, sum(total_price) as amount_spent from customers 
   join orders orders on customers.Customer_id=orders.Customer_id 
   join sales on orders.Order_id=sales.Order_id group by customers.Age order by amount_spent desc
----(57)



--2. Oldest, youngest and avgerage age of customers--

select max(age), min(age), avg(age) from customers
----80, 20, 49.86



--3. Number of customers in each age group--
select count(age), age from customers group by age
---Age groups with most cutomers
select count(age), age from customers group by age order by 1 desc
----59, 75, 34



--4. Gender wise count--
select gender, count(gender) from customers group by gender


--5. Gender that spent the most--
select gender, sum(total_price) from customers 
   join orders on customers.Customer_id=orders.Customer_id 
   join sales on orders.Order_id=sales.Order_id group by gender
----Female



--6. Number of customers from each state--
select state, count(state )from customers group by state


--7. State with the most customers--

select state, count(state ) as customers_count from customers group by state order by customers_count desc
----South Australia (139)


--8. State that generated the most revenue--

select state, sum(total_price) as total_revenue from customers
   join orders on customers.Customer_id=orders.Customer_id 
   join sales on orders.Order_id=sales.Order_id group by State order by total_revenue desc
-----South Australia (147816) followed by Queensland (142062)


