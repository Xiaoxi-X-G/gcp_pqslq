SELECT column_name, data_type
FROM information_schema.columns 
WHERE 
table_schema =  'credit_card_feature'
AND table_name = 'cc_features_company'


DO $$
DECLARE
sep text := ';';
table_schema text :=  'credit_card_feature';
table_name text := 'cc_features_company_view';
targ text := 'age';

ele text;
col_nm text := '';

BEGIN
    FOR ele IN EXECUTE format('SELECT column_name FROM information_schema.columns WHERE 
	table_schema = ''%s'' AND table_name = ''%s''; ',table_schema, table_name) LOOP
	IF ele LIKE '%dyofwk%' AND ele like 'txnamt_%' AND ele like '%_txn' THEN
	    col_nm := col_nm || sep || ele;
	ELSE 
	    CONTINUE;
	END IF;

	

    END LOOP;

    RAISE NOTICE 'ALL COLUMNS %', col_nm;

END;
$$;