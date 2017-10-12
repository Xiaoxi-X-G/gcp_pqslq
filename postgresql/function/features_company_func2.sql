DO $$
DECLARE
    qry text := '';
    tmp_qry text;
    ele text;
    agg_m text;
    agg_col_name_m text;
    
    agg_col_name text := 'a_prchsd';
    alias text := 'txn_merch_cust_card';
    entity text := 'cust';    
    attrbt_nm_metadata_array TEXT[] default ARRAY['metadata.gndr', 'metadata.hr', 'metadata.dyofwk','metadata.mth']; -- same length with attrbt_type_array
    attrbt_type_array text[] := array['gndr', 'hr', 'dyofwk','mth'];
    --
    agg_nm text[] := array['cnt','amt']; -- apply for all attrbt_type 
    agg_func text[] := array['count', 'sum']; 
    --

    m int := 1;
    i int := 1;
    j int := 1;
    
BEGIN

    FOR m IN 1..array_length(agg_func, 1) LOOP
    	    agg_m := agg_func[m];
    	    IF agg_m = 'count' THEN
		agg_col_name_m := '1';
	    ELSE 
	        agg_col_name_m := agg_col_name;
    	    END IF;
    
    
	    FOR i IN 1..array_length(attrbt_type_array, 1) LOOP    
		IF array_length(attrbt_type_array, 1) <> array_length(attrbt_nm_metadata_array, 1) THEN
		    RAISE NOTICE 'No. of attribute type % <> No. of metadata table %', array_length(attrbt_type_array, 1), array_length(attrbt_nm_metadata_array, 1);
		    EXIT;
		END IF;
		
		RAISE NOTICE 'current attribute is %', attrbt_type_array[i];


		--
		j := 1;
		tmp_qry := '';
		IF attrbt_type_array[i] = 'age_bins' THEN
		    FOR j in 1..array_length(agg_nm, 1) LOOP
			RAISE NOTICE 'current aggregation %', agg_nm;
		    END LOOP;

		--    
		ELSE
		    FOR j in 1..array_length(agg_nm, 1) LOOP
			RAISE NOTICE 'current aggregation %', agg_nm;
			
			--tmp_qry := format('SELECT attrbt_nm FROM %s;', attrbt_nm_metadata_array[i]);
			--RAISE NOTICE 'tmp_qry: %', tmp_qry;

			FOR ele in EXECUTE format('SELECT attrbt_nm FROM %s;', attrbt_nm_metadata_array[i]) LOOP
				tmp_qry := format(', %s(CASE WHEN  %s.%s = ''%s'' THEN 1*%s END) AS %s_%s_%s_%s', agg_m, alias, attrbt_type_array[i], ele, agg_col_name_m, entity, attrbt_type_array[i], ele, agg_nm[m]);
				--RAISE NOTICE 'tmp_qry: %', tmp_qry;

				qry := qry || tmp_qry;
				--RAISE NOTICE 'qry: %', qry;
			END LOOP;

			
		    END LOOP;


		    
		END IF;
		
		
	    END LOOP;
    END LOOP;

    RAISE NOTICE 'qry: %', qry;

END;
$$