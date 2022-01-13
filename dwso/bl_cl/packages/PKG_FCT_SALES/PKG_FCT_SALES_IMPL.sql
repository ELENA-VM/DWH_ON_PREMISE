CREATE OR REPLACE PACKAGE BODY PKG_FCT_SALES AS 
/*
    Package for load table fct_sales, layer BL_DM 
*/  
    ñ_source_system CONSTANT VARCHAR(6) := 'BL_3NF';
    c_ce_sales CONSTANT VARCHAR(8) := 'CE_SALES';

    PROCEDURE load_sale_bl_3nf_layer(p_date_period in date)
    IS
    BEGIN
         insert_msg_log(ñ_source_system, c_ce_sales, 'load_sale', 'start execution'); 
         
         EXECUTE IMMEDIATE 'TRUNCATE TABLE wrk_ex_dm_fct_sales';
         
         INSERT INTO wrk_ex_dm_fct_sales (sales_id, source_system, source_entity,                    
                    book_surr_id, date_id, customer_surr_id, employee_surr_id, 
                    store_surr_id, address_surr_id, type_payment_surr_id, 
                    quantity, sale_amount, num_invoice, update_dt, insert_dt  ) 
         SELECT ces.sales_src_id,
                ñ_source_system,
                c_ce_sales,
                dm_book.book_surr_id,
                dm_dt.DATE_ID,
                dm_cust.customer_surr_id,
                dm_em.employee_surr_id,    
                dm_st.store_surr_id,    
                dm_ad.address_surr_id,    
                dm_tp.type_payment_surr_id,
                ces.quantity,
                ces.sale_amount,
                ces.num_invoice,
                sysdate,
                sysdate
         FROM nf_ce_sales ces
                JOIN dm_dim_books_scd dm_book ON ces.book_surr_id = dm_book.book_id
                JOIN dm_dim_dates dm_dt ON ces.date_sale = dm_dt.DATE_ID
                JOIN dm_dim_customers dm_cust ON ces.customer_surr_id = dm_cust.customer_id
                JOIN dm_dim_employees dm_em ON ces.employee_surr_id = dm_em.employee_id
                JOIN dm_dim_stores dm_st ON ces.store_surr_id = dm_st.store_id
                JOIN dm_dim_addresses dm_ad ON ces.address_surr_id = dm_ad.address_id
                JOIN dm_dim_type_payments dm_tp ON ces.type_payment_surr_id = dm_tp.type_payment_id
         WHERE ces.date_sale >= p_date_period
           AND ces.date_sale < add_months(p_date_period, 1);
               
        insert_msg_log( ñ_source_system, c_ce_sales, 'load_sale', 'processed ' || SQL%ROWCOUNT || ' rows'); 
    
        COMMIT;
    
        EXECUTE IMMEDIATE 'ALTER TABLE BL_DM.fct_sales 
                           EXCHANGE PARTITION P_'|| TO_CHAR(p_date_period, 'YYYYMM') ||
                          ' WITH TABLE wrk_ex_dm_fct_sales';
   
	EXCEPTION
		WHEN OTHERS THEN 
           insert_msg_log( ñ_source_system, 'ce_sales', 'load_sale', 'exception '||TO_CHAR(p_date_period, 'YYYYMM'), 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK; 
  
    END load_sale_bl_3nf_layer;


    PROCEDURE ld_ce_sales_by_part(p_start_date in date default sysdate,
                                  p_end_date in date default sysdate) 
    IS
        tmp_date date := sysdate;  
    BEGIN
        tmp_date := TO_DATE('01' || TO_CHAR(p_start_date, 'MMYYYY'), 'DDMMYYYY');

        WHILE (tmp_date <= p_end_date)
        LOOP            
            load_sale_bl_3nf_layer(tmp_date);  

            tmp_date := add_months(tmp_date, 1);
        END LOOP;        
    END;
    
	PROCEDURE ld_fct_sales
	IS 
	BEGIN
        insert_msg_log( ñ_source_system, c_ce_sales, 'ld_fct_sales', 'start execution'); 
    
        MERGE INTO dm_fct_sales target              
        USING (
                SELECT ces.sales_src_id,
                       dm_book.book_surr_id,
                       dm_dt.DATE_ID,
                       dm_cust.customer_surr_id,
                       dm_em.employee_surr_id,    
                       dm_st.store_surr_id,    
                       dm_ad.address_surr_id,    
                       dm_tp.type_payment_surr_id,
                       ces.quantity,
                       ces.sale_amount,
                       ces.num_invoice
                FROM nf_ce_sales ces
                JOIN dm_dim_books_scd dm_book ON ces.book_surr_id = dm_book.book_id
                JOIN dm_dim_dates dm_dt ON ces.date_sale = dm_dt.DATE_ID
                JOIN dm_dim_customers dm_cust ON ces.customer_surr_id = dm_cust.customer_id
                JOIN dm_dim_employees dm_em ON ces.employee_surr_id = dm_em.employee_id
                JOIN dm_dim_stores dm_st ON ces.store_surr_id = dm_st.store_id
                JOIN dm_dim_addresses dm_ad ON ces.address_surr_id = dm_ad.address_id
                JOIN dm_dim_type_payments dm_tp ON ces.type_payment_surr_id = dm_tp.type_payment_id
            ) source       
            ON (target.sales_id = source.sales_src_id AND
				target.source_system = ñ_source_system AND
				target.source_entity = c_ce_sales) 
            
        WHEN MATCHED THEN
            UPDATE SET target.book_surr_id = source.book_surr_id, 
                       target.date_id = source.date_id, 
                       target.customer_surr_id = source.customer_surr_id, 
                       target.employee_surr_id = source.employee_surr_id,                        
                       target.store_surr_id = source.store_surr_id, 
                       target.address_surr_id = source.address_surr_id, 
                       target.type_payment_surr_id = source.type_payment_surr_id, 
                       target.quantity = source.quantity,                          
                       target.sale_amount = source.sale_amount, 
                       target.num_invoice = source.num_invoice,
                       target.UPDATE_DT  = sysdate
                       
            WHERE (DECODE(target.book_surr_id, source.book_surr_id, 0, 1) +
                   DECODE(target.date_id, source.date_id, 0, 1) + 
                   DECODE(target.customer_surr_id, source.customer_surr_id, 0, 1) +   
                   DECODE(target.employee_surr_id, source.employee_surr_id, 0, 1) +
                   DECODE(target.store_surr_id, source.store_surr_id, 0, 1) +
                   DECODE(target.address_surr_id, source.address_surr_id, 0, 1) + 
                   DECODE(target.type_payment_surr_id, source.type_payment_surr_id, 0, 1) +
                   DECODE(target.quantity, source.quantity, 0, 1) + 
                   DECODE(target.sale_amount, source.sale_amount, 0, 1) +
                   DECODE(target.num_invoice, source.num_invoice, 0, 1) ) > 1
 
        WHEN NOT MATCHED THEN 
            INSERT (target.sales_id, target.source_system, target.source_entity,                    
                    target.book_surr_id, target.date_id, target.customer_surr_id, target.employee_surr_id, 
                    target.store_surr_id, target.address_surr_id, target.type_payment_surr_id, 
                    target.quantity, target.sale_amount, target.num_invoice, target.update_dt, target.insert_dt)

            VALUES (source.sales_src_id, ñ_source_system, c_ce_sales,
                    source.book_surr_id , source.date_id, source.customer_surr_id, source.employee_surr_id,
                    source.store_surr_id, source.address_surr_id, source.type_payment_surr_id,
                    source.quantity, source.sale_amount, source.num_invoice, sysdate, sysdate); 
       
        insert_msg_log( ñ_source_system, c_ce_sales, 'ld_fct_sales', 'processed ' || SQL%ROWCOUNT || ' rows'); 

        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_system, c_ce_sales, 'ld_fct_sales', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
	END ld_fct_sales;
    
END PKG_FCT_SALES;

