CREATE TABLE wrk_books (
    book_id              NUMBER NOT NULL,
    book_src_id          VARCHAR2(50) NOT NULL,
    source_system        VARCHAR2(30) NOT NULL,
    source_entity        VARCHAR2(30) NOT NULL,
    isbn                 VARCHAR2(20) NOT NULL,
    publisher            VARCHAR2(100) NOT NULL,
    book_title           VARCHAR2(300) NOT NULL,
    year_of_publication  INTEGER NOT NULL,
    author_id            NUMBER NOT NULL,
    sub_category_surr_id NUMBER NOT NULL,
    start_dt             DATE NOT NULL,
    end_dt               DATE NOT NULL,
    is_active            VARCHAR2(4) NOT NULL,
    update_dt            DATE NOT NULL,
    insert_dt            DATE NOT NULL
);