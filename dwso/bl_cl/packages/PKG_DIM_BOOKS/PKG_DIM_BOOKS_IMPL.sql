CREATE OR REPLACE PACKAGE BODY PKG_DIM_BOOKS AS 
/*
    Package for load table dim_books_scd, layer BL_DM 
*/
    ñ_source_system CONSTANT VARCHAR(6) := 'BL_3NF';
    c_ce_books CONSTANT VARCHAR(12) := 'CE_BOOKS_SCD';

	PROCEDURE ld_dim_books
	IS 
	BEGIN
        insert_msg_log(ñ_source_system, c_ce_books, 'ld_dim_books', 'start execution'); 

        MERGE INTO dm_dim_books_scd target              
        USING (
                SELECT  ceb.book_id,
                        ceb.isbn,
                        ceb.publisher,
                        ceb.book_title,
                        ceb.year_of_publication,
                        cea.author_id,
                        cea.author_name,
                        ces.sub_category_id,
                        ces.sub_category,
                        cec.category_id,
                        cec.category_name,
                        ceb.start_dt,
                        ceb.end_dt,
                        ceb.is_active
                    FROM nf_ce_books ceb
                    INNER JOIN nf_ce_authors cea ON ceb.author_id = cea.author_id 
                    INNER JOIN nf_ce_sub_categories ces ON ceb.sub_category_surr_id = ces.sub_category_id              
                    INNER JOIN nf_ce_categories cec ON ces.category_surr_id = cec.category_id

              ) source       
            ON (target.book_id = source.book_id AND
                target.start_dt = source.start_dt AND
				target.source_system = ñ_source_system AND
				target.source_entity = c_ce_books ) 
            
        WHEN MATCHED THEN
            UPDATE SET target.isbn = source.isbn, 
                       target.publisher = source.publisher, 
                       target.book_title = source.book_title, 
                       target.year_of_publication = source.year_of_publication,                        
                       target.author_id = source.author_id, 
                       target.author = source.author_name, 
                       target.sub_category_id = source.sub_category_id, 
                       target.sub_category = source.sub_category,                          
                       target.category_id = source.category_id, 
                       target.category_name = source.category_name,
                       target.update_dt = sysdate,
                       target.end_dt = source.end_dt,
                       target.is_active = source.is_active                                            
                       
            WHERE (DECODE(target.isbn, source.isbn, 0, 1) +
                   DECODE(target.publisher, source.publisher, 0, 1) + 
                   DECODE(target.book_title, source.book_title, 0, 1) +   
                   DECODE(target.year_of_publication, source.year_of_publication, 0, 1) +
                   DECODE(target.author_id, source.author_id, 0, 1) +
                   DECODE(target.author, source.author_name, 0, 1) + 
                   DECODE(target.sub_category_id, source.sub_category_id, 0, 1) +
                   DECODE(target.sub_category, source.sub_category, 0, 1) + 
                   DECODE(target.category_id, source.category_id, 0, 1) +
                   DECODE(target.category_name, source.category_name, 0, 1) +
                   DECODE(target.end_dt, source.end_dt, 0, 1) +
                   DECODE(target.is_active, source.is_active, 0, 1) ) > 1
 
        WHEN NOT MATCHED THEN 
            INSERT (target.book_surr_id , target.book_id, target.source_system, target.source_entity,                    
                    target.isbn, target.publisher, target.book_title, target.year_of_publication, target.author_id,
                    target.author, target.category_id, target.category_name, target.sub_category_id, 
                    target.sub_category, target.start_dt, target.end_dt, target.is_active,                    
                    target.update_dt, target.insert_dt)

            VALUES (dm_dim_books_scd_seq.NEXTVAL, source.book_id, ñ_source_system, c_ce_books,
                    source.isbn , source.publisher, source.book_title, source.year_of_publication , source.author_id,
                    source.author_name, source.category_id, source.category_name, source.sub_category_id, 
                    source.sub_category, source.start_dt, source.end_dt, source.is_active, sysdate, sysdate); 

        insert_msg_log( ñ_source_system, c_ce_books, 'ld_dim_books', 'processed ' || SQL%ROWCOUNT || ' rows'); 

        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_system, c_ce_books, 'ld_dim_books', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) );         
			ROLLBACK;
	END;
    
END PKG_DIM_BOOKS;
