ALTER SESSION SET "_ORACLE_SCRIPT" = true;
CREATE USER BL_CL IDENTIFIED BY BL_CL
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
PROFILE default;
GRANT connect, resource TO BL_CL;
GRANT UNLIMITED TABLESPACE TO BL_CL;
GRANT create TABLE TO BL_CL; 
GRANT system TO BL_CL; 
GRANT CREATE ANY DIRECTORY TO BL_CL;
GRANT SELECT, INSERT, UPDATE ON BL_CL TO PUBLIC;


GRANT ALL ON BL_3NF.ce_customers TO BL_CL;
GRANT ALL ON BL_3NF.ce_employees TO BL_CL;
GRANT ALL ON BL_3NF.ce_stores TO BL_CL;
GRANT ALL ON BL_3NF.ce_type_payments TO BL_CL;


GRANT ALL ON BL_DM.dim_addresses TO BL_CL;
GRANT ALL ON BL_DM.dim_books_scd TO BL_CL;
GRANT ALL ON BL_DM.dim_customers TO BL_CL;
GRANT ALL ON BL_DM.dim_employees TO BL_CL;
GRANT ALL ON BL_DM.dim_stores TO BL_CL;
GRANT ALL ON BL_DM.dim_dates TO BL_CL;
GRANT ALL ON BL_DM.dim_type_payments TO BL_CL;


