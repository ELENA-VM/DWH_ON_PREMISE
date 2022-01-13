CREATE OR REPLACE PACKAGE PKG_3NF_SALES AS 
    PROCEDURE ld_ce_sales_from_retail;
    PROCEDURE ld_ce_sales_from_stock;
    PROCEDURE ld_ce_sales_by_part(p_start_date in date default sysdate,
                                  p_end_date in date default sysdate); 
                                  
    PROCEDURE load_sale_sa_layers(p_date_period in date);
    PROCEDURE ld_incr_sale_from_sa_layers;    
END PKG_3NF_SALES;
