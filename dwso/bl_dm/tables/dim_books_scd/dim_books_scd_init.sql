INSERT INTO  BL_DM.dim_books_scd(book_surr_id, book_id, source_system, source_entity, isbn,
                                 publisher, book_title, year_of_publication, author_id, author, category_id, 
                                 category_name, sub_category_id, sub_category, start_dt, 
                                 end_dt, is_active, update_dt, insert_dt)    
                                 
SELECT -1, -1, 'NA', 'NA', 'NA', 'NA', 'NA', -1, -1, 'NA', -1,  
        'NA', -1 , 'NA', TO_DATE('01011970', 'MMDDYYYY'), TO_DATE('01019999', 'MMDDYYYY'), 'true', sysdate, sysdate
FROM dual
WHERE NOT EXISTS ( SELECT book_surr_id
                   FROM BL_DM.dim_books_scd
                   WHERE book_surr_id = -1 );
COMMIT;
