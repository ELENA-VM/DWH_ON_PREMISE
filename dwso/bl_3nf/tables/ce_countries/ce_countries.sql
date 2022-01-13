drop table ce_countries;

CREATE TABLE ce_countries (
    country_id      NUMBER NOT NULL,
    country_src_id  VARCHAR2(50) NOT NULL,
    source_entity   VARCHAR2(30) NOT NULL,
    source_system   VARCHAR2(30) NOT NULL,
    country         VARCHAR2(50) NOT NULL, 
    region_surr_id  NUMBER NOT NULL,
    update_dt       DATE NOT NULL,
    insert_dt       DATE NOT NULL
);

ALTER TABLE ce_countries ADD CONSTRAINT ce_country_pk PRIMARY KEY ( country_id );

ALTER TABLE ce_countries
    ADD CONSTRAINT ce_country_ce_region_fk FOREIGN KEY ( region_surr_id )
        REFERENCES ce_regions ( region_id );
