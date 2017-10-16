DO
$BODY$
DECLARE
    qry text := '';
    tmp_qry text;
    ele text;
    ele1 text;
    agg_m text;
    agg_col_name_m text;
    
    agg_col_name text := 'a_prchsd';
    alias text := 'txn_merch_cust_card';
    entity text := 'cust';    
    attrbt_nm_metadata_array TEXT[] := ARRAY['metadata.gndr', 'metadata.custage_bin']; -- same length with attrbt_type_array
    attrbt_type_array text[] := array['gndr','age'];
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
    	    RAISE NOTICE 'M: %', m;
    
    
	    FOR i IN 1..array_length(attrbt_type_array, 1) LOOP    
		IF array_length(attrbt_type_array, 1) <> array_length(attrbt_nm_metadata_array, 1) THEN
		    RAISE NOTICE 'No. of attribute type % <> No. of metadata table %', array_length(attrbt_type_array, 1), array_length(attrbt_nm_metadata_array, 1);
		    EXIT;
		END IF;		
		--RAISE NOTICE 'current attribute is %', attrbt_type_array[i];
		--RAISE NOTICE 'I: %', i;

		--
		tmp_qry := '';
		IF attrbt_type_array[i] = 'age' THEN
		     FOR ele, ele1 in EXECUTE format('SELECT attrbt_lwr_lmt, attrbt_uppr_lmt FROM %s;', attrbt_nm_metadata_array[i]) LOOP
			 tmp_qry := format(', %s(CASE WHEN  %s.%s BETWEEN %s AND %s THEN 1*%s END) AS %s_%s_%s_%s_%s', agg_m, alias, attrbt_type_array[i], ele, ele1, agg_col_name_m, entity, attrbt_type_array[i], ele, ele1, agg_nm[m]);
				--RAISE NOTICE 'tmp_qry: %', tmp_qry;

			 qry := qry || tmp_qry;
				--RAISE NOTICE 'qry: %', qry;
		     END LOOP;

		--    
		ELSE
		     FOR ele in EXECUTE format('SELECT attrbt_nm FROM %s;', attrbt_nm_metadata_array[i]) LOOP
			 tmp_qry := format(', %s(CASE WHEN  %s.%s = ''%s'' THEN 1*%s END) AS %s_%s_%s_%s', agg_m, alias, attrbt_type_array[i], ele, agg_col_name_m, entity, attrbt_type_array[i], ele, agg_nm[m]);
				--RAISE NOTICE 'tmp_qry: %', tmp_qry;

			 qry := qry || tmp_qry;
				--RAISE NOTICE 'qry: %', qry;
		     END LOOP;
			
		    --END LOOP;
		    
		END IF;		
		
	    END LOOP;
    END LOOP;

    RAISE NOTICE 'qry: %', qry;
    --RETURN qry;

END;
$BODY$
