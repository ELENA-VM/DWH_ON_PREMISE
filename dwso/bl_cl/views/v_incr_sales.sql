CREATE OR REPLACE VIEW v_incr_sales
AS
( 
    SELECT
            trim('"' from satr.sale_id) sale_id,
            'RETAIL' SOURCE_SYSTEM,
            'SA_TRANSACTION_RETAIL' SOURCE_ENTITY,
            NVL(ceb.book_id, -1) book_id,
            to_date(substr(satr.invoice_date, 1, 10), 'YYYY-MM-DD') invoice_date,
            NVL(cec.customer_id, -1) customer_id,
            NVL(cee.employee_id, -1) employee_id,
            NVL(ces.store_id, -1) store_id,
            NVL(ceadr.address_id, -1) address_id,
            NVL(ctp.type_payment_id, -1) type_payment_id,
            NVL(TO_NUMBER(satr.quantity), 0) quantity,
            TO_NUMBER(satr.sale_amount, '9999999999.9999999999999999') sale_amount,
            trim('"' from satr.invoice) invoice
    FROM sar_transaction_retail satr
    LEFT JOIN nf_ce_stores ces ON trim('"' from satr.store_id) = ces.store_src_id
    LEFT JOIN nf_ce_addresses ceadr ON satr.address_id = ceadr.address_src_id
    LEFT JOIN nf_ce_employees cee ON trim('"' from satr.employee_id) = cee.employee_src_id
    LEFT JOIN nf_ce_type_payments ctp ON satr.type_payment_id = ctp.type_payment_src_id
    LEFT JOIN nf_ce_books ceb ON satr.book_id = ceb.book_src_id 
          AND ceb.start_dt <= to_date(substr(satr.invoice_date, 1, 10), 'YYYY-MM-DD')
          AND ceb.end_dt   >= to_date(substr(satr.invoice_date, 1, 10), 'YYYY-MM-DD')
    LEFT JOIN nf_ce_customers cec ON satr.customer_id = cec.customer_src_id 
          AND cec.SOURCE_SYSTEM = 'RETAIL'         
    WHERE satr.insert_dt > 
        ( SELECT previous_loaded_date
          FROM prm_mta_incremental_load 
          WHERE sa_table_name = 'SA_TRANSACTION' )
       OR satr.update_dt > 
        ( SELECT previous_loaded_date 
          FROM prm_mta_incremental_load 
          WHERE sa_table_name = 'SA_TRANSACTION' )

    UNION ALL
    
    SELECT  trim('"' from sats.sale_id) sale_id,
            'STOCK' SOURCE_SYSTEM,
            'SA_TRANSACTION_STOCK' SOURCE_ENTITY,
            NVL(ceb.book_id, -1) book_id,
            to_date(substr(sats.invoice_date, 1, 10), 'YYYY-MM-DD') invoice_date,
            NVL(cec.customer_id, -1) customer_id,
            NVL(cee.employee_id, -1) employee_id,
            NVL(ces.store_id, -1) store_id,
            NVL(ceadr.address_id, -1) address_id,
            NVL(ctp.type_payment_id, -1) type_payment_id,
            NVL(TO_NUMBER(sats.quantity), 0) quantity,  
            TO_NUMBER(sats.sale_amount, '9999999999.9999999999999999') sale_amount,  
            trim('"' from sats.invoice) invoice
    FROM sas_transaction_stock sats
    LEFT JOIN nf_ce_stores ces ON trim('"' from sats.store_id) = ces.store_src_id
    LEFT JOIN nf_ce_addresses ceadr ON sats.address_id = ceadr.address_src_id
    LEFT JOIN nf_ce_employees cee ON trim('"' from sats.employee_id) = cee.employee_src_id
    LEFT JOIN nf_ce_type_payments ctp ON sats.type_payment_id = ctp.type_payment_src_id
    LEFT JOIN nf_ce_books ceb ON sats.book_id = ceb.book_src_id 
          AND ceb.start_dt <= to_date(substr(sats.invoice_date, 1, 10), 'YYYY-MM-DD')
          AND ceb.end_dt   >= to_date(substr(sats.invoice_date, 1, 10), 'YYYY-MM-DD')         
    LEFT JOIN nf_ce_customers cec ON sats.customer_id = cec.customer_src_id 
          AND cec.SOURCE_SYSTEM = 'STOCK'
          
    WHERE sats.insert_dt > 
        ( SELECT previous_loaded_date
          FROM prm_mta_incremental_load 
          WHERE sa_table_name = 'SA_TRANSACTION' )
       OR sats.update_dt > 
        ( SELECT previous_loaded_date 
          FROM prm_mta_incremental_load 
          WHERE sa_table_name = 'SA_TRANSACTION' )
);         
               
                