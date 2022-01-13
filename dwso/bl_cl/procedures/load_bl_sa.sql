CREATE OR REPLACE PROCEDURE load_bl_sa
IS 
BEGIN
begin
    PKG_LD_SA_RETAIL.ld_sa_type_stores;
    PKG_LD_SA_RETAIL.ld_sa_type_payments;
    PKG_LD_SA_RETAIL.ld_sa_stores;
    PKG_LD_SA_RETAIL.ld_sa_posts;
    PKG_LD_SA_RETAIL.ld_sa_regions;
    PKG_LD_SA_RETAIL.ld_sa_countries;
    PKG_LD_SA_RETAIL.ld_sa_cities;
    PKG_LD_SA_RETAIL.ld_sa_address;
    PKG_LD_SA_RETAIL.ld_sa_employees;
    PKG_LD_SA_RETAIL.ld_sa_authors;
    PKG_LD_SA_RETAIL.ld_sa_books;
    PKG_LD_SA_RETAIL.ld_sa_customers_retail;
    PKG_LD_SA_RETAIL.ld_sa_transaction_retail;
    PKG_LD_SA_STOCK.ld_sa_customers_stock;
    PKG_LD_SA_STOCK.ld_sa_transaction_stock;
end;
   
EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        dbms_output.put_line('ERROR EXECUTE PROCEDURE load_bl_sa');
END;

