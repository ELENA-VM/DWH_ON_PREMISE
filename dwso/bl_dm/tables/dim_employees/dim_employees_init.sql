INSERT INTO BL_DM.dim_employees(employee_surr_id, employee_id, source_entity, source_system, first_name, last_name, 
                                post_id, post, store_id, store_name, store_type_id, store_type, update_dt, insert_dt) 
SELECT -1, '-1', 'NA', 'NA', 'NA', 'NA', -1, 'NA', -1, 'NA', -1, 'NA', sysdate, sysdate
FROM dual
WHERE NOT EXISTS ( SELECT employee_surr_id
                   FROM BL_DM.dim_employees
                   WHERE employee_surr_id = -1 );
COMMIT;
