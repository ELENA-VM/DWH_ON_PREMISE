DROP TABLE prm_mta_incremental_load;


CREATE TABLE prm_mta_incremental_load (
    incremental_load_type VARCHAR2(50) NOT NULL,
    sa_table_name         VARCHAR2(50) NOT NULL,
    target_table_name     VARCHAR2(50) NOT NULL,
    package		          VARCHAR2(50) NOT NULL,
    procedure             VARCHAR2(50) NOT NULL,
    previous_loaded_date  DATE
);
