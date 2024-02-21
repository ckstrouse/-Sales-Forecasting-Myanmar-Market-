WITH daily_sales AS (SELECT "date",
SUM("total") AS daily_sales
FROM markets
GROUP BY "date" ORDER BY "date"),holidays AS (
SELECT "date", 'holiday'::text AS event_type
 FROM your_holidays_table
)
SELECT
d."date",
d.daily_sales,d.daily_sales * (1 + (avg_growth_rate / 100)) * COALESCE(seasonal_factor, 1) AS forecasted_sales
FROM daily_sales d
LEFT JOIN (SELECT "date", AVG(daily_growth_rate) AS avg_growth_rate,AVG(seasonal_factor) AS seasonal_factor
FROM (SELECT d."date",d.daily_sales, LAG(d.daily_sales) 
OVER (ORDER BY d."date") AS prev_day_sales,(d.daily_sales - LAG(d.daily_sales) 
OVER (ORDER BY d."date")) / LAG(d.daily_sales) OVER (ORDER BY d."date") * 100 AS daily_growth_rate,h.event_type,
CASE
WHEN h.event_type = 'holiday' THEN 1.2 -- Adjust based on the presence of a holiday
ELSE 1
END AS seasonal_factor
FROM daily_sales d
LEFT JOIN holidays h ON d."date" = h."date") subquery
GROUP BY "date"
) aggregated_data ON d."date" = aggregated_data."date";
