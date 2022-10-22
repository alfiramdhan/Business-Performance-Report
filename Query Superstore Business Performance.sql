-- 1. Financial Performance Analysis : US-Superstore
-- total order 2015 - 2018 4922
select count(distinct order_id)
from store_data

-- number of state 41
select count (distinct state)
from master_customer

-- total customer 793
select count(distinct customer_id)
from master_customer


-- Revenue per Year : trend revenue drop in 2016 table 1

WITH year_revenue AS (
	SELECT
	date_part('year',order_date)as Year,
	sum(sales)as revenue
	FROM public.store_data
	Group by 1
	order by 1 desc
),

-- Check average revenue per year : mulai turun di 2016 sampe 2018
average_revenue as (
	SELECT
	date_part('year',order_date)as Year,
	avg(sales)as avg_revenue
	FROM public.store_data
	Group by 1
	order by 1
)

SELECT yr.Year,
		yr.revenue,
		ar.avg_revenue
FROM year_revenue AS yr
JOIN average_revenue AS ar ON yr.year = ar.year;

-- Check correlation
-- SELECT corr(yr.revenue, ar.avg_revenue)as correlation
-- FROM year_revenue AS yr
-- JOIN average_revenue AS ar ON yr.year = ar.year;

-- -- Discount value per year tabel 2
-- Discount_value as (
-- 	Select
-- 	mp.category,
-- 	date_part('year',order_date)as Year,
-- 	sum(sd.sales*sd.discount)as disc_value
-- 	from public.store_data sd
-- 	join public.master_product mp on sd.product_id = mp.product_id
-- 	group by 1,2
-- 	order by 2
-- );


-- GMV : diperoleh customer mana saja yg berkontribusi thdp penurunan sales tabel 3
GMV as (
		SELECT distinct(Customer_ID),
		date_part('year',order_date)as Year,
		sum(Sales)as GMV
		FROM public.store_data
		group by 1,2
		order by 2
);

-- ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷

-- 2. Customer Activity Growth Analysis : US-Superstore
-- Total user : 793
select
count(distinct customer_id)as total_user
from public.master_customer;


-- active users per year table 4
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
)

SELECT ac.Year,
		ac.active_user,
		nn.new_customer
FROM active_cust ac
JOIN num_newcust nn ON ac.year = nn.year;

-- Average order per year : trend increase every year
with average_order AS( 
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

SELECT ao.Year,
		ao.avg_order,
		nr.repeat_order
FROM average_order ao 
JOIN num_repeatorder nr ON ao.year = nr.year;

-- check correlation
-- SELECT corr(ao.avg_order, nr.repeat_order)as correlation
-- FROM average_order AS ao
-- JOIN num_repeatorder AS nr ON ao.year = nr.year;


--  number segment per order and sales 
-- yakni secara transaksi, segment consumer paling tinggi namun segment HO berkontribusi paling besar untuk sales
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

-- first order date of each customer 
first_order as(
	select
	distinct(sd.customer_id)as user,
	mc.customer_name,
	sd.order_id,
	min(sd.order_date)as first_order_date
	from public.store_data sd
	join public.master_customer mc on mc.customer_id = sd.customer_id
	group by 1,2,3
	order by 3
);

-- number of customer who made their first order in each city, each day ???
-- num_cust_first_order as(
-- 	SELECT
-- 	mc.city,
-- 	tabel.first_order_date,
-- 	COUNT(tabel.user)num_customer
-- 	FROM(
-- 		select
-- 		distinct(customer_id)as user,
-- 		min(order_date)as first_order_date
-- 		from public.store_data sd
-- 		group by 1
-- 	)as tabel
-- 	JOIN master_customer mc ON tabel.customer_id = mc.customer_id
-- 	GROUP BY 1,2
-- 	ORDER BY 1
-- )	

-- best city by order 
with num_order as(
	select
	city,
	count(distinct order_id)as total_order
	from public.master_customer mc
	join public.store_data sd on mc.customer_id = sd.customer_id
	group by 1
	order by 2 desc
),

-- number customer per city
customer_bycity as (
	select
	city,
	count(distinct customer_id)as total_customer
	from public.master_customer
	group by 1
	order by 2 desc
)

SELECT
nu.city,
nu.total_order,
cb.total_customer
FROM num_order NU 
JOIN customer_bycity cb ON nu.city = cb.city
LIMIT 20;

-- number customer by age 
with customer_byage as (
	select
	age,
	count(distinct customer_id)as total_customer
	from public.master_customer
	group by 1
	order by 2 desc
);


-- ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷

-- 3. Product Category Quality Analysis : US-Superstore
-- Best product order per category by city 
-- product_bycity as (
-- 	select
-- 	mc.city,
-- 	mp.category,
-- 	mp.product_name,
-- 	count(distinct sd.order_id)as total_order
-- 	from public.master_customer mc
-- 	join public.store_data sd on mc.customer_id = sd.customer_id
-- 	join public.master_product mp on sd.product_id = mp.product_id
-- 	group by 1,2,3
-- 	order by 4 desc
-- 	limit 10
-- );



-- Best product per category per year by sales : tech - tabel 11
with revenue_byproduct as (
	select
	date_part('year',order_date)as Year,
	category,
	sum(sales)as total_sales
	from public.store_data sd
	join public.master_product mp on sd.product_id = mp.product_id
	group by 1,2
	order by 3 desc
);

-- ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷

-- -- annual ship mode type usage analysis
-- -- annual ship mode type usage
-- with annual_usage AS(
-- 	select 
-- 		date_part('year', order_date) as year,
-- 		ship_mode,
-- 		count(1) as num_used
-- 	from store_data
-- 	group by 1,2
-- 	order by 1
-- ),


-- -- average duration ship mode per year
-- average_duration AS(
-- 	SELECT distinct ship_mode,
-- 		year,
-- 		avg(duration)as average_duration
-- 	FROM (
-- 		SELECT 
-- 			extract(year from order_date)as year,		
-- 			ship_mode,
-- 			ship_date,
-- 			order_date,
-- 			(ship_date - order_date)as duration
-- 		FROM
-- 			public.store_data
-- 		GROUP BY 1,2,3,4	
-- 		ORDER BY duration desc
-- )as a
-- 	GROUP BY 1,2
-- 	ORDER BY 1
-- )


-- select
-- au.year,
-- au.ship_mode,
-- num_used,
-- average_duration
-- from annual_usage au
-- join average_duration ad on au.year = ad.year;



