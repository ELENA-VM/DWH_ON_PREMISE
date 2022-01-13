drop TABLE dim_employees;

CREATE TABLE dim_employees (
    employee_surr_id  NUMBER NOT NULL,
    employee_id       VARCHAR2(50) NOT NULL,
    source_entity     VARCHAR2(30) NOT NULL,
    source_system     VARCHAR2(30) NOT NULL,
    first_name        VARCHAR2(50) NOT NULL,
    last_name         VARCHAR2(50) NOT NULL,
    post_id           NUMBER NOT NULL,
    post              VARCHAR2(50) NOT NULL,
    store_id          NUMBER NOT NULL,
    store_name        VARCHAR2(50) NOT NULL,
    store_type_id     NUMBER NOT NULL,
    store_type        VARCHAR2(30) NOT NULL,
    update_dt         DATE NOT NULL,
    insert_dt         DATE NOT NULL
);

ALTER TABLE dim_employees ADD CONSTRAINT dim_employee_pk PRIMARY KEY ( employee_surr_id );