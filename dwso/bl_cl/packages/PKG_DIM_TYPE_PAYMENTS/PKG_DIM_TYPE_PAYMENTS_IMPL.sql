CREATE OR REPLACE PACKAGE BODY PKG_DIM_TYPE_PAYMENTS AS 
/*
    Package for load table dim_type_payments, layer BL_DM 
*/    

    ñ_source_system CONSTANT VARCHAR(6) := 'BL_3NF';
    c_ce_type_payments CONSTANT VARCHAR(16) := 'CE_TYPE_PATMENTS';

	PROCEDURE ld_dim_type_payments
	IS 
	BEGIN
        insert_msg_log( ñ_source_system, c_ce_type_payments, 'ld_dim_type_payments', 'start execution'); 
      
        MERGE INTO dm_dim_type_payments target              
        USING (SELECT type_payment_id,
                      type_payment
               FROM bl_3nf.ce_type_payments ) source       
            ON (target.type_payment_id = source.type_payment_id AND
				target.SOURCE_SYSTEM = ñ_source_system AND
				target.SOURCE_ENTITY = c_ce_type_payments) 
            
        WHEN MATCHED THEN
            UPDATE SET target.TYPE_PAYMENT = source.TYPE_PAYMENT,
                       target.UPDATE_DT  = sysdate
            WHERE DECODE(target.TYPE_PAYMENT, source.TYPE_PAYMENT, 0, 1) > 0
            
        WHEN NOT MATCHED THEN 
            INSERT (target.type_payment_surr_id, target.type_payment_id, target.TYPE_PAYMENT, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, target.update_dt, target.insert_dt) 
            VALUES (dm_dim_type_payments_seq.NEXTVAL, source.TYPE_PAYMENT_ID, source.TYPE_PAYMENT, ñ_source_system, c_ce_type_payments, sysdate, sysdate); 

        insert_msg_log( ñ_source_system, c_ce_type_payments, 'ld_dim_type_payments', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_system, c_ce_type_payments, 'ld_dim_type_payments', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
	END ld_dim_type_payments;
    
END PKG_DIM_TYPE_PAYMENTS;

