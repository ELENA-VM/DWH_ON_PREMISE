CREATE OR REPLACE PACKAGE BODY PKG_LD_SA_STOCK AS  
/*
    Package for load SA tables from extermal tables
    Layer: SA_STOCK
    Tables: sa_customers_stock, sa_transaction_stock
*/ 
  
   PROCEDURE ld_sa_customers_stock IS
   BEGIN   
        insert_msg_log( 'sa_stock', 'ext_stock_customers', 'ld_sa_customers_stock', 'start execution'); 

        MERGE INTO sas_customers_stock target              
        USING (SELECT CUSTOMER_ID,              
                      NAME_OF_ORGANIZATION,
                      HEAD_OF_ORGANIZATION,
                      EMAIL,
                      IBAN,
                      ADDRESS_ID              
               FROM sa_stock.ext_stock_customers) source       
            ON (target.CUSTOMER_ID = source.CUSTOMER_ID)   
            
        WHEN MATCHED THEN
            UPDATE SET target.NAME_OF_ORGANIZATION = upper(source.NAME_OF_ORGANIZATION),
                       target.HEAD_OF_ORGANIZATION = upper(source.HEAD_OF_ORGANIZATION),
                       target.EMAIL = upper(source.EMAIL),
                       target.IBAN = source.IBAN,               
                       target.ADDRESS_ID = source.ADDRESS_ID, 
                       target.UPDATE_DT  = sysdate
            WHERE (DECODE(target.NAME_OF_ORGANIZATION, upper(source.NAME_OF_ORGANIZATION), 0, 1) + 
                   DECODE(target.HEAD_OF_ORGANIZATION, upper(source.HEAD_OF_ORGANIZATION), 0, 1) + 
                   DECODE(target.EMAIL, upper(source.EMAIL), 0, 1) + 
                   DECODE(target.IBAN, source.IBAN, 0, 1) + 
                   DECODE(target.ADDRESS_ID, source.ADDRESS_ID, 0, 1) ) >0        
            
        WHEN NOT MATCHED THEN 
            INSERT (target.CUSTOMER_ID, target.NAME_OF_ORGANIZATION, target.HEAD_OF_ORGANIZATION, target.EMAIL, target.IBAN, target.ADDRESS_ID, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.CUSTOMER_ID, upper(source.NAME_OF_ORGANIZATION), upper(source.HEAD_OF_ORGANIZATION), upper(source.EMAIL), source.IBAN, source.ADDRESS_ID, sysdate, sysdate);
 
        insert_msg_log('retail', 'ext_stock_customers', 'ld_sa_customers_stock', 'processed ' || SQL%ROWCOUNT || ' rows');             
        COMMIT;  
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_stock_customers', 'ld_sa_customers_stock', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_customers_stock;
   
   PROCEDURE ld_sa_transaction_stock IS
   BEGIN
        insert_msg_log('sa_stock', 'ext_transaction_stock', 'ld_sa_transaction_stock', 'start execution'); 

        MERGE INTO sas_transaction_stock target              
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
               FROM sa_stock.ext_transaction_stock) source       
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
                       target.BOOK_ID = source.BOOK_ID,              
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
                   DECODE(target.BOOK_ID, source.BOOK_ID, 0, 1) ) > 0  
            
        WHEN NOT MATCHED THEN 
            INSERT (target.SALE_ID, target.INVOICE, target.STORE_ID, target.QUANTITY, 
                    target.PRICE, target.CUSTOMER_ID, target.INVOICE_DATE, target.SALE_AMOUNT, 
                    target.ADDRESS_ID, target.EMPLOYEE_ID, target.type_payment_id, 
                    target.BOOK_ID, target.INSERT_DT, target.UPDATE_DT) 
            VALUES (source.SALE_ID, upper(source.INVOICE),source.STORE_ID, source.QUANTITY, 
                    source.PRICE, source.CUSTOMER_ID, source.INVOICE_DATE, source.SALE_AMOUNT,
                    source.ADDRESS_ID, source.EMPLOYEE_ID, source.type_payment_id, 
                    source.BOOK_ID, sysdate, sysdate); 

        insert_msg_log( 'retail', 'ext_transaction_stock', 'ld_sa_transaction_stock', 'processed ' || SQL%ROWCOUNT || ' rows');             
        COMMIT; 
    EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log('retail', 'ext_transaction_stock', 'ld_sa_transaction_stock', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
   END ld_sa_transaction_stock;
   
END PKG_LD_SA_STOCK;