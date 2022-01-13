drop table dim_dates;
CREATE TABLE dim_dates (
    date_id                  DATE NOT NULL,
    day_name                 VARCHAR2(20) NOT NULL,
    day_number_in_week       NUMBER NOT NULL,
    day_number_in_month      NUMBER NOT NULL,
    calendar_week_number     NUMBER NOT NULL,
    calendar_month_number    NUMBER NOT NULL,
    calendar_quarter_number  NUMBER NOT NULL,
    days_in_cal_year         NUMBER NOT NULL,
    year_num                 NUMBER NOT NULL
);

ALTER TABLE dim_dates ADD CONSTRAINT dim_time_pk PRIMARY KEY ( date_id );