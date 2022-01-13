create or replace NONEDITIONABLE PROCEDURE fill_dim_date(start_date in date, end_date in date) 
IS 
BEGIN
    DECLARE tmp_date date;   

    BEGIN
        tmp_date := start_date;

        WHILE (tmp_date <= end_date)
        LOOP
            INSERT INTO DIM_DATES(DATE_ID, DAY_NAME, DAY_NUMBER_IN_WEEK, DAY_NUMBER_IN_MONTH, 
                                CALENDAR_WEEK_NUMBER, CALENDAR_MONTH_NUMBER, CALENDAR_QUARTER_NUMBER,
                                DAYS_IN_CAL_YEAR, YEAR_NUM)                             
            SELECT tmp_date,
                   TRIM(TO_CHAR(tmp_date, 'Day', 'nls_date_language=english')),
                   TO_NUMBER(TO_CHAR(tmp_date, 'D')),
                   TO_NUMBER(TO_CHAR(tmp_date, 'DD')),
                   TO_NUMBER(TO_CHAR(tmp_date, 'iw')),
                   TO_NUMBER(TO_CHAR(tmp_date, 'MM')),
                   TO_NUMBER(TO_CHAR(tmp_date, 'Q')),
                   TO_NUMBER(TO_CHAR(tmp_date, 'DDD')),
                   TO_NUMBER(TO_CHAR(tmp_date, 'YYYY'))
            from dual;                   

            tmp_date := tmp_date + INTERVAL '1' DAY;
        END LOOP;   
        
        COMMIT;
    END; 
EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        dbms_output.put_line('ERROR EXECUTE PROCEDURE fill_dim_date');
END;