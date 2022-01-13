drop table wrk_ex_dm_fct_sales;

create table wrk_ex_dm_fct_sales
tablespace users
for exchange with table dm_fct_sales;

ALTER TABLE wrk_ex_dm_fct_sales
    ADD CONSTRAINT wrk_fct_sales_dim_address_fk FOREIGN KEY ( address_surr_id )
        REFERENCES BL_DM.dim_addresses ( address_surr_id );

ALTER TABLE wrk_ex_dm_fct_sales
    ADD CONSTRAINT wrk_fct_sales_dim_book_fk FOREIGN KEY ( book_surr_id )
        REFERENCES BL_DM.dim_books_scd ( book_surr_id );
		
ALTER TABLE wrk_ex_dm_fct_sales
    ADD CONSTRAINT wrk_fct_sales_dim_customer_fk FOREIGN KEY ( customer_surr_id )
        REFERENCES BL_DM.dim_customers ( customer_surr_id );

ALTER TABLE wrk_ex_dm_fct_sales
    ADD CONSTRAINT wrk_fct_sales_dim_employee_scd_fk FOREIGN KEY ( employee_surr_id )
        REFERENCES BL_DM.dim_employees ( employee_surr_id );
		
ALTER TABLE wrk_ex_dm_fct_sales
    ADD CONSTRAINT wrk_fct_sales_dim_store_fk FOREIGN KEY ( store_surr_id )
        REFERENCES BL_DM.dim_stores ( store_surr_id );

ALTER TABLE wrk_ex_dm_fct_sales
    ADD CONSTRAINT wrk_fct_sales_dim_time_fk FOREIGN KEY ( date_id )
        REFERENCES BL_DM.dim_dates ( date_id );
		
ALTER TABLE wrk_ex_dm_fct_sales
    ADD CONSTRAINT wrk_fct_sales_dim_type_payment_fk FOREIGN KEY ( type_payment_surr_id )
        REFERENCES BL_DM.dim_type_payments ( type_payment_surr_id );