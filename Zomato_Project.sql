#Created a database named Zomato
#upload the files main , Country , Currency

create database Zomato;
use Zomato;


set sql_safe_updates=0;
set session cte_max_recursion_depth = 100000;

/* 1. Delete Null Values from Main
   2. We have created a table Main2
   3. Insert all the data from Main file to Main2 
   4. Drop the table Main
   5. Rename Main2 file to Main  */
   
   
CREATE TABLE Main2 (
    RestaurantID BIGINT PRIMARY KEY,
    RestaurantName VARCHAR(100),
    countryCode INT,
    City VARCHAR(250),
    Address VARCHAR(250),
    Locality VARCHAR(250),
    LocalityVerbose VARCHAR(250),
    Longitude DOUBLE,
    Latitude DOUBLE,
    Cuisines VARCHAR(250),
    Currency VARCHAR(250),
    Has_Table_booking VARCHAR(250),
    Has_Online_delivery VARCHAR(250),
    Is_delivering_now VARCHAR(250),
    Switch_to_order_menu VARCHAR(250),
    Price_range BIGINT,
    Votes BIGINT,
    Average_Cost_for_two BIGINT,
    Rating DOUBLE,
    `Year Opening` BIGINT,
    `Month Opening` BIGINT,
    `Day Opening` BIGINT
);

delete from main where RestaurantID is null;

insert into main2
select * from main;

drop table main;

rename table main2 to main;


/* 1. Delete Null Values from Country
   2. We have created a table Country2
   3. Insert all the data from Country file to Country2
   4. Drop the table Country
   5. Rename Country2 file to Country  */

CREATE TABLE country2 (
    countryID INT PRIMARY KEY,
    countryname VARCHAR(50)
);

delete from country where countryID is null;


insert into country2
select * from country;

drop table country;

rename table country2 to country;


/* 1. Delete Null Values from Currency
   2. We have created a table Currency2
   3. Insert all the data from Currency file to Currency2
   4. Drop the table Currency
   5. Rename Currency2 file to Currency */

CREATE TABLE currency2 (
    currency VARCHAR(250) PRIMARY KEY,
    `USD Rate` DOUBLE
);

delete from currency where currency is null;

insert into currency2
select * from currency;

drop table currency;

rename table currency2 to currency;


/* In Main table countryCode and Currency  is a foreign Key
   from table Country and Currency table respectively */
   
alter table main 
add constraint fk_countryCode foreign key(countryCode) references Country(countryID),
add constraint fk_currency foreign key(currency) references Currency(currency);

/* Add one column Opening_date of Date datatype to Main table and 
insert data from column Year , Month and date */

alter table main add column Opening_Date date;

UPDATE main 
SET 
    opening_date = STR_TO_DATE(CONCAT(`Year opening`,
                    '-',
                    `Month opening`,
                    '-',
                    `Day opening`),
            '%Y-%m-%d');


#------Question 2 ------------------------------------------------------
#Build a Calendar Table using the Columns Datekey_Opening

/* In this we build a Calendar table and 
   insert data in table from opening date column
   we use date series in this and fill the date from min to max opening date 
   and with the help of date_add function add date on interval of 1*/
   
/* alter Main table and change opening_date as foreign key with referrence to calendar table column Date */  

 
CREATE TABLE calendar (
    `Date` DATE PRIMARY KEY,
    `Year` INT,
    Monthno INT,
    Monthfullname VARCHAR(50),
    `Quarter` VARCHAR(50),
    Yearmonth VARCHAR(50),
    Weekdayno VARCHAR(50),
    Weekdayname VARCHAR(50),
    Financialmonth VARCHAR(50),
    FinancialQuarter VARCHAR(50)
);


insert into calendar (
`Date` , `Year` , Monthno , Monthfullname, `Quarter` , 
Yearmonth , Weekdayno , Weekdayname , Financialmonth , 
FinancialQuarter)

with recursive date_series as (
select Min(opening_date) as dt
from main
union all
select date_add(dt, interval 1 day)
from date_series
where dt < (select max(opening_date) from main))
select 
dt as `Date`,
Year(dt) as `Year`,
Month(dt) as Monthno,
Monthname(dt) as Monthfullname,
concat('Q', Quarter(dt)) as `Quarter`,
date_format(dt, '%Y-%b') as YearMonth,
Weekday(dt) + 1 as Weekdayno,
Dayname(dt) as Weekdayname,
Concat('FM', 
case
when month(dt) >=4 then month(dt) - 3
else Month(dt) + 9
end) as FinancialMonth,

Concat('FQ-', 
case
when month(dt)between 4 and 6 then 1
when month(dt)between 7 and 9 then 2
when month(dt)between 10 and 12 then 3
else 4 
end) as FinancialQuarter

from date_series;


alter table main add constraint fk_opening_date
foreign key (Opening_Date) references calendar(`Date`);

# Check the data in Main table
SELECT 
    *
FROM
    main
LIMIT 10;

# Check the data in Calendar table

SELECT 
    *
FROM
    calendar
LIMIT 10;

/* Write a column to check relationship between the tables are established or not
   if table is empty then relationship not established and if there is forgein key columns 
   then relationship established */
   
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
    REFERENCED_TABLE_SCHEMA = 'Zomato'
        AND TABLE_NAME = 'main';


#------Question 3 ------------------------------------------------------
/*Convert the Average cost for 2 column into USD dollars 
(currently the Average cost for 2 in local currencies)
*/

ALTER TABLE main ADD COLUMN Exchange_Rate_USD DOUBLE;

UPDATE main m
        JOIN
    currency c ON m.currency = c.currency 
SET 
     m.Exchange_Rate_USD = ROUND((m.average_cost_for_two * c.`USD Rate`),
            2);

select currency , Average_Cost_for_two , Exchange_Rate_USD from main limit 10;


#------Question 4 ------------------------------------------------------
#Find the Numbers of Resturants based on City and Country.

SELECT 
    c.Countryname,
    m.City,
    COUNT(m.RestaurantID) AS Total_Restaurants
FROM
    main m
        JOIN
    country c ON m.countrycode = c.countryid
WHERE
    c.Countryname = 'Australia'
GROUP BY c.Countryname , m.City
ORDER BY c.Countryname , m.City;


#------Question 5 ------------------------------------------------------
#Numbers of Resturants opening based on Year , Quarter , Month

SELECT 
  YEAR(opening_date) AS Year,
  QUARTER(opening_date) AS Quarter,
  MONTHNAME(opening_date) AS Month_Name,
  COUNT(RestaurantID) AS Total_Restaurants
FROM main
GROUP BY 
  YEAR(opening_date),
  QUARTER(opening_date),
  MONTHNAME(opening_date)
ORDER BY Year, Quarter, Month_name;




#------Question 6 ------------------------------------------------------
#Count of Resturants based on Average Ratings

alter table main add column Rating_Bucket varchar(50);

UPDATE main 
SET 
    rating_bucket = CASE
        WHEN rating > 4 THEN '*****'
        WHEN rating > 3 THEN '****'
        WHEN rating > 2 THEN '***'
        WHEN rating > 1 THEN '**'
        ELSE '*'
    END
;


SELECT 
    rating_bucket, COUNT(RestaurantID) AS Total_Restaurants
FROM
    main
GROUP BY rating_bucket
ORDER BY rating_bucket
;




#------Question 7 ------------------------------------------------------
/*Create buckets based on Average Price of reasonable size and find out 
how many resturants falls in each buckets
*/

alter table main add column Price_Bucket varchar(50);

UPDATE main 
SET 
    Price_Bucket = CASE
        WHEN Average_Cost_for_two <= 300 THEN 'Low(0 - 300)'
        WHEN Average_Cost_for_two <= 600 THEN 'Midium(301 - 600)'
        WHEN Average_Cost_for_two <= 900 THEN 'High(601 - 1000)'
        ELSE 'Premium(1000+)'
    END
;


SELECT 
    Price_bucket, COUNT(RestaurantID) AS Total_Restaurants
FROM
    main
GROUP BY Price_bucket
ORDER BY COUNT(RestaurantID)
;




#------Question 8 ------------------------------------------------------
#Percentage of Resturants based on "Has_Table_booking"

SELECT 
    Has_Table_booking,
    CONCAT(ROUND(((COUNT(RestaurantID)) / (SELECT 
                            COUNT(*)
                        FROM
                            main)) * 100,
                    2),
            ' %') AS Percentage_restaurants
FROM
    main
GROUP BY Has_Table_booking
ORDER BY COUNT(RestaurantID);

#------Question 9 ------------------------------------------------------
#Percentage of Resturants based on "Has_Online_delivery"

SELECT 
    Has_Online_delivery,
    CONCAT(ROUND(((COUNT(RestaurantID)) / (SELECT 
                            COUNT(*)
                        FROM
                            main)) * 100,
                    2),
            ' %') AS Percentage_restaurants
FROM
    main
GROUP BY Has_Online_delivery
ORDER BY COUNT(RestaurantID);

#---------Question 10--------------------------------------------------------------
#------------KPI-------------------------------------------------------------------

select count(*) as Total_Restaurants from main;  #This Query shows Total no. of Restaurants

#This query shows the country which has max no. of restaurants.

select c.countryname , COUNT(m.RestaurantID) as Total_Restaurants
from main m 
join country c 
on c.CountryID = m.CountryCode
group by c.countryname
order by COUNT(m.RestaurantID) desc
limit 5 ;

#This query shows the city which has max no. of restaurants and in which country.

select c.countryname , m.city , COUNT(m.RestaurantID) as Total_Restaurants
from main m 
join country c 
on m.CountryCode = C.CountryID
group by c.countryname , m.city
order by COUNT(m.RestaurantID) desc
limit 1 ;

#This Query shows Total no. of Votes

select concat(round(sum(votes)/100000 ), ' L') as Total_votes from main;

#This shows the avg of Average_Cost_for_two

select concat(round(avg(Average_Cost_for_two)/1000 , 1), ' K') as `Avg of Average_Cost_for_two` from main;