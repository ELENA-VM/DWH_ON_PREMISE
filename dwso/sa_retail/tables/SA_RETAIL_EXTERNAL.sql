CREATE OR REPLACE DIRECTORY ext_data_dir AS 'd:/WORK/Epam/Data_Engineering/DWH/learn/_practice/task_05/csv';

DROP TABLE ext_regions;

CREATE TABLE ext_regions
(
  CHILD_CODE  VARCHAR2(4000),
  PARENT_CODE VARCHAR2(4000),
  STRUCTURE_DESC VARCHAR2(4000),
  STRUCTURE_LEVEL VARCHAR2(4000)
) 
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('geo_structure_region.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

select *
from ext_regions;

DROP TABLE ext_countries;
 
CREATE TABLE ext_countries
(
  COUNTRY_ID  VARCHAR2(4000),
  COUNTY_DESC VARCHAR2(4000),  
  STRUCTURE_CODE VARCHAR2(4000), 
  STRUCTURE_DESC VARCHAR2(4000)
) 
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('geo_countries_structure.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;


select *
from EXT_COUNTRIES;

drop table ext_authors;

CREATE TABLE ext_authors
(
  AUTHOR_ID  VARCHAR2(4000),
  AUTHOR_NAME VARCHAR2(4000)
) 
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('author.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

select *
from EXT_AUTHORS

drop table ext_books;

CREATE TABLE ext_books
(
  BOOK_ID VARCHAR2(4000),
  ISBN  VARCHAR2(4000),
  PUBLISHER VARCHAR2(4000),
  BOOK_TITLE VARCHAR2(4000),
  BOOK_AUTHOR VARCHAR2(4000),
  YEAR_OF_PUBLICATION VARCHAR2(4000),
  AUTHOR_ID VARCHAR2(4000),
  CATEGORY_ID VARCHAR2(4000),
  "CATEGORY" VARCHAR2(4000),
  SUB_CATEGORY_ID VARCHAR2(4000),
  SUB_CATEGORY VARCHAR2(4000)
) 
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('book.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

select *
from EXT_BOOKS;

drop table ext_type_payments;

CREATE TABLE ext_type_payments
(
  TYPE_PAYMENT_ID VARCHAR2(4000),
  TYPE_PAYMENT VARCHAR2(4000) 
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('type_payment.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

select *
from EXT_TYPE_PAYMENTS;

DROP TABLE ext_type_stores;

CREATE TABLE ext_type_stores
(
  TYPE_STORE_ID VARCHAR2(4000),
  TYPE_STORE VARCHAR2(4000)  
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('type_stores.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

drop table ext_stores;

CREATE TABLE ext_stores
(
  STORE_ID VARCHAR2(4000),
  STORE_NAME VARCHAR2(4000),
  STORE_TYPE_ID VARCHAR2(4000)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('stores.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

select *
from EXT_STORES;

drop table ext_customers;

CREATE TABLE ext_customers
(
  CUSTOMER_ID VARCHAR2(4000),
  FIRST_NAME VARCHAR2(4000),
  LAST_NAME VARCHAR2(4000),
  GENDER VARCHAR2(4000),
  DATE_OF_BIRTH VARCHAR2(4000),
  ADDRESS_ID VARCHAR2(4000)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('customer.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

select *
from ext_customers;

drop table ext_posts;

CREATE TABLE ext_posts
(
  POST_ID VARCHAR2(4000),
  POST_NAME VARCHAR2(4000)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('post.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;


select *
from ext_posts;

drop table ext_employees;

CREATE TABLE ext_employees
(
  EMPLOYEE_ID VARCHAR2(4000),
  FIRST_NAME VARCHAR2(4000),
  LAST_NAME VARCHAR2(4000),
  POST_ID VARCHAR2(4000),
  STORE_ID VARCHAR2(4000)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('employee.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

select *
from ext_employees;

drop table ext_cities;

CREATE TABLE ext_cities
(
  CITY_ID  VARCHAR2(4000),
  CITY VARCHAR2(4000),
  COUNTRY_ID  VARCHAR2(4000)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('city.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

select *
from ext_cities;

DROP TABLE ext_region;

CREATE TABLE ext_region
(
  REGION_ID VARCHAR2(4000),
  REGION_NAME VARCHAR2(4000)  
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('region.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

DROP TABLE ext_country;

CREATE TABLE ext_country
(
  COUNTRY_ID VARCHAR2(4000),
  COUNTRY VARCHAR2(4000),
  REGION_ID VARCHAR2(4000)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('country.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

drop table ext_address;

CREATE TABLE ext_address
(
  ADDRESS_ID VARCHAR2(4000),
  ADDRESS VARCHAR2(4000),
  ADDRESS2 VARCHAR2(4000),
  DISTRICT VARCHAR2(4000),
  CITY_ID VARCHAR2(4000),
  POSTAL_CODE VARCHAR2(4000)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('address.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;

drop table ext_transaction_retail;

CREATE TABLE ext_transaction_retail
(
  SALE_ID VARCHAR2(4000),
  INVOICE VARCHAR2(4000),  
  STORE_ID VARCHAR2(4000),
  QUANTITY VARCHAR2(4000),
  PRICE  VARCHAR2(4000),
  CUSTOMER_ID VARCHAR2(4000),  
  INVOICE_DATE VARCHAR2(4000),
  SALE_AMOUNT VARCHAR2(4000),
  ADDRESS_ID VARCHAR2(4000),
  EMPLOYEE_ID VARCHAR2(4000),
  type_payment_id VARCHAR2(4000),
  BOOK_ID VARCHAR2(4000)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_data_dir
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE SKIP 1
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('b_transaction_600000.csv')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;


select *
from ext_transaction_retail;