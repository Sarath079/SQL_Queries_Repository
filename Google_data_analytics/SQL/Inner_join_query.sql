SELECT 
	station_id,
	name,
	number_of_rides AS number_of_rides_starting_at_station --this column is from subquery
FROM
	(
		SELECT 
			CAST(start_station_id AS STRING) AS start_station_id_str, --converting start_station_id as a string.
			COUNT(*) AS number_of_rides --counting number of rides started from each station
		FROM 
      		bigquery-public-data.new_york.citibike_trips
		GROUP BY 
			start_station_id_str --grouping stations to count number of rides from the station
	)
	AS station_num_trips --alice naming the subquery
	INNER JOIN 
		bigquery-public-data.new_york.citibike_stations 
	ON 
		station_id = start_station_id_str --combining two tables using one common column / key
	ORDER BY 
		number_of_rides_starting_at_station DESC;
