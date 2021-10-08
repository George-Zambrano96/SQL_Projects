select *
from hotel_bookings



---bookings by hotel type

SELECT hotel, count(arrival_date_day_of_month) AS 'Total by Hotel'
FROM hotel_bookings
GROUP BY hotel;

---which months have the most bookings?

SELECT arrival_date_month, COUNT(*) as 'Total Booking Per Month'
FROM hotel_bookings
GROUP BY arrival_date_month
ORDER BY 2 DESC;

---which countries provide the most traffic for the hotels?

SELECT country, COUNT(*) as 'Total Booking Per Country'
FROM hotel_bookings
GROUP BY country
ORDER BY 2 DESC;


---Cancellations 


alter table hotel_bookings  
alter column is_canceled int;

select hotel, SUM(is_canceled) as 'Total Cancelations'
from hotel_bookings
group by hotel;





--- Total Bookings by Customer Type 

select customer_type, count(*) as 'Bookings by Type' 
from hotel_bookings
group by customer_type
order by 2 desc;
--As a Percentage
select customer_type, count(*) * 100.0 / SUM(COUNT(*)) OVER() as 'Bookings by Type Percentage' 
from hotel_bookings
group by customer_type
order by 2 desc;



---INCOME BY MONTH

alter table hotel_bookings  
alter column adr float;


select arrival_date_month, SUM(adr) as 'Income by Month'
from hotel_bookings
group by arrival_date_month
order by 2 desc;


---what days have the lowest traffic out of those months

---select *
---from hotel_bookings;

select arrival_date_day_of_month, count(*) as  'total by day'
from hotel_bookings
group by arrival_date_day_of_month
order by 2 asc;




---Percentage by market segment
select market_segment, COUNT(*) * 100.00 / SUM(COUNT(*)) OVER() AS Percentage 
FROM hotel_bookings
group by market_segment;


---stayed in weekend nights vs stays in week days


alter table hotel_bookings  
alter column stays_in_weekend_nights int;

alter table hotel_bookings  
alter column stays_in_week_nights int;

SELECT hotel,
	SUM(stays_in_weekend_nights) AS 'total weekend night', 
	SUM(stays_in_week_nights) AS 'total week night', 
	SUM(stays_in_weekend_nights) * 100.0 / SUM(stays_in_weekend_nights + stays_in_week_nights) AS '% weekend night',
	SUM(stays_in_week_nights) * 100.0 / SUM(stays_in_weekend_nights + stays_in_week_nights) AS '% week night' 
	FROM hotel_bookings 
	GROUP BY hotel;