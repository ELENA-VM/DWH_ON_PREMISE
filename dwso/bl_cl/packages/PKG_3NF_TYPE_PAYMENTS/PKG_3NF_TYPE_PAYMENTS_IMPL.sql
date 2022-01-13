CREATE OR REPLACE PACKAGE BODY PKG_3NF_TYPE_PAYMENTS AS 
/*
    Package for load table ce_type_payments to layer BL_3NF 
*/

    c_source_retail CONSTANT VARCHAR(6) := 'RETAIL';
    c_sa_type_payments CONSTANT VARCHAR(16) := 'SA_TYPE_PAYMENTS';
  
	PROCEDURE ld_ce_type_payments
	IS 
      number_row NUMERIC;
      
      CURSOR type_payments_cur
      IS
        SELECT TYPE_PAYMENT_ID, TYPE_PAYMENT
		FROM SAR_TYPE_PAYMENTS;
        
        TYPE set_type_payment IS TABLE OF type_payments_cur%ROWTYPE;
        row_tp_cur set_type_payment;        

	BEGIN
        insert_msg_log( c_source_retail, c_sa_type_payments, 'ld_ce_type_payments', 'start execution'); 
        
        number_row := 0;
        
        OPEN type_payments_cur;
        LOOP  
        FETCH type_payments_cur BULK COLLECT INTO row_tp_cur;
        
            FOR l_row IN 1..row_tp_cur.COUNT
            LOOP
                INSERT INTO nf_ce_type_payments(TYPE_PAYMENT_ID, TYPE_PAYMENT_SRC_ID, TYPE_PAYMENT, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
                SELECT nf_ce_type_payments_seq.NEXTVAL, row_tp_cur(l_row).TYPE_PAYMENT_ID, row_tp_cur(l_row).TYPE_PAYMENT, c_source_retail, c_sa_type_payments, sysdate, sysdate
                FROM dual           
                WHERE NOT EXISTS ( SELECT nctype.TYPE_PAYMENT_ID
                                   FROM nf_ce_type_payments nctype 
                                   WHERE nctype.TYPE_PAYMENT_SRC_ID = row_tp_cur(l_row).TYPE_PAYMENT_ID
                                     AND nctype.SOURCE_SYSTEM = c_source_retail 
                                     AND nctype.SOURCE_ENTITY = c_sa_type_payments );
               
                number_row := number_row + SQL%ROWCOUNT;                     
                
                UPDATE nf_ce_type_payments
                SET TYPE_PAYMENT = row_tp_cur(l_row).TYPE_PAYMENT,
                    UPDATE_DT = sysdate
                WHERE TYPE_PAYMENT_SRC_ID = row_tp_cur(l_row).TYPE_PAYMENT_ID
                  AND SOURCE_SYSTEM = c_source_retail 
                  AND SOURCE_ENTITY = c_sa_type_payments
                  AND DECODE(TYPE_PAYMENT, UPPER(row_tp_cur(l_row).TYPE_PAYMENT), 0, 1) > 0;	
                  
                number_row := number_row + SQL%ROWCOUNT;       
            END LOOP;        
        
        EXIT WHEN type_payments_cur%NOTFOUND;        
        END LOOP;

        insert_msg_log( c_source_retail, c_sa_type_payments, 'ld_ce_type_payments', 
                        'processed ' || number_row || ' rows'); 

        CLOSE type_payments_cur;  
        COMMIT;
    
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( c_source_retail, c_sa_type_payments, 'ld_ce_type_payments', 
                            'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK;

	END ld_ce_type_payments;
    
END PKG_3NF_TYPE_PAYMENTS;

