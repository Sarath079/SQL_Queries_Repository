SELECT 
  products_industry_name, 
  COUNT(report_number) AS count_hospitalizations
FROM
  bigquery-public-data.fda_food.food_events
WHERE 
  products_industry_name IN --products_industry_name should match with the names given by subquery
    (SELECT 
      products_industry_name
    FROM 
      bigquery-public-data.fda_food.food_events
    GROUP BY products_industry_name
    ORDER BY COUNT(report_number) DESC LIMIT 10)
  AND outcomes LIKE '%Hospitalization%'
--The AND operator displays a record if all the conditions are TRUE.
--The LIKE operator is used in a WHERE clause to search for a specified pattern ('%Hospitalization%') in a column.
GROUP BY products_industry_name
ORDER BY count_hospitalizations DESC;
