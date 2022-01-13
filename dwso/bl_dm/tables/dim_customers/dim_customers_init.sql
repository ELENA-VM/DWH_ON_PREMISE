INSERT INTO  BL_DM.dim_customers(customer_surr_id, customer_id, source_system, source_entity, type_customer, address_id,
                                 first_name, last_name, gender, date_of_birth, name_of_organization,
                                 email, head_of_organization, iban, address, postal_code, city_id,
                                 city, country_id, country, region_id, region, update_dt, insert_dt)           
SELECT -1, -1, 'NA', 'NA', -1, -1,
       'NA', 'NA', 'NA', TO_DATE('01011970', 'MMDDYYYY'), 'NA',
       'NA', 'NA', 'NA', 'NA', -1, -1, 'NA', -1, 'NA',-1, 'NA', sysdate, sysdate
FROM dual
WHERE NOT EXISTS ( SELECT customer_surr_id
                   FROM BL_DM.dim_customers
                   WHERE customer_surr_id = -1 );
COMMIT;
