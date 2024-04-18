SELECT
    --below given three columns are columns of the citibike_trips table
    starttime,
    start_station_id,
    tripduration,
    (
        SELECT ROUND(AVG(tripduration),2) --rounding the average trip duration to 2 decimals
        FROM bigquery-public-data.new_york_citibike.citibike_trips
        WHERE start_station_id = outer_trips.start_station_id -- it acts like JOINing the subquery with the outer query table and grouping the tripdurations of each station.
    ) AS avg_duration_for_station, --naming the subquery
    ROUND(tripduration - ( --to find difference between tripduration and average of tripdurations
        SELECT AVG(tripduration)
        FROM bigquery-public-data.new_york_citibike.citibike_trips
        WHERE start_station_id = outer_trips.start_station_id) , 2) AS difference_from_avg -- grouping by station_id by joining the station_id with outer table station_id and rounding to 2 decimals.
FROM bigquery-public-data.new_york_citibike.citibike_trips AS outer_trips --here is the outer table, which is used in where clauses for grouping the stations.
ORDER BY difference_from_avg DESC --tripduration those were unusually larger than average
LIMIT 25; --top 25 unusually long trips when comparing to average durations.
