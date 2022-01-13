truncate table wrk_logs;
truncate table wrk_test_results;
-- initial load
exec clear_data_sa_retail;
exec clear_data_sa_stock;

exec load_bl_sa;

select * 
from wrk_logs;

exec run_tests('SA_');

select *
from wrk_test_results
where source_system like 'SA_%'
order by source_entity, test_date;

exec clear_data_bl_3nf;
exec insert_initial_data;

truncate table wrk_logs;

update prm_mta_incremental_load
set previous_loaded_date = date'2021-04-30';

update sar_stores 
set IS_CPROCESSED = 'N';
commit;

exec load_bl_3nf;

select * 
from wrk_logs;

exec run_tests('BL_3NF');

select *
from wrk_test_results
where source_system like 'BL_3NF%'
order by source_entity, test_date;

truncate table wrk_logs;

exec clear_data_bl_dm;
exec load_bl_dm(to_date('2020-12-01', 'YYYY-MM-DD'), to_date('2022-12-31', 'YYYY-MM-DD'));

select * 
from wrk_logs;

exec run_tests('BL_DM');

select *
from wrk_test_results
where source_system like 'BL_DM%'
order by source_entity, test_date;
--------------------------------------------------------------------------------
-- regular load
update prm_mta_incremental_load
set previous_loaded_date = date'2021-05-01';

update sar_employees
set insert_dt  = date'2021-05-01',
    update_dt = date'2021-05-01';

update sar_transaction_retail
set insert_dt  = date'2021-05-01',
    update_dt = date'2021-05-01';

update sas_transaction_stock
set insert_dt  = date'2021-05-01',
    update_dt = date'2021-05-01';
commit;

truncate table wrk_logs;

exec load_bl_sa;

select * 
from wrk_logs;

exec run_tests('SA_');

select *
from wrk_test_results
where source_system like 'SA_%'
order by source_entity, test_date;

truncate table wrk_logs;

exec load_bl_3nf;

select * 
from wrk_logs;

exec run_tests('BL_3NF');

select *
from wrk_tests;

select *
from wrk_test_results
where source_system like 'BL_3NF%'
order by source_entity, test_date;

truncate table wrk_logs;

exec load_bl_dm;

select * 
from wrk_logs;

exec run_tests('BL_DM');

select *
from wrk_test_results
where source_system like 'BL_DM%'
order by source_entity, test_date;


select * 
from nf_ce_books ncb
where ncb.book_src_id = '2989'; 

select *
from dm_dim_books_scd 
where book_id = 23555396;







select *
from sar_books
where book_id like '_2989'; 

