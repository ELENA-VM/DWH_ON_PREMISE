CREATE OR REPLACE PACKAGE BODY PKG_DIM_STORES AS 
    ñ_source_system CONSTANT VARCHAR(6) := 'BL_3NF';
    c_ce_stores CONSTANT VARCHAR(9) := 'CE_STORES';
/*
    Package for load table dim_stores, layer BL_DM 
*/    

	PROCEDURE ld_dim_stores
	IS 
	BEGIN
        insert_msg_log( ñ_source_system, c_ce_stores, 'ld_dim_stores', 'start execution'); 
    
        MERGE INTO dm_dim_stores target              
        USING (
                SELECT
                    ces.store_id,
                    ces.store_name,
                    cets.type_store_id,
                    cets.type_store
                FROM nf_ce_stores ces
                INNER JOIN nf_ce_type_stores cets ON ces.store_type_surr_id = cets.type_store_id
              ) source       
            ON (target.store_id = source.store_id AND
				target.source_system = ñ_source_system AND
				target.source_entity = c_ce_stores) 
            
        WHEN MATCHED THEN
            UPDATE SET target.store_name = source.store_name,
                       target.store_type_id = source.type_store_id, 
                       target.store_type = source.type_store, 
                       target.UPDATE_DT  = sysdate
                       
            WHERE (DECODE(target.store_name, source.store_name, 0, 1) +
                   DECODE(target.store_type_id, source.type_store_id, 0, 1) + 
                   DECODE(target.store_type, source.type_store, 0, 1)) > 1
            
        WHEN NOT MATCHED THEN 
            INSERT (target.store_surr_id, target.store_id, target.source_system, target.source_entity, 
                    target.store_name, target.store_type_id, target.store_type, target.update_dt, target.insert_dt) 
            VALUES (dm_dim_stores_seq.NEXTVAL, source.store_id, ñ_source_system, c_ce_stores,
                    source.store_name, source.type_store_id, source.type_store, sysdate, sysdate); 
                    
        insert_msg_log( ñ_source_system, c_ce_stores, 'ld_dim_stores', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        COMMIT;

	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_system, c_ce_stores, 'ld_dim_stores', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
	END ld_dim_stores;
END PKG_DIM_STORES;

