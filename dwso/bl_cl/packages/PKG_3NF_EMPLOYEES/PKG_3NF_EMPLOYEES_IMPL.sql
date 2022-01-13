CREATE OR REPLACE PACKAGE BODY PKG_3NF_EMPLOYEES AS 
/*
    Package for load tables to layer BL_3NF: ce_posts, ce_employees
*/
    ñ_source_retail CONSTANT VARCHAR(6) := 'RETAIL';
    c_sa_employees CONSTANT VARCHAR(12) := 'SA_EMPLOYEES';
    c_sa_posts CONSTANT VARCHAR(8) := 'SA_POSTS';
    
    -- Load list of posts
    PROCEDURE ld_ce_posts
    IS 
    BEGIN
       insert_msg_log( ñ_source_retail, c_sa_posts, 'ld_ce_posts', 'start execution'); 
    
        MERGE INTO nf_ce_posts target              
        USING (SELECT POST_ID,
                      POST_NAME
               FROM SAR_POSTS ) source       
            ON (target.POST_SRC_ID = source.POST_ID AND
                target.SOURCE_SYSTEM = ñ_source_retail AND
                target.SOURCE_ENTITY = c_sa_posts) 
            
        WHEN MATCHED THEN
            UPDATE SET target.POST_NAME = source.POST_NAME,
                       target.UPDATE_DT  = sysdate
            WHERE target.POST_NAME <> source.POST_NAME
            
        WHEN NOT MATCHED THEN 
            INSERT (target.POST_ID, target.POST_SRC_ID, target.POST_NAME, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, target.update_dt, target.insert_dt) 
            VALUES (nf_ce_post_seq.NEXTVAL, source.POST_ID, source.POST_NAME, ñ_source_retail, c_sa_posts, sysdate, sysdate); 
    
        insert_msg_log( ñ_source_retail, c_sa_posts, 'ld_ce_posts', 'processed ' || SQL%ROWCOUNT || ' rows');         
        COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, c_sa_posts, 'ld_ce_posts', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
        
            ROLLBACK;
    END ld_ce_posts;  

    -- Load list of employees, use only merge
    PROCEDURE ld_ce_employees
    IS 
    BEGIN
        insert_msg_log( ñ_source_retail, c_sa_employees, 'ld_ce_employees', 'start execution'); 

        MERGE INTO nf_ce_employees target              
        USING ( SELECT sae.EMPLOYEE_ID,
                       sae.FIRST_NAME,
                       sae.LAST_NAME,
                       NVL(cep.POST_ID, -1) POST_ID,
                       NVL(ces.STORE_ID, -1) STORE_ID
                FROM sar_employees sae               
                LEFT JOIN nf_ce_posts cep ON sae.POST_ID = cep.post_src_id
                LEFT JOIN nf_ce_stores ces ON sae.STORE_ID = ces.store_src_id ) source       
            ON (target.EMPLOYEE_SRC_ID = source.EMPLOYEE_ID AND
                target.SOURCE_SYSTEM = ñ_source_retail AND
                target.SOURCE_ENTITY = c_sa_employees) 
            
        WHEN MATCHED THEN
            UPDATE SET target.FIRST_NAME = source.FIRST_NAME,
                       target.LAST_NAME = source.LAST_NAME,
                       target.POST_SURR_ID = source.POST_ID,
                       target.STORE_SURR_ID = source.STORE_ID,                       
                       target.UPDATE_DT = sysdate
            WHERE ( DECODE(target.FIRST_NAME, source.FIRST_NAME, 0, 1) +
                    DECODE(target.LAST_NAME, source.LAST_NAME, 0, 1) +
                    DECODE(target.POST_SURR_ID, source.POST_ID, 0, 1) +
                    DECODE(target.STORE_SURR_ID, source.STORE_ID, 0, 1) ) > 1  
            
        WHEN NOT MATCHED THEN 
            INSERT (target.EMPLOYEE_ID, target.EMPLOYEE_SRC_ID, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, 
                    target.STORE_SURR_ID, target.FIRST_NAME, target.LAST_NAME, 
                    target.POST_SURR_ID, target.update_dt, target.insert_dt) 
            VALUES (nf_ce_employees_seq.NEXTVAL, source.EMPLOYEE_ID, ñ_source_retail, c_sa_employees,
                    source.store_id, source.FIRST_NAME, source.LAST_NAME, source.post_id, sysdate, sysdate);
    
        insert_msg_log( ñ_source_retail, c_sa_employees, 'ld_ce_employees', 'processed ' || SQL%ROWCOUNT || ' rows');   
        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, c_sa_employees, 'ld_ce_employees', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
            ROLLBACK;
    END ld_ce_employees;

    -- Load list of employees, use views for incremental load
    PROCEDURE ld_incr_ce_employees
    IS 
    BEGIN
        insert_msg_log( ñ_source_retail, c_sa_employees, 'ld_ce_employees', 'start execution'); 

        MERGE INTO nf_ce_employees target              
        USING ( SELECT *
                FROM v_incr_employees ) source       
            ON (target.EMPLOYEE_SRC_ID = source.EMPLOYEE_ID AND
                target.SOURCE_SYSTEM = ñ_source_retail AND
                target.SOURCE_ENTITY = c_sa_employees) 
            
        WHEN MATCHED THEN
            UPDATE SET target.FIRST_NAME = source.FIRST_NAME,
                       target.LAST_NAME = source.LAST_NAME,
                       target.POST_SURR_ID = source.POST_ID,
                       target.STORE_SURR_ID = source.STORE_ID,                       
                       target.UPDATE_DT = sysdate
            WHERE ( DECODE(target.FIRST_NAME, source.FIRST_NAME, 0, 1) +
                    DECODE(target.LAST_NAME, source.LAST_NAME, 0, 1) +
                    DECODE(target.POST_SURR_ID, source.POST_ID, 0, 1) +
                    DECODE(target.STORE_SURR_ID, source.STORE_ID, 0, 1) ) > 1  
            
        WHEN NOT MATCHED THEN 
            INSERT (target.EMPLOYEE_ID, target.EMPLOYEE_SRC_ID, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, 
                    target.STORE_SURR_ID, target.FIRST_NAME, target.LAST_NAME, 
                    target.POST_SURR_ID, target.update_dt, target.insert_dt) 
            VALUES (nf_ce_employees_seq.NEXTVAL, source.EMPLOYEE_ID, ñ_source_retail, c_sa_employees,
                    source.store_id, source.FIRST_NAME, source.LAST_NAME, source.post_id, sysdate, sysdate);
    
        insert_msg_log( ñ_source_retail, c_sa_employees, 'ld_ce_employees', 'processed ' || SQL%ROWCOUNT || ' rows');   

        UPDATE prm_mta_incremental_load
        SET previous_loaded_date = SYSDATE
        WHERE sa_table_name = 'SA_EMPLOYEES';

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, c_sa_employees, 'ld_ce_employees', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
            ROLLBACK;
    END ld_incr_ce_employees;

END PKG_3NF_EMPLOYEES;

