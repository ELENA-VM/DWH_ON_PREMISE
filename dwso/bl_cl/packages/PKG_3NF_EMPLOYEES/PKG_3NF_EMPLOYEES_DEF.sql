CREATE OR REPLACE PACKAGE PKG_3NF_EMPLOYEES AS 
    PROCEDURE ld_ce_posts;    
    PROCEDURE ld_ce_employees;
    PROCEDURE ld_incr_ce_employees;
END PKG_3NF_EMPLOYEES;
