SELECT "date",daily_sales,
LAG(daily_sales) OVER (ORDER BY "date") AS prev_day_sales,
(daily_sales - LAG(daily_sales) OVER (ORDER BY "date")) / LAG(daily_sales) OVER (ORDER BY "date") * 100 AS daily_growth_rate
FROM (SELECT "date", SUM("total") AS daily_sales FROM markets GROUP BY "date") daily_sales;
