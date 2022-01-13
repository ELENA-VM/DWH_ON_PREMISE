drop table dim_customers;

CREATE TABLE dim_customers (
    customer_surr_id      NUMBER NOT NULL,
    customer_id           NUMBER NOT NULL,
    source_system         VARCHAR2(30) NOT NULL,
    source_entity         VARCHAR2(30) NOT NULL,
    type_customer         NUMBER NOT NULL,
    first_name            VARCHAR2(50) NOT NULL,
    last_name             VARCHAR2(50) NOT NULL,
    gender                VARCHAR2(20) NOT NULL,
    date_of_birth         DATE NOT NULL,
    name_of_organization  VARCHAR2(100) NOT NULL,
    email                 VARCHAR2(50) NOT NULL,
    head_of_organization  VARCHAR2(50) NOT NULL,
    iban                  VARCHAR2(50) NOT NULL,
    address_id            NUMERIC NOT NULL,
    address               VARCHAR2(50) NOT NULL,
    postal_code           VARCHAR2(20)  NOT NULL,
    city_id               NUMBER NOT NULL,
    city                  VARCHAR2(50)  NOT NULL,
    country_id            NUMBER NOT NULL,
    country               VARCHAR2(50)  NOT NULL,
    region_id             NUMBER NOT NULL,
    region                VARCHAR2(50)  NOT NULL,
    update_dt             DATE NOT NULL,
    insert_dt             DATE NOT NULL
);

ALTER TABLE dim_customers ADD CONSTRAINT dim_customer_pk PRIMARY KEY ( customer_surr_id );