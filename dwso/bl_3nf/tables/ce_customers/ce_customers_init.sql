INSERT INTO bl_3nf.ce_customers(customer_id, customer_src_id, source_system, source_entity,
                                type_customer, first_name, last_name, gender, date_of_birth, 
                                name_of_organization, head_of_organization, 
                                iban, email, address_surr_id, update_dt, insert_dt) 
SELECT -1, -1, 'NA', 'NA', -1, 'NA', 'NA', 'NA', TO_DATE('01011970', 'MMDDYYYY'),  'NA', 'NA', 'NA', 'NA', -1, sysdate, sysdate
FROM dual
WHERE NOT EXISTS ( SELECT customer_id
                   FROM bl_3nf.ce_customers
                   WHERE customer_id = -1 );
COMMIT;
