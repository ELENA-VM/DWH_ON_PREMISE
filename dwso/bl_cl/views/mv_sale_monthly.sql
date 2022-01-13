CREATE MATERIALIZED VIEW mv_sale_monthly
BUILD IMMEDIATE 
REFRESH FORCE
ON DEMAND
ENABLE QUERY REWRITE 
AS
	SELECT EXTRACT(year from date_id) t_year, 
		   EXTRACT(month from date_id) t_month, 
		   SUM(quantity) t_quantity,
		   SUM(sale_amount) t_amount
	FROM dm_fct_sales
	GROUP BY EXTRACT(year from date_id), EXTRACT(month from date_id)
    ORDER BY t_year,  t_month;
