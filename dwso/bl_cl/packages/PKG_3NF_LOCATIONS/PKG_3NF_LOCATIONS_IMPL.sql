CREATE OR REPLACE PACKAGE BODY PKG_3NF_LOCATIONS AS 
/*
    Package for load tables to layer BL_3NF: ce_regions, ce_countries, ce_cities,
    ce_addresses
*/
    ñ_source_retail CONSTANT VARCHAR(6) := 'RETAIL';
    c_sa_regions CONSTANT VARCHAR(10) := 'SA_REGIONS';
    c_sa_countries CONSTANT VARCHAR(12) := 'SA_COUNTRIES';
    c_sa_cities CONSTANT VARCHAR(9) := 'SA_CITIES';     
    c_sa_addresses CONSTANT VARCHAR(12) := 'SA_ADDRESSES'; 
   
    PROCEDURE ld_ce_regions
    IS 
        TYPE set_region IS TABLE OF sar_regions%ROWTYPE INDEX BY PLS_INTEGER; 
        s_region set_region;      
    BEGIN
        insert_msg_log( ñ_source_retail, c_sa_regions, 'ld_ce_regions', 'start execution'); 
        
        SELECT *
        BULK COLLECT INTO s_region
        FROM sar_regions;
        
        FORALL indx in s_region.FIRST .. s_region.LAST
            MERGE INTO nf_ce_regions target              
            USING (SELECT sar.REGION_ID,
                          sar.REGION_NAME
                   FROM sar_regions sar
                   WHERE sar.REGION_ID = s_region(indx).REGION_ID
                   ) source       
                ON (target.REGION_SRC_ID = source.REGION_ID AND
                    target.SOURCE_SYSTEM = ñ_source_retail AND
                    target.SOURCE_ENTITY = c_sa_regions) 
                
            WHEN MATCHED THEN
                UPDATE SET target.REGION = source.REGION_NAME,
                           target.UPDATE_DT  = sysdate
                WHERE target.REGION <> source.REGION_NAME
                
            WHEN NOT MATCHED THEN 
                INSERT (target.REGION_ID, target.REGION_SRC_ID, target.REGION, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, target.update_dt, target.insert_dt) 
                VALUES (nf_ce_regions_seq.NEXTVAL, source.REGION_ID, source.REGION_NAME, ñ_source_retail, c_sa_regions, sysdate, sysdate); 
    
        insert_msg_log( ñ_source_retail, c_sa_regions, 'ld_ce_regions', 'processed ' || SQL%ROWCOUNT || ' rows'); 
        COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN 
            ROLLBACK;
    END ld_ce_regions;

    PROCEDURE ld_ce_countries
    IS 
    BEGIN  
        insert_msg_log( ñ_source_retail, c_sa_countries, 'ld_ce_countries', 'start execution'); 
        
        MERGE INTO nf_ce_countries target              
        USING (SELECT trim('"' from sac.COUNTRY_ID) COUNTRY_ID,
                      trim('"' from sac.COUNTRY) COUNTRY,
                      NVL(bcr.REGION_ID, -1) REGION_ID
               FROM sar_countries sac 
               LEFT JOIN nf_ce_regions bcr ON sac.REGION_ID = bcr.REGION_SRC_ID
               AND bcr.SOURCE_SYSTEM = ñ_source_retail
               AND bcr.SOURCE_ENTITY = c_sa_regions
             ) source       
            ON (target.COUNTRY_SRC_ID = source.COUNTRY_ID AND
                target.SOURCE_SYSTEM = ñ_source_retail AND
                target.SOURCE_ENTITY = c_sa_countries) 
            
        WHEN MATCHED THEN
            UPDATE SET target.COUNTRY = source.COUNTRY,
                       target.REGION_SURR_ID = source.REGION_ID,
                       target.UPDATE_DT = sysdate
            WHERE (DECODE(target.COUNTRY, source.COUNTRY, 0, 1) +
                   DECODE(target.REGION_SURR_ID, source.REGION_ID, 0, 1)) > 0
        WHEN NOT MATCHED THEN 
            INSERT (target.COUNTRY_ID, target.COUNTRY_SRC_ID, target.COUNTRY, 
                    target.region_surr_id, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, target.update_dt, target.insert_dt) 
            VALUES (nf_ce_countries_seq.NEXTVAL, trim('"' from source.COUNTRY_ID), trim('"' from source.COUNTRY), 
                    source.REGION_ID, ñ_source_retail, c_sa_countries, sysdate, sysdate); 
    
        insert_msg_log( ñ_source_retail, c_sa_countries, 'ld_ce_countries', 'processed ' || SQL%ROWCOUNT || ' rows');    
        COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN 
            ROLLBACK;
    END ld_ce_countries;

    PROCEDURE ld_ce_cities
    IS 
        TYPE CUR_CITY IS REF CURSOR;
        cv_city CUR_CITY;   
        r_city sar_cities%ROWTYPE;
        sql_stmt VARCHAR2(4000);     
        number_row NUMERIC;
    
    BEGIN
        insert_msg_log( ñ_source_retail, c_sa_cities, 'ld_ce_cities', 'start execution'); 

        number_row := 0;
        sql_stmt := 'SELECT sac.CITY_ID, sac.CITY, NVL(bcc.COUNTRY_ID,-1) COUNTRY_ID, sac.INSERT_DT, sac.UPDATE_DT ' ||
                    'FROM sar_cities sac ' ||
                    'LEFT JOIN nf_ce_countries bcc ON sac.COUNTRY_ID = bcc.COUNTRY_SRC_ID ' ||
                    'AND bcc.SOURCE_SYSTEM = ''RETAIL'' ' ||
                    'AND bcc.SOURCE_ENTITY = ''SA_COUNTRIES''';
        OPEN cv_city FOR sql_stmt;

        LOOP
              FETCH cv_city INTO r_city;

                INSERT INTO nf_ce_cities(CITY_ID, CITY_SRC_ID, CITY, COUNTRY_SURR_ID, SOURCE_SYSTEM, SOURCE_ENTITY, update_dt, insert_dt) 
                SELECT nf_ce_cities_seq.NEXTVAL, r_city.CITY_ID, r_city.CITY, r_city.COUNTRY_ID, ñ_source_retail, c_sa_cities, sysdate, sysdate
                FROM dual
                WHERE NOT EXISTS ( SELECT ncity.CITY_ID
                                   FROM nf_ce_cities ncity 
                                   WHERE ncity.CITY_SRC_ID = r_city.CITY_ID
                                   AND ncity.SOURCE_SYSTEM = ñ_source_retail 
                                   AND ncity.SOURCE_ENTITY = c_sa_cities );
                
                number_row := number_row + SQL%ROWCOUNT;       
                
                UPDATE nf_ce_cities
                SET CITY = r_city.CITY,
                    COUNTRY_SURR_ID = r_city.COUNTRY_ID,
                    UPDATE_DT = sysdate
                    
                WHERE CITY_SRC_ID = r_city.CITY_ID
                  AND SOURCE_SYSTEM = ñ_source_retail 
                  AND SOURCE_ENTITY = c_sa_cities
                  AND (DECODE(CITY, r_city.CITY, 0, 1) + 
                       DECODE(COUNTRY_SURR_ID, r_city.COUNTRY_ID, 0, 1)) > 0;

                number_row := number_row + SQL%ROWCOUNT;       
                
              EXIT WHEN cv_city%NOTFOUND;
        END LOOP;
        insert_msg_log( ñ_source_retail, c_sa_cities, 'ld_ce_cities', 'processed ' || number_row || ' rows');  
        CLOSE cv_city;
        COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN 
            ROLLBACK;
    END ld_ce_cities;


	PROCEDURE ld_ce_addresses
	IS 
	BEGIN
        insert_msg_log( ñ_source_retail, c_sa_addresses, 'ld_ce_addresses', 'start execution'); 
        
		MERGE INTO nf_ce_addresses target              
		USING (SELECT trim('"' from saa.ADDRESS_ID) ADDRESS_ID,
					  trim('"' from saa.ADDRESS) ADDRESS,
					  trim('"' from saa.postal_code) POSTAL_CODE,
					  NVL(bcc.CITY_ID, -1) CITY_ID
			   FROM sar_address saa 
			   LEFT JOIN nf_ce_cities bcc ON saa.CITY_ID = bcc.CITY_SRC_ID
			   AND bcc.SOURCE_SYSTEM = ñ_source_retail
			   AND bcc.SOURCE_ENTITY = c_sa_cities) source           
			ON (target.ADDRESS_SRC_ID = source.ADDRESS_ID AND
				target.SOURCE_SYSTEM = ñ_source_retail AND
				target.SOURCE_ENTITY = c_sa_addresses) 
			
		WHEN MATCHED THEN
			UPDATE SET target.ADDRESS = source.ADDRESS,                      
					   target.POSTAL_CODE = source.POSTAL_CODE,
					   target.CITY_SURR_ID = source.CITY_ID,
					   target.UPDATE_DT = sysdate
			WHERE (DECODE(target.ADDRESS, source.ADDRESS, 0, 1) +                
				   DECODE(target.POSTAL_CODE, source.POSTAL_CODE, 0, 1) +
				   DECODE(target.CITY_SURR_ID, source.CITY_ID, 0, 1)) > 0 
				  
		WHEN NOT MATCHED THEN 
			INSERT (target.ADDRESS_ID, target.ADDRESS_SRC_ID, target.ADDRESS, target.postal_code, target.CITY_SURR_ID, target.SOURCE_SYSTEM, target.SOURCE_ENTITY, target.update_dt, target.insert_dt) 
			VALUES (nf_ce_addresses_seq.NEXTVAL, to_number(trim('"' from source.ADDRESS_ID)), trim('"' from source.ADDRESS), NVL(trim('"' from source.postal_code), 'NA'),  source.CITY_ID, ñ_source_retail, c_sa_addresses, sysdate, sysdate); 

        insert_msg_log( ñ_source_retail, c_sa_addresses, 'ld_ce_addresses', 'processed ' || SQL%ROWCOUNT || ' rows');   
		COMMIT;
        
	EXCEPTION
		WHEN OTHERS THEN 
			ROLLBACK;
	END ld_ce_addresses;
    
END PKG_3NF_LOCATIONS;

