INSERT INTO bl_3nf.ce_cities(CITY_ID, CITY_SRC_ID, CITY, COUNTRY_SURR_ID, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
SELECT -1, -1, 'NA', -1, 'NA', 'NA', sysdate, sysdate
FROM dual
WHERE NOT EXISTS ( SELECT CITY_ID
                   FROM bl_3nf.ce_cities
                   WHERE CITY_ID = -1 );
COMMIT;
