CREATE OR REPLACE PACKAGE BODY PKG_3NF_STORES AS 
/*
    Package for load tables to layer BL_3NF: ce_stores, ce_type_stores 
*/
    ñ_source_retail CONSTANT VARCHAR(6) := 'RETAIL';
    c_sa_type_stores CONSTANT VARCHAR(14) := 'SA_TYPE_STORES';
    c_sa_stores CONSTANT VARCHAR(9) := 'SA_STORES';
    -- load list of type stores
    PROCEDURE ld_ce_type_stores
    IS 
    number_row NUMERIC;
    BEGIN
        insert_msg_log( ñ_source_retail, c_sa_type_stores, 'ld_ce_type_stores', 'start execution'); 
        
        number_row := 0;

        FOR r_type_stores IN (SELECT TYPE_STORE_ID,
                                      TYPE_STORE
                               FROM SAR_TYPE_STORES)   
        LOOP
            INSERT INTO nf_ce_type_stores(TYPE_STORE_ID, TYPE_STORE_SRC_ID, TYPE_STORE, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
            SELECT nf_ce_type_stores_seq.NEXTVAL, r_type_stores.TYPE_STORE_ID, upper(r_type_stores.TYPE_STORE), ñ_source_retail, c_sa_type_stores, sysdate, sysdate
            FROM dual           
            WHERE NOT EXISTS ( SELECT ncts.TYPE_STORE_ID
                               FROM nf_ce_type_stores ncts 
                               WHERE ncts.TYPE_STORE_SRC_ID = r_type_stores.TYPE_STORE_ID
                                 AND ncts.SOURCE_SYSTEM = ñ_source_retail 
                                 AND ncts.SOURCE_ENTITY = c_sa_type_stores );
                                 
            number_row := number_row + SQL%ROWCOUNT;       
                                 
            UPDATE nf_ce_type_stores            
            SET TYPE_STORE = r_type_stores.TYPE_STORE,
				UPDATE_DT = sysdate                
			WHERE TYPE_STORE_SRC_ID = r_type_stores.TYPE_STORE_ID
              AND SOURCE_SYSTEM = ñ_source_retail 
              AND SOURCE_ENTITY = c_sa_type_stores
              AND DECODE(TYPE_STORE, upper(r_type_stores.TYPE_STORE), 0, 1) > 0;	
              
            number_row := number_row + SQL%ROWCOUNT;         
        END LOOP;        
        insert_msg_log( ñ_source_retail, c_sa_type_stores, 'ld_ce_type_stores', 'processed ' || number_row || ' rows');    
        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, c_sa_type_stores, 'ld_ce_type_stores', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
            ROLLBACK;
    END ld_ce_type_stores;
    
    -- load list of stores with use merge
    PROCEDURE ld_ce_stores
    IS 
    BEGIN      
        insert_msg_log( ñ_source_retail, c_sa_stores, 'ld_ce_stores', 'start execution'); 

        MERGE INTO nf_ce_stores target              
        USING (SELECT sast.STORE_ID,
                      sast.STORE_NAME,
                      NVL(cets.type_store_id, -1) type_store_id
               FROM sar_stores sast 
               LEFT JOIN nf_ce_type_stores cets ON sast.STORE_TYPE_ID = cets.TYPE_STORE_SRC_ID
               AND cets.SOURCE_SYSTEM = ñ_source_retail
               AND cets.SOURCE_ENTITY = c_sa_type_stores
               ) source       
            ON (target.STORE_SRC_ID = source.STORE_ID AND
                target.SOURCE_SYSTEM = ñ_source_retail AND
                target.SOURCE_ENTITY = c_sa_stores) 
            
        WHEN MATCHED THEN
            UPDATE SET target.STORE_NAME = source.STORE_NAME,
                       target.STORE_TYPE_SURR_ID = source.type_store_id,
                       target.UPDATE_DT = sysdate
            WHERE (DECODE(target.STORE_NAME, source.STORE_NAME, 0, 1) + 
                   DECODE(target.STORE_TYPE_SURR_ID, source.STORE_ID, 0, 1)) > 0 
            
        WHEN NOT MATCHED THEN 
            INSERT (target.STORE_ID, target.STORE_SRC_ID, target.STORE_NAME, target.STORE_TYPE_SURR_ID, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, target.update_dt, target.insert_dt) 
            VALUES (nf_ce_stores_seq.NEXTVAL, source.STORE_ID, source.STORE_NAME, source.TYPE_STORE_ID, ñ_source_retail, c_sa_stores, sysdate, sysdate); 

        insert_msg_log( ñ_source_retail, c_sa_stores, 'ld_ce_stores', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, c_sa_stores, 'ld_ce_stores', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
            ROLLBACK;
    END ld_ce_stores;  
--------------------------------------------------------------------------------
    -- Load list of stores, use views for incremental load
    PROCEDURE ld_incr_ce_stores
    IS 
    BEGIN      
        insert_msg_log( ñ_source_retail, c_sa_stores, 'ld_ce_stores', 'start execution'); 

        MERGE INTO nf_ce_stores target              
        USING (SELECT *
               FROM v_incr_stores) source       
            ON (target.STORE_SRC_ID = source.STORE_ID AND
                target.SOURCE_SYSTEM = ñ_source_retail AND
                target.SOURCE_ENTITY = c_sa_stores) 
            
        WHEN MATCHED THEN
            UPDATE SET target.STORE_NAME = source.STORE_NAME,
                       target.STORE_TYPE_SURR_ID = source.type_store_id,
                       target.UPDATE_DT = sysdate
            WHERE (DECODE(target.STORE_NAME, source.STORE_NAME, 0, 1) + 
                   DECODE(target.STORE_TYPE_SURR_ID, source.STORE_ID, 0, 1)) > 0 
            
        WHEN NOT MATCHED THEN 
            INSERT (target.STORE_ID, target.STORE_SRC_ID, target.STORE_NAME, target.STORE_TYPE_SURR_ID, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, target.update_dt, target.insert_dt) 
            VALUES (nf_ce_stores_seq.NEXTVAL, source.STORE_ID, source.STORE_NAME, source.TYPE_STORE_ID, ñ_source_retail, c_sa_stores, sysdate, sysdate); 

        insert_msg_log( ñ_source_retail, c_sa_stores, 'ld_ce_stores', 'processed ' || SQL%ROWCOUNT || ' rows');
        
        UPDATE sar_stores
        SET IS_CPROCESSED = 'Y';
        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, c_sa_stores, 'ld_ce_stores', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
            ROLLBACK;
    END ld_incr_ce_stores;  

END PKG_3NF_STORES;

