CREATE OR REPLACE PACKAGE PKG_3NF_CUSTOMERS AS 
    PROCEDURE ld_ce_customers_from_retail;
    PROCEDURE ld_ce_customers_from_stock;
END PKG_3NF_CUSTOMERS;
