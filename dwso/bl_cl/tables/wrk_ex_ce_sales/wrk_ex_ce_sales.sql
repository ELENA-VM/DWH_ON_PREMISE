DROP TABLE wrk_ex_ce_sales;

create table wrk_ex_ce_sales
tablespace users
for exchange with table nf_ce_sales;

ALTER TABLE BL_CL.wrk_ex_ce_sales
    ADD CONSTRAINT wrk_ex_ce_sales_ce_customer_fk FOREIGN KEY ( customer_surr_id )
        REFERENCES BL_3NF.ce_customers ( customer_id );

ALTER TABLE wrk_ex_ce_sales
    ADD CONSTRAINT wrk_ex_ce_sales_ce_employee_fk FOREIGN KEY ( employee_surr_id )
        REFERENCES BL_3NF.ce_employees ( employee_id );

ALTER TABLE wrk_ex_ce_sales
    ADD CONSTRAINT wrk_ex_ce_sales_ce_store_fk FOREIGN KEY ( store_surr_id )
        REFERENCES BL_3NF.ce_stores ( store_id );

ALTER TABLE wrk_ex_ce_sales
    ADD CONSTRAINT wrk_ex_ce_sales_ce_type_payment_fk FOREIGN KEY ( type_payment_surr_id )
        REFERENCES BL_3NF.ce_type_payments ( type_payment_id );
        
