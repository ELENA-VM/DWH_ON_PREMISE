TRUNCATE TABLE wrk_tests;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_TYPE_STORES', 'select count(*) from sar_type_stores'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_TYPE_PAYMENTS', 'select count(*) from sar_type_payments'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_STORES', 'select count(*) from sar_stores'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_POSTS', 'select count(*) from sar_posts'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_REGIONS', 'select count(*) from sar_regions'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_COUNTRIES', 'select count(*) from sar_countries'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_CITIES', 'select count(*) from sar_cities'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_ADDRESS', 'select count(*) from sar_address'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_EMPLOYEES', 'select count(*) from sar_employees'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_AUTHORS', 'select count(*) from sar_authors'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_BOOKS', 'select count(*) from sar_books'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_CUSTOMER_RETAIL', 'select count(*) from sar_customers_retail'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_RETAIL', 'SA_TRANSACTION_RETAIL', 'select count(*) from sar_transaction_retail'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_STOCK', 'SA_CUSTOMER_STOCK', 'select count(*) from sas_customers_stock'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'SA_STOCK', 'SA_TRANSACTION_STOCK', 'select count(*) from sas_transaction_stock'
FROM dual;

COMMIT;
--------------------------------------------------------------------------------
INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_type_stores'), 'select count(*) from nf_ce_type_stores'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_type_payments'), 'select count(*) from nf_ce_type_payments'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_sub_categories'), 'select count(*) from nf_ce_sub_categories'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_stores'), 'select count(*) from nf_ce_stores'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_sales'), 'select count(*) from nf_ce_sales'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_regions'), 'select count(*) from nf_ce_regions'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_posts'), 'select count(*) from nf_ce_posts'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_employees'), 'select count(*) from nf_ce_employees'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_customers'), 'select count(*) from nf_ce_customers'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_countries'), 'select count(*) from nf_ce_countries'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_cities'), 'select count(*) from nf_ce_cities'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_categories'), 'select count(*) from nf_ce_categories'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_books'), 'select count(*) from nf_ce_books'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_book_author'), 'select count(*) from nf_ce_book_author'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_authors'), 'select count(*) from nf_ce_authors'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_3NF', UPPER('ce_addresses'), 'select count(*) from nf_ce_addresses'
FROM dual;

COMMIT;
--------------------------------------------------------------------------------
INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_DM', UPPER('dim_type_payments'), 'select count(*) from dm_dim_type_payments'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_DM', UPPER('dim_stores'), 'select count(*) from dm_dim_stores'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_DM', UPPER('dim_employees'), 'select count(*) from dm_dim_employees'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_DM', UPPER('dim_addresses'), 'select count(*) from dm_dim_addresses'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_DM', UPPER('dim_books'), 'select count(*) from dm_dim_books_scd'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_DM', UPPER('dim_customers'), 'select count(*) from dm_dim_customers'
FROM dual;

COMMIT;

INSERT INTO wrk_tests(test_id, source_system, source_entity, test_text)  
SELECT wrk_tests_seq.nextval , 'BL_DM', UPPER('fct_sales'), 'select count(*) from dm_fct_sales'
FROM dual;

COMMIT;

