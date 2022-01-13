CREATE TABLE dim_addresses (
    address_surr_id  NUMBER NOT NULL,
    address_id       VARCHAR2(50) NOT NULL,
    source_system    VARCHAR2(30) NOT NULL,
    source_entity    VARCHAR2(30) NOT NULL,
    address          VARCHAR2(50) NOT NULL,
    postal_code      VARCHAR2(20) NOT NULL,
    city_id          NUMBER NOT NULL,
    city             VARCHAR2(50) NOT NULL,
    country_id       NUMBER NOT NULL,
    country          VARCHAR2(50) NOT NULL,
    region_id        NUMBER NOT NULL,
    region           VARCHAR2(50) NOT NULL,
    update_dt        DATE NOT NULL,
    insert_dt        DATE NOT NULL
);

ALTER TABLE dim_addresses ADD CONSTRAINT dim_address_pk PRIMARY KEY ( address_surr_id );