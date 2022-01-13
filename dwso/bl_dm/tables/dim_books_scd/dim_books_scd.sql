drop TABLE dim_books_scd;

CREATE TABLE dim_books_scd (
    book_surr_id         NUMBER NOT NULL,
    book_id              NUMBER NOT NULL,
    source_system        VARCHAR2(30) NOT NULL,
    source_entity        VARCHAR2(30) NOT NULL,
    isbn                 VARCHAR2(20) NOT NULL,
    publisher            VARCHAR2(100) NOT NULL,
    book_title           VARCHAR2(300) NOT NULL,
    year_of_publication  INTEGER  NOT NULL,
    author_id            NUMBER NOT NULL,
    author               VARCHAR2(150) NOT NULL,
    category_id          NUMBER NOT NULL,
    category_name        VARCHAR2(30) NOT NULL,
    sub_category_id      NUMBER NOT NULL,
    sub_category         VARCHAR2(100) NOT NULL,
    start_dt             DATE NOT NULL,
    end_dt               DATE NOT NULL,
    is_active            VARCHAR2(4) NOT NULL,
    update_dt            DATE NOT NULL,
    insert_dt            DATE NOT NULL
);

ALTER TABLE dim_books_scd ADD CONSTRAINT dim_book_scd_pk PRIMARY KEY ( book_surr_id, start_dt );