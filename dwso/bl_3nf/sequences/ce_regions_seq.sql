DROP SEQUENCE ce_regions_seq;

CREATE SEQUENCE ce_regions_seq
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;