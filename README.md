# Superstore-Business-Performance-Analysis
Measuring business performance is a way to assess your current market, access new customers and find new business opportunities. In this project, I will analyze the performance of the US-Superstore business by reviewing sales, customer, and product overview.
Here the dataset I used was dummy data that I got from the bootcamp platform: MySkill. The dataset represents the number of transactions in Superstores in the US (dummy-dataset) during 2015 to 2018, including its features allowing viewing of orders from multiple dimensions: from sales, discount value, order_date, delivery date, product details and customer information.
As I began this project I took into consideration the cycle of a data analysis project : Business Issue Understanding (set up objective and research queation), Data Understanding, Data Preparation, EDA , Visualization and Analysis and Insights.

Reasearch Question
Through the information has given, I desire to understand :

1. Sales performace from 2015 to 2018 by seeing sales growth, burn-rate per year, best GMV on every customer’s first transaction, and best city with the largest first order;

2. Customer growth from 2015 to 2018 by seeing annual active user vs new customer, customer with repeat order (retention), best GMV per year and the ages who make order per year;

3. Product overview from 2015 to 2018 by seeing best category by order, best category by sales, category with highest discount value, and best product for first order.

Data Preparation
After understanding my data sources and data storage formats, I will perform analysis using PostgreSQL and create visualizations using Google Data Studio.
I then proceeded to the data preparation phase using PostgreSQL which entailed cleaning the data while referring to the research questions and ready-to-process data. The steps are as follows.
Create a new database and its tables for the data that has been prepared by paying attention to the data type of each column.
Importing csv data into the database by paying attention to the dataset storage path.
Create entity relationships between tables.
Once I had the tables needed for the analysis I loaded the data into Google Data Studio for data visualization. I created the relationships between the tables as necessary using the primary and foreign keys to make filtering the results effective.

Data Visualization
Next, a dashboard was created using Google Data Studio based on research questions. I first set up a Sales Review, which will provide details about sales and products that customers like best.

Then I set up a Customer Review dashboard to help Sales Representatives get to know their customers better including to compare active users over time to the number of new customers and see the growth of repeat customers.
This dashboard also shows total sales from the top customer cities allowing sales representatives to increase sales of their products or take necessary follow-up to retain these customers.

Last but not least, I created a Product Overview to give the team insight into the most ordered products and the cities where the most orders were made.

Analysis and Insights

1. Sales Overview
- Total revenue from 2015 to 2018 were 33.9 billion. In 2016 the store experienced negative revenue growth of -4.3% on the contrary sales growth showed an increasing trend with a peak trend in 2017 of 27.1%;

- The best GMV on the first order was SM/20320 by contributing to total revenue of 339,6 million and unfortunately it has a downward trend in the following year;

- Of the promotion value given by the shop, the average burning rate was about 5.8% per year;

- The best cities with the number of consumers placing first orders were dominated by New York with 49 and 14 in 2015 to 2016. It shows the locations of the clients making the most purchases overall allowing the sales team to drive sales and marketing efforts in these areas to retain existing customers and attract new ones;

- The store experienced negative revenue growth and experienced a downward trend in GMV on the first order, it could be an initial diagnosis of the customer not being interested / unsatisfied / disappointed in shopping at the store. The store needs to do a lot of improvement both in terms of product and marketing business.

2. Customer Overview
- Total Customers were 793. Number of transaction (orders) were 4912. This shows the probability that most of the customers were repeat customers and new clients were few;

- Based on the table of Active Users vs. New Customers vs. Retaining Customers, it can be seen that there was an opposite correlation in the variable growth of active users and new customers every year. The number of active users has increased every year as evidenced by the increase in the number of customers who make repeat orders. On the other hand, the number of new customers decreased drastically in 2016 and continued to decline in the following year;

- In 2015, SM/20320 became the best customer by contributing to total revenue of 354.9 million. However, in 2016 the highest total sales experienced a significant decrease in revenue, which was around 38% to 135.3 million;

- The age who made the order was dominated by the age of 33 years during 2015 to 2016.

3. Product Overview
- The office supplies category is a category that dominates in the number of orders and the value of promotion every year. But this category is the lowest in the store’s revenue value;

- Staple Envelope was the product that customers order the most. The company had to improve warehousing operations and stock control to ensure round-the-clock availability of this product;

- Although included in the most orders, Office Supplies was not the best product category of total sales. Technology generated the most sales and this can be attributed to the unit price of the product.


Recommendations

1. Explore marketing strategies that will help target and bring in new clients.

2. The company should utilize customer and product information for marketing strategies that will help in retaining top customers.

3. Find out what makes New York, Los Angeles, and Philadelphia their favorite cities for customers and apply the same strategy in other customer cities.

4. The Office Supplies category seems to be the community’s favorite activity in the company’s sales area, which is indicated by orders and the technology category being the largest total sales. Companies must optimize sales by providing more products in both technology and office supplies categories and adapt their marketing campaigns to this niche market.

Thanks
