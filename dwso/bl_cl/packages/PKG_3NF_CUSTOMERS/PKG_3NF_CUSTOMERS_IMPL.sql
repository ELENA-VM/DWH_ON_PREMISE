CREATE OR REPLACE PACKAGE BODY PKG_3NF_CUSTOMERS AS 
/*
    Package for load table ce_customers from some source system
    to layer BL_3NF. 
*/

    ñ_source_retail CONSTANT VARCHAR(6) := 'RETAIL';
    c_sa_customer_retail CONSTANT VARCHAR(19) := 'SA_CUSTOMERS_RETAIL';

    ñ_source_stock CONSTANT VARCHAR(6) := 'STOCK';
    c_sa_customer_stockl CONSTANT VARCHAR(18) := 'SA_CUSTOMERS_STOCK';

	PROCEDURE ld_ce_customers_from_retail
	IS 
	BEGIN
        insert_msg_log( ñ_source_retail, c_sa_customer_retail, 'ld_ce_customers_from_retail', 'start execution');     
    
        MERGE INTO nf_ce_customers target              
        USING ( SELECT sacr.CUSTOMER_ID,
                       sacr.FIRST_NAME,
                       sacr.LAST_NAME,
                       sacr.GENDER,
                       TO_DATE(DATE_OF_BIRTH, 'MM/DD/YYYY') DATE_OF_BIRTH,
                       NVL(ceadd.ADDRESS_ID, -1) ADDRESS_ID
                FROM sar_customers_retail sacr
                LEFT JOIN nf_ce_addresses ceadd on sacr.ADDRESS_ID = ceadd.ADDRESS_ID ) source       
            ON (target.CUSTOMER_SRC_ID = source.CUSTOMER_ID AND
				target.SOURCE_SYSTEM = ñ_source_retail AND
				target.SOURCE_ENTITY = c_sa_customer_retail) 
            
        WHEN MATCHED THEN
            UPDATE SET target.FIRST_NAME = source.FIRST_NAME,
                       target.LAST_NAME = source.LAST_NAME,                       
                       target.GENDER = source.GENDER,
                       target.DATE_OF_BIRTH = source.DATE_OF_BIRTH,
                       target.address_surr_id = source.ADDRESS_ID,
                       target.UPDATE_DT = sysdate
                       
            WHERE (DECODE(target.FIRST_NAME, source.FIRST_NAME, 0, 1) +
                   DECODE(target.LAST_NAME, source.LAST_NAME, 0, 1) +
                   DECODE(target.GENDER, source.GENDER, 0, 1) +
                   DECODE(target.DATE_OF_BIRTH, source.DATE_OF_BIRTH, 0, 1) + 
                   DECODE(target.address_surr_id, source.ADDRESS_ID, 0, 1)) > 0
            
        WHEN NOT MATCHED THEN 
            INSERT (target.customer_id, target.customer_src_id, target.SOURCE_SYSTEM, target.SOURCE_ENTITY,  target.type_customer,
                    target.first_name, target.last_name, target.gender, target.date_of_birth, 
                    target.name_of_organization, target.head_of_organization, target.iban, target.email, target.address_surr_id,
                    target.update_dt, target.insert_dt) 
            
            VALUES (nf_ce_customers_seq.NEXTVAL, source.customer_id, ñ_source_retail, c_sa_customer_retail, 0,
                    source.first_name, source.last_name,  source.gender, source.date_of_birth,
                    'NA', 'NA', 'NA', 'NA', source.ADDRESS_ID, sysdate, sysdate);

        insert_msg_log( ñ_source_retail, c_sa_customer_retail, 'ld_ce_customers_from_retail', 
                        'processed ' || SQL%ROWCOUNT || ' rows');         

        COMMIT;
        
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, c_sa_customer_retail, 'ld_ce_customers_from_retail', 
                            'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK;
	END ld_ce_customers_from_retail;

	PROCEDURE ld_ce_customers_from_stock
	IS 
	BEGIN
        insert_msg_log( ñ_source_stock, c_sa_customer_stockl, 'ld_ce_customers_from_stock', 'start execution');     

        MERGE INTO nf_ce_customers target              
        USING ( SELECT trim('"' from sacs.CUSTOMER_ID) CUSTOMER_ID,
                       trim('"' from sacs.NAME_OF_ORGANIZATION) NAME_OF_ORGANIZATION,
                       trim('"' from sacs.HEAD_OF_ORGANIZATION) HEAD_OF_ORGANIZATION,
                       sacs.EMAIL,
                       sacs.IBAN,
                       NVL(ceadd.ADDRESS_ID, -1) ADDRESS_ID
                FROM sas_customers_stock sacs
                LEFT JOIN nf_ce_addresses ceadd on DECODE(ltrim(sacs.ADDRESS_ID,'1234567890'), null, sacs.ADDRESS_ID, -1) = ceadd.ADDRESS_ID 
              ) source       
            ON (target.CUSTOMER_SRC_ID = source.CUSTOMER_ID	AND
				target.SOURCE_SYSTEM = ñ_source_stock AND
				target.SOURCE_ENTITY = c_sa_customer_stockl) 
            
        WHEN MATCHED THEN
            UPDATE SET target.NAME_OF_ORGANIZATION = source.NAME_OF_ORGANIZATION,
                       target.HEAD_OF_ORGANIZATION = source.HEAD_OF_ORGANIZATION,                       
                       target.EMAIL = source.EMAIL,
                       target.IBAN = source.IBAN,
                       target.address_surr_id = source.ADDRESS_ID,
                       target.UPDATE_DT = sysdate
                       
            WHERE (DECODE(target.NAME_OF_ORGANIZATION, source.NAME_OF_ORGANIZATION, 0, 1) +
                   DECODE(target.HEAD_OF_ORGANIZATION, source.HEAD_OF_ORGANIZATION, 0, 1) +
                   DECODE(target.EMAIL, source.EMAIL, 0, 1) +
                   DECODE(target.IBAN, source.IBAN, 0, 1) + 
                   DECODE(target.address_surr_id, source.ADDRESS_ID, 0, 1)) > 0
            
        WHEN NOT MATCHED THEN 
            INSERT (target.customer_id, target.customer_src_id, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, target.type_customer,
                    target.first_name, target.last_name, target.gender, target.date_of_birth, 
                    target.name_of_organization, target.head_of_organization, target.iban, target.email, target.address_surr_id,
                    target.update_dt, target.insert_dt) 
            
            VALUES (nf_ce_customers_seq.NEXTVAL, source.customer_id, ñ_source_stock, c_sa_customer_stockl, 1,
                    'NA', 'NA', 'NA', TO_DATE('01011970', 'MMDDYYYY'),
                    source.name_of_organization, source.head_of_organization, source.iban, source.email,
                     source.ADDRESS_ID, sysdate, sysdate);

        insert_msg_log( ñ_source_stock, c_sa_customer_stockl, 'ld_ce_customers_from_stock', 
                        'processed ' || SQL%ROWCOUNT || ' rows');   

        COMMIT; 
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_stock, c_sa_customer_stockl, 'ld_ce_customers_from_stock', 
                            'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK;
	END ld_ce_customers_from_stock;

END PKG_3NF_CUSTOMERS;

