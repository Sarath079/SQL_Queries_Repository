--To find missing values in the table
--we can also do select sum(case when ride_id is null then 1 else 0 end) count_nulls from `project2-418501.cyclistic_2023.nov_2023` 
--or we can use count function along with where clause
SELECT count(*)-count(ride_id) as Ride_id,
count(*)-count(rideable_type) as rideable_type,
count(*)-count(started_at) as started_at,
count(*)-count(ended_at) as ended_at,
count(*)-count(start_station_name) as start_station_name,
count(*)-count(start_station_id) as start_station_id,
count(*)-count(end_station_name) as end_station_name,
count(*)-count(end_station_id) as end_station_id,
count(*)-count(start_lat) as start_lat,
count(*)-count(start_lng) as start_lng,
count(*)-count(end_lat) as end_lat,
count(*)-count(end_lng) as end_lng,
count(*)-count(member_casual) as member_casual
FROM `project2-418501.cyclistic_2023.nov_2023` 

--To find start_station_name
--output gives that "There is no data to display."
--As we cannot be able to fill the null values, we should find different way to handle nulls.
  
SELECT n.start_station_name, n.start_lat, n.start_lng
FROM `project2-418501.cyclistic_2023.nov_2023` n
join 
  (select start_lat from `project2-418501.cyclistic_2023.nov_2023` n1 where n1.start_station_name is null) n2
  on n.start_lat=n2.start_lat
  and n.start_lng=n2.start_lng
where start_station_name is not null 

--Incase of having data to update the null values
--updating the table with start station name
  
update `project2-418501.cyclistic_2023.jan_2023` n
set n.start_station_name = n2.start_station_name
from 
  (SELECT distinct n.ride_id, n.start_station_name, n.start_lat, n.start_lng
  FROM `project2-418501.cyclistic_2023.jan_2023` n
  inner join (select start_lat,start_lng from `project2-418501.cyclistic_2023.jan_2023` n1 where n1.start_station_name is null) n2
    on n.start_lat=n2.start_lat
    and n.start_lng=n2.start_lng
  where start_station_name is not null) n2
where n.start_lat=n2.start_lat and n.start_lng = n2.start_lng and n.ride_id = n2.ride_id

--after successfully updating some null values, will remove the null values.
