DROP TABLE wrk_logs;

CREATE TABLE wrk_logs (
	user_id           	 VARCHAR2(30),
    source_system        VARCHAR2(30),
    source_entity        VARCHAR2(30) ,
	obj_name			 VARCHAR2(100),
	msg_type			 NUMERIC,	
	msg_text			 VARCHAR2(100),
	msg_code			 VARCHAR2(30),
	msg_descr			 VARCHAR2(300),
	insert_dt		 	 DATE	
);

