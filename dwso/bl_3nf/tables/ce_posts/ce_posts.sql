drop table ce_posts;

CREATE TABLE ce_posts (
    post_id        NUMBER NOT NULL,
    post_src_id    VARCHAR2(50) NOT NULL,
    source_entity  VARCHAR2(30) NOT NULL,
    source_system  VARCHAR2(30) NOT NULL,
    post_name      VARCHAR2(50) NOT NULL,
    update_dt      DATE NOT NULL,
    insert_dt      DATE NOT NULL
);

ALTER TABLE ce_posts ADD CONSTRAINT ce_post_pk PRIMARY KEY ( post_id );