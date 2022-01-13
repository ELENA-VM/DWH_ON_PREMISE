DROP TABLE ce_type_payments;

CREATE TABLE ce_type_payments (
    type_payment_id      NUMBER NOT NULL,
    type_payment_src_id  VARCHAR2(50) NOT NULL,
    source_system        VARCHAR2(30) NOT NULL,
    source_entity        VARCHAR2(30) NOT NULL,
    type_payment         VARCHAR2(30) NOT NULL,
    update_dt            DATE NOT NULL,
    insert_dt            DATE NOT NULL
);

ALTER TABLE ce_type_payments ADD CONSTRAINT ce_type_payment_pk PRIMARY KEY ( type_payment_id );