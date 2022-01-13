INSERT INTO bl_3nf.ce_posts(POST_ID, POST_SRC_ID, POST_NAME, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt)
SELECT -1, -1, 'NA', 'NA', 'NA', sysdate, sysdate
FROM dual
WHERE NOT EXISTS ( SELECT POST_ID
                   FROM bl_3nf.ce_posts
                   WHERE POST_ID = -1 );
COMMIT;
