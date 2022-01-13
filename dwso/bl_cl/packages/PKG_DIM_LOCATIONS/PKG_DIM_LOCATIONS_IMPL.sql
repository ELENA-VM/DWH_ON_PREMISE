CREATE OR REPLACE PACKAGE BODY PKG_DIM_LOCATIONS AS 
/*
    Package for load table dim_addresses, layer BL_DM 
*/
    ñ_source_system CONSTANT VARCHAR(6) := 'BL_3NF';
    c_ce_addresses CONSTANT VARCHAR(12) := 'CE_ADDRESSES';
    
	PROCEDURE ld_dim_addresses
	IS 
	BEGIN
        insert_msg_log( ñ_source_system, c_ce_addresses, 'ld_dim_addresses', 'start execution'); 
        
        MERGE INTO dm_dim_addresses target              
        USING (
                SELECT  ceadr.address_id,
                        ceadr.address,
                        ceadr.postal_code,
                        cect.city_id,
                        cect.city,
                        ceco.country_id,
                        ceco.country,
                        cer.region_id,
                        cer.region
                FROM nf_ce_addresses ceadr 
                INNER JOIN nf_ce_cities cect ON ceadr.city_surr_id = cect.city_id
                INNER JOIN nf_ce_countries ceco ON cect.country_surr_id = ceco.country_id
                INNER JOIN nf_ce_regions cer ON ceco.region_surr_id = cer.region_id 
              ) source       
            ON (target.address_id = source.address_id AND
				target.source_system = ñ_source_system AND
				target.source_entity = c_ce_addresses) 
            
        WHEN MATCHED THEN
            UPDATE SET target.address = source.address, 
                       target.postal_code = source.postal_code, 
                       target.city_id = source.city_id, 
                       target.city = source.city,                        
                       target.country_id = source.country_id, 
                       target.country = source.country, 
                       target.region_id = source.region_id, 
                       target.region = source.region,                          
                       target.UPDATE_DT  = sysdate
                       
            WHERE (DECODE(target.address, source.address, 0, 1) +
                   DECODE(target.postal_code, source.postal_code, 0, 1) + 
                   DECODE(target.city_id, source.city_id, 0, 1) +   
                   DECODE(target.city, source.city, 0, 1) +
                   DECODE(target.country_id, source.country_id, 0, 1) +
                   DECODE(target.country, source.country, 0, 1) + 
                   DECODE(target.city_id, source.city_id, 0, 1) +
                   DECODE(target.region_id, source.region_id, 0, 1) + 
                   DECODE(target.region, source.region, 0, 1) ) > 1
            
        WHEN NOT MATCHED THEN 
            INSERT (target.address_surr_id , target.address_id, target.source_system, target.source_entity,                    
                    target.address, target.postal_code, target.city_id, target.city, target.country_id,
                    target.country, target.region_id, target.region, target.update_dt, target.insert_dt)

            VALUES (dm_dim_addresses_seq.NEXTVAL, source.address_id, ñ_source_system, c_ce_addresses,
                    source.address , source.postal_code, source.city_id, source.city , source.country_id,
                    source.country, source.region_id, source.region, sysdate, sysdate); 
                    
        insert_msg_log( ñ_source_system, c_ce_addresses, 'ld_dim_addresses', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        
        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_system, c_ce_addresses, 'ld_dim_addresses', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
	END ld_dim_addresses;
    
END PKG_DIM_LOCATIONS;

