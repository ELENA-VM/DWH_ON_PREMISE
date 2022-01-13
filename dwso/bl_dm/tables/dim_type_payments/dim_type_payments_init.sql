INSERT INTO BL_DM.dim_type_payments(type_payment_surr_id, type_payment_id, source_system, source_entity, type_payment, update_dt, insert_dt) 
SELECT -1, -1, 'NA', 'NA', 'NA', sysdate, sysdate
FROM dual
WHERE NOT EXISTS ( SELECT type_payment_surr_id
                   FROM BL_DM.dim_type_payments
                   WHERE type_payment_surr_id = -1 );
COMMIT;
