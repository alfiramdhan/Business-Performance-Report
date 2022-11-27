1. Calculate average customer exist, number of new customer and number of retention customers

```sql
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
	JOIN retain USING (year);
```

2. Best GMV per year

```sql
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
```

3. Find the ages who make order per year

```sql
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
```    
