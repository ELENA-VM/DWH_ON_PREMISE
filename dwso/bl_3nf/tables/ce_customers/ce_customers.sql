drop table ce_customers;

CREATE TABLE ce_customers (
    customer_id           NUMBER NOT NULL,
    customer_src_id       VARCHAR2(50) NOT NULL,
    source_system         VARCHAR2(30) NOT NULL,
    source_entity         VARCHAR2(30) NOT NULL,
    type_customer         NUMBER NOT NULL,
    first_name            VARCHAR2(50) NOT NULL,
    last_name             VARCHAR2(50) NOT NULL,
    gender                VARCHAR2(20) NOT NULL,
    date_of_birth         DATE NOT NULL,
    name_of_organization  VARCHAR2(100) NOT NULL,
    head_of_organization  VARCHAR2(100) NOT NULL,
    iban                  VARCHAR2(50) NOT NULL,
    email                 VARCHAR2(50) NOT NULL,
    address_surr_id       NUMBER NOT NULL,
    update_dt             DATE NOT NULL,
    insert_dt             DATE NOT NULL
);

ALTER TABLE ce_customers ADD CONSTRAINT ce_customer_pk PRIMARY KEY ( customer_id );

ALTER TABLE ce_customers
    ADD CONSTRAINT ce_customer_ce_address_fk FOREIGN KEY ( address_surr_id )
        REFERENCES ce_addresses ( address_id );


