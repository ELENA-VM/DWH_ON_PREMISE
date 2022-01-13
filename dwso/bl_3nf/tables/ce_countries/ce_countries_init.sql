INSERT INTO bl_3nf.ce_countries(COUNTRY_ID, COUNTRY_SRC_ID, COUNTRY, region_surr_id, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
SELECT -1, -1, 'NA', -1, 'NA', 'NA', sysdate, sysdate
FROM dual
WHERE NOT EXISTS ( SELECT COUNTRY_ID
                   FROM bl_3nf.ce_countries
                   WHERE COUNTRY_ID = -1 );
COMMIT;
