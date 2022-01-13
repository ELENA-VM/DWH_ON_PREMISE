DROP TABLE ce_sub_categories;

CREATE TABLE ce_sub_categories (
    sub_category_id      NUMBER NOT NULL,
    sub_category_src_id  VARCHAR2(50) NOT NULL,
    source_entity        VARCHAR2(30) NOT NULL,
    source_system        VARCHAR2(30) NOT NULL,
    sub_category         VARCHAR2(100) NOT NULL,
    category_surr_id     NUMBER NOT NULL,
    update_dt            DATE NOT NULL,
    insert_dt            DATE NOT NULL
);

ALTER TABLE ce_sub_categories ADD CONSTRAINT ce_sub_category_pk PRIMARY KEY ( sub_category_id );
        
ALTER TABLE ce_sub_categories
    ADD CONSTRAINT ce_sub_ce_category_category_fk FOREIGN KEY ( category_surr_id )
        REFERENCES ce_categories ( category_id );

