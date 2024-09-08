#Top 10 highest reveue generating products 
select  product_id, SUM(sale_price) as sales
from orders
group by product_id
order by sales desc
limit 10;


#Top 5 highest selling products in each region

with cte1 as (select region,product_id,sum(sale_price) as sales
from orders
group by region,product_id) ,
cte2 as (select region , product_id , sales , row_number() over(partition by region order by sales) as rnk
from cte1)
select region , product_id,sales
from cte2
where rnk <= 5
;

#Month over Month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

with cte1 as (select year(order_date) as years,month(order_date) as months,sum(sale_price) as sales
from orders
group by years ,months)
select months, 
sum(case when years=2022 then sales else 0 end) as year_2022,
sum(case when years=2023 then sales else 0 end) as year_2023
from cte1
group by months
order by months;


#for each category which month had highest sales 
WITH cte AS (
    SELECT category,
           DATE_FORMAT(order_date, '%Y-%m') AS order_year_month,
           SUM(sale_price) AS sales
    FROM orders
    GROUP BY category, DATE_FORMAT(order_date, '%Y-%m')
)
SELECT * FROM (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY category ORDER BY sales DESC) AS rn
    FROM cte
) a
WHERE rn = 1;

#which sub category had highest growth by profit in 2023 compare to 2022

with cte1 as (select year(order_date) as years,sub_category, sum(sale_price) as sales
from orders 
group by sub_category,years),
cte2 as (select sub_category, sum(case when years=2022 then sales else 0 end) as sales_2022,
sum(case when years=2023 then sales else 0 end) as sales_2023
from cte1
group by sub_category)
select *,sales_2023-sales_2022 as growth
from cte2
order by sales_2023-sales_2022 desc
;


