1. Find Category with the highest discount value

```sql
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
```

2. Find the Best Category by sales

```sql
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
	WHERE rank= 1;
```

3. Find the Best Category by Order

```sql
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
	WHERE rank= 1;
  ```
  
4. Find the number of order for first order in each product per year / popular product for first order

```sql
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
	WHERE rank = 1 ;
```
