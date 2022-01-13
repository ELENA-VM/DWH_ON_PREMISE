CREATE OR REPLACE PROCEDURE clear_data_sa_retail 
IS 
BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_type_stores';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_type_payments';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_stores';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_posts';    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_regions';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_countries';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_cities';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_address';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_employees';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_authors';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_books';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_customers_retail';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE retail.sa_transaction_retail';
EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        dbms_output.put_line('ERROR EXECUTE PROCEDURE clear_data_sa_retail');
END;
 