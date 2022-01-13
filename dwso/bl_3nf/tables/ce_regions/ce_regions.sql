drop table ce_regions;

CREATE TABLE ce_regions (
    region_id      NUMBER NOT NULL,
    region_src_id  VARCHAR2(50) NOT NULL,
    source_entity  VARCHAR2(30) NOT NULL,
    source_system  VARCHAR2(30) NOT NULL,
    region         VARCHAR2(50) NOT NULL,
    update_dt      DATE NOT NULL,
    insert_dt      DATE NOT NULL
);

ALTER TABLE ce_regions ADD CONSTRAINT ce_region_pk PRIMARY KEY ( region_id );