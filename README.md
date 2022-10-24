# Superstore-Business-Performance-Analysis
Measuring business performance is a way to assess your current market, access new customers and find new business opportunities. In this project, I will analyze the performance of the US-Superstore business by reviewing sales, customer, and product overview.
Here the dataset I used was dummy data that I got from the bootcamp platform: MySkill. The dataset represents the number of transactions in Superstores in the US (dummy-dataset) during 2015 to 2018, including its features allowing viewing of orders from multiple dimensions: from sales, discount value, order_date, delivery date, product details and customer information.
As I began this project I took into consideration the cycle of a data analysis project : Business Issue Understanding (set up objective and research queation), Data Understanding, Data Preparation, EDA , Visualization and Analysis and Insights.

Reasearch Question
Through the information has given, I desire to understand :
Sales performace from 2015 to 2018 by seeing annual revenue, average revenue, best selling product, best selling category and top customer by sales;
Customer growth from 2015 to 2018 by seeing annual active user, new customer, customer with repeat order, average order by customers, consumer segment and topcity by sales;
Product overview from 2015 to 2018 by seeing total order by product, total order by category, top product order by city and top category order by city.

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
Total sales from 2015 to 2018 were 33.9 billion. In 2016 there was a downward trend in income by 0.04% and the average income trend also decreased. However, these trends were not correlated with each other, as the trend of income started to increase in 2017, while the average variable shows the opposite trend.
Of the total sales per category, Technology generated the most sales of 12.4 billion. The best-selling product is the Canon ImageCLASS 2200 Advance Copier with total sales of 924 million. However, in 2016 there was a decrease in 2 product categories by 0.07% from technology and 0.09% from office supplies.
In 2015, SM/20320 and SC/20095 became the 2 best customers with total sales of 354.9 million and 193.1 million, respectively. However, both experienced a significant sales decline of 97% in 2016.

2. Customer Overview
Total Customers is 793. Number of Orders is 4912. This shows the probability that most of the customers are repeat customers and new clients are few.
Based on the table of Active Users vs. New Customers, it can be seen that there is an opposite correlation in the variable growth of active users and new customers every year. The number of active users has increased every year although in 2016 it decreased. On the other hand, the number of new customers decreased drastically in 2016 and continued to decline in the following year.
There was a strong correlation of 0.9 between the repeat order variable and the average order variable. However a strong correlation does not imply causality. We cannot say that a change in one variable causes a change in another, only that the changes move together. So we need to do more testing to determine if they are statistically significant. Meanwhile, the two variables experienced an increasing trend every year (from 2015 to 2018.
In consumer segment analysis, the top segment is consumers with 50.8% with total sales of 17.2 billion. Corporate came in second with sales of 10.3 billion from 30.4% and Home Office around 18.8% with sales of 6.4 billion.
The top 5 customer cities with the highest sales were New York 3.1 billion, Los Angeles 2.1 billion, and Philadelphia 1.9 billion. It shows the locations of the clients making the most purchases overall allowing the sales team to drive sales and marketing efforts in these areas to retain existing customers and attract new ones.

3. Product Overview
Staple Envelope, Staples, and Easy-Staple Paper are the products that customers order the most. The company had to improve warehousing operations and stock control in New York, Los Angeles, and Philadelphia to ensure round-the-clock availability of this product.
Although included in the most orders, Office Supplies (3665) is not the best product category of total sales. Technology (1518) generated the most sales and this can be attributed to the unit price of the product.

Recommendations

Explore marketing strategies that will help target and bring in new clients.
The company should utilize customer and product information for marketing strategies that will help in retaining top customers.
Find out what makes New York, Los Angeles, and Philadelphia their favorite cities for customers and apply the same strategy in other customer cities.
The Office Supplies category seems to be the community’s favorite activity in the company’s sales area, which is indicated by orders and the technology category being the largest total sales. Companies must optimize sales by providing more products in both technology and office supplies categories and adapt their marketing campaigns to this niche market.

Thanks
