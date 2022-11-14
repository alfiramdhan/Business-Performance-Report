-- A. Sales Performance 
-- 1. total revenue, total order, total customer
SELECT sum(sales)as total_revenue,
		count(distinct customer_id)as total_customer,
		count(distinct order_id)as total_order
FROM store_data;

-- 2. burn-rate
SELECT extract(year from order_date)as year,
		SUM(sales)as revenue,
		SUM(discount)as promotion_value,
		SUM(discount)*100/SUM(sales) as burn_rate
FROM store_data
WHERE sales IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- 3. compare total order vs revenue growth
-- a : Overall performance by years
WITH before_after AS (
SELECT extract(year from order_date)as year,
		COUNT(DISTINCT order_id)as total_order,
		SUM(sales)as revenue
FROM store_data
WHERE sales IS NOT NULL
GROUP BY 1
ORDER BY 1
),	

-- b : add column LAG and LEAD 
 growth_pct AS(
	SELECT year,
			total_order,
			LAG(total_order) OVER (order by year)as total_order_before,
			LEAD(total_order) OVER (ORDER BY year)as total_order_after,
			revenue,
			LAG(revenue) OVER (order by year)as revenue_before,
			LEAD(revenue) OVER (ORDER BY year)as revenue_after
	FROM before_after
	ORDER BY 1
	)
		SELECT year, total_order, revenue,
				SUM(total_order - total_order_before)*100/SUM(total_order_before) as growth_order,
				SUM(revenue - revenue_before)*100/SUM(revenue_before) as growth_revenue
		FROM growth_pct
		GROUP BY 1,2,3
		ORDER BY 1;
		

-- 4.Find the first order each year, each customer for best GMV(sales). If there is a tie, use the order with the lower order_id
-- with or without use lower order_id, the result still same
-- rank each year for each customer :
WITH gmv_for_first_order AS(
SELECT t1.customer_id, t1.sales, extract(year from first_date)as year
FROM store_data t1
INNER JOIN(
		SELECT DISTINCT customer_id, min(order_date)as first_date
		FROM (
			SELECT customer_id, order_date
			FROM store_data
			ORDER BY order_id)a
		GROUP BY 1
)t2
ON t1.customer_id = t2.customer_id
AND t1.order_date = t2.first_date
WHERE sales IS NOT NULL
ORDER BY 2 desc
),

GMV_RANK_year AS(
SELECT customer_id,
		year,
		sales,
		RANK() OVER(PARTITION BY year ORDER BY sales DESC)as rank
FROM gmv_for_first_order	
group by 1,2,3
order by 2, 3 desc
)
	SELECT year,
			customer_id,
			sales
	FROM GMV_RANK_year
	WHERE rank = 1
	
-- or
-- Find the first order on each day, each customer for best GMV(sales) / rank each day for each customer
with GMV_per_customer AS (
	SELECT first_date,
			t1.customer_id,
			t1.sales
	FROM store_data t1
	JOIN(
		SELECT customer_id,
				MIN(order_date)as first_date
		FROM store_data 
		GROUP BY 1) t2 USING (customer_id)
	WHERE t1.order_date = t2.first_date
),
index_order AS(
	SELECT first_date,
			customer_id,
			SUM(sales)as GMV,
			ROW_NUMBER() OVER(PARTITION BY first_date ORDER BY SUM(sales) DESC)as row,
			RANK() OVER(PARTITION BY first_date ORDER BY SUM(sales) DESC)as ranking
	FROM GMV_per_customer
	GROUP BY 1,2
	ORDER BY 1
)	
	SELECT first_date,
			customer_id
	FROM index_order
	WHERE row = 1
		and ranking = 1
		

-- 5. Find the number of customer who made first order in each city per year / the best city that makes the largest first order 
With first_order_city AS(
SELECT extract(year from first_date)as year,city, count(customer_id)as total_customer
FROM (
	SELECT customer_id, min(order_date)as first_date
	FROM store_data
	GROUP BY 1)t1
LEFT JOIN master_customer t2 USING (customer_id)
GROUP BY 1,2
ORDER BY 1, 3 desc
)	,

City_RANK_year AS(
SELECT city,
		year,
		total_customer,
		ROW_NUMBER() OVER(PARTITION BY year ORDER BY total_customer DESC)as rank
FROM first_order_city	
group by 1,2,3
order by 2, 3 desc
)
	SELECT year,
			city,
			total_customer
	FROM City_RANK_year
	WHERE rank = 1

		 
		 
÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷


-- B. Customer Performance
-- 1. average customer exist
WITH average AS(
SELECT year, ROUND(AVG(total_customer),2)as avg_active_customer
FROM(
	SELECT COUNT(DISTINCT customer_id)as total_customer,
			extract(year from order_date)as year,
			extract(month from order_date)as month
	FROM store_data
	JOIN master_customer using (customer_id)
	WHERE sales IS NOT NULL
	GROUP BY 2,3)a
GROUP BY 1	
),
				
-- number of new customers per year
newcust AS(
SELECT extract(year from first_date)as year,
		COUNT(customer_id)as new_customer
FROM (		
	SELECT DISTINCT customer_id, MIN(order_date)as first_date
	FROM store_data
	JOIN master_customer using (customer_id)
	GROUP BY 1
	)a
GROUP BY 1
ORDER BY 1),
	
-- 2. retention customer basic		
-- assume that we are looking at customer retention of customers who visited in 2015 over the following year.		
retain AS(  
	  SELECT extract(year from order_date)as year,
       			count (distinct customer_id) AS retain_customer
		FROM store_data
		WHERE customer_id IN (SELECT DISTINCT customer_id
							  FROM store_data
							  WHERE extract(year from order_date) = 2015)
		GROUP BY 1
		HAVING COUNT(order_id)>1)	
	
	SELECT year,
			avg_active_customer,
			new_customer,
			retain_customer
	FROM average
	JOIN newcust USING (year)
	JOIN retain USING (year)
			
-- 3. Best Customer by sales per year
with GMV_year AS(
SELECT DISTINCT customer_id,
		extract(year from order_date)as year,
		SUM(sales)as total_GMV,
		RANK() OVER(PARTITION BY extract(year from order_date) ORDER BY sum(sales) DESC)as rank
FROM public.store_data
WHERE sales IS NOT NULL	
group by 1,2
order by 2, 3 desc
)
	SELECT year,
			customer_id,
			total_GMV
	FROM GMV_year
	WHERE rank = 1
	
-- the ages who make order per year
with age_year AS(
SELECT DISTINCT age,
		extract(year from order_date)as year,
		COUNT(age)as number_customer,
		RANK() OVER(PARTITION BY extract(year from order_date) ORDER BY COUNT(age) DESC)as rank
FROM store_data
	JOIN master_customer USING (customer_id)
WHERE age IS NOT NULL	
group by 1,2
order by 2, 3 desc
)
	SELECT year,
			age,
			number_customer
	FROM age_year
	WHERE rank = 1


÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷

-- C. Product Performance
-- 1. Category with the highest discount value
with product_promotion_year AS(
SELECT category,
		extract(year from order_date)as year,
		SUM(discount)as total_discount,
		RANK() OVER(PARTITION BY extract(year from order_date) ORDER BY sum(discount) DESC)as rank
FROM store_data
JOIN master_product USING (product_id)	
WHERE discount IS NOT NULL	
group by 1,2
order by 2, 3 desc
)
	SELECT year,
			category,
			total_discount
	FROM product_promotion_year
	WHERE rank = 1
	
	
-- 2. Best Category by sales
with revenue_per_category as (
	SELECT extract(year from order_date)as year,
			category,
			sum(sales)as revenue,
			RANK() OVER(PARTITION BY extract(year from order_date) ORDER BY sum(sales) DESC)as rank		
	FROM store_data sd
	JOIN master_product mp on sd.product_id = mp.product_id
	WHERE sales IS NOT NULL
	GROUP BY 1,2
)
	SELECT year,
			category,
			revenue
	FROM revenue_per_category
	WHERE rank= 1


-- 3. Best Category by Order
with order_per_category as (
	SELECT extract(year from order_date)as year,
			category,
			count(order_id)as total_order,
			RANK() OVER(PARTITION BY extract(year from order_date) ORDER BY count(order_id) DESC)as rank		
	FROM store_data sd
	JOIN master_product mp on sd.product_id = mp.product_id
	WHERE sales IS NOT NULL
	GROUP BY 1,2
)
	SELECT year,
			category,
			total_order
	FROM order_per_category
	WHERE rank= 1

-- 4.Find the number of order for first order in each product per year / popular product for first order
WITH product_first_order AS(
SELECT extract(year from first_date)as year, product_name, count(order_id)as total_customer
FROM (
	SELECT order_id, product_name, min(order_date)as first_date
	FROM store_data
	JOIN master_product USING (product_id)
	GROUP BY 1,2)t1
GROUP BY 1,2
ORDER BY 1, 3 desc
	),

Product_RANK_year AS(
SELECT product_name,
		year,
		total_customer,
		ROW_NUMBER() OVER(PARTITION BY year ORDER BY total_customer DESC)as rank
FROM product_first_order	
group by 1,2,3
order by 2, 3 desc
)
	SELECT year,
			product_name,
			total_customer
	FROM Product_RANK_year
	WHERE rank = 1
