drop table dim_stores;

CREATE TABLE dim_stores (
    store_surr_id  NUMBER NOT NULL,
    store_id       NUMBER NOT NULL,
    source_system  VARCHAR2(30) NOT NULL,
    source_entity  VARCHAR2(30) NOT NULL,
    store_name     VARCHAR2(50) NOT NULL,
    store_type_id  NUMBER  NOT NULL,
    store_type     VARCHAR2(30) NOT NULL,
    update_dt      DATE NOT NULL,
    insert_dt      DATE NOT NULL
);

ALTER TABLE dim_stores ADD CONSTRAINT dim_store_pk PRIMARY KEY ( store_surr_id );