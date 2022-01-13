TRUNCATE TABLE wrk_test_results;

DROP TABLE wrk_test_results;

CREATE TABLE wrk_test_results (
	test_id           	 NUMERIC,
    source_system        VARCHAR2(30),
    source_entity        VARCHAR2(30),
	test_result			 NUMERIC,
    test_date            DATE
);

