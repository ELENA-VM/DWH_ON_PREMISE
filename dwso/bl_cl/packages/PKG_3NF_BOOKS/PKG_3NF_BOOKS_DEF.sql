CREATE OR REPLACE PACKAGE PKG_3NF_BOOKS AS 
    PROCEDURE ld_ce_categories;
    PROCEDURE ld_ce_sub_categories;
    PROCEDURE ld_ce_authors;
    PROCEDURE ld_ce_books;
    PROCEDURE ld_ce_book_author;
END PKG_3NF_BOOKS;
