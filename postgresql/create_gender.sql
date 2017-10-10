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

--
select gender_agg();
select * from tmp_gender;


--#####################################################
-- Join function
DO
$$
DECLARE
    join_tbl varchar(100):= 'insto_data_analytics_dev.cc_raw_dim_merchant_Locn_fake';
    from_tbl varchar(100):= 'insto_data_analytics_dev.cc_raw_dim_merchant_Locn_fake';
    join_tbl_key varchar(100) := 'id_merchant_locn';
    from_tbl_key varchar(100) := 'id_merchant_locn';

BEGIN

END;
$$




--######################################################
DROP FUNCTION create_table(integer);
CREATE OR REPLACE FUNCTION public.create_table(table_id integer)
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
ALTER FUNCTION public.create_table(integer)
  OWNER TO gcppoc;
