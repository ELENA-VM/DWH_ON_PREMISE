CREATE OR REPLACE PROCEDURE clear_data_bl_dm 
IS 
BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.fct_sales';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.dim_type_payments';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.dim_stores';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.dim_employees';    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.dim_addresses';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.dim_books_scd';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.dim_customers';

EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        dbms_output.put_line('ERROR EXECUTE PROCEDURE clear_data_bl_dm');
END;
