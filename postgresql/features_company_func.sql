CREATE OR REPLACE FUNCTION gender_agg(
metatbl_name varchar(100) default 'gender_metadata', 
metadata_col varchar(100) default 'gender',
datatbl_name varchar(100) default 'insto_data_analytics_dev.cc_raw_dim_customer_fake',
agg_col varchar(100) default 'c_gender',
new_colnm varchar(100) default 'cnt'
)RETURNS VOID AS
$$
DECLARE
    --agg_col varchar(100) := 'c_gender';
    --metadata_col varchar(100) := 'gender';
    ele varchar(1);
    query text; 
BEGIN
    query := format('Select %s', agg_col);

    FOR ele IN EXECUTE format('SELECT %I FROM %I', metadata_col ,metatbl_name) LOOP
	RAISE NOTICE 'The current element is: %', ele;

    query := query ||  format(', COUNT(CASE WHEN %s = ''%s'' THEN 1 ELSE NULL END) AS %s_%s ', agg_col, ele, new_colnm,  ele); 
    END LOOP;

    query := query || format('From %s GROUP BY %s' , datatbl_name, agg_col);        
    query := format('DROP TABLE IF EXISTS tmp_gender; CREATE TEMPORARY TABLE tmp_gender AS %s', query);
    
    RAISE NOTICE 'The query is: %', query;

    EXECUTE query; 
END;
$$
LANGUAGE plpgsql;



--################################################
select gender_agg();
select * from tmp_gender;


--#######################################################################################################
DROP FUNCTION if exists create_tbl_fm_metadata(integer);
CREATE OR REPLACE FUNCTION public.create_tbl_fm_metadata(table_id integer)
  RETURNS text AS
$BODY$

	DECLARE 
		qry_get_table_name text;
		qry_get_build_metadata text;
		target_column_name varchar(100);
		column_name varchar(100);
		column_aggregation_type varchar(100);
		column_filter varchar(100);
		qry_aggregations text := 'SELECT count(distinct txn_merch_cust_card.id_customer) cust_cnt';
		--qry_aggregations text default ' count(distinct txn_merch_cust_card.id_customer) cust_cnt';
		from_tbl text := 'txn_merch_cust_card';
		groupby_col text := 'id_merchant_locn';
	BEGIN
		-- get name of table to be created. 
		qry_get_table_name:= format('SELECT table_name from metadata.cc_features WHERE table_id=%s', table_id);
		EXECUTE qry_get_table_name INTO target_column_name;

		-- get metadata details for the table to be created. 
		qry_get_build_metadata:= format('SELECT column_name, column_aggregation_type, column_filter from metadata.build_details where table_id =%s', table_id);
	
		FOR column_name, column_aggregation_type, column_filter IN
			EXECUTE qry_get_build_metadata
			LOOP
				IF column_filter IS NULL AND column_aggregation_type IS NULL THEN
					qry_aggregations:= qry_aggregations || ', ' || column_name;
				ELSEIF column_aggregation_type IS NOT NULL AND column_filter IS NULL THEN
					qry_aggregations:= qry_aggregations || ', ' || column_aggregation_type || '(a_prchsd) ' || 'AS ' || column_name; -- else 0 end
				ELSEIF column_aggregation_type IS NOT NULL AND column_filter LIKE 'BETWEEN %' THEN
					qry_aggregations:= qry_aggregations || ', ' || column_aggregation_type || '(CASE WHEN n_age '|| column_filter || ' THEN 1 ELSE NULL END) as ' || column_name;
				ELSE
					qry_aggregations:=  format('%s, %s(CASE WHEN c_gender = ''%s'' THEN 1 ELSE NULL END) as %s ', qry_aggregations, column_aggregation_type, column_filter, column_name);
				END IF;	
			END LOOP;
		RETURN qry_aggregations || ' from ' || from_tbl || ' group by ' || groupby_col;
	END;
$BODY$
  LANGUAGE plpgsql;

--
ALTER FUNCTION public.create_tbl_fm_metadata(integer)
  OWNER TO gcppoc;


 --##########################################################

Create or Replace dupl_cc_features_company 
 
  select column_name as col_nm, data_type, character_maximum_length as char_max_len from information_schema.columns
  where table_schema = 'credit_card_feature' 
  and table_name = 'cc_features_company';


--#######################################################################################################
select * from public.txn_merch_cust_card limit 10;

--
select create_tbl_fm_metadata(1)

--#######################################################################################################
DO $$
    DECLARE
	dyn_query text;
	encap_query text;
	new_tbl_nm text := 'func_to_create_company_feature';
	
	
    BEGIN
	    EXECUTE 'select create_tbl_fm_metadata(1)' INTO dyn_query;
	    RAISE NOTICE 'Dyn QUERY: %', dyn_query;
	    encap_query := 'CREATE TABLE ' || new_tbl_nm || ' AS ( ' || dyn_query || ' )';

	    RAISE NOTICE 'FULL QUERY: %', encap_query;
	    EXECUTE encap_query;

	    RAISE NOTICE 'Table % is created', new_tbl_nm;
    END;
$$;



--select * from create_table(1);



-- #########################################
-- DROP TABLE IF EXISTS txn_merch_cust_card;
-- CREATE TABLE txn_merch_cust_card as
-- (
-- 		SELECT txn_merch_card.a_prchsd, txn_merch_card.id_day, txn_merch_card.weekdays, txn_merch_card.months,txn_merch_card.id_customer
-- 		, txn_merch_card.nm_terml, txn_merch_card.id_merchant_locn, txn_merch_card.id_industry_clsfn, txn_merch_card.hr
-- 		, cust.n_age, cust.c_gender
-- 		FROM
-- 		(-- join customer information with merch and txn
-- 			SELECT txn_merch.a_prchsd, txn_merch.id_plastic_card, txn_merch.nm_terml, txn_merch.id_merchant_locn, txn_merch.id_day, txn_merch.id_industry_clsfn
-- 			 , to_char(txn_merch.id_day, 'day') weekdays
-- 			 , to_char(txn_merch.id_day, 'mon') months
-- 			 , to_char(txn_merch.id_time_of_day, 'HH24') hr
-- 			 , card.id_customer
-- 			FROM
-- 			( -- join merch information with txn
-- 
-- 				SELECT txn.a_prchsd, txn.id_plastic_card, to_date(to_char(txn.id_day, '99999999'), 'YYYYMMDD') id_day
-- 				,  to_timestamp(to_char(txn.id_time_of_day, '999999'),'HH24MISS') id_time_of_day 
-- 				, merch_locn_pos.nm_terml, merch_locn_pos.id_merchant_locn, merch_locn_pos.id_industry_clsfn
-- 				FROM
-- 				(-- get merch infor by joining merch locn and merch pos
-- 					SELECT DISTINCT merch_pos.nm_terml, merch_pos.id_merchant_locn, merch_pos.id_merchant_pos, merch_locn.id_industry_clsfn
-- 					FROM
-- 					(
-- 						SELECT id_merchant_locn, nm_state, id_industry_clsfn 
-- 						FROM insto_data_analytics_dev.cc_raw_dim_merchant_Locn_fake 
-- 						WHERE id_merchant_locn IN (681551, 667140, 183950, 215864)					
-- 					) merch_locn
-- 					INNER JOIN insto_data_analytics_dev.cc_raw_dim_merchant_Pos_fake merch_pos
-- 					ON merch_locn.id_merchant_locn = merch_pos.id_merchant_locn
-- 					ORDER BY merch_pos.id_merchant_locn, merch_pos.nm_terml
-- 				)merch_locn_pos
-- 				INNER JOIN insto_data_analytics_dev.cc_raw_fct_base_card_fake txn
-- 				ON merch_locn_pos.id_merchant_pos = txn.id_merchant_pos
-- 			)txn_merch
-- 			INNER JOIN insto_data_analytics_dev.cc_raw_dim_plastic_card_fake card
-- 			ON txn_merch.id_plastic_card = card.id_plastic_card
-- 		) txn_merch_card
-- 		INNER JOIN insto_data_analytics_dev.cc_raw_dim_customer_fake cust
-- 		ON txn_merch_card.id_customer = cust.id_customer
-- )