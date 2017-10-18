CREATE OR REPLACE FUNCTION cmpny_feature_tbl_agg(
	attrbt_nm_metadata_array TEXT[],
	attrbt_type_array text[]
) RETURNS TEXT AS
$BODY$
DECLARE
    qry text := '';
    tmp_qry text;
    ele text;
    ele1 text;
    agg_m text;
    agg_col_name_m text;
    
    agg_col_name text[] := array['a_prchsd','id_customer'];
    alias text := 'txn_merch_cust_card';
    entity text := 'cust';    
    --attrbt_nm_metadata_array TEXT[] : ARRAY['metadata.gndr', 'metadata.hr', 'metadata.dyofwk','metadata.mth']; -- same length with attrbt_type_array
    --attrbt_type_array text[] := array['gndr', 'hr', 'dyofwk','mth'];
    --
    agg_nm text[] := array['cnt','amt']; -- apply for all attrbt_type 
    agg_func text[] := array['count', 'sum']; 
    --

    m int := 1;
    i int := 1;
    
    
BEGIN

    FOR m IN 1..array_length(agg_func, 1) LOOP
    	    agg_m := agg_func[m];
    	    IF agg_m = 'count' THEN
		agg_col_name_m := '1';
	    ELSE 
	        agg_col_name_m := agg_col_name[1];
    	    END IF;
    
    
	    FOR i IN 1..array_length(attrbt_type_array, 1) LOOP    
		IF array_length(attrbt_type_array, 1) <> array_length(attrbt_nm_metadata_array, 1) THEN
		    --RAISE NOTICE 'No. of attribute type % <> No. of metadata table %', array_length(attrbt_type_array, 1), array_length(attrbt_nm_metadata_array, 1);
		    EXIT;
		END IF;
		
		--RAISE NOTICE 'current attribute is %', attrbt_type_array[i];

		
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
		        IF agg_m = 'count' AND attrbt_type_array[i] = 'gndr' THEN
			    tmp_qry := format(', %s(DISTINCT(CASE WHEN  %s.%s = ''%s'' THEN %s END)) AS %s_%s_%s_%s', agg_m, alias, attrbt_type_array[i], ele, agg_col_name[2], entity, attrbt_type_array[i], ele, agg_nm[m]);
		        ELSE
			    tmp_qry := format(', %s(CASE WHEN  %s.%s = ''%s'' THEN 1*%s END) AS %s_%s_%s_%s', agg_m, alias, attrbt_type_array[i], ele, agg_col_name_m, entity, attrbt_type_array[i], ele, agg_nm[m]);
			--RAISE NOTICE 'tmp_qry: %', tmp_qry;
                        END IF;

			qry := qry || tmp_qry;
			--RAISE NOTICE 'qry: %', qry;
		    END LOOP;
		    
		END IF;
		
		
	    END LOOP;
    END LOOP;

    RAISE NOTICE 'qry: %', qry;
    RETURN qry;

END;
$BODY$
LANGUAGE plpgsql;


-- test
--select cmpny_feature_tbl_agg(ARRAY['metadata.gndr','metadata.custage_bin'], array['gndr', 'age']);

--
DO $$
DECLARE
 func_nm text := 'cmpny_feature_tbl_agg';
 arg1 text[] := array['metadata.gndr', 'metadata.hr', 'metadata.dyofwk','metadata.mth','metadata.custage_bin'];
 arg2 text[] := array['gndr', 'hr', 'dyofwk','mth','age'];

 tbl_nm text := 'xiaoxitest';

 tst text := '';
--
 mid_qry text := '';
 pre_qry text := 'select cmpnyid
	--, txn_merch_cust_card.id_merchant_locn
	, max(txn_merch_cust_card.id_industry_clsfn) industry_clsfn 
	, sum(txn_merch_cust_card.a_prchsd) Txnamt_Sum
	, ROUND(avg(txn_merch_cust_card.a_prchsd)::DECIMAL, 2) txmamt_mean
	, count(DISTINCT txn_merch_cust_card.id_customer) Cust_Cnt
	, count(txn_merch_cust_card.a_prchsd) Txn_Cnt
	, max(txn_merch_cust_card.id_day) last_date
	, min(txn_merch_cust_card.id_day) first_date'; 
 post_qry text := ' FROM
	(
		SELECT txn_merch_card.a_prchsd, txn_merch_card.id_day, txn_merch_card.weekdays as dyofwk, txn_merch_card.months as mth,txn_merch_card.id_customer
		,txn_merch_card.cmpnyid, txn_merch_card.nm_terml, txn_merch_card.id_merchant_locn, txn_merch_card.id_industry_clsfn, txn_merch_card.hr
		, cust.n_age as age, cust.c_gender as gndr
		FROM
		(-- join customer information with merch and txn
			SELECT txn_merch.a_prchsd, txn_merch.id_plastic_card, txn_merch.cmpnyid, txn_merch.nm_terml, txn_merch.id_merchant_locn, txn_merch.id_day, txn_merch.id_industry_clsfn
			 , to_char(txn_merch.id_day, ''dy'') weekdays
			 , to_char(txn_merch.id_day, ''mon'') months
			 , to_char(txn_merch.id_time_of_day, ''FMHH24'') hr
			 , card.id_customer
			FROM
			( -- join merch information with txn

				SELECT txn.a_prchsd, txn.id_plastic_card, to_date(to_char(txn.id_day, ''99999999''), ''YYYYMMDD'') id_day
				,  to_timestamp(to_char(txn.id_time_of_day, ''999999''),''FMHH24MISS'') id_time_of_day 
				, merch_locn_pos.cmpnyid, merch_locn_pos.nm_terml, merch_locn_pos.id_merchant_locn, merch_locn_pos.id_industry_clsfn
				FROM
				(-- get merch infor by joining merch locn and merch pos
					SELECT DISTINCT cmpny_merch_locn.cmpnyid,  cmpny_merch_locn.id_industry_clsfn
					,merch_pos.id_merchant_locn, merch_pos.id_merchant_pos, merch_pos.nm_terml
					FROM
					(
						SELECT cmp_merch.cmpnyid, cmp_merch.id_merchant_locn, merch_locn.nm_state, merch_locn.id_industry_clsfn 
						FROM
						(
						     SELECT cmpnyid, id_merchant_locn
						     FROM insto_data_analytics_dev.cc_dim_cmpnyid_mrchnt_map_fake
						     WHERE cmpnyid in (1,2)
						) cmp_merch
						INNER JOIN insto_data_analytics_dev.cc_raw_dim_merchant_locn_fake merch_locn
						ON merch_locn.id_merchant_locn = cmp_merch.id_merchant_locn				
					) cmpny_merch_locn
					INNER JOIN insto_data_analytics_dev.cc_raw_dim_merchant_Pos_fake merch_pos
					ON cmpny_merch_locn.id_merchant_locn = merch_pos.id_merchant_locn
					ORDER BY merch_pos.id_merchant_locn, merch_pos.nm_terml
				)merch_locn_pos
				INNER JOIN insto_data_analytics_dev.cc_raw_fct_base_card_fake txn
				ON merch_locn_pos.id_merchant_pos = txn.id_merchant_pos
			)txn_merch
			INNER JOIN insto_data_analytics_dev.cc_raw_dim_plastic_card_fake card
			ON txn_merch.id_plastic_card = card.id_plastic_card
		) txn_merch_card
		INNER JOIN insto_data_analytics_dev.cc_raw_dim_customer_fake cust
		ON txn_merch_card.id_customer = cust.id_customer

	) txn_merch_cust_card
	GROUP BY cmpnyid ';
 full_qry text := '';
BEGIN
    EXECUTE format('select %s(''%s'', ''%s'')', func_nm, arg1, arg2) INTO mid_qry;
    RAISE NOTICE 'mid-qry: %', mid_qry;

    full_qry := pre_qry || mid_qry || post_qry;
    RAISE NOTICE 'full-qry: %', full_qry;

    tst := format('DROP TABLE IF EXISTS %s; CREATE TABLE %s AS( %s);' ,tbl_nm, tbl_nm ,full_qry);
    RAISE NOTICE 'CREATE TABLE SQL: %', tst;
    EXECUTE tst;
END;
$$;