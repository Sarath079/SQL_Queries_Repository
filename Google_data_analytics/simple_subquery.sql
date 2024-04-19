SELECT
	station_id,
	name
FROM
	bigquery-public-data.new_york.citibike_stations
WHERE
	station_id IN
	(
		SELECT
			CAST(start_station_id AS STRING) AS start_station_id_str --converting data type to make station_id and start_station_id as same data type.
		FROM
	    	bigquery-public-data.new_york.citibike_trips --subquery pulling data from different table, in this case suquery is also joining two tables.
	  WHERE
			usertype = 'Subscriber'
  );
