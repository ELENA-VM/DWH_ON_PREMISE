CREATE OR REPLACE PROCEDURE clear_data_sa_stock 
IS 
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE sa_stock.sa_customers_stock';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE sa_stock.sa_transaction_stock';
EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        dbms_output.put_line('ERROR EXECUTE PROCEDURE clear_data_sa_stock');
END;
 