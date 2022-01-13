INSERT INTO bl_3nf.ce_categories (CATEGORY_ID, CATEGORY_SRC_ID, category_name, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
SELECT -1, -1, 'NA', 'NA', 'NA', sysdate, sysdate
FROM dual
WHERE NOT EXISTS ( SELECT CATEGORY_ID
                   FROM bl_3nf.ce_categories
                   WHERE CATEGORY_ID = -1 );
COMMIT;
