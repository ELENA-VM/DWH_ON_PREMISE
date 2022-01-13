CREATE OR REPLACE PROCEDURE insert_initial_data 
IS 
BEGIN
    INSERT INTO bl_3nf.ce_type_stores(TYPE_STORE_ID, TYPE_STORE_SRC_ID, TYPE_STORE, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
    SELECT -1, -1, 'NA', 'NA', 'NA', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT TYPE_STORE_ID
                       FROM bl_3nf.ce_type_stores
                       WHERE TYPE_STORE_ID = -1 );
    COMMIT;
    
    INSERT INTO bl_3nf.ce_type_payments(TYPE_PAYMENT_ID, TYPE_PAYMENT_SRC_ID, TYPE_PAYMENT, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
    SELECT -1, -1, 'NA', 'NA', 'NA', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT TYPE_PAYMENT_ID
                       FROM bl_3nf.ce_type_payments
                       WHERE TYPE_PAYMENT_ID = -1 );
    COMMIT;
    
    INSERT INTO bl_3nf.ce_categories (CATEGORY_ID, CATEGORY_SRC_ID, category_name, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
    SELECT -1, -1, 'NA', 'NA', 'NA', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT CATEGORY_ID
                       FROM bl_3nf.ce_categories
                       WHERE CATEGORY_ID = -1 );
    COMMIT;
    
    INSERT INTO bl_3nf.ce_sub_categories(SUB_CATEGORY_ID, SUB_CATEGORY_SRC_ID, SUB_CATEGORY, category_surr_id, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
    SELECT -1, -1, 'NA', -1, 'NA', 'NA', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT SUB_CATEGORY_ID
                       FROM bl_3nf.ce_sub_categories
                       WHERE SUB_CATEGORY_ID = -1 );
    COMMIT;
    
    INSERT INTO bl_3nf.ce_stores(STORE_ID, STORE_SRC_ID, STORE_NAME, STORE_TYPE_SURR_ID, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt)  
    SELECT -1, -1, 'NA', -1, 'NA', 'NA', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT STORE_ID
                       FROM bl_3nf.ce_stores
                       WHERE STORE_ID = -1 );
    COMMIT;
    
    INSERT INTO bl_3nf.ce_regions(REGION_ID, REGION_SRC_ID, REGION, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
    SELECT -1, -1, 'NA', 'NA', 'NA', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT REGION_ID
                       FROM bl_3nf.ce_regions
                       WHERE REGION_ID = -1 );
    COMMIT;   
    
    INSERT INTO bl_3nf.ce_posts(POST_ID, POST_SRC_ID, POST_NAME, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt)
    SELECT -1, -1, 'NA', 'NA', 'NA', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT POST_ID
                       FROM bl_3nf.ce_posts
                       WHERE POST_ID = -1 );
    COMMIT;
    
    INSERT INTO bl_3nf.ce_employees(EMPLOYEE_ID, EMPLOYEE_SRC_ID, SOURCE_ENTITY, SOURCE_SYSTEM, store_surr_id, FIRST_NAME, 
                                    LAST_NAME, POST_SURR_ID, update_dt, insert_dt) 
    SELECT -1, -1, 'NA', 'NA', -1, 'NA', 'NA', -1, sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT EMPLOYEE_ID
                       FROM bl_3nf.ce_employees
                       WHERE EMPLOYEE_ID = -1 );
    COMMIT;
    
    INSERT INTO bl_3nf.ce_countries(COUNTRY_ID, COUNTRY_SRC_ID, COUNTRY, region_surr_id, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
    SELECT -1, -1, 'NA', -1, 'NA', 'NA', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT COUNTRY_ID
                       FROM bl_3nf.ce_countries
                       WHERE COUNTRY_ID = -1 );
    COMMIT;
   
    INSERT INTO bl_3nf.ce_cities(CITY_ID, CITY_SRC_ID, CITY, COUNTRY_SURR_ID, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
    SELECT -1, -1, 'NA', -1, 'NA', 'NA', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT CITY_ID
                       FROM bl_3nf.ce_cities
                       WHERE CITY_ID = -1 );
    COMMIT;
    
    INSERT INTO bl_3nf.ce_addresses(ADDRESS_ID, ADDRESS_SRC_ID, ADDRESS, postal_code, CITY_SURR_ID, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt)  
    SELECT -1, -1, 'NA', 'NA', -1, 'NA', 'NA', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT ADDRESS_ID
                       FROM bl_3nf.ce_addresses
                       WHERE ADDRESS_ID = -1 );
    COMMIT;

    INSERT INTO bl_3nf.ce_customers(customer_id, customer_src_id, source_system, source_entity,
                                    type_customer, first_name, last_name, gender, date_of_birth, 
                                    name_of_organization, head_of_organization, 
                                    iban, email, address_surr_id, update_dt, insert_dt) 
    SELECT -1, -1, 'NA', 'NA', -1, 'NA', 'NA', 'NA', TO_DATE('01011970', 'MMDDYYYY'),  'NA', 'NA', 'NA', 'NA', -1, sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT customer_id
                       FROM bl_3nf.ce_customers
                       WHERE customer_id = -1 );
    COMMIT;

    INSERT INTO bl_3nf.ce_authors(AUTHOR_ID, AUTHOR_SRC_ID, AUTHOR_NAME, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
    SELECT -1, -1, 'NA', 'NA', 'NA', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT AUTHOR_ID
                       FROM bl_3nf.ce_authors
                       WHERE AUTHOR_ID = -1 );
    COMMIT;
    
    INSERT INTO bl_3nf.ce_books(BOOK_ID, BOOK_SRC_ID, SOURCE_SYSTEM, SOURCE_ENTITY, ISBN, PUBLISHER, BOOK_TITLE,
                                YEAR_OF_PUBLICATION, AUTHOR_ID, SUB_CATEGORY_SURR_ID, START_DT, END_DT, IS_ACTIVE, UPDATE_DT, INSERT_DT) 
    SELECT -1, -1, 'NA', 'NA', 'NA', 'NA', 'NA', -1, -1, -1, TO_DATE('01011970', 'MMDDYYYY'), TO_DATE('01019999', 'MMDDYYYY'), 'yes', sysdate, sysdate
    FROM dual
    WHERE NOT EXISTS ( SELECT BOOK_ID
                       FROM bl_3nf.ce_books
                       WHERE BOOK_ID = -1 );
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        dbms_output.put_line('ERROR EXECUTE PROCEDURE insert_initial_data');
END;

