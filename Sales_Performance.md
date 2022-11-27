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
