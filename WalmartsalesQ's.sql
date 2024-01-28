create database salesdatawalmart;
create table if not exists sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null, 
city varchar(30) not null,
customer_type varchar(30)not null,
gender varchar(10)not null,
product_line varchar(100)not null,
unit_price decimal(10,2)not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(10,2) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_percentage float(11,9) not null,
gross_income decimal(10,2) not null,
rating float(2,1));


-- Feature engineering----THIS WILL GENERATE SOME NEW COLUMNS FROM EXISTING ONE-------%%%%%

-- time_of_day--------------------------------------------


select time,(
case when time between "00:00:00" and "12:00:00" then "Morning" when time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end) 
as time_of_date
from sales;

alter table sales add column time_of_day varchar(30);

update sales set time_of_day=(
case 
    when time between "00:00:00" and "12:00:00" then "Morning" 
    when time between "12:01:00" and "16:00:00" then "Afternoon"
	else "Evening"
end
);



-- day_name----------------------------------

select date, dayname(date) from sales;

alter table sales add column name_of_day varchar(30);

update sales set name_of_day=dayname(date);

-- month_name---------------------------------

select date, monthname(date) from sales;

alter table sales add column month_name varchar(30);

update sales set month_name=monthname(date);

-- BUSINESS QUESTIONS---

-- How many unique cities does the data have?

select distinct city from sales;

-- 2)In which city is each branch?

select  distinct city, branch 
from sales ;

-- Product How many unique product lines does the data have?

select distinct product_line from sales;
select distinct count(distinct product_line) from sales;

-- What is the most common payment method?

select payment_method, count(payment_method) AS Numberofpaymentsdone 
from sales
group by payment_method 
order by numberofpaymentsdone desc;

-- What is the most selling product line?

select product_line, 
count(product_line) as Mostselling
from sales
group by product_line
order by mostselling desc;

-- 4.	What is the total revenue by month?

select month_name as Month, sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?

select month_name as month ,sum(cogs) 
from sales
group by month_name
order by sum(cogs) desc;

-- What product line had the largest revenue?
select product_line ,sum(total) as Largest_revenue
from sales
group by product_line
order by Largest_revenue desc;

-- What is the city with the largest revenue?

select branch,city, sum(total)as largest_revenue_city
from sales
group by city,branch
order by largest_revenue_city desc;

-- What product line had the largest VAT?

select product_line, avg(VAT)
from sales
group by product_line
order by avg(VAT) desc;

-- 9.	Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

alter table sales add column state_of_product_line varchar(255) after product_line;

select avg(quantity) as avgsales from sales;


select product_line, 
case
when avg(quantity)>6 then 'good' 
else 'bad'
end as Remark 
from sales
group by product_line;

select*from sales;

-- Which branch sold more products than average product sold?

select branch,sum(quantity) from sales
group by branch
having sum(quantity)> (select avg(quantity) from sales);

-- 11.	What is the most common product line by gender?

select gender,product_line,count(gender) as total_cnt from sales
GROUP BY gender,product_line
order by total_cnt desc;


-- 12.	What is the average rating of each product line?

select product_line ,round(avg(rating),2) -- Rounding decimal to 2 places
from sales
group by product_line;

-- Sales--------------- Number of sales made in each time of the day per weekday

select time_of_day,
count(*) as total_sales 
from sales
where name_of_day= "tuesday"
group by time_of_day;

-- 2.	Which of the customer types brings the most revenue?

select customer_type, sum(total)
from sales
group by customer_type
order by sum(total) desc;

-- 3.	Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, avg(VAT)
from sales
group by city
order by avg(vat)desc;

-- Which customer type pays the most in VAT?

select customer_type , sum(vat)
from sales
group by customer_type
order by customer_type desc;

-- Customer-----------------------------------------------------------------------------
---------------------------------------------------

-- How many unique customer types does the data have?

select distinct(customer_type) 
from sales;

-- ---How many unique payment methods does the data have?

select distinct(payment_method)
from sales;

--  What is the most common customer type?

select customer_type,count(customer_type) as common_customer
from sales
group by customer_type
order by common_customer desc;

-- Which customer type buys the most?

select customer_type, sum(total)
from sales
group by customer_type
order by sum(total) desc;

-- What is the gender of most of the customers?

select gender, count(gender)
from sales
group by gender
order by count(gender) desc;


-- 6.	What is the gender distribution per branch?

select branch, gender, count(gender)
from sales
group by branch,gender
order by branch;

-- Which time of the day do customers give most ratings?

select avg(rating), time_of_day
from sales
group by time_of_day
order by avg(rating) desc;


--  Which time of the day do customers give most ratings per branch?

select avg(rating), time_of_day, branch
from sales
where branch="C"
group by time_of_day
order by avg(rating) desc;

-- Which day of the week has the best avg ratings?

select avg(rating), name_of_day
from sales
group by name_of_day
order by avg(rating) desc;

-- Which day of the week has the best average ratings per branch?

select avg(rating), name_of_day
from sales
where branch="A"
group by name_of_day
order by avg(rating) desc;

