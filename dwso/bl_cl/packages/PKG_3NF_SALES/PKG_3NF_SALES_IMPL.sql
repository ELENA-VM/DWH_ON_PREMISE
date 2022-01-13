CREATE OR REPLACE PACKAGE BODY PKG_3NF_SALES AS 
/*
    Package for load table ce_sales from some source system
    to layer BL_3NF. 
*/
    ñ_source_retail CONSTANT VARCHAR(6) := 'RETAIL';
    c_sa_transaction_retail CONSTANT VARCHAR(21) := 'SA_TRANSACTION_RETAIL';
    ñ_source_stock CONSTANT VARCHAR(5) := 'STOCK';
    c_sa_transaction_stock CONSTANT VARCHAR(20) := 'SA_TRANSACTION_STOCK';
    -- Load sales using partition exchange
    PROCEDURE load_sale_sa_layers(p_date_period in date)
    IS
    BEGIN
         insert_msg_log('BL_CL', 'SA_LAYER', 'load_sale', 'start execution'); 
         
         EXECUTE IMMEDIATE 'TRUNCATE TABLE wrk_ex_ce_sales';
         
         INSERT INTO wrk_ex_ce_sales (sales_src_id, SOURCE_SYSTEM, SOURCE_ENTITY, book_surr_id,
                                      date_sale, customer_surr_id, employee_surr_id, store_surr_id, 
                                      address_surr_id, type_payment_surr_id, quantity,                     
                                      sale_amount, num_invoice, update_dt, insert_dt) 
         SELECT
                trim('"' from satr.sale_id) sale_id,
                ñ_source_retail,
                c_sa_transaction_retail,
                NVL(ceb.book_id, -1) book_id,
                to_date(substr(satr.invoice_date, 1, 10), 'YYYY-MM-DD') invoice_date,
                NVL(cec.customer_id, -1) customer_id,
                NVL(cee.employee_id, -1) employee_id,
                NVL(ces.store_id, -1) store_id,
                NVL(ceadr.address_id, -1) address_id,
                NVL(ctp.type_payment_id, -1) type_payment_id,
                NVL(TO_NUMBER(satr.quantity), 0) quantity,
                TO_NUMBER(satr.sale_amount, '9999999999.9999999999999999') sale_amount,
                trim('"' from satr.invoice) invoice,
                sysdate,
                sysdate
                FROM sar_transaction_retail satr
                LEFT JOIN nf_ce_stores ces ON trim('"' from satr.store_id) = ces.store_src_id
                LEFT JOIN nf_ce_addresses ceadr ON satr.address_id = ceadr.address_src_id
                LEFT JOIN nf_ce_employees cee ON trim('"' from satr.employee_id) = cee.employee_src_id
                LEFT JOIN nf_ce_type_payments ctp ON satr.type_payment_id = ctp.type_payment_src_id
                LEFT JOIN nf_ce_books ceb ON satr.book_id = ceb.book_src_id 
                      AND ceb.start_dt <= to_date(substr(satr.invoice_date, 1, 10), 'YYYY-MM-DD')
                      AND ceb.end_dt   >= to_date(substr(satr.invoice_date, 1, 10), 'YYYY-MM-DD')
                LEFT JOIN nf_ce_customers cec ON satr.customer_id = cec.customer_src_id 
                      AND cec.SOURCE_SYSTEM = ñ_source_retail         
                WHERE to_date(substr(satr.invoice_date, 1, 10), 'YYYY-MM-DD') >= p_date_period
                  AND to_date(substr(satr.invoice_date, 1, 10), 'YYYY-MM-DD') < add_months(p_date_period, 1)
        UNION ALL
        
        SELECT  trim('"' from sats.sale_id) sale_id,
                ñ_source_stock,
                c_sa_transaction_stock,
                NVL(ceb.book_id, -1) book_id,
                to_date(substr(sats.invoice_date, 1, 10), 'YYYY-MM-DD') invoice_date,
                NVL(cec.customer_id, -1) customer_id,
                NVL(cee.employee_id, -1) employee_id,
                NVL(ces.store_id, -1) store_id,
                NVL(ceadr.address_id, -1) address_id,
                NVL(ctp.type_payment_id, -1) type_payment_id,
                NVL(TO_NUMBER(sats.quantity), 0) quantity,  
                TO_NUMBER(sats.sale_amount, '9999999999.9999999999999999') sale_amount,  
                trim('"' from sats.invoice) invoice,                
                sysdate,
                sysdate
        FROM sas_transaction_stock sats
        LEFT JOIN nf_ce_stores ces ON trim('"' from sats.store_id) = ces.store_src_id
        LEFT JOIN nf_ce_addresses ceadr ON sats.address_id = ceadr.address_src_id
        LEFT JOIN nf_ce_employees cee ON trim('"' from sats.employee_id) = cee.employee_src_id
        LEFT JOIN nf_ce_type_payments ctp ON sats.type_payment_id = ctp.type_payment_src_id
        LEFT JOIN nf_ce_books ceb ON sats.book_id = ceb.book_src_id 
              AND ceb.start_dt <= to_date(substr(sats.invoice_date, 1, 10), 'YYYY-MM-DD')
              AND ceb.end_dt   >= to_date(substr(sats.invoice_date, 1, 10), 'YYYY-MM-DD')      
			  
        LEFT JOIN nf_ce_customers cec ON sats.customer_id = cec.customer_src_id 
              AND cec.SOURCE_SYSTEM = ñ_source_stock
        WHERE to_date(substr(sats.invoice_date, 1, 10), 'YYYY-MM-DD') >= p_date_period
          AND to_date(substr(sats.invoice_date, 1, 10), 'YYYY-MM-DD') < add_months(p_date_period, 1);        
      
        insert_msg_log( 'BL_CL', 'SA_LAYER', 'load_sale', 'processed ' || SQL%ROWCOUNT || ' rows'); 
    
        COMMIT;
        
        EXECUTE IMMEDIATE 'ALTER TABLE BL_3NF.ce_sales 
                           EXCHANGE PARTITION P_'|| TO_CHAR(p_date_period, 'YYYYMM') ||
                          ' WITH TABLE wrk_ex_ce_sales';
  
	EXCEPTION
		WHEN OTHERS THEN 
           insert_msg_log( 'BL_CL', 'SA_LAYER', 'load_sale', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK; 
  
    END load_sale_sa_layers;
    
    -- load sales by periods
    PROCEDURE ld_ce_sales_by_part(p_start_date in date default sysdate,
                                  p_end_date in date default sysdate) 
    IS
        tmp_date date := sysdate;  
    BEGIN
        tmp_date := TO_DATE('01' || TO_CHAR(p_start_date, 'MMYYYY'), 'DDMMYYYY');

        WHILE (tmp_date <= p_end_date)
        LOOP            
            load_sale_sa_layers(tmp_date);  

            tmp_date := add_months(tmp_date, 1);
        END LOOP;        
    END;
    
    -- load sales with merge
	PROCEDURE ld_ce_sales_from_retail
	IS 
	BEGIN
        insert_msg_log( ñ_source_retail, c_sa_transaction_retail, 'ld_ce_sales_from_retail', 'start execution'); 
        
        MERGE INTO nf_ce_sales target              
        USING ( SELECT  trim('"' from satr.sale_id) sale_id,
                        trim('"' from satr.invoice) invoice,
                        NVL(ces.store_id, -1) store_id,
                        NVL(TO_NUMBER(satr.quantity), 0) quantity,
                        NVL(cec.customer_id, -1) customer_id,
                        to_date(substr(satr.invoice_date, 1, 10), 'YYYY-MM-DD') invoice_date,
                        TO_NUMBER(satr.sale_amount, '9999999999.9999999999999999') sale_amount,
                        NVL(ceadr.address_id, -1) address_id,
                        NVL(cee.employee_id, -1) employee_id,
                        NVL(ctp.type_payment_id, -1) type_payment_id,
                        NVL(ceb.book_id, -1) book_id
                    FROM sar_transaction_retail satr
                    LEFT JOIN nf_ce_stores ces ON trim('"' from satr.store_id) = ces.store_src_id
                    LEFT JOIN nf_ce_addresses ceadr ON satr.address_id = ceadr.address_src_id
                    LEFT JOIN nf_ce_employees cee ON trim('"' from satr.employee_id) = cee.employee_src_id
                    LEFT JOIN nf_ce_type_payments ctp ON satr.type_payment_id = ctp.type_payment_src_id
                    LEFT JOIN nf_ce_books ceb ON satr.book_id = ceb.book_src_id 
                          AND ceb.start_dt <= to_date(substr(satr.invoice_date, 1, 10), 'YYYY-MM-DD')
                          AND ceb.end_dt   >  to_date(substr(satr.invoice_date, 1, 10), 'YYYY-MM-DD')
                    LEFT JOIN nf_ce_customers cec ON satr.customer_id = cec.customer_src_id 
                         AND cec.SOURCE_SYSTEM = ñ_source_retail ) source       
            ON (target.sales_src_id = source.sale_id AND
				target.SOURCE_SYSTEM = ñ_source_retail AND
				target.SOURCE_ENTITY = c_sa_transaction_retail)          
            
        WHEN MATCHED THEN
            UPDATE SET target.num_invoice = source.invoice,
                       target.store_surr_id = source.store_id,                       
                       target.quantity = source.quantity,
                       target.customer_surr_id = source.customer_id,
                       target.date_sale = source.invoice_date,
                       target.sale_amount = source.sale_amount,
                       target.address_surr_id = source.address_id,
                       target.employee_surr_id = source.employee_id,
                       target.type_payment_surr_id = source.type_payment_id,
                       target.book_surr_id = source.book_id,
                       target.UPDATE_DT = sysdate
                       
            WHERE (DECODE(target.num_invoice, source.invoice, 0, 1) +
                   DECODE(target.store_surr_id, source.store_id, 0, 1) +
                   DECODE(target.quantity, source.quantity, 0, 1) +
                   DECODE(target.customer_surr_id, source.customer_id, 0, 1) + 
                   DECODE(target.date_sale, source.invoice_date, 0, 1) +
                   DECODE(target.sale_amount, source.sale_amount, 0, 1) +
                   DECODE(target.address_surr_id, source.address_id, 0, 1) +
                   DECODE(target.employee_surr_id, source.employee_id, 0, 1) +
                   DECODE(target.type_payment_surr_id, source.type_payment_id, 0, 1) +
                   DECODE(target.book_surr_id, source.book_id, 0, 1)) > 0
            
        WHEN NOT MATCHED THEN 
            INSERT (target.sales_src_id, target.SOURCE_SYSTEM, target.SOURCE_ENTITY,  target.book_surr_id,
                    target.date_sale, target.customer_surr_id, target.employee_surr_id, target.store_surr_id, 
                    target.address_surr_id, target.type_payment_surr_id, target.quantity,                     
                    target.sale_amount, target.num_invoice, target.update_dt, target.insert_dt) 
            
            VALUES (source.sale_id, ñ_source_retail, c_sa_transaction_retail, source.book_id,
                    source.invoice_date, source.customer_id,  source.employee_id, source.store_id,
                    source.address_id, source.type_payment_id, source.quantity, 
                    source.sale_amount, source.invoice, sysdate, sysdate);

        insert_msg_log( ñ_source_retail, c_sa_transaction_retail, 'ld_ce_sales_from_retail', 'processed ' || SQL%ROWCOUNT || ' rows'); 
    
        COMMIT;

	EXCEPTION
		WHEN OTHERS THEN 
           insert_msg_log( ñ_source_retail, c_sa_transaction_retail, 'ld_ce_sales_from_retail', 
                            'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK;
	END ld_ce_sales_from_retail;

    -- load data with merge
	PROCEDURE ld_ce_sales_from_stock
	IS 
	BEGIN
        insert_msg_log( ñ_source_stock, c_sa_transaction_stock, 'ld_ce_sales_from_stock', 'start execution'); 

        MERGE INTO nf_ce_sales target              
        USING ( SELECT  trim('"' from sats.sale_id) sale_id,
                        trim('"' from sats.invoice) invoice,
                        NVL(ces.store_id, -1) store_id,
                        NVL(TO_NUMBER(sats.quantity), 0) quantity,
                        NVL(cec.customer_id, -1) customer_id,
                        to_date(substr(sats.invoice_date, 1, 10), 'YYYY-MM-DD') invoice_date,
                        TO_NUMBER(sats.sale_amount, '9999999999.9999999999999999') sale_amount,
                        NVL(ceadr.address_id, -1) address_id,
                        NVL(cee.employee_id, -1) employee_id,
                        NVL(ctp.type_payment_id, -1) type_payment_id,
                        NVL(ceb.book_id, -1) book_id
                    FROM sas_transaction_stock sats
                    LEFT JOIN nf_ce_stores ces ON trim('"' from sats.store_id) = ces.store_src_id
                    LEFT JOIN nf_ce_addresses ceadr ON sats.address_id = ceadr.address_src_id
                    LEFT JOIN nf_ce_employees cee ON trim('"' from sats.employee_id) = cee.employee_src_id
                    LEFT JOIN nf_ce_type_payments ctp ON sats.type_payment_id = ctp.type_payment_src_id
                    LEFT JOIN nf_ce_books ceb ON sats.book_id = ceb.book_src_id 
                          AND ceb.start_dt <= to_date(substr(sats.invoice_date, 1, 10), 'YYYY-MM-DD')
                          AND ceb.end_dt   >= to_date(substr(sats.invoice_date, 1, 10), 'YYYY-MM-DD')         
                    LEFT JOIN nf_ce_customers cec ON sats.customer_id = cec.customer_src_id 
                         AND cec.SOURCE_SYSTEM = ñ_source_stock ) source       
            ON (target.sales_src_id = source.sale_id AND
				target.SOURCE_SYSTEM = ñ_source_stock AND
				target.SOURCE_ENTITY = c_sa_transaction_stock)        
            
        WHEN MATCHED THEN
            UPDATE SET target.num_invoice = source.invoice,
                       target.store_surr_id = source.store_id,                       
                       target.quantity = source.quantity,
                       target.customer_surr_id = source.customer_id,
                       target.date_sale = source.invoice_date,
                       target.sale_amount = source.sale_amount,
                       target.address_surr_id = source.address_id,
                       target.employee_surr_id = source.employee_id,
                       target.type_payment_surr_id = source.type_payment_id,
                       target.book_surr_id = source.book_id,
                       target.UPDATE_DT = sysdate
                       
            WHERE (DECODE(target.num_invoice, source.invoice, 0, 1) +
                  DECODE(target.store_surr_id, source.store_id, 0, 1) +
                   DECODE(target.quantity, source.quantity, 0, 1) +
                   DECODE(target.customer_surr_id, source.customer_id, 0, 1) + 
                   DECODE(target.date_sale, source.invoice_date, 0, 1) +
                   DECODE(target.sale_amount, source.sale_amount, 0, 1) +
                   DECODE(target.address_surr_id, source.address_id, 0, 1) +
                   DECODE(target.employee_surr_id, source.employee_id, 0, 1) +
                   DECODE(target.type_payment_surr_id, source.type_payment_id, 0, 1) +
                   DECODE(target.book_surr_id, source.book_id, 0, 1)) > 0
            
        WHEN NOT MATCHED THEN 
            INSERT (target.sales_src_id, target.SOURCE_SYSTEM, target.SOURCE_ENTITY,  target.book_surr_id,
                    target.date_sale, target.employee_surr_id, target.store_surr_id, target.customer_surr_id,
                    target.address_surr_id, target.type_payment_surr_id, target.quantity,
                    target.num_invoice, target.update_dt, target.insert_dt, target.sale_amount )
                    
            VALUES (source.sale_id, ñ_source_stock, c_sa_transaction_stock, source.book_id, 
                    source.invoice_date, source.employee_id, source.store_id, source.customer_id,
                    source.address_id, source.type_payment_id, source.quantity,
                    source.invoice, sysdate , sysdate, source.sale_amount);

        insert_msg_log( ñ_source_stock, c_sa_transaction_stock, 'ld_ce_sales_from_stock', 'processed ' || SQL%ROWCOUNT || ' rows');   
        COMMIT;
       
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_stock, c_sa_transaction_stock, 'ld_ce_sales_from_stock', 
                            'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK;
	END ld_ce_sales_from_stock;
--------------------------------------------------------------------------------
    -- Load sales, use views for incremental load
    PROCEDURE ld_incr_sale_from_sa_layers
    IS
    BEGIN
        insert_msg_log('BL_CL', 'SA_LAYER', 'ld_incr_sale_from_sa_layers', 'start execution'); 
         
        INSERT INTO nf_ce_sales (sales_src_id, SOURCE_SYSTEM, SOURCE_ENTITY, book_surr_id,
                                 date_sale, customer_surr_id, employee_surr_id, store_surr_id, 
                                 address_surr_id, type_payment_surr_id, quantity,                     
                                 sale_amount, num_invoice, update_dt, insert_dt) 
        
        SELECT vs.sale_id, vs.SOURCE_SYSTEM, vs.SOURCE_ENTITY, vs.book_id, 
               vs.invoice_date, vs.customer_id, vs.employee_id, vs.store_id,
               vs.address_id, vs.type_payment_id, vs.quantity, vs.sale_amount,
               vs.invoice, sysdate, sysdate
        FROM v_incr_sales vs;
      
        insert_msg_log( 'BL_CL', 'SA_LAYER', 'ld_incr_sale_from_sa_layers', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        
        UPDATE prm_mta_incremental_load
        SET previous_loaded_date = SYSDATE
        WHERE sa_table_name = 'SA_TRANSACTION';        
    
        COMMIT;
        
	EXCEPTION
		WHEN OTHERS THEN 
           insert_msg_log( 'BL_CL', 'SA_LAYER', 'ld_incr_sale_from_sa_layers', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
		   ROLLBACK; 
  
    END ld_incr_sale_from_sa_layers;
    
END PKG_3NF_SALES;

