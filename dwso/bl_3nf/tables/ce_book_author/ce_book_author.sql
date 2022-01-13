CREATE TABLE ce_book_author (
    book_surr_id    NUMBER NOT NULL,
    author_surr_id  NUMBER NOT NULL
);

ALTER TABLE ce_book_author ADD CONSTRAINT ce_book_author_pk PRIMARY KEY ( book_surr_id,
                                                                          author_surr_id );
																		  
ALTER TABLE ce_book_author
    ADD CONSTRAINT ce_book_author_ce_author_fk FOREIGN KEY ( author_surr_id )
        REFERENCES ce_authors ( author_id );

ALTER TABLE ce_book_author
    ADD CONSTRAINT ce_book_author_ce_book_fk FOREIGN KEY ( book_surr_id )
        REFERENCES ce_books ( book_id );
        
											