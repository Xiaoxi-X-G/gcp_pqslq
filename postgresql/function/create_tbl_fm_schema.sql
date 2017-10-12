-- DO $$
--     DECLARE 
-- 	tbl_schema_qry text;
-- 	create_tbl_qry text;
-- 	col_nm text;
-- 	data_type text;
-- 	char_max int;
-- 	no_row int;
-- 	cnter int := 0;
-- 	org_schema_nm text := 'credit_card_feature';
-- 	org_tbl_nm text := 'cc_features_company';
-- 	des_schema_name text := 'public';
-- 	des_tbl_nm text := 'tmp_cc_features_company';
-- 	
-- 
--     BEGIN
--     -- extract table schema and no of columns
-- 	tbl_schema_qry := format('SELECT column_name AS col_nm, data_type, character_maximum_length AS char_max_len FROM information_schema.columns WHERE 
-- 	table_schema = ''%s'' AND table_name = ''%s''; ',org_schema_nm, org_tbl_nm);	
-- 	RAISE NOTICE 'FULL QUERY: %', tbl_schema_qry;
-- 
-- 	EXECUTE format('SELECT count(data_type) FROM information_schema.columns WHERE 
-- 	table_schema = ''%s'' AND table_name = ''%s''; ',org_schema_nm, org_tbl_nm) into no_row;
-- 
--     -- run through each col and type construct create-table string 
--     	create_tbl_qry := format('CREATE TABLE %s.%s (', des_schema_name, des_tbl_nm);
-- 	FOR col_nm, data_type, char_max IN EXECUTE tbl_schema_qry
-- 	    LOOP
-- 		cnter := cnter + 1;
-- 		IF cnter = no_row THEN
-- 		    create_tbl_qry := create_tbl_qry || col_nm || ' ' || data_type; 
-- 		ELSE
-- 		    create_tbl_qry := create_tbl_qry || col_nm || ' ' || data_type ||',';
-- 		END IF;
-- 
-- 	    RAISE NOTICE 'Create table query: %', create_tbl_qry;
-- 	    END LOOP;
-- 
-- 	create_tbl_qry := create_tbl_qry || ')'; 
--     -- RAISE NOTICE 'Create table query: %', create_tbl_qry;
-- 
-- 	EXECUTE create_tbl_qry;
--     END;
-- $$;

-- ########################### create function to create table
CREATE OR REPLACE FUNCTION metadata.create_tbl_fm_ext_schema(
    	org_schema_nm text,
	org_tbl_nm text,
	des_schema_name text,
	des_tbl_nm text
) RETURNS VOID AS
$$
DECLARE
    	tbl_schema_qry text;
	create_tbl_qry text;
	col_nm text;
	data_type text;
	char_max int;
	no_row int;
	cnter int := 0;
	
BEGIN
	tbl_schema_qry := format('SELECT column_name AS col_nm, data_type, character_maximum_length AS char_max_len FROM information_schema.columns WHERE 
	table_schema = ''%s'' AND table_name = ''%s''; ',org_schema_nm, org_tbl_nm);	
	RAISE NOTICE 'FULL QUERY: %', tbl_schema_qry;

	EXECUTE format('SELECT count(data_type) FROM information_schema.columns WHERE 
	table_schema = ''%s'' AND table_name = ''%s''; ',org_schema_nm, org_tbl_nm) into no_row;

    -- run through each col and type construct create-table string 
    	create_tbl_qry := format('DROP TABLE IF EXISTS %s.%s; CREATE TABLE %s.%s (', des_schema_name, des_tbl_nm, des_schema_name, des_tbl_nm);
	FOR col_nm, data_type, char_max IN EXECUTE tbl_schema_qry
	    LOOP
		cnter := cnter + 1;
		IF cnter = no_row THEN
		    create_tbl_qry := create_tbl_qry || col_nm || ' ' || data_type; 
		ELSE
		    create_tbl_qry := create_tbl_qry || col_nm || ' ' || data_type ||',';
		END IF;

	    --RAISE NOTICE 'Create table query: %', create_tbl_qry;
	    END LOOP;

	create_tbl_qry := create_tbl_qry || ')'; 
        RAISE NOTICE 'Create table query: %', create_tbl_qry;

	--EXECUTE create_tbl_qry;
END;
$$
LANGUAGE plpgsql;




-- ########################
DO $$
DECLARE
	org_schema_nm text := 'credit_card_feature';
	org_tbl_nm text := 'cc_features_company';
	des_schema_name text := 'metadata';
	des_tbl_nm text := 'tmp_cc_features_company';
	qry text;
BEGIN
	EXECUTE format('SELECT metadata.create_tbl_fm_ext_schema( ''%s'', ''%s'', ''%s'', ''%s'');', 
	org_schema_nm, org_tbl_nm, des_schema_name, des_tbl_nm) INTO qry;

	RAISE NOTICE 'Query is %', qry;

	EXECUTE qry;
END;
$$;