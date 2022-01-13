CREATE OR REPLACE PROCEDURE clear_data_bl_3nf 
IS 
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_sales';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_book_author';      
    
    DELETE bl_3nf.ce_customers
    WHERE customer_id > 0;
    
    DELETE bl_3nf.ce_employees
    WHERE EMPLOYEE_ID > 0;    
    
    DELETE bl_3nf.ce_posts
    WHERE POST_ID > 0;
    
    DELETE bl_3nf.ce_stores
    WHERE STORE_ID > 0; 
    
    DELETE bl_3nf.ce_type_stores
    WHERE TYPE_STORE_ID > 0;  
    
    DELETE bl_3nf.ce_addresses
    WHERE ADDRESS_ID > 0; 
    
    DELETE bl_3nf.ce_cities
    WHERE CITY_ID > 0; 
    
    DELETE bl_3nf.ce_countries
    WHERE COUNTRY_ID > 0;
    
    DELETE bl_3nf.ce_regions
    WHERE REGION_ID > 0;    

    DELETE bl_3nf.ce_authors
    WHERE AUTHOR_ID > AUTHOR_ID; 
    
    DELETE bl_3nf.ce_books
    WHERE BOOK_ID > 0;
    
    DELETE bl_3nf.ce_sub_categories
    WHERE SUB_CATEGORY_ID > 0;      
    
    DELETE bl_3nf.ce_categories
    WHERE CATEGORY_ID > 0; 
    
    DELETE bl_3nf.ce_type_payments
    WHERE TYPE_PAYMENT_ID > 0;       
EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        dbms_output.put_line('ERROR EXECUTE PROCEDURE clear_data_bl_3nf');
END;

