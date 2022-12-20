/*Snow flake Assigmnet Submission url:https://sgyspws-he80912.snowflakecomputing.com/console#/internal/worksheet*/
create database Fsda_Assignment_1_Abhishek;
use Fsda_Assignment_1_Abhishek;
##Task1
create table As_Shopping_History(
product varchar(60) not null,
quantity int not null,
unit_price int not null  
);
insert into As_Shopping_History values('Milk',2,30),('bread',7,3),('bread',5,2),('Tea',1,30),('bread',1,3),('Milk',2,30),('egg',7,300),('Meat',7,3000);
select product,sum(quantity*unit_price) as Total_Price from As_Shopping_History group by product;
##Task2
create table As_phones(
caller_name varchar(20) not null,
phone_no integer not null unique  
);
create   or replace table As_call(
id int,
caller int not null,
caller_no  int not null,
call_duration int not null,
primary key(id)  
);
insert into As_phones values('Ravi',12345),('Pooja',12335),('Rajesh',52345),('Rohan',32335),('Mack',99234),('jack',38902);
insert into As_call values
(32,52345,12345,2),
(63,12345,52345,1),
(31,12345,12335,2),
(34,99234,12335,5),
(3,38902,12345,2),
(1,99234,12335,1),
(12,12335,12345,5),
(90,12335,12345,2);

with call_duration as(
select caller as phone_number,sum(call_duration)as total_duration from As_call group by caller
union all
select caller_no as phone_number,sum(call_duration)as total_duration from As_call group by caller_no
)
select p.caller_name from call_duration as c1 inner join  As_phones p on p.phone_no=c1.phone_number
group by p.caller_name
having sum(c1.total_duration)>10;
## Task 3
create or replace table As_Transaction(
Amt int not null,
Trans_data date not null  
);
Insert into As_Transaction values(1000,'2020-01-06'),
(-10,'2020-01-14'),
(-75,'2020-01-20'),
(-5,'2020-01-25'),
(-4,'2020-01-29'),
(2000,'2020-03-10'),
(-75,'2020-03-12'),
(-20,'2020-03-15'),
(40,'2020-03-15'),
(-50,'2020-03-17'),
(200,'2020-10-10'),
(-200,'2020-10-10');
select (sum(Amt)-(select sum(case 
          when usage.Trans_amt>100 or usage.event_c>3 then 0
          else 5
          end) as Trans_fee
from(select 1 As month union
    select 2  union
    select 3 union
    select 4  union
    select 5  union
    select 6  union
    select 7  union
    select 8  union
    select 9  union
    select 10  union
    select 11  union
    select 12) as Months
Left outer join
(select sum(Amt) as Trans_amt,count(0) event_c,month(Trans_Data)As Month_name from As_Transaction where Amt<0 group by Month_name)usage on Months.Month=usage.Month_name)) as remaining_balance from As_Transaction;