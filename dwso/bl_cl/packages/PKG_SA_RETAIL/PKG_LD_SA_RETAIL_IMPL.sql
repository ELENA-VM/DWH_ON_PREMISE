CREATE OR REPLACE PACKAGE BODY PKG_LD_SA_RETAIL AS  
/*
    Package for load SA tables from extermal tables
    Layer: SA_RETAIL
    Tables: sa_type_stores, sa_type_payments, sa_stores, sa_posts, sa_regions,
    sa_countries, sa_cities, sa_address, sa_employees, sa_authors, sa_books,
    sa_customers_retail, sa_transaction_retail
*/ 
   PROCEDURE ld_sa_type_stores IS
   BEGIN
        insert_msg_log( 'retail', 'ext_type_stores', 'ld_sa_type_stores', 'start execution'); 
   
        MERGE INTO sar_type_stores target              
        USING (SELECT TYPE_STORE_ID,
                      TYPE_STORE
               FROM retail.ext_type_stores) source       
            ON (target.TYPE_STORE_ID = source.TYPE_STORE_ID) 
            
        WHEN MATCHED THEN
            UPDATE SET target.TYPE_STORE = upper(source.TYPE_STORE),
                       target.UPDATE_DT  = sysdate
            WHERE DECODE(target.TYPE_STORE, upper(source.TYPE_STORE), 0, 1) > 0
            
        WHEN NOT MATCHED THEN 
            INSERT (target.TYPE_STORE_ID, target.TYPE_STORE, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.TYPE_STORE_ID, upper(source.TYPE_STORE), sysdate, sysdate); 

        insert_msg_log('retail', 'ext_type_stores', 'ld_sa_type_stores', 'processed ' || SQL%ROWCOUNT || ' rows'); 
            
        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
            insert_msg_log('retail', 'ext_type_stores', 'ld_sa_type_stores', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_type_stores; 

   PROCEDURE ld_sa_type_payments IS
   BEGIN
        insert_msg_log( 'retail', 'ext_type_payments', 'ld_sa_type_payments', 'start execution'); 

        MERGE INTO sar_type_payments target              
        USING (SELECT TYPE_PAYMENT_ID,
                      TYPE_PAYMENT
               FROM retail.ext_type_payments ) source       
            ON (target.TYPE_PAYMENT_ID = source.TYPE_PAYMENT_ID) 
            
        WHEN MATCHED THEN
            UPDATE SET target.TYPE_PAYMENT = upper(source.TYPE_PAYMENT),
                       target.UPDATE_DT  = sysdate
            WHERE DECODE(target.TYPE_PAYMENT, upper(source.TYPE_PAYMENT), 0, 1) > 0
            
        WHEN NOT MATCHED THEN 
            INSERT (target.TYPE_PAYMENT_ID, target.TYPE_PAYMENT, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.TYPE_PAYMENT_ID, upper(source.TYPE_PAYMENT), sysdate, sysdate); 

        insert_msg_log( 'retail', 'ext_type_payments', 'ld_sa_type_payments', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_type_payments', 'ld_sa_type_payments', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_type_payments; 

   PROCEDURE ld_sa_stores IS
   BEGIN
        insert_msg_log( 'retail', 'ext_stores', 'ld_sa_stores', 'start execution'); 

        MERGE INTO sar_stores target              
        USING (SELECT STORE_ID,              
                      STORE_NAME,
                      STORE_TYPE_ID         
               FROM retail.ext_stores) source       
            ON (target.STORE_ID = source.STORE_ID)   
            
        WHEN MATCHED THEN
            UPDATE SET target.STORE_NAME = upper(source.STORE_NAME),
                       target.STORE_TYPE_ID = source.STORE_TYPE_ID, 
                       target.IS_CPROCESSED = 'N',
                       target.UPDATE_DT  = sysdate
            WHERE ( DECODE(target.STORE_NAME, upper(source.STORE_NAME), 0, 1) +
                    DECODE(target.STORE_TYPE_ID, source.STORE_TYPE_ID, 0, 1) ) > 0 
            
        WHEN NOT MATCHED THEN 
            INSERT (target.STORE_ID, target.STORE_NAME, target.STORE_TYPE_ID, target.IS_CPROCESSED, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.STORE_ID, upper(source.STORE_NAME), source.STORE_TYPE_ID, 'N', sysdate, sysdate);

        insert_msg_log( 'retail', 'ext_stores', 'ld_sa_stores', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_stores', 'ld_sa_stores', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_stores; 
     
   PROCEDURE ld_sa_posts IS
   BEGIN
        insert_msg_log('retail', 'ext_posts', 'ld_sa_posts', 'start execution'); 

        MERGE INTO sar_posts target              
        USING (SELECT POST_ID,
                      POST_NAME
               FROM retail.ext_posts) source       
            ON (target.POST_ID = source.POST_ID) 
            
        WHEN MATCHED THEN
            UPDATE SET target.POST_NAME = upper(source.POST_NAME),
                       target.UPDATE_DT  = sysdate
            WHERE DECODE(target.POST_NAME, upper(source.POST_NAME), 0, 1) > 0
            
        WHEN NOT MATCHED THEN 
            INSERT (target.POST_ID, target.POST_NAME, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.POST_ID, upper(source.POST_NAME), sysdate, sysdate)
            WHERE source.POST_ID IS NOT NULL; 

        insert_msg_log('retail', 'ext_posts', 'ld_sa_posts', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_posts', 'ld_sa_posts', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_posts; 
   
   PROCEDURE ld_sa_regions IS
   BEGIN   
        insert_msg_log( 'retail', 'ext_region', 'ld_sa_regions', 'start execution'); 

        MERGE INTO sar_regions target              
        USING (SELECT REGION_ID,
                      REGION_NAME
               FROM retail.ext_region) source       
            ON (target.REGION_ID = source.REGION_ID) 
            
        WHEN MATCHED THEN
            UPDATE SET target.REGION_NAME = upper(source.REGION_NAME),
                       target.UPDATE_DT  = sysdate
            WHERE DECODE(target.REGION_NAME, upper(source.REGION_NAME), 0, 1) > 0
            
        WHEN NOT MATCHED THEN 
            INSERT (target.REGION_ID, target.REGION_NAME, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.REGION_ID, upper(source.REGION_NAME), sysdate, sysdate);

        insert_msg_log( 'retail', 'ext_region', 'ld_sa_regions', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        COMMIT;   
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_region', 'ld_sa_regions', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_regions; 
      
   PROCEDURE ld_sa_countries IS
   BEGIN    
        insert_msg_log( 'retail', 'ext_country', 'ld_sa_countries', 'start execution'); 

        MERGE INTO sar_countries target              
        USING (SELECT COUNTRY_ID,
                      COUNTRY,
                      REGION_ID
               FROM retail.ext_country) source       
            ON (target.COUNTRY_ID = source.COUNTRY_ID) 
            
        WHEN MATCHED THEN
            UPDATE SET target.COUNTRY = upper(source.COUNTRY),
                       target.REGION_ID = source.REGION_ID, 
                       target.UPDATE_DT  = sysdate
            WHERE ( DECODE(target.COUNTRY, upper(source.COUNTRY), 0, 1) +
                    DECODE(target.REGION_ID, source.REGION_ID, 0, 1) ) > 0
            
        WHEN NOT MATCHED THEN 
            INSERT (target.COUNTRY_ID, target.COUNTRY, target.REGION_ID, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.COUNTRY_ID, upper(source.COUNTRY), source.REGION_ID, sysdate, sysdate);
            insert_msg_log( 'retail', 'ext_country', 'ld_sa_countries', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        COMMIT;   
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_country', 'ld_sa_countries', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_countries;
   
   PROCEDURE ld_sa_cities IS
   BEGIN   
        insert_msg_log( 'retail', 'ext_cities', 'ld_sa_cities', 'start execution'); 

        MERGE INTO sar_cities target              
        USING (SELECT CITY_ID,
                      CITY,
                      COUNTRY_ID
               FROM retail.ext_cities) source       
            ON (target.CITY_ID = source.CITY_ID) 
            
        WHEN MATCHED THEN
            UPDATE SET target.CITY = upper(source.CITY),
                       target.COUNTRY_ID = source.COUNTRY_ID, 
                       target.UPDATE_DT  = sysdate
            WHERE ( DECODE(target.CITY, upper(source.CITY), 0, 1) +
                    DECODE(target.COUNTRY_ID, source.COUNTRY_ID, 0, 1) ) > 0     
            
        WHEN NOT MATCHED THEN 
            INSERT (target.CITY_ID, target.CITY, target.COUNTRY_ID, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.CITY_ID, upper(source.CITY), source.COUNTRY_ID, sysdate, sysdate);
            
        insert_msg_log('retail', 'ext_cities', 'ld_sa_cities', 'processed ' || SQL%ROWCOUNT || ' rows');             
        COMMIT;   
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_cities', 'ld_sa_cities', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_cities;

   PROCEDURE ld_sa_address IS
   BEGIN  
        insert_msg_log('retail', 'ext_address', 'ld_sa_address', 'start execution'); 

        MERGE INTO sar_address target              
        USING (SELECT ADDRESS_ID,
                      ADDRESS,
                      ADDRESS2,
                      DISTRICT,
                      CITY_ID,
                      POSTAL_CODE
               FROM retail.ext_address) source       
            ON (target.ADDRESS_ID = source.ADDRESS_ID) 
            
        WHEN MATCHED THEN
            UPDATE SET target.ADDRESS = upper(source.ADDRESS),
                       target.ADDRESS2 = upper(source.ADDRESS2), 
                       target.DISTRICT = upper(source.DISTRICT),
                       target.CITY_ID = source.CITY_ID,
                       target.POSTAL_CODE = source.POSTAL_CODE,
                       target.UPDATE_DT  = sysdate
            WHERE (DECODE(target.ADDRESS, upper(source.ADDRESS), 0, 1) + 
                   DECODE(target.ADDRESS2, upper(source.ADDRESS2), 0, 1) +
                   DECODE(target.DISTRICT, upper(source.DISTRICT), 0, 1) + 
                   DECODE(target.POSTAL_CODE, upper(source.POSTAL_CODE), 0, 1) +
                   DECODE(target.CITY_ID, source.CITY_ID, 0, 1) ) > 0 
            
        WHEN NOT MATCHED THEN 
            INSERT (target.ADDRESS_ID, target.ADDRESS, target.ADDRESS2, target.DISTRICT, target.CITY_ID, target.POSTAL_CODE, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.ADDRESS_ID, upper(source.ADDRESS), upper(source.ADDRESS2), upper(source.DISTRICT), source.CITY_ID, source.POSTAL_CODE, sysdate, sysdate);

        insert_msg_log( 'retail', 'ext_address', 'ld_sa_address', 'processed ' || SQL%ROWCOUNT || ' rows');             
        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_address', 'ld_sa_address', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_address;   
   
   PROCEDURE ld_sa_employees IS
   BEGIN
        insert_msg_log( 'retail', 'ext_employees', 'ld_sa_employees', 'start execution'); 

        MERGE INTO sar_employees target              
        USING (SELECT EMPLOYEE_ID,
                      FIRST_NAME,
                      LAST_NAME,
                      POST_ID,
                      STORE_ID
               FROM retail.ext_employees) source       
            ON (target.EMPLOYEE_ID = source.EMPLOYEE_ID) 
            
        WHEN MATCHED THEN
            UPDATE SET target.FIRST_NAME = upper(source.FIRST_NAME),
                       target.LAST_NAME = upper(source.LAST_NAME),    
                       target.POST_ID = source.POST_ID, 
                       target.STORE_ID = source.STORE_ID, 
                       target.UPDATE_DT  = sysdate
            WHERE (DECODE(target.FIRST_NAME, upper(source.FIRST_NAME), 0, 1) +
                   DECODE(target.LAST_NAME, upper(source.LAST_NAME), 0, 1) +
                   DECODE(target.STORE_ID, source.STORE_ID, 0, 1) +
                   DECODE(target.POST_ID, source.POST_ID, 0, 1)) > 0
                      
        WHEN NOT MATCHED THEN 
            INSERT (target.EMPLOYEE_ID, target.FIRST_NAME, target.LAST_NAME, target.POST_ID, target.STORE_ID, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.EMPLOYEE_ID, upper(source.FIRST_NAME), upper(source.LAST_NAME), source.POST_ID, source.STORE_ID, sysdate, sysdate);
        insert_msg_log( 'retail', 'ext_employees', 'ld_sa_employees', 'processed ' || SQL%ROWCOUNT || ' rows');             
        COMMIT; 
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_employees', 'ld_sa_employees', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_employees;  
   
   PROCEDURE ld_sa_authors IS
   BEGIN
        insert_msg_log( 'retail', 'ext_authors', 'ld_sa_authors', 'start execution'); 

        MERGE INTO sar_authors target              
        USING (SELECT AUTHOR_ID,
                      AUTHOR_NAME
               FROM retail.ext_authors) source       
            ON (target.AUTHOR_ID = source.AUTHOR_ID) 
            
        WHEN MATCHED THEN
            UPDATE SET target.AUTHOR_NAME = upper(source.AUTHOR_NAME),
                       target.UPDATE_DT  = sysdate
            WHERE DECODE(target.AUTHOR_NAME, upper(source.AUTHOR_NAME), 0, 1) > 0

        WHEN NOT MATCHED THEN 
            INSERT (target.AUTHOR_ID, target.AUTHOR_NAME, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.AUTHOR_ID, upper(source.AUTHOR_NAME), sysdate, sysdate); 

        insert_msg_log( 'retail', 'ext_authors', 'ld_sa_authors', 'processed ' || SQL%ROWCOUNT || ' rows');             

        COMMIT;   
 	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_authors', 'ld_sa_authors', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_authors;
   
   PROCEDURE ld_sa_books IS
   BEGIN   
        insert_msg_log( 'retail', 'ext_books', 'ld_sa_books', 'start execution'); 

        MERGE INTO sar_books target              
        USING (SELECT BOOK_ID,
                      ISBN,              
                      PUBLISHER,
                      BOOK_TITLE,
                      BOOK_AUTHOR,
                      YEAR_OF_PUBLICATION,
                      AUTHOR_ID,
                      CATEGORY_ID,
                      "CATEGORY",
                      SUB_CATEGORY_ID,
                      SUB_CATEGORY
               FROM retail.ext_books
               WHERE trim(';' from BOOK_ID) is not null ) source       
            ON (target.BOOK_ID = source.BOOK_ID)   
            
        WHEN MATCHED THEN
            UPDATE SET target.ISBN = source.ISBN,
                       target.PUBLISHER = upper(source.PUBLISHER),
                       target.BOOK_TITLE = upper(source.BOOK_TITLE), 
                       target.BOOK_AUTHOR = upper(source.BOOK_AUTHOR),
                       target.YEAR_OF_PUBLICATION = source.YEAR_OF_PUBLICATION,
                       target.AUTHOR_ID = source.AUTHOR_ID,
                       target.CATEGORY_ID = source.CATEGORY_ID,
                       target."CATEGORY" = upper(source."CATEGORY"),
                       target.SUB_CATEGORY_ID = source.SUB_CATEGORY_ID,
                       target.SUB_CATEGORY = upper(source.SUB_CATEGORY), 
                       target.UPDATE_DT  = sysdate
            WHERE (DECODE(target.ISBN, source.ISBN, 0, 1) +
                   DECODE(target.PUBLISHER, upper(source.PUBLISHER), 0, 1) +
                   DECODE(target.BOOK_TITLE, upper(source.BOOK_TITLE), 0, 1) +
                   DECODE(target.BOOK_AUTHOR, upper(source.BOOK_AUTHOR), 0, 1) +
                   DECODE(target.YEAR_OF_PUBLICATION, source.YEAR_OF_PUBLICATION, 0, 1) +
                   DECODE(target.AUTHOR_ID, source.AUTHOR_ID, 0, 1) +
                   DECODE(target.CATEGORY_ID, source.CATEGORY_ID, 0, 1) +
                   DECODE(target."CATEGORY", upper(source."CATEGORY"), 0, 1) +
                   DECODE(target.SUB_CATEGORY, upper(source.SUB_CATEGORY), 0, 1) +        
                   DECODE(target.SUB_CATEGORY_ID, source.SUB_CATEGORY_ID, 0, 1)) > 0
        
        WHEN NOT MATCHED THEN 
            INSERT (target.BOOK_ID, target.ISBN, target.PUBLISHER, target.BOOK_TITLE, target.BOOK_AUTHOR, target.YEAR_OF_PUBLICATION, target.AUTHOR_ID, target.CATEGORY_ID, target."CATEGORY", target.SUB_CATEGORY_ID, target.SUB_CATEGORY, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.BOOK_ID, source.ISBN, upper(source.PUBLISHER), upper(source.BOOK_TITLE), upper(source.BOOK_AUTHOR), source.YEAR_OF_PUBLICATION, source.AUTHOR_ID, source.CATEGORY_ID, upper(source."CATEGORY"), source.SUB_CATEGORY_ID, upper(source.SUB_CATEGORY), sysdate, sysdate);
        insert_msg_log( 'retail', 'ext_books', 'ld_sa_books', 'processed ' || SQL%ROWCOUNT || ' rows');             
        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
           insert_msg_log('retail', 'ext_books', 'ld_sa_books', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_books;
   
   PROCEDURE ld_sa_customers_retail IS
   BEGIN
        insert_msg_log('retail', 'ext_customers', 'ld_sa_customers_retail', 'start execution'); 

        MERGE INTO sar_customers_retail target              
        USING (SELECT CUSTOMER_ID,              
                      FIRST_NAME,
                      LAST_NAME,
                      GENDER,
                      DATE_OF_BIRTH,
                      ADDRESS_ID                      
               FROM retail.ext_customers) source       
            ON (target.CUSTOMER_ID = source.CUSTOMER_ID)   
            
        WHEN MATCHED THEN
            UPDATE SET target.FIRST_NAME = upper(source.FIRST_NAME),
                       target.LAST_NAME = upper(source.LAST_NAME),
                       target.GENDER = upper(source.GENDER),
                       target.DATE_OF_BIRTH = source.DATE_OF_BIRTH,               
                       target.ADDRESS_ID = source.ADDRESS_ID, 
                       target.UPDATE_DT  = sysdate
            WHERE ( DECODE(target.FIRST_NAME, upper(source.FIRST_NAME), 0, 1) +
                    DECODE(target.LAST_NAME, upper(source.LAST_NAME), 0, 1) +
                    DECODE(target.GENDER, upper(source.GENDER), 0, 1) +
                    DECODE(target.DATE_OF_BIRTH, source.DATE_OF_BIRTH, 0, 1) +
                    DECODE(target.ADDRESS_ID, source.ADDRESS_ID, 0, 1) ) > 0
            
        WHEN NOT MATCHED THEN 
            INSERT (target.CUSTOMER_ID, target.FIRST_NAME, target.LAST_NAME, target.GENDER, target.DATE_OF_BIRTH, target.ADDRESS_ID, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.CUSTOMER_ID, upper(source.FIRST_NAME), upper(source.LAST_NAME), upper(source.GENDER), source.DATE_OF_BIRTH, source.ADDRESS_ID, sysdate, sysdate);

        insert_msg_log('retail', 'ext_customers', 'ld_sa_customers_retail', 'processed ' || SQL%ROWCOUNT || ' rows');             
        COMMIT;   
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_customers', 'ld_sa_customers_retail', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_customers_retail;
   
   PROCEDURE ld_sa_transaction_retail IS
   BEGIN
        insert_msg_log( 'retail', 'ext_transaction_retail', 'ld_sa_transaction_retail', 'start execution'); 

        MERGE INTO sar_transaction_retail target              
        USING (SELECT SALE_ID,
                      INVOICE,
                      STORE_ID,
                      QUANTITY,
                      PRICE,
                      CUSTOMER_ID,
                      INVOICE_DATE,
                      SALE_AMOUNT,
                      ADDRESS_ID,
                      EMPLOYEE_ID,
                      type_payment_id,
                      BOOK_ID
               FROM retail.ext_transaction_retail) source       
            ON (target.SALE_ID = source.SALE_ID) 
            
        WHEN MATCHED THEN
            UPDATE SET target.INVOICE = upper(source.INVOICE),
                       target.STORE_ID = source.STORE_ID, 
                       target.QUANTITY = source.QUANTITY,
                       target.PRICE = source.PRICE,
                       target.CUSTOMER_ID = source.CUSTOMER_ID,
                       target.INVOICE_DATE = source.INVOICE_DATE,
                       target.SALE_AMOUNT = source.SALE_AMOUNT,
                       target.ADDRESS_ID = source.ADDRESS_ID,
                       target.EMPLOYEE_ID = source.EMPLOYEE_ID,
                       target.type_payment_id = source.type_payment_id,
                       target.book_id = source.book_id,
                       target.UPDATE_DT  = sysdate
            WHERE (DECODE(target.INVOICE, upper(source.INVOICE), 0, 1) +
                   DECODE(target.STORE_ID, source.STORE_ID, 0, 1) + 
                   DECODE(target.QUANTITY, source.QUANTITY, 0, 1) +
                   DECODE(target.PRICE, source.PRICE, 0, 1) +
                   DECODE(target.CUSTOMER_ID, source.CUSTOMER_ID, 0, 1) +
                   DECODE(target.INVOICE_DATE, source.INVOICE_DATE, 0, 1) +
                   DECODE(target.SALE_AMOUNT, source.SALE_AMOUNT, 0, 1) + 
                   DECODE(target.ADDRESS_ID, source.ADDRESS_ID, 0, 1) + 
                   DECODE(target.EMPLOYEE_ID, source.EMPLOYEE_ID, 0, 1) + 
                   DECODE(target.type_payment_id, source.type_payment_id, 0, 1) + 
                   DECODE(target.book_id, source.book_id, 0, 1) ) > 0 
            
        WHEN NOT MATCHED THEN 
            INSERT (target.SALE_ID, target.INVOICE, target.STORE_ID, target.QUANTITY, 
                    target.PRICE, target.CUSTOMER_ID, target.INVOICE_DATE, target.SALE_AMOUNT, 
                    target.ADDRESS_ID, target.EMPLOYEE_ID, target.type_payment_id, 
                    target.book_id, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.SALE_ID, upper(source.INVOICE),source.STORE_ID, source.QUANTITY, 
                    source.PRICE, source.CUSTOMER_ID, source.INVOICE_DATE, source.SALE_AMOUNT, 
                    source.ADDRESS_ID, source.EMPLOYEE_ID, source.type_payment_id, 
                    source.book_id, sysdate, sysdate); 
        insert_msg_log( 'retail', 'ext_transaction_retail', 'ld_sa_transaction_retail', 'processed ' || SQL%ROWCOUNT || ' rows');             
        
        COMMIT;            
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_transaction_retail', 'ld_sa_transaction_retail', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_transaction_retail;
   
END PKG_LD_SA_RETAIL;