CREATE OR REPLACE PROCEDURE load_bl_dm ( p_start_date in date default add_months(sysdate,-2),
                                         p_end_date in date default sysdate,
                                         p_type_period in numeric default 0 )
IS 
BEGIN
    pkg_dim_type_payments.ld_dim_type_payments;
    pkg_dim_stores.ld_dim_stores;
    pkg_dim_employees.ld_dim_employees;
    pkg_dim_locations.ld_dim_addresses;
    pkg_dim_books.ld_dim_books;
    pkg_dim_customers.ld_dim_customers;  
    
--    if p_type_period = 1 then -- the whole period
        pkg_fct_sales.ld_ce_sales_by_part(to_date('2020-12-01', 'YYYY-MM-DD'), to_date('2022-12-31', 'YYYY-MM-DD'));
--    else
--        pkg_fct_sales.ld_ce_sales_by_part(p_start_date, p_end_date);
--    end if;
EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        dbms_output.put_line('ERROR EXECUTE PROCEDURE load_bl_dm');
END;

