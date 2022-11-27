1. Calculate total revenue, total order, and total customer

```sql
SELECT sum(sales)as total_revenue,
		count(distinct customer_id)as total_customer,
		count(distinct order_id)as total_order
FROM store_data;
```

2. Calculate the burn-rate

```sql
SELECT extract(year from order_date)as year,
		SUM(sales)as revenue,
		SUM(discount)as promotion_value,
		SUM(discount)*100/SUM(sales) as burn_rate
FROM store_data
WHERE sales IS NOT NULL
GROUP BY 1
ORDER BY 1;
```


3. Overall performance by compare total order vs revenue growth

```sql
WITH before_after AS (
SELECT extract(year from order_date)as year,
		COUNT(DISTINCT order_id)as total_order,
		SUM(sales)as revenue
FROM store_data
WHERE sales IS NOT NULL
GROUP BY 1
ORDER BY 1
),	

-- add column LAG and LEAD 
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
```    

4. Find the first order each year, each customer for best GMV(sales). If there is a tie, use the order with the lower order_id with or without use lower order_id, the result still same

```sql
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
```

5. Find the number of customer who made first order in each city per year / the best city that makes the largest first order 

```sql
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
```
