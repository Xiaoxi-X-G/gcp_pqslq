-- CREATE OR REPLACE FUNCTION public.featuretable_agg_case_statement2(
--     attrbt_type_array text[],
--     col_name_array text[],
--     agg_function text,
--     agg_col_name text,
--     prefix text,
--     suffix text,
--     alias_nm text)
--   RETURNS text AS
-- $BODY$


Do $$
-- declare variables
DECLARE 
	qry varchar default '';
	i int := 1;
	case_array TEXT[];
	nm_array TEXT[];
	attrbt_lmt_array TEXT[][];
	attrbt_nm_array TEXT[];
	attrbt_nm_col_array TEXT[];

	-- identify different metadata table
	attrbt_nm_metadata_array TEXT[] default ARRAY['gndr', 'dyofwk', 'hr', 'mth', 'state'];
	-- quote_attrbt_nm_metadata_array TEXT[] default ARRAY['gndr', 'dyofwk', 'mth', 'state']; -- do not delete
	attrbt_lmt_metadata_array TEXT[] default ARRAY['custage_bin'];
	
BEGIN 
    -----------------------------------------------------------------------------
    -- Get attribute name
    -- Form the AND statements
	-- e.g. (custgndr=$$F$$) AND (custstate=$$vic$$) AND (custage BETWEEN 0 AND 4)
	-- Construct new column names
	-- e.g. custgndr_f_custstate_vic_custage_0_4 
    -----------------------------------------------------------------------------

    FOR i IN 1..array_length(attrbt_type_array, 1) LOOP

    	-- if metadata table does not exist, skip and continue 
    	IF NOT (attrbt_type_array[i] = ANY (attrbt_nm_metadata_array||attrbt_lmt_metadata_array)) THEN
    		RAISE NOTICE 'public.generate_agg_case_statement(): % is not a metadata table. Skipped.', attrbt_type_array[i];
    		CONTINUE;
    	
    	-- if metadata table is of attrbt_nm type
    	ELSIF attrbt_type_array[i] = ANY (attrbt_nm_metadata_array) THEN
    		RAISE NOTICE '% in attrbt_nm_metadata', attrbt_type_array[i];
    		
    		-- get attribute names    		 
		    EXECUTE FORMAT('SELECT public.metadata_read_attrbt_nm(''%s'')', attrbt_type_array[i]) INTO attrbt_nm_array;		    
		    
		    -- form part of column name e.g. custgndr_f
		    EXECUTE FORMAT('SELECT public.array_text_product(''%s'', ''%s'')',
		    	ARRAY[col_name_array[i]||'_'], attrbt_nm_array) INTO attrbt_nm_col_array;

		    -- dollar-quote attribute array e.g. $$F$$
		    attrbt_nm_array = public.array_text_product(public.array_text_product(array['$$'],attrbt_nm_array),array['$$']);

		    -- do not delete: to skip quoting for non-quote attribute, unquote quote_attrbt_nm_metadata_array and do the following
		    -- IF attrbt_type_array[i] = ANY (quote_attrbt_nm_metadata_array) THEN
		    -- 	attrbt_nm_array = public.array_text_product(public.array_text_product(array['$$'],attrbt_nm_array),array['$$']);
		    -- END IF;
		    
		    -- form comparison statement e.g. (custgndr=$$F$$)
		    EXECUTE FORMAT('SELECT public.array_text_product(''%s'', array_text_product(''%s'', ''%s''))',
		    	ARRAY['('||col_name_array[i]||'='], attrbt_nm_array, array[')']) INTO attrbt_nm_array;		    


		-- if metadata table is of attrbt_lmt type (under dev)
    	ELSIF attrbt_type_array[i] = ANY (attrbt_lmt_metadata_array) THEN
    		RAISE NOTICE '% in attrbt_lmt_metadata', attrbt_type_array[i]; 

    		-- get attribute limits into 2D array
		    EXECUTE FORMAT('SELECT public.metadata_read_attrbt_lmt(''%s'')', attrbt_type_array[i]) INTO attrbt_lmt_array;
		    
		    -- form part of column name e.g. custage_0_4
		    EXECUTE FORMAT('SELECT public.array_text_product(public.array_text_product(''%s'', ''%s''), public.array_text_product(''%s'', ''%s''))',
		    	array[col_name_array[i]||'_'], attrbt_lmt_array[1:1], ARRAY['_'], attrbt_lmt_array[2:2]) INTO attrbt_nm_col_array;

		    -- form comparison statement e.g. (custage BETWEEN 0 AND 4)
		    -- concatenate '(custage BETWEEN' || '0' || 'AND'
		    EXECUTE FORMAT('SELECT public.array_text_product(''%s'', public.array_text_product(''%s'', ''%s''))',
		    	array['('||col_name_array[i]||' BETWEEN '], attrbt_lmt_array[1:1], array[' AND ']) INTO attrbt_nm_array;
		    
		    -- RAISE NOTICE '%', attrbt_nm_array;
		    
		    -- concatenate '(custage BETWEEN 0 AND' || '4' || ')'
		    EXECUTE FORMAT('SELECT array_text_product(array_text_sum (''%s'',''%s''), ''%s'')',
		    	attrbt_nm_array, array_unnest_2d_1d(attrbt_lmt_array[2:2]), array[')']) INTO attrbt_nm_array;	    

		    -- RAISE NOTICE '%', attrbt_nm_array;

		    
    	END IF;

	    
	    
	    IF i = 1 THEN
	    	case_array = attrbt_nm_array;
	    	nm_array = attrbt_nm_col_array;
	    ELSE
	    	-- form boolean statement
	    	-- e.g. (custgndr=$$F$$) AND (custstate=$$vic$$) AND (custage BETWEEN 0 AND 4)
	    	EXECUTE FORMAT('SELECT public.array_text_product(''%s'', public.array_text_product(''%s'', ''%s''))',
	    		case_array, array[' AND '], attrbt_nm_array) INTO case_array;

	    	-- form column name 
	    	-- e.g. custgndr_f_custstate_vic_custage_0_4
	    	EXECUTE FORMAT('SELECT public.array_text_product(''%s'', public.array_text_product(''%s'', ''%s''))',
	    		nm_array, array['_'], attrbt_nm_col_array) INTO nm_array;
	    END IF;
	END LOOP;

    -----------------------------------------------------------------------------
	-- Replace dollar quote with single quote
	-- e.g. (custgndr='F') AND (custstate='vic') AND (custage BETWEEN 0 AND 4) 
    -----------------------------------------------------------------------------

  	-- try to use array_replace but not working
	-- case_array = array_replace(case_array, '$$', '''');
	case_array = public.array_text_replace(case_array, '$$', '''');

	------------------------------------------------------------------------------------------
	-- Generate single case query 
	-- e.g. count(CASE WHEN (custgndr='F') AND (custstate='vic') AND (custage BETWEEN 0 AND 4)
	-- 		THEN 1 ELSE NULL END) cust_custgndr_f_custstate_vic_custage_0_4_cnt
	------------------------------------------------------------------------------------------

	i = 1;
	FOR i IN 1..array_length(case_array, 1) LOOP

		IF agg_function = 'count' THEN
			qry := qry || FORMAT(', COUNT(CASE WHEN %s THEN 1 ELSE NULL END) %s_%s_%s'
				, case_array[i], prefix, nm_array[i], suffix);

		ELSIF agg_function = 'sum' THEN
			qry := qry || FORMAT(', SUM(CASE WHEN %s THEN %s ELSE 0 END) %s_%s_%s'
				, case_array[i], agg_col_name, prefix, nm_array[i], suffix);

		END IF; 

		i = i + 1;
	END LOOP;

	--for testing
  RAISE NOTICE '%', qry;


RETURN qry;
END
$$;
