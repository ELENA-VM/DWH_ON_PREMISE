CREATE OR REPLACE PACKAGE BODY PKG_3NF_BOOKS AS 
/*
    Package for load tables layer BL_3NF: ce_categories, ce_sub_categories,
    ce_authors, ce_books, ce_book_author
*/
    ñ_source_retail CONSTANT VARCHAR(6) := 'RETAIL';
    c_sa_books CONSTANT VARCHAR(8) := 'SA_BOOKS'; 
    c_sa_authors CONSTANT VARCHAR(10) := 'SA_AUTHORS';    
        
	PROCEDURE ld_ce_categories
	IS 
	BEGIN
        insert_msg_log( ñ_source_retail, 'ce_categories', 'ld_ce_categories', 'start execution'); 
        
        MERGE INTO nf_ce_categories target              
        USING (SELECT DISTINCT CATEGORY_ID,
                               "CATEGORY"   
               FROM sar_books
               WHERE CATEGORY_ID in ('1', '2') ) source       
            ON (target.CATEGORY_SRC_ID = source.CATEGORY_ID AND
				target.SOURCE_SYSTEM = ñ_source_retail AND
				target.SOURCE_ENTITY = c_sa_books) 
            
        WHEN MATCHED THEN
            UPDATE SET target.category_name = source."CATEGORY",
                       target.UPDATE_DT = sysdate
            WHERE target.category_name <> source."CATEGORY"
            
        WHEN NOT MATCHED THEN 
            INSERT (target.CATEGORY_ID, target.CATEGORY_SRC_ID, target.category_name, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, target.update_dt, target.insert_dt) 
            VALUES (nf_ce_categories_seq.NEXTVAL, source.CATEGORY_ID, source."CATEGORY", ñ_source_retail, c_sa_books, sysdate, sysdate); 
        insert_msg_log( ñ_source_retail, c_sa_books, 'ld_ce_categories', 'processed ' || SQL%ROWCOUNT || ' rows'); 

        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, c_sa_books, 'ld_ce_categories', 
                            'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK;
	END ld_ce_categories;

	PROCEDURE ld_ce_sub_categories
	IS 
	BEGIN
        insert_msg_log( ñ_source_retail, 'ce_sub_categories', 'ld_ce_sub_categories', 'start execution'); 

        MERGE INTO nf_ce_sub_categories target              
        USING ( SELECT DISTINCT SUB_CATEGORY_ID,
                       NVL(trim('"' from (trim(';' from SUB_CATEGORY))) , 'NA') SUB_CATEGORY,
                       NVL(cecat.category_id, -1) category_id
                FROM sar_books
                LEFT JOIN nf_ce_categories cecat ON cecat.category_name = sar_books."CATEGORY"                
                WHERE DECODE(ltrim(SUB_CATEGORY_ID,'1234567890'), null, 0, 1) = 0 and
                      DECODE(ltrim(SUB_CATEGORY,'1234567890'), null, 0, 1) = 1 and
                      SUB_CATEGORY_ID is not null ) source       
            ON (target.SUB_CATEGORY_SRC_ID = source.SUB_CATEGORY_ID AND
				target.SOURCE_SYSTEM = ñ_source_retail AND 
				target.SOURCE_ENTITY = c_sa_books) 
            
        WHEN MATCHED THEN
            UPDATE SET target.SUB_CATEGORY = source.SUB_CATEGORY,
                       target.UPDATE_DT = sysdate
            WHERE target.SUB_CATEGORY <> source.SUB_CATEGORY
            
        WHEN NOT MATCHED THEN 
            INSERT (target.SUB_CATEGORY_ID, target.SUB_CATEGORY_SRC_ID, target.SUB_CATEGORY, target.category_surr_id, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, target.update_dt, target.insert_dt) 
            VALUES (nf_ce_sub_categories_seq.NEXTVAL, source.SUB_CATEGORY_ID, source.SUB_CATEGORY, source.category_id, ñ_source_retail, c_sa_books, sysdate, sysdate);

        insert_msg_log( ñ_source_retail, 'ce_sub_categories', 'ld_ce_sub_categories', 'processed ' || SQL%ROWCOUNT || ' rows'); 

        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, 'ce_sub_categories', 'ld_ce_sub_categories', 
                            'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK;
	END ld_ce_sub_categories;

	PROCEDURE ld_ce_authors
	IS 
	BEGIN
        insert_msg_log( ñ_source_retail, c_sa_authors, 'ld_ce_authors', 'start execution'); 

        MERGE INTO nf_ce_authors target              
        USING (SELECT AUTHOR_ID,
                      NVL(trim('"' from trim(';' from AUTHOR_NAME)), 'NA') AUTHOR_NAME  
               FROM sar_authors ) source       
            ON (target.AUTHOR_SRC_ID = source.AUTHOR_ID AND
				target.SOURCE_SYSTEM = ñ_source_retail AND 
				target.SOURCE_ENTITY = c_sa_authors) 
            
        WHEN MATCHED THEN
            UPDATE SET target.AUTHOR_NAME = source.AUTHOR_NAME,
                       target.UPDATE_DT = sysdate
            WHERE target.AUTHOR_NAME <> source.AUTHOR_NAME
            
        WHEN NOT MATCHED THEN 
            INSERT (target.AUTHOR_ID, target.AUTHOR_SRC_ID, target.AUTHOR_NAME, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, target.update_dt, target.insert_dt) 
            VALUES (nf_ce_authors_seq.NEXTVAL, source.AUTHOR_ID, NVL(trim('"' from trim(';' from source.AUTHOR_NAME)), 'NA'), ñ_source_retail, c_sa_authors, sysdate, sysdate); 

        insert_msg_log( ñ_source_retail, c_sa_authors, 'ld_ce_authors', 'processed ' || SQL%ROWCOUNT || ' rows'); 

        COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, c_sa_authors, 'ld_ce_authors', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK;
	END;

	PROCEDURE ld_ce_books
	IS 
	BEGIN
       insert_msg_log( ñ_source_retail, c_sa_books, 'ld_ce_books', 'start execution');

       EXECUTE IMMEDIATE 'TRUNCATE TABLE wrk_books';

       insert_msg_log( ñ_source_retail, c_sa_books, 'ld_ce_books', 'insert wrk table');

       INSERT INTO wrk_books (book_id, book_src_id, source_system, source_entity, isbn,
                   publisher, book_title, year_of_publication, author_id,
                   sub_category_surr_id, start_dt, end_dt, is_active, update_dt, insert_dt) 
       
       SELECT ncb.BOOK_ID,
              trim('"' from sab.BOOK_ID),
              ñ_source_retail,
              c_sa_books,
              trim('"' from sab.ISBN),              
              NVL(trim('"' from sab.PUBLISHER), 'NA'),
              NVL(trim('"' from sab.BOOK_TITLE), 'NA'),
              DECODE(ltrim(sab.YEAR_OF_PUBLICATION,'1234567890'), null, to_number(sab.YEAR_OF_PUBLICATION), -1),
              NVL(cea.author_id, -1),
              NVL(ces.sub_category_id, -1),
              sysdate,
              TO_DATE('01019999', 'MMDDYY'), 
              'yes', 
              sysdate, 
              sysdate
              
       FROM sar_books sab
       LEFT JOIN nf_ce_authors cea ON sab.author_id = cea.author_src_id
       LEFT JOIN nf_ce_sub_categories ces ON sab.sub_category_id = ces.sub_category_src_id 
       INNER JOIN nf_ce_books ncb ON ncb.BOOK_SRC_ID = trim('"' from sab.BOOK_ID) 
       AND ncb.source_system = ñ_source_retail 
       AND ncb.source_entity = c_sa_books 
       AND ncb.is_active = 'yes' 
--       AND TO_CHAR(ncb.start_dt,'DD.MM.YYYY') != TO_CHAR(sysdate, 'DD.MM.YYYY')
       WHERE ( DECODE(ncb.ISBN, trim('"' from sab.ISBN), 0, 1) +
               DECODE(ncb.PUBLISHER, NVL(trim('"' from sab.PUBLISHER), 'NA'), 0, 1) +
               DECODE(ncb.BOOK_TITLE, NVL(trim('"' from sab.BOOK_TITLE), 'NA'), 0, 1) +
               DECODE(ncb.AUTHOR_ID, NVL(cea.author_id, -1), 0, 1) +
               DECODE(ncb.SUB_CATEGORY_SURR_ID, NVL(ces.sub_category_id, -1), 0, 1) +
               DECODE(ncb.YEAR_OF_PUBLICATION, 
               DECODE(ltrim(sab.YEAR_OF_PUBLICATION,'1234567890'), null, to_number(sab.YEAR_OF_PUBLICATION), -1)  , 0, 1) 
            ) > 0;     
        
       insert_msg_log( ñ_source_retail, 'wrk_books', 'ld_ce_books',  'processed ' || SQL%ROWCOUNT || ' rows'); 
       COMMIT;
       
       insert_msg_log( ñ_source_retail, c_sa_books, 'ld_ce_books', 'merge');

       MERGE INTO nf_ce_books target              
       USING ( SELECT trim('"' from sab.BOOK_ID) BOOK_ID,
                      trim('"' from sab.ISBN) ISBN,              
                      NVL(trim('"' from sab.PUBLISHER), 'NA') PUBLISHER,
                      NVL(trim('"' from sab.BOOK_TITLE), 'NA') BOOK_TITLE,
                      NVL(cea.author_id, -1) AUTHOR_ID,
                      NVL(ces.sub_category_id, -1) SUB_CATEGORY_ID,
                      DECODE(ltrim(sab.YEAR_OF_PUBLICATION,'1234567890'), null, to_number(sab.YEAR_OF_PUBLICATION), -1) YEAR_OF_PUBLICATION
               FROM sar_books sab
               LEFT JOIN nf_ce_authors cea on sab.author_id = cea.author_src_id
               LEFT JOIN nf_ce_sub_categories ces on sab.sub_category_id = ces.sub_category_src_id
             ) source       
           ON (target.BOOK_SRC_ID = source.BOOK_ID AND
			   target.source_system = ñ_source_retail AND
			   target.source_entity = c_sa_books) 
            
       WHEN MATCHED THEN 
           UPDATE SET target.is_active = 'no',
                      target.END_DT = sysdate,
                      target.UPDATE_DT = sysdate                       
            
           WHERE ( DECODE(target.ISBN, source.ISBN, 0, 1) +
                   DECODE(target.PUBLISHER, source.PUBLISHER, 0, 1) +
                   DECODE(target.BOOK_TITLE, source.BOOK_TITLE, 0, 1) +
                   DECODE(target.AUTHOR_ID, source.AUTHOR_ID, 0, 1) +
                   DECODE(target.SUB_CATEGORY_SURR_ID, source.SUB_CATEGORY_ID, 0, 1) +
                   DECODE(target.YEAR_OF_PUBLICATION, source.YEAR_OF_PUBLICATION, 0, 1) ) > 0
           
       WHEN NOT MATCHED THEN 
           INSERT (target.book_id, target.book_src_id, target.source_system, target.source_entity, target.isbn,
                   target.publisher, target.book_title, target.year_of_publication, target.author_id,
                   target.sub_category_surr_id, target.start_dt, target.end_dt, target.is_active, target.update_dt, target.insert_dt) 
           VALUES (nf_ce_books_seq.NEXTVAL, source.BOOK_ID, ñ_source_retail, c_sa_books, source.isbn,
                   source.publisher, source.book_title, source.year_of_publication, source.author_id,
                   source.sub_category_id, TO_DATE('01011970', 'MMDDYY'),  TO_DATE('01019999', 'MMDDYY'), 'yes', sysdate, sysdate);

       insert_msg_log( ñ_source_retail, c_sa_books, 'ld_ce_books',  'processed ' || SQL%ROWCOUNT || ' rows'); 
       COMMIT;

       INSERT INTO nf_ce_books(book_id, book_src_id, source_system, source_entity, isbn,
                               publisher, book_title, year_of_publication, author_id,
                               sub_category_surr_id, start_dt, end_dt, is_active, update_dt, insert_dt) 
       
       SELECT wrk.book_id, wrk.book_src_id, wrk.source_system, wrk.source_entity, wrk.isbn,
              wrk.publisher, wrk.book_title, wrk.year_of_publication, wrk.author_id,
              wrk.sub_category_surr_id, wrk.start_dt, wrk.end_dt, wrk.is_active, wrk.update_dt, wrk.insert_dt              
       FROM wrk_books wrk;
       insert_msg_log( ñ_source_retail, 'wrk_books', 'ld_ce_books',  'processed ' || SQL%ROWCOUNT || ' rows'); 
       COMMIT;
        
       EXECUTE IMMEDIATE 'TRUNCATE TABLE wrk_books';

	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, c_sa_authors, 'ld_ce_authors', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK;
	END ld_ce_books;

	PROCEDURE ld_ce_book_author
	IS 
	BEGIN
        insert_msg_log( ñ_source_retail, c_sa_books, 'ld_ce_book_author', 'start execution');
        
        MERGE INTO nf_ce_book_author target              
        USING (SELECT NVL(ceb.book_id, -1) BOOK_ID,           
                      NVL(cea.author_id, -1) AUTHOR_ID
                      FROM sar_books sab
                      LEFT JOIN nf_ce_authors cea on sab.author_id = cea.author_src_id
                      LEFT JOIN nf_ce_books ceb on trim('"' from sab.book_id) = ceb.book_src_id ) source       
            ON (target.BOOK_SURR_ID = source.BOOK_ID and
                target.AUTHOR_SURR_ID = source.AUTHOR_ID)             
           
        WHEN NOT MATCHED THEN 
            INSERT (target.BOOK_SURR_ID, target.AUTHOR_SURR_ID) 
            VALUES (source.BOOK_ID, source.AUTHOR_ID); 
            
        insert_msg_log( ñ_source_retail, c_sa_books, 'ld_ce_book_author',  'processed ' || SQL%ROWCOUNT || ' rows'); 
        COMMIT;

	EXCEPTION
		WHEN OTHERS THEN 
            insert_msg_log( ñ_source_retail, c_sa_books, 'ld_ce_book_author', 'exception', 1, SQLCODE, SUBSTR(SQLERRM, 1, 300) ); 
			ROLLBACK;
	END;

END PKG_3NF_BOOKS;
