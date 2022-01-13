INSERT INTO prm_mta_incremental_load(incremental_load_type, sa_table_name, target_table_name, package, procedure, previous_loaded_date) 
SELECT 'LAST_DATE', 'SA_EMPLOYEES', 'CE_EMPLOYEES', 'PKG_3NF_EMPLOYEES', 'LD_INCR_CE_EMPLOYEES', date'1970-01-01'
FROM dual;

COMMIT;

INSERT INTO prm_mta_incremental_load(incremental_load_type, sa_table_name, target_table_name, package, procedure, previous_loaded_date) 
SELECT 'LAST_DATE', 'SA_TRANSACTION', 'CE_SALES', 'PKG_3NF_SALES', 'LD_INCR_CE_SALES', date'1970-01-01'
FROM dual;

COMMIT;


INSERT INTO prm_mta_incremental_load(incremental_load_type, sa_table_name, target_table_name, package, procedure, previous_loaded_date) 
SELECT 'FLAG', 'SA_STORES', 'CE_STORES', 'PKG_3NF_STORES', 'LD_INCR_CE_STORES', date'1970-01-01'
FROM dual;

COMMIT;
