CREATE OR REPLACE PACKAGE BODY PKG_DIM_EMPLOYEES AS 
/*
    Package for load table dim_employees, layer BL_DM 
*/
    ñ_source_system CONSTANT VARCHAR(6) := 'BL_3NF';
    c_ce_employees CONSTANT VARCHAR(12) := 'CE_EMPLOYEES';
    
	PROCEDURE ld_dim_employees
	IS 
	BEGIN
        insert_msg_log( ñ_source_system, c_ce_employees, 'ld_dim_employees', 'start execution'); 
    
        MERGE INTO dm_dim_employees target              
        USING ( SELECT cem.employee_id,
                       ces.store_id,
                       ces.store_name,
                       cets.type_store_id,
                       cets.type_store,
                       cem.first_name,
                       cem.last_name,
                       cep.post_id,
                       cep.post_name 
                FROM nf_ce_employees cem 
                INNER JOIN nf_ce_stores ces ON cem.store_surr_id = ces.store_id
                INNER JOIN nf_ce_type_stores cets ON ces.store_type_surr_id = cets.type_store_id
                INNER JOIN nf_ce_posts cep ON cem.post_surr_id = cep.post_id   
        ) source       
            ON (target.employee_id = source.employee_id AND
				target.source_entity = c_ce_employees AND
				target.source_system = ñ_source_system) 
           
        WHEN MATCHED THEN
            UPDATE SET target.store_id = source.store_id,
                       target.store_name = source.store_name, 
                       target.store_type_id = source.type_store_id, 
                       target.store_type = source.type_store, 
                       target.first_name = source.first_name, 
                       target.last_name = source.last_name, 
                       target.post_id  = source.post_id,
                       target.post  = source.post_name,
                       target.UPDATE_DT  = sysdate
            WHERE (DECODE(target.store_id, source.store_id, 0, 1) +
                   DECODE(target.store_name, source.store_name, 0, 1) + 
                   DECODE(target.store_type_id, source.type_store_id, 0, 1) + 
                   DECODE(target.store_type, source.type_store, 0, 1) +
                   DECODE(target.first_name, source.first_name, 0, 1) +
                   DECODE(target.last_name, source.last_name, 0, 1) +
                   DECODE(target.post_id, source.post_id, 0, 1) +
                   DECODE(target.post, source.post_name, 0, 1)) > 1
            
        WHEN NOT MATCHED THEN 
            INSERT (target.employee_surr_id, target.employee_id, target.source_entity, target.source_system,
                    target.first_name, target.last_name, target.post_id, target.post, target.store_id, target.store_name,
                    target.store_type_id, target.store_type, target.update_dt, target.insert_dt) 
                    
            VALUES (dm_dim_employees_seq.NEXTVAL, source.employee_id,  c_ce_employees, ñ_source_system,
                    source.first_name, source.last_name, source.post_id, source.post_name, source.store_id,
                    source.store_name, source.type_store_id, source.type_store, sysdate, sysdate); 
                    
        insert_msg_log( ñ_source_system, c_ce_employees, 'ld_dim_employees', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        
        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
			ROLLBACK;
	END ld_dim_employees;
END PKG_DIM_EMPLOYEES;

