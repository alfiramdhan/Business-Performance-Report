-- Customer overview :
-- 1.	How many customers has store ever had?
select count(distinct customer_id)as total_customer,
		count(distinct order_id)as total_sales,
		sum(sales)as total_revenue
FROM store_data;

-- 2.	What is the average monthly active users per year
with yearly_number AS(
	select extract(year from order_date)as years,
			extract(month from order_date)as months,
			count(distinct customer_id)as number_customer
	from store_data	
	group by 1,2
	order by 1
)
	SELECT years,
			round(avg(number_customer))as avg_active_cust
	from yearly_number	
	group by 1;

-- 3.	What is the number of new customer per year?
select extract(year from first_date)as years,
		count(distinct customer_id)as num_customer
from (		
		select customer_id,
				min(order_date)as first_date
		from store_data	
		group by 1
		order by 2
	)as table_annual
group by 1
order by 1;

-- 4.	What is the number of customers who placed a repeat order (retained)?
with repeat_order AS(
	select extract(year from order_date)as years,
			t1.customer_id,
			count(distinct t1.customer_id)as number_customer
	from store_data t1
	left join master_customer t2 ON t1.customer_id = t2.customer_id
	group by 1,2
	having count(order_id) > 1
)
	SELECT years,
			count(number_customer)as total_customer_repeat
	from repeat_order	
	group by 1;

-- 5.	What is the average order per year
with orders as(
	select extract(year from order_date)as years,
			customer_id,
			count(distinct order_id)as number_order
	from store_data
	group by 1,2
	order by 1
)
	select years,
			round(avg(number_order),1)as avg_order
	from orders
	group by 1;
	
-- 

-- Sales Overview :
-- 6.	What has the trend been for sales versus revenue from 2015 to 2018?
WITH first_number AS (
SELECT extract(year from order_date)as year,
		COUNT(DISTINCT order_id)as total_order,
		SUM(sales)as revenue
FROM store_data
WHERE sales IS NOT NULL
GROUP BY 1
ORDER BY 1
),
-- add column LAG and LEAD 
 before_after AS(
	SELECT year,
			total_order,
			LAG(total_order) OVER (order by year)as total_order_before,
			LEAD(total_order) OVER (ORDER BY year)as total_order_after,
			revenue,
			LAG(revenue) OVER (order by year)as revenue_before,
			LEAD(revenue) OVER (ORDER BY year)as revenue_after
	FROM first_number
	ORDER BY 1
	)
		SELECT year, total_order, revenue,
				round(cast(SUM(total_order - total_order_before)::float*100/SUM(total_order_before)::float as numeric),2) as growth_order,
				round(cast(SUM(revenue - revenue_before)::float*100/SUM(revenue_before)::float as numeric),2) as growth_revenue
		FROM before_after
		GROUP BY 1,2,3
		ORDER BY 1;

-- 7.	Which state contributed the most to sales and revenue?
SELECT state,
		COUNT(DISTINCT order_id)as total_order,
		row_number() over(order by COUNT(DISTINCT order_id) desc)as rank_sales,
		SUM(sales)as revenue,
		row_number() over(order by SUM(sales) desc)as rank_revenue
FROM store_data t1
left join master_customer t2 ON t1.customer_id = t2.customer_id
WHERE sales IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC, 4 DESC;

-- 8.	Which category contributed the most to sales and revenue?
SELECT category,
		COUNT(DISTINCT order_id)as total_order,
		row_number() over(order by COUNT(DISTINCT order_id) desc)as rank_sales,
		SUM(sales)as revenue,
		row_number() over(order by SUM(sales) desc)as rank_revenue
FROM store_data t1
left join master_product t2 ON t1.product_id = t2.product_id
WHERE sales IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC, 4 DESC;

-- 9.	What is the largest total amount (GMV) each customer spent at the store?
SELECT t1.customer_id,
		SUM(sales)as revenue,
		row_number() over(order by SUM(sales) desc)as rank_revenue
FROM store_data t1
left join master_customer t2 ON t1.customer_id = t2.customer_id
WHERE sales IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
limit 1;

-- 10.	Which market/segment is the largest and smallest?
SELECT segment,
		count(distinct t1.customer_id)as number_customer,
		count(distinct order_id)as number_orders
from store_data t1
join master_customer t2 on t1.customer_id = t2.customer_id
group by 1;

-- Product Overview
-- 11.	What was the first item purchased by all customer?
select customer_id,
		product_name,
		min(order_date)as first_date
from store_data t1
left join master_product t2 on t1.product_id = t2.product_id
group by 1,2
order by 3

-- 
with index_rank as(
	select order_date,
		category,
		product_name,
		row_number() over(order by order_date)as rnk
	from store_data t1
		left join master_product t2 on t1.product_id = t2.product_id
)
	
	select order_date,
		category,
		product_name
	from index_rank
	where rnk = 1
	order by 1;		

-- 12.	What is the most purchased item and how many times was it purchased by all customers?
select t1.product_id,
		product_name,
		count(t1.product_id)as number_purchase,
		row_number() over(partition by t1.product_id
						  order by count(t1.product_id) desc)as rank_order
from store_data t1
		left join master_product t2 on t1.product_id = t2.product_id
group by 1,2
order by 3 desc
limit 1;

-- 13.	Which sub_category was the most popular for all customer?
with index_rank as(
	select sub_category,
			count(sub_category)as number_product,
			row_number() over(order by count(sub_category) desc)as rnk
	from store_data t1
		left join master_product t2 on t1.product_id = t2.product_id
	group by 1
	order by 2 desc
)
	
	select sub_category,
			number_product
	from index_rank
	where rnk = 1
	order by 1;	
	
-- 14.	Which category was the most popular for all customer?
with index_rank as(
	select category,
			count(category)as number_product,
			row_number() over(order by count(category) desc)as rnk
	from store_data t1
		left join master_product t2 on t1.product_id = t2.product_id
	group by 1
	order by 2 desc
)
	
	select category,
			number_product
	from index_rank
	where rnk = 1
	order by 1;		
	
	
	
	