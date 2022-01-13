CREATE OR REPLACE PACKAGE PKG_LD_SA_RETAIL AS 
    PROCEDURE ld_sa_type_stores;
    PROCEDURE ld_sa_type_payments;
    PROCEDURE ld_sa_stores;
    PROCEDURE ld_sa_posts;
    PROCEDURE ld_sa_regions; 
    PROCEDURE ld_sa_countries;
    PROCEDURE ld_sa_cities;
    PROCEDURE ld_sa_address;
    PROCEDURE ld_sa_employees;
    PROCEDURE ld_sa_authors;
    PROCEDURE ld_sa_books;
    PROCEDURE ld_sa_customers_retail;
    PROCEDURE ld_sa_transaction_retail;
END PKG_LD_SA_RETAIL;
