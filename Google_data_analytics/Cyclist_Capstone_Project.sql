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
--output gives that start_station_name = 'Rush St & Hubbard St'with lat = 41.89 and longitude -87.625703 is missing in multiple rows(6449)
--update the table with the start_station_name
  
SELECT n.start_station_name, n.start_lat, n.start_lng
FROM `project2-418501.cyclistic_2023.nov_2023` n
join (select start_lat from `project2-418501.cyclistic_2023.nov_2023` n1 where n1.start_station_name is null) n2
on n.start_lat=n2.start_lat
where start_station_name is not null 

--updating the table with start station name
  
update `project2-418501.cyclistic_2023.nov_2023` n
set start_station_name = 'Rush St & Hubbard St'
where n.start_lat = 41.89 and start_lng = -87.625703*/
