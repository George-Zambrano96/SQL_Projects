 
--tripduration - Duration in Seconds
--starttime - Start Time and Date
--stoptime - Stop Time and Date
--start station id - ID of Start Station
--start station name - Name of Start Station
--start station latitude - Latitude of start station
--start station longitude - Longitude of start station
--end station id - ID of End Station
--end station name - Name of End Station
--end station latitude - Latitude of End station
--end station longitude - Longitude of End station
--Bike ID - Bike ID
--usertype - Customer = 24-hour pass or 3-day pass user; Subscriber = Annual Member
--gender - Zero=unknown; 1=male; 2=female
--birthyear - Year of Birth


--Combine all tables with UNION ALL in order to analyze data more efficiently



SELECT * INTO CombinedTable FROM( 
	

	SELECT *
	FROM April2021

	UNION all 

	SELECT *
	FROM August2020
	
	UNION ALL 

	SELECT *
	FROM December2020

	UNION ALL

	SELECT * 
	FROM February2020

	UNION ALL

	SELECT * 
	FROM February2021

	union all

	SELECT *
	FROM January2020

	union all 

	select *
	from January2021
	union all 

	select *
	from July2020

	union all 

	select *
	from June2020

	union all 

	select * 
	from March2020

	union all 

	select *
	from March2021

	union all 

	select *
	from May2020

	union all 

	select *
	from November2020

	union all 

	select *
	from October2020

	union all 

	select *
	from September2020)

	as sub

--Updated gender column and replaced 0,1,2 with unknown,male,female respectively


update CombinedTable
set gender = 'unknown'
where gender = '0';

update CombinedTable
set gender = 'male'
where gender = '1';

update CombinedTable
set gender = 'female'
where gender = '2';

alter table CombinedTable
alter column gender nvarchar(50);

select top 500 gender
from CombinedTable


select top 500 starttime, stoptime
from CombinedTable
--top starting areas 


select top 10 start_station_name, count(start_station_name) as total 
from CombinedTable
group by start_station_name
order by total desc;

--top drop off areas

select top 10 end_station_name, count(end_station_name) as total 
from CombinedTable
group by end_station_name
order by total desc;


--top pickup off per month
select count(*) as total, month(starttime) as by_month
from CombinedTable
group by month(starttime)
order by total desc;
 
-- popular pick up to drop off combination

select  
	concat(start_station_name, ' to ' ,end_station_name) as trip,
	count(concat(start_station_name, ' to ' ,end_station_name)) as numberoftrips
from CombinedTable
group by concat(start_station_name, ' to ' ,end_station_name)
order by numberoftrips desc;





-- least popular pick up to drop off location

select  
	concat(start_station_name, ' to ' ,end_station_name) as trip,
	count(concat(start_station_name, ' to ' ,end_station_name)) as numberoftrips
from CombinedTable
group by concat(start_station_name, ' to ' ,end_station_name)
order by numberoftrips asc;

 

--total duration of trips per month


select 
	month(starttime) as by_month,
	sum(datediff(minute, starttime, stoptime)) as duration_per_trip_in_min
from CombinedTable
group by month(starttime)
order by duration_per_trip_in_min desc;


--select 
	--starttime,
	--stoptime, 
	--datediff(minute, starttime, stoptime) as duration_in_minutes
--from CombinedTable;

-- average duration per month
select 
	month(starttime) as by_month,
	avg(datediff(minute, starttime, stoptime)) as avg_duration_per_trip_in_min
from CombinedTable
group by month(starttime)
order by avg_duration_per_trip_in_min desc;

--usage count per day per month

select count(*) as total, day(starttime) as day_in_month
from CombinedTable
group by day(starttime)
order by total desc;

--days that have the least usage
select count(*) as total, day(starttime) as day_in_month
from CombinedTable
group by day(starttime)
having count(*) < 12000
order by total desc;

--Usage by UserType as Percentage

select usertype, count(usertype) as total_users, 100.0 * count(usertype) / sum(count(*)) over () as Percentage
from CombinedTable
group by usertype;
--Find usage by generation


SELECT
  ISNULL(v.AgeGroup, 'Other') AS AgeGroup, 
  COUNT(*) AS Count,
  COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS Percentage
FROM CombinedTable ct
LEFT JOIN (VALUES
    (1928,1945,'Silent'),
    (1946,1964,'Boomers'),
    (1965,1980,'Generation X'),
    (1981,1996,'Millennial'),
    (1997,2012,'Generation Z')
) v(StartYear, EndYear, AgeGroup) ON ct.birth_year BETWEEN v.StartYear AND v.EndYear
GROUP BY 
  ISNULL(v.AgeGroup, 'Other')
ORDER BY Percentage desc;


--Usage by gender

select gender, count(*) as total
from CombinedTable
group by gender

--user type by gender

select usertype, gender, count(*) as total, 100.0 * count(gender) / sum(count(*)) over () as total_percentage
from CombinedTable
group by usertype, gender
order by usertype;

--most frequent starttime of day group by hour 

select 
	datepart(hour,starttime) as hour_of_day,
	count(*) as total_count_of_usage
from CombinedTable
group by datepart(hour,starttime)
order by total_count_of_usage desc;


--usage by day of week

set datefirst 1

select
	datepart(weekday, starttime) as day_of_week,
	count(*) as total
from CombinedTable
group by datepart(weekday, starttime) 
order by total desc;

