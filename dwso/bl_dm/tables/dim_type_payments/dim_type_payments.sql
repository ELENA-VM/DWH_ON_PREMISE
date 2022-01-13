drop table dim_type_payments;

CREATE TABLE dim_type_payments (
    type_payment_surr_id  NUMBER NOT NULL,
    type_payment_id       NUMBER NOT NULL,
    source_system         VARCHAR2(30) NOT NULL,
    source_entity         VARCHAR2(30) NOT NULL,
    type_payment          VARCHAR2(30) NOT NULL,
    update_dt             DATE  NOT NULL,
    insert_dt             DATE  NOT NULL
);

ALTER TABLE dim_type_payments ADD CONSTRAINT dim_type_payment_pk PRIMARY KEY ( type_payment_surr_id );