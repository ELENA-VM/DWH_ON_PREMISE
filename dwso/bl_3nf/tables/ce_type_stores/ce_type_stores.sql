drop table ce_type_stores;

CREATE TABLE ce_type_stores (
    type_store_id      NUMBER NOT NULL,
    type_store_src_id  VARCHAR2(50) NOT NULL,
    source_entity      VARCHAR2(30) NOT NULL,
    source_system      VARCHAR2(30) NOT NULL,
    type_store         VARCHAR2(30) NOT NULL,
    update_dt          DATE NOT NULL,
    insert_dt          DATE NOT NULL
);

ALTER TABLE ce_type_stores ADD CONSTRAINT ce_stores_type_pk PRIMARY KEY ( type_store_id );
