drop table ce_cities;

CREATE TABLE ce_cities (
    city_id          NUMBER NOT NULL,
    city_src_id      VARCHAR2(30) NOT NULL, 
    source_entity    VARCHAR2(30) NOT NULL,
    source_system    VARCHAR2(30) NOT NULL,
    city             VARCHAR2(50) NOT NULL,
    country_surr_id  NUMBER NOT NULL,
    update_dt        DATE NOT NULL,
    insert_dt        DATE NOT NULL
);

ALTER TABLE ce_cities ADD CONSTRAINT ce_city_pk PRIMARY KEY ( city_id );

ALTER TABLE ce_cities
    ADD CONSTRAINT ce_city_country_fk FOREIGN KEY ( country_surr_id )
        REFERENCES ce_countries ( country_id );
