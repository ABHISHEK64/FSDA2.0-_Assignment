use database Demo;
Select * from sales1;
create or replace table sales_copy_data like  sales1;
describe table sales_copy_data;
Alter table sales1
add primary key(order_id);
select to_date(ship_date) from sales1;
/*snowflakes links :https://sgyspws-he80912.snowflakecomputing.com/console#/internal/worksheet
*/
alter table sales1
add column ship_date_new date;
update sales1
set ship_date_new
=to_date(ship_date);
select * from sales1;
select Avg(sales),Avg(quantity),Avg(discount),Avg(profit),category,`order_date_new` from sales1 
where `order_date_new` between '2011-01-01' and '2013-01-01'
group by category,`order_date_new`;
select year(`order_date_new`) from sales1;
alter table sales1
drop column year;
alter table sales1
add column year number(4,0);
update sales1
set year=year(`order_date_new`);
select year,avg(sales),avg(discount),avg(profit) from sales1 group by year;
select discount from sales1;
alter table sales1
add column flag varchar(3);
update sales1
set flag='NO' where discount=0.000;
/*No of days required to shift between order date and ship date*/
select order_id,sum(datediff('days',`order_date_new`,ship_date_new)) as days from sales1 group by order_id;
alter table sales1
add column days number(5,0);
update sales1
set days=datediff('days',`order_date_new`,ship_date_new);
select year,category,ship_Mode,avg(profit),avg(rating),avg(shipping_cost),avg(final_profit) from(select *,case when days>10 then 2
              when days>6 and days<10 then 3
              when days>3 and days<6 then 4
              else 5
          end as rating,(sales-(discount*sales+shipping_cost)) as final_profit from sales1)
          group by category,ship_Mode,year;
select sales,profit,discount,shipping_cost,(profit-(discount*sales+shipping_cost)) as final_profit from sales1;
select region,avg(profit),avg(sales),avg(quantity),avg(discount),year from sales1 group by region,year;
