DROP SEQUENCE ce_countries_seq;

CREATE SEQUENCE ce_countries_seq
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;