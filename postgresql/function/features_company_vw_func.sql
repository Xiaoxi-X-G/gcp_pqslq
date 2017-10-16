-- CREATE OR REPLACE FUNCTION cmpny_feature_tbl_agg(
-- 	attrbt_nm_metadata_array TEXT[],
-- 	attrbt_type_array text[]
-- ) RETURNS TEXT AS
DO
$$
DECLARE
    qry text := '';
    tmp_qry text;
    ele text;
    ele1 text;
    agg_m text;
    agg_col_name_m text;
    entity text;
    
    core_tbl_nm text := 'txn_merch_cust_card';     
    cor_tbl_entity text[] := array['cust','txn'];
    cor_tbl_attrbt text[] := array['cnt','amt'];
    
       
    attrbt_nm_metadata_array TEXT[] := ARRAY['metadata.gndr']; -- same length with attrbt_type_array
    attrbt_type_array text[] := array['gndr'];
    --
    agg_nm text[] := array['percust','pertxn','pcn']; -- apply for all attrbt_type 
    --
    
    m int:= 1;
    n int:= 1;
    i int:= 1;
    j int:= 1;
    
BEGIN

    -- for each entity, ie: custamt, custcnt, txnamt, txncnt 
    FOR i IN 1..array_length(cor_tbl_entity,1) LOOP
	FOR j IN 1..array_length(cor_tbl_attrbt,1) LOOP
	
	
	    entity := cor_tbl_entity[i] || cor_tbl_attrbt[j];	    
	    --RAISE NOTICE 'CURRENT ENTITY %', entity;

	    
            -- loop through all attrbt, ie: percust, pertxn, pcn
            FOR m IN 1..array_length(agg_nm,1) LOOP
                            
                -- exclude custamt_XX_percust
	        IF cor_tbl_entity[i] = 'custamt' AND agg_nm[m] = 'percust' THEN
	    	    CONTINUE;
	        ELSIF cor_tbl_entity[i] = 'custcnt' AND agg_nm[m] = 'percust' THEN
	            CONTINUE;
	        ELSE
                -- loop through each metadata table
                    FOR n IN 1..array_length(attrbt_nm_metadata_array, 1) LOOP  
                    -- INITAL tmp_qry
                        tmp_qry := '';

                        -- FOR AGE METADATA TABLE
                        IF attrbt_type_array[n] = 'age' THEN
			    FOR ele, ele1 in EXECUTE format('SELECT attrbt_lwr_lmt, attrbt_uppr_lmt FROM %s;', attrbt_nm_metadata_array[n]) LOOP
			        IF agg_nm[m] = 'pcn' THEN
					tmp_qry := format(', round(%s.%s_%s_%s_%s_%s/%s.%s_%s)::DECIMAL, 2) AS %s_%s_%s_%s',
						core_tbl_nm,cor_tbl_entity[i],attrbt_type_array[n], ele, ele1, cor_tbl_attrbt[j], core_tbl_nm,cor_tbl_entity[i],cor_tbl_attrbt[j], entity, attrbt_type_array[n],ele,agg_nm[m]);
                                ELSE
					tmp_qry := format(', round(%s.%s_%s_%s_%s_%s/%s.%s_%s_%s_%s)::DECIMAL, 2) AS %s_%s_%s_%s',
						core_tbl_nm,cor_tbl_entity[i],attrbt_type_array[n], ele, ele1, cor_tbl_attrbt[j], core_tbl_nm,cor_tbl_entity[i], ele,ele1, cor_tbl_attrbt[j], entity, attrbt_type_array[n],ele,agg_nm[m]);
                                
                                END IF;
                                
                                RAISE NOTICE 'CURRENT QUERY: %',tmp_qry;
				qry := qry || tmp_qry;
			    END LOOP;
                        ELSE
                            FOR ele in EXECUTE format('SELECT attrbt_nm FROM %s;', attrbt_nm_metadata_array[n]) LOOP
                                RAISE NOTICE 'CURRENT cor_tbl_entity: %', cor_tbl_entity[i];
                                RAISE NOTICE 'CURRENT cor_tbl_attrbt: %', cor_tbl_attrbt[j];
                                
                                RAISE NOTICE 'CURRENT agg_nm: %', agg_nm[m];
                                RAISE NOTICE 'CURRENT ENTITY %', entity;

                                RAISE NOTICE 'CURRENT attrbt_nm_metadata_array %',attrbt_nm_metadata_array[n];
                                
                                RAISE NOTICE 'CURRENT ATTRIBUTE: %', ele;
                                
                                IF agg_nm[m] = 'pcn' THEN
					tmp_qry := format(', round(%s.%s_%s_%s_%s/%s.%s_%s)::DECIMAL, 2) AS %s_%s_%s_%s',
						core_tbl_nm,cor_tbl_entity[i],attrbt_type_array[n], ele, cor_tbl_attrbt[j], core_tbl_nm,cor_tbl_entity[i],cor_tbl_attrbt[j], entity, attrbt_type_array[n],ele,agg_nm[m]);
				ELSE
					tmp_qry := format(', round(%s.%s_%s_%s_%s/%s.%s_%s_%s)::DECIMAL, 2) AS %s_%s_%s_%s',
						core_tbl_nm,cor_tbl_entity[i],attrbt_type_array[n], ele, cor_tbl_attrbt[j], core_tbl_nm,cor_tbl_entity[i],ele, cor_tbl_attrbt[j], entity, attrbt_type_array[n],ele,agg_nm[m]);
				END IF;
                                RAISE NOTICE 'CURRENT QUERY: %',tmp_qry;
                                qry := qry || tmp_qry;
                            END LOOP;  
                        END IF;
                    END LOOP;	    
               END IF;
            END LOOP;

	    
	END LOOP;
    END LOOP;

    RAISE NOTICE 'ALL SUB_QUERY: %', qry;
END;
$$;