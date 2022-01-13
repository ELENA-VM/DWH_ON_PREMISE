CREATE OR REPLACE PACKAGE BODY PKG_DIM_CUSTOMERS AS 
/*
    Package for load table dim_customers, layer BL_DM 
*/
    ñ_source_system CONSTANT VARCHAR(6) := 'BL_3NF';
    c_ce_customers CONSTANT VARCHAR(12) := 'CE_CUSTOMERS';

	PROCEDURE ld_dim_customers
	IS 
	BEGIN
        insert_msg_log( ñ_source_system, c_ce_customers, 'ld_dim_customers', 'start execution'); 
        
        MERGE INTO dm_dim_customers target              
        USING (
                SELECT  cecust.customer_id,
                        cecust.type_customer,
                        cecust.first_name,
                        cecust.last_name,
                        cecust.gender,
                        cecust.date_of_birth,
                        cecust.name_of_organization,
                        cecust.head_of_organization,
                        cecust.iban,
                        cecust.email,
                        ceadr.address_id,
                        ceadr.address,
                        ceadr.postal_code,
                        cect.city_id,
                        cect.city,
                        ceco.country_id,
                        ceco.country,
                        cer.region_id,
                        cer.region
                FROM nf_ce_customers cecust
                INNER JOIN nf_ce_addresses ceadr ON cecust.address_surr_id = ceadr.address_id
                INNER JOIN nf_ce_cities cect ON ceadr.city_surr_id = cect.city_id
                INNER JOIN nf_ce_countries ceco ON cect.country_surr_id = ceco.country_id
                INNER JOIN nf_ce_regions cer ON ceco.region_surr_id = cer.region_id 
              ) source       
            ON (target.customer_id = source.customer_id AND 
				target.source_system = ñ_source_system AND
				target.source_entity = c_ce_customers ) 
            
        WHEN MATCHED THEN
            UPDATE SET target.type_customer = source.type_customer,
                       target.first_name = source.first_name, 
                       target.last_name = source.last_name, 
                       target.gender = source.gender, 
                       target.date_of_birth = source.date_of_birth,                        
                       target.name_of_organization = source.name_of_organization, 
                       target.head_of_organization = source.head_of_organization, 
                       target.iban = source.iban, 
                       target.email = source.email, 
                       target.address_id = source.address_id, 
                       target.address = source.address, 
                       target.postal_code = source.postal_code, 
                       target.city_id = source.city_id, 
                       target.city = source.city,                        
                       target.country_id = source.country_id, 
                       target.country = source.country, 
                       target.region_id = source.region_id, 
                       target.region = source.region,                          
                       target.UPDATE_DT  = sysdate
                       
            WHERE (DECODE(target.type_customer, source.type_customer, 0, 1) +
                   DECODE(target.first_name, source.first_name, 0, 1) + 
                   DECODE(target.last_name, source.last_name, 0, 1) +                   
                   DECODE(target.gender, source.gender, 0, 1) +
                   DECODE(target.date_of_birth, source.date_of_birth, 0, 1) + 
                   DECODE(target.name_of_organization, source.name_of_organization, 0, 1) +
                   DECODE(target.head_of_organization, source.head_of_organization, 0, 1) +
                   DECODE(target.iban, source.iban, 0, 1) + 
                   DECODE(target.email, source.email, 0, 1) +                   
                   DECODE(target.address_id, source.address_id, 0, 1) +
                   DECODE(target.address, source.address, 0, 1) +
                   DECODE(target.postal_code, source.postal_code, 0, 1) + 
                   DECODE(target.city_id, source.city_id, 0, 1) +   
                   DECODE(target.city, source.city, 0, 1) +
                   DECODE(target.country_id, source.country_id, 0, 1) +
                   DECODE(target.country, source.country, 0, 1) + 
                   DECODE(target.city_id, source.city_id, 0, 1) +
                   DECODE(target.region_id, source.region_id, 0, 1) + 
                   DECODE(target.region, source.region, 0, 1) ) > 1
            
        WHEN NOT MATCHED THEN 
            INSERT (target.customer_surr_id , target.customer_id, target.source_system , target.source_entity,
                    target.type_customer, target.first_name, target.last_name, target.gender, target.date_of_birth,
                    target.name_of_organization, target.email, target.head_of_organization, target.iban,
                    target.address, target.postal_code, target.city_id, target.city, target.country_id,
                    target.country, target.region_id, target.region, target.address_id, target.update_dt, target.insert_dt)


            VALUES (dm_dim_customers_seq.NEXTVAL, source.customer_id, ñ_source_system, c_ce_customers,
                    source.type_customer, source.first_name, source.last_name, source.gender, source.date_of_birth,
                    source.name_of_organization , source.email, source.head_of_organization, source.iban,
                    source.address , source.postal_code, source.city_id, source.city , source.country_id,
                    source.country, source.region_id, source.region, source.address_id, sysdate, sysdate); 

        insert_msg_log( ñ_source_system, c_ce_customers, 'ld_dim_customers', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        COMMIT;
        
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_system, c_ce_customers, 'ld_dim_customers', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
	END;

END PKG_DIM_CUSTOMERS;

