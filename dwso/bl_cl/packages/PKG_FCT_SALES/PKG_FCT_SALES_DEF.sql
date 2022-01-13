CREATE OR REPLACE PACKAGE PKG_FCT_SALES AS 
    PROCEDURE ld_fct_sales;
    PROCEDURE ld_ce_sales_by_part(p_start_date in date default sysdate,
                                  p_end_date in date default sysdate);  
                                  
    PROCEDURE load_sale_bl_3nf_layer(p_date_period in date);
END PKG_FCT_SALES;
