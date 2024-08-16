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
  
delete from project2-418501.cyclistic_2023.jan_2023
where start_station_name is null
or start_station_id is null
or end_station_name is null
or end_station_id is null
or end_lat is null
or end_lng is null

--To check the data integrity
  --checking ride_id column
  select ride_id
  from project2-418501.cyclistic_2023.jan_2023
  where length(ride_id)<>16
  --checking rideable_type column
  select rideable_type
  from project2-418501.cyclistic_2023.jan_2023
  where rideable_type <> 'electric_bike' 
  and rideable_type <>'classic_bike'
  and rideable_type <> 'docked_bike';
  --

