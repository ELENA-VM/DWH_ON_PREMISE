CREATE OR REPLACE VIEW v_incr_employees
AS
( SELECT sae.EMPLOYEE_ID,
         sae.FIRST_NAME,
         sae.LAST_NAME,
         NVL(cep.POST_ID, -1) POST_ID,
         NVL(ces.STORE_ID, -1) STORE_ID
                
  FROM sar_employees sae
  LEFT JOIN nf_ce_posts cep ON sae.POST_ID = cep.post_src_id
  LEFT JOIN nf_ce_stores ces ON sae.STORE_ID = ces.store_src_id 
 
  WHERE sae.insert_dt > 
        ( SELECT previous_loaded_date
          FROM prm_mta_incremental_load 
          WHERE sa_table_name = 'SA_EMPLOYEES' )
     OR sae.update_dt > 
        ( SELECT previous_loaded_date 
          FROM prm_mta_incremental_load 
          WHERE sa_table_name = 'SA_EMPLOYEES' )
);         
               
                