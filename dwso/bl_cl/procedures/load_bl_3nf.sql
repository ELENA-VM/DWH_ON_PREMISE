CREATE OR REPLACE PROCEDURE load_bl_3nf ( p_start_date in date default add_months(sysdate,-2),
                                          p_end_date in date default sysdate,
                                          p_type_period in numeric default 0 )
IS 
BEGIN
    pkg_3nf_type_payments.ld_ce_type_payments;
    pkg_3nf_stores.ld_ce_type_stores;
    pkg_3nf_employees.ld_ce_posts;
    pkg_3nf_stores.ld_incr_ce_stores;
    pkg_3nf_employees.ld_incr_ce_employees;    
    pkg_3nf_locations.ld_ce_regions;
    pkg_3nf_locations.ld_ce_countries;
    pkg_3nf_locations.ld_ce_cities;
    pkg_3nf_locations.ld_ce_addresses;
    pkg_3nf_customers.ld_ce_customers_from_retail;
    pkg_3nf_customers.ld_ce_customers_from_stock;
    pkg_3nf_books.ld_ce_categories;
    pkg_3nf_books.ld_ce_sub_categories;    
    pkg_3nf_books.ld_ce_authors; 
    pkg_3nf_books.ld_ce_books;
    pkg_3nf_books.ld_ce_book_author;
    
    pkg_3nf_sales.ld_incr_sale_from_sa_layers;
    
--    if p_type_period = 1 then -- the whole period
--        pkg_3nf_sales.ld_ce_sales_by_part(to_date('2020-12-01', 'YYYY-MM-DD'), to_date('2023-12-31', 'YYYY-MM-DD'));
--    else
--        pkg_3nf_sales.ld_ce_sales_by_part(p_start_date, p_end_date);
--    end if;
      
EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        dbms_output.put_line('ERROR EXECUTE PROCEDURE load_bl_3nf');
END;

