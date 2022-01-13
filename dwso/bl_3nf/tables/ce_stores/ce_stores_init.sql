INSERT INTO bl_3nf.ce_stores(STORE_ID, STORE_SRC_ID, STORE_NAME, STORE_TYPE_SURR_ID, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt)  
SELECT -1, -1, 'NA', -1, 'NA', 'NA', sysdate, sysdate
FROM dual
WHERE NOT EXISTS ( SELECT STORE_ID
                   FROM bl_3nf.ce_stores
                   WHERE STORE_ID = -1 );
COMMIT;
