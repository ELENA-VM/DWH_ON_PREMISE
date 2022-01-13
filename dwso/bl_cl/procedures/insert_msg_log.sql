CREATE OR REPLACE NONEDITIONABLE PROCEDURE insert_msg_log( p_source_system in varchar2, 
                                                           p_source_entity in varchar2,
                                                           p_obj_name  in varchar2,                                                           
                                                           p_msg_text  in varchar2,
                                                           p_msg_type  in number default 0,
                                                           p_msg_code  in varchar default '',
                                                           p_msg_descr in varchar2 default '' ) 
IS 
    PRAGMA autonomous_transaction;
BEGIN
    INSERT INTO wrk_logs(user_id, source_system, source_entity, obj_name, 
                         msg_type, msg_text, msg_code, msg_descr, insert_dt)
    SELECT   user,
             UPPER(p_source_system),
             UPPER(p_source_entity),
             UPPER(p_obj_name),
             p_msg_type,
             UPPER(p_msg_text),
             UPPER(p_msg_code),
             UPPER(p_msg_descr),
             sysdate
    FROM dual;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        dbms_output.put_line('ERROR EXECUTE PROCEDURE insert_msg_log');
END;

