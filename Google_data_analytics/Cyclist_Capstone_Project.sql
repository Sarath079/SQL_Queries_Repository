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
  --To check the consistency of the timestamp
  --checking the year
  SELECT started_at FROM `project2-418501.cyclistic_2023.jan_2023` 
  where extract(year from started_at) <> 2023
  --checking the day
  SELECT extract(day from started_at) FROM `project2-418501.cyclistic_2023.jan_2023` 
  where extract(day from started_at) >31 
  or extract(day from started_at) <1
  --checking months
  SELECT extract(month from started_at) FROM `project2-418501.cyclistic_2023.jan_2023` 
  where extract(month from started_at) >12
  or extract(month from started_at)<1
  --checking the member_casual column
  SELECT member_casual FROM `project2-418501.cyclistic_2023.jan_2023` 
  where member_casual <> 'member' and member_casual <> 'casual'

--Adding new columns that would be helpful in analysis
--Duration may exceed 24 hours, so data type of the column should be string

Alter table `project2-418501.cyclistic_2023.jan_2023`
add column duration string

--duration of the ride can be caluculated by subtracting ended_at column and started_at column
    
UPDATE project2-418501.cyclistic_2023.jan_2023
SET duration = CONCAT(
  LPAD(CAST(EXTRACT(HOUR FROM (ended_at-started_at)) AS STRING), 2, '0'), ':',
  LPAD(CAST(EXTRACT(MINUTE FROM (ended_at-started_at)) AS STRING), 2, '0'), ':',
  LPAD(CAST(EXTRACT(SECOND FROM (ended_at-started_at)) AS STRING), 2, '0')
)
WHERE true;

--We didn't get the duration with right data type, "Interval" is the appropriate data type for the column
--so add new column with interval data type and drop the old one. we did a mistake and fixed it.

ALTER TABLE project2-418501.cyclistic_2023.jan_2023 
ADD COLUMN ride_length INTERVAL --adding column with correct data type

--now update the new column with values
UPDATE project2-418501.cyclistic_2023.feb_2023
SET ride_length = INTERVAL 
                  CAST(SPLIT(Duration, ':')[OFFSET(0)] AS INT64) HOUR +
                  INTERVAL CAST(SPLIT(Duration, ':')[OFFSET(1)] AS INT64) MINUTE +
                  INTERVAL CAST(SPLIT(Duration, ':')[OFFSET(2)] AS INT64) SECOND
where true                  

--finally droping the old column

ALTER TABLE project2-418501.cyclistic_2023.jan_2023
DROP COLUMN duration

--adding column to know the day of the week, ride was started.
Alter table `project2-418501.cyclistic_2023.jan_2023`
add column day_of_week int64

--Updating the column with values 1 to 7, where 1 is sunday and 7 is saturday
UPDATE project2-418501.cyclistic_2023.jan_2023
SET day_of_week = EXTRACT(dayofweek FROM started_at)
where true;


