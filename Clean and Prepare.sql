-- 1. Dashboard Sales Overview --
-- metrics:
-- total sales
-- average revenue
-- total order
-- total customer
-- Top sales for product_name
-- Top sales by product category
-- Top 5 customer by sales

-- dimensions :
-- state
-- city
-- category
-- sub_category
-- year

with sales_overview as(
SELECT DATE(order_date)as date,
		state,
		city,
		mc.customer_id,
		order_id,
		category,
		sub_category,
		product_name,
		sales
FROM master_customer mc
JOIN store_data sd on mc.customer_id = sd.customer_id
JOIN master_product mp on sd.product_id = mp.product_id
WHERE sales is not Null
);	

-- 2. Customer Overview --
-- metrics:
-- Active user
-- New customer
-- repeat order
-- avg order
-- Top customer city by sales
-- Consumer segment by total sales

-- dimensions :
-- state
-- city
-- category
-- sub_category
-- year

WITH active_cust AS(
			SELECT
			count(distinct Customer_ID)as active_user,
			date_part('year',order_date)as Year
			FROM public.store_data
			group by 2
			order by 2
),

-- number of new customers per year
num_newcust AS ( 
	select
	date_part('year',first_order_date)as Year,
	count(user)as new_customer
	from (
		select
		distinct(customer_id)as user,
		min(order_date)as first_order_date
		from public.store_data
		group by 1
	)as a
	group by 1
	order by 1
),

-- Average order per year : trend increase every year
average_order AS( 
	SELECT
	Year,
	round(avg(total_order),2)as avg_order
	From (
		SELECT
		date_part('year',order_date)as Year,
		customer_ID,
		count(distinct order_ID)as total_order
		FROM public.store_data
		group by 1,2
	)unique_order
	group by 1
	order by 1
),

-- number of customers who placed a repeat order per year : trend increase every year
num_repeatorder as(
	select
	Year,
	count(total_user)as repeat_order
	from (
		select
		date_part('year',order_date)as Year,
		customer_id,
		count(distinct customer_id)as total_user,
		count(order_id)as total_order
		from public.store_data
		group by 1,2
		having count(order_id) > 1
	)as b
	group by 1
	order by 1
)
-- tabel 1
SELECT ao.Year,
		ao.avg_order,
		nr.repeat_order,
		ac.active_user,
		nn.new_customer
FROM active_cust ac
JOIN num_newcust nn ON ac.year = nn.year
JOIN average_order ao ON nn.year = ao.year
JOIN num_repeatorder nr ON ao.year = nr.year;

-- tabel 2
with order_persegment as(
	select
	mc.segment,
	count(distinct sd.order_id)as total_order,
	sum(sd.sales)as total_sales
	from public.master_customer mc
	join public.store_data sd on mc.customer_id = sd.customer_id
	join public.master_product mp on sd.product_id = mp.product_id
	group by 1
	order by 2,3 desc	
);

-- with sales_overview as(
SELECT DATE(order_date)as date,
		state,
		city,
		mc.customer_id,
		order_id,
		category,
		sub_category,
		product_name,
		sales
FROM master_customer mc
JOIN store_data sd on mc.customer_id = sd.customer_id
JOIN master_product mp on sd.product_id = mp.product_id
WHERE sales is not Null
);	-- for tabel Top customer city by sales


-- 3. Product Overview --
-- metrics:
-- Top 10 product by order
-- Top category order by sales state
-- Top category order by city
-- Top product name order by city

-- dimensions :
-- state
-- city
-- category
-- sub_category
-- year

with product_overview as(
	SELECT DATE(order_date)as date,
			state,
			city,
			mc.customer_id,
			order_id,
			category,
			sub_category,
			product_name,
			sales
	FROM master_customer mc
	JOIN store_data sd on mc.customer_id = sd.customer_id
	JOIN master_product mp on sd.product_id = mp.product_id
	WHERE sales is not Null
);	
