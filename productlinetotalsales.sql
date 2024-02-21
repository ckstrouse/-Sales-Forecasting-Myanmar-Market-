SELECT "Product line", SUM(total) AS total_sales
FROM markets
GROUP BY "Product line"
ORDER BY total_sales DESC;

