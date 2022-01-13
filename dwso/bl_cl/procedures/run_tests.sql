CREATE OR REPLACE PROCEDURE run_tests(p_source_system in varchar2) 
IS 
    l_return PLS_INTEGER;
BEGIN
    FOR r_test IN (SELECT test_id,
                          source_system,
                          source_entity, 
                          test_text
                   FROM wrk_tests
                   WHERE source_system like UPPER(p_source_system)||'%')   
    LOOP
        EXECUTE IMMEDIATE r_test.test_text INTO l_return;
  
        INSERT INTO wrk_test_results(test_id, source_system, source_entity, test_result, test_date)
        SELECT r_test.test_id, r_test.source_system, r_test.source_entity, l_return, sysdate
        FROM dual;  
        
        insert_msg_log( r_test.source_system, r_test.source_entity, l_return, 'TEST' );   

        COMMIT; 
    END LOOP;     

EXCEPTION
    WHEN OTHERS THEN 
        insert_msg_log( p_source_system, 'TEST', 'TEST', 
                        'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
        ROLLBACK;
        dbms_output.put_line('ERROR EXECUTE PROCEDURE run_tests');
END;