DROP TABLE ce_addresses;

CREATE TABLE ce_addresses (
    address_id      NUMBER NOT NULL,
    address_src_id  VARCHAR2(50) NOT NULL,
    source_system   VARCHAR2(30) NOT NULL,
    source_entity   VARCHAR2(30) NOT NULL,
    address         VARCHAR2(50) NOT NULL,
    postal_code     VARCHAR(20)  NOT NULL,
    city_surr_id    NUMBER NOT NULL,
    update_dt       DATE NOT NULL,
	insert_dt       DATE NOT NULL
);

ALTER TABLE ce_addresses ADD CONSTRAINT ce_address_pk PRIMARY KEY ( address_id );

ALTER TABLE ce_addresses
    ADD CONSTRAINT ce_address_city_fk FOREIGN KEY ( city_surr_id )
        REFERENCES ce_cities ( city_id );
