--- ref:http://www.postgresqltutorial.com/plpgsql-block-structure/

-- 1. block structure
DO $$ -- do statement doesn't belong to the block. It is used to execute an anonymous block
DECLARE 
    counter int := 0;
BEGIN 
    counter := counter + 1;
    RAISE NOTICE 'THE CURRENT COUNTER VALUE IS %', counter; -- has to be single quote '
END
$$;

--#############################################################
-- meaning of $$
--https://stackoverflow.com/questions/12144284/what-are-used-for-in-pl-pgsql
--https://stackoverflow.com/questions/12316953/insert-text-with-single-quotes-in-postgresql/12320729#12320729

-- #############################################################
-- 1.2 sub-block: use block label to access var in outer block
DO $$
<<outer_block>> --A block may have optional labels at the beginning and at the end
DECLARE 
    counter int := 0;
BEGIN
    counter := counter + 1;
    RAISE NOTICE 'THE CURRENT OUTER VAR IS %', counter;

    <<inner_block>>
    DECLARE
        counter int := 0;
        BEGIN 
	    counter := counter + 10000;
	    RAISE NOTICE 'THE CURRENT INNER VAR IS %', inner_block.counter; -- raise statement
	    RAISE NOTICE 'THE CURRENT OUTER VAR IS %', outer_block.counter;

	    outer_block.counter := outer_block.counter - 1000;
        END inner_block;
        
    RAISE NOTICE 'THE CURRENT OUTER VAR IS %', outer_block.counter;
    --RAISE NOTICE 'THE CURRENT inner VAR IS %', inner_block.counter; -- inner var cannot be access from outer_block
    
END outer_block
$$;




--###############################
-- 2.1 Error and messages

-- Notice that not all messages are reported back to client, 
-- only INFO, WARNING, and NOTICE level messages are reported to 
-- client. This is controlled by the client_min_messages and log_min_messages 
-- configuration parameters.
DO $$
BEGIN 
    RAISE INFO 'INFORMATION MESSAGE %', NOW();
    RAISE LOG 'LOG MESSAGE %', NOW();
    RAISE DEBUG 'DEBUG MESSAGE %', NOW();
    RAISE WARNING 'WARNING MESSAGE %', NOW();
    RAISE NOTICE 'NOTICE MESSAGE %', NOW();
END
$$;


-- 2.2 Raise exception 
DO $$
DECLARE
    email varchar(255) := 'xxxxx@anz.com';
BEGIN
    -- check for duplicate
    -- ...
    -- report duplicate email
    RAISE  'EMAIL DUPLICATION: %', email
    USING HINT = 'check the email again'; -- hint can be also replaced with 'message', 'detail', etc
END
$$;


-- 2.3 assert ???
-- ASSERT condition [, message]; 
-- if the condition is 

-- DO $$
-- DECLARE
--     counter int := -1;
-- BEGIN
--     ASSERT counter < 0
--     MESSAGE 'SFDGS';
-- END
-- $$;





-- ############################################
-- 3. create functions

-- CREATE FUNCTION function_name(p1 type, p2 type)
--  RETURNS type AS
-- BEGIN
--  -- logic
-- END;
-- LANGUAGE language_name;


-- ############################################
-- 4. create functions parameters

-- 4.1 IN parameter
-- By default, the parameter’s type of any parameter 
-- in PostgreSQL is IN parameter. You can pass the IN parameters 
-- to the function but you cannot get them back as a part of result.
CREATE FUNCTION get_sum(a int, b int)
    RETURNS int AS
$func$
BEGIN
    RETURN a + b;
END;
$func$
LANGUAGE plpgsql;

select get_sum(1,2);



-- ############################################
-- 4.2 OUT parameter
-- Because we use the OUT parameters, we don’t need to have 
-- a RETURN statement. The OUT parameters are useful in a function 
-- that needs to return multiple values without defining a custom type

CREATE OR REPLACE FUNCTION hi_lo(
   a NUMERIC,
   b NUMERIC,
   c NUMERIC,
   OUT hi NUMERIC,  -- the output can be declare inside the function with returns, ie, next example
   OUT lo NUMERIC 
) AS
$func$
BEGIN 
    hi := GREATEST(a, b, c);
    lo := LEAST(a, b , c);
END;
$func$
LANGUAGE plpgsql;


select hi_lo(1,3,4)

-- The output of the function is a record, which is 
-- a custom type. To make the output separated as columns, 
-- you use the following syntax:
select * from hi_lo(1,3,4)


-- ###
CREATE OR REPLACE FUNCTION hi(
    a NUMERIC,
    b NUMERIC,
    c NUMERIC
) RETURNS INT AS
$BODY$
DECLARE
    hi INT;
BEGIN
    hi:= GREATEST(a, b, c);
    RETURN hi;
END;
$BODY$
LANGUAGE plpgsql;

--
select hi(1,3,4)    
    
    


-- ############################
--4.3 VARIADIC
-- A PostgreSQL function can accept a variable numbers of arguments 
-- with one condition that all arguments have the same data type. 
-- The arguments are passed to the function as an array
CREATE OR REPLACE FUNCTION sum_avg(
    VARIADIC list NUMERIC[],
    OUT a NUMERIC
) AS
$func$
BEGIN
    SELECT INTO a SUM(unnest_array)
    FROM UNNEST(list) unnest_array; -- unnest the array before agg
END;
$func$
LANGUAGE plpgsql;

--
select * from sum_avg(10,20)


--################################
-- 5. function overloading
-- PostgreSQL allows more than one function to have the same name, 
-- so long as the arguments are different. If more than one function 
-- has the same name, we say those functions are overloaded.

-- When a function is called, PostgreSQL determines exact function 
-- is being called based on the input arguments.


--################################
-- 6. function reurns a table
--  use RETURNS TABLE syntax and specify the columns of the table. 
-- Each column is separated by a comma (,)

-- Notice that the columns in the SELECT statement must match with the 
-- columns of the table that we want to return (type)
-- DROP FUNCTION get_merch(character varying)
CREATE OR REPLACE FUNCTION get_merch(
    p_pattern varchar
) RETURNS TABLE(
    nm_terml VARCHAR(100),
    id_merchant_locn bigint
) AS
$func$
BEGIN
    RETURN QUERY 
    SELECT DISTINCT merch.nm_terml, merch.id_merchant_locn  -- use full dir
    FROM "instoDataAnalyticsDev".cc_raw_dim_merchant_pos_fake merch 
    WHERE merch.nm_terml LIKE p_pattern;
END;
$func$
LANGUAGE plpgsql;

-- 
SELECT * FROM get_merch('K%')


--################################
-- 6.1 build up each row and format to a table (via for loop)
CREATE OR REPLACE FUNCTION get_merch_upper(
    p_pattern varchar
) RETURNS TABLE(
    merch_name varchar(100),
    merch_id bigint
) As
$$
DECLARE
    tmp record;
BEGIN
    FOR tmp IN (SELECT merch.nm_terml, merch.id_merchant_locn 
		FROM "instoDataAnalyticsDev".cc_raw_dim_merchant_pos_fake merch 
		WHERE merch.nm_terml LIKE p_pattern) LOOP 
		
        merch_name := UPPER(tmp.nm_terml); -- assign each row to var
        merch_id := tmp.id_merchant_locn;
        RETURN NEXT;
    END LOOP;
END;
$$
LANGUAGE plpgsql;

--
select * FROM get_merch_upper('K%')



-- ####################################
-- 7. declare variables
-- variable_name data_type [:= expression]
-- NULL value will be assigned if there is no deflaut

-- For example, you can define a variable named city_name that 
-- refers to the name column of the city table as follows:
-- --- city_name city.name%TYPE := 'San Francisco';
DO
$$
DECLARE
    counter int := 1;
    first_name varchar(50) := 'XX';
    last_name varchar(50) := 'YY';
BEGIN
    RAISE NOTICE 'ID = %, FIRST NAME % AND LAST NAME %', counter, first_name, last_name;
END;
$$


-- ######################################
-- 8. constant
-- constant_name CONSTANT data_type := expression;
DO
$$
DECLARE
     price CONSTANT NUMERIC := 0.111;
     rate CONSTANT NUMERIC := 23;
     curr_time CONSTANT time := now();
BEGIN
     RAISE NOTICE 'At %, the price is %', curr_time, price*rate;
END;
$$



-- ########################################
-- 9. If condition
-- IF condition THEN
--    statement;
-- END IF;
--###################
-- IF condition THEN
--   statements;
-- ELSE
--   alternative-statements;
-- END IF;
--##################
-- IF condition-1 THEN
--   if-statement;
-- ELSIF condition-2 THEN
--   elsif-statement-2
-- ...
-- ELSIF condition-n THEN
--   elsif-statement-n;
-- ELSE
--   else-statement;
-- END IF:
DO
$$
DECLARE
    const_a CONSTANT NUMERIC := 10.9;
    const_b CONSTANT INT := 9;
BEGIN
    IF const_a > const_b THEN
        RAISE NOTICE 'const_a is larger than const_b by %', const_a-const_b;        
    ELSIF const_a < const_b THEN
        RAISE NOTICE 'const_a is smaller than const_b by %', const_b-const_a;
    ELSE 
        RAISE NOTICE 'const_a is SAME AS const_b ss %', const_b;
    END IF;
END; 
$$



--##########################
-- 10. case
-- CASE search-expression
--    WHEN expression_1 [, expression_2, ...] THEN
--       when-statements
--   [ ... ]
--   [ELSE
--       else-statements ]
-- END CASE;

--######
-- CASE
--     WHEN boolean-expression-1 THEN
--       statements
--   [ WHEN boolean-expression-2 THEN
--       statements
--     ... ]
--   [ ELSE
--       statements ]
-- END CASE;


--#####################################
-- 11. Loop: LOOP, WHILE, FOR 

-- 11.1 FOR
-- [ <<label>> ]
-- FOR loop_counter IN [ REVERSE ] from.. to [ BY expression ] LOOP
--     statements
-- END LOOP [ label ];
DO
$$
DECLARE
    upper int := 44;
    lower int := 4;
BEGIN
    --FOR counter IN lower..upper BY 3 LOOP
    FOR counter IN REVERSE upper..lower BY 10 LOOP
        RAISE NOTICE 'THE CURRENT COUNTER IS %', counter;
    END LOOP;
END;
$$

-- You can use the FOR loop statement to loop through a query result. 
-- [ <<label>> ]
-- FOR target IN query LOOP
--     statements
-- END LOOP [ label ];
DO
$$
DECLARE 
    limit_no int := 6;
    i record;
BEGIN
    FOR i IN (SELECT distinct(merch.nm_terml)
		FROM "instoDataAnalyticsDev".cc_raw_dim_merchant_pos_fake merch 
		LIMIT limit_no) LOOP
        RAISE NOTICE 'MERCH NAME IS %', i;
    END LOOP;
END;
$$

-- FOR loop for looping through a query result of a dynamic query, and loop through its result
-- use the USING statement to pass the parameter to the query

-- [ <<label>> ]
-- FOR row IN EXECUTE string_expression [ USING query_param [, ... ] ] 
-- LOOP
--     statements
-- END LOOP [ label ];

--DROP FUNCTION for_loop_dyn_query(integer,integer)
CREATE OR REPLACE FUNCTION for_loop_dyn_query(
    cod_idx int,
    limit_no int
) RETURNS VOID AS
$$
DECLARE 
    query text;
    rec record;
BEGIN 
    query := 'SELECT DISTINCT merch.id_merchant_locn';
    IF cod_idx = 1 THEN
	query := query || ', merch.nm_terml';
    ELSIF cod_idx = 2 THEN
	query := query ||  ', merch.ad_city_terml';
    ELSE 
        RAISE EXCEPTION 'INVALID, PLS ENTER 1 OR 2, NOT %s', cod_idx;
    END IF;

    query := query || ' FROM "instoDataAnalyticsDev".cc_raw_dim_merchant_pos_fake merch  LIMIT $1';  --refer to parameters by position, using $1, $2, et
    FOR rec IN EXECUTE query USING limit_no LOOP
	RAISE NOTICE 'THE CURRENT ROW IS % --- %', rec.nm_terml, rec.id_merchant_locn;
    END LOOP;
END;
$$
LANGUAGE plpgsql;

--
-- SELECT DISTINCT merch.id_merchant_locn, merch.nm_terml
-- FROM "instoDataAnalyticsDev".cc_raw_dim_merchant_pos_fake merch
-- LIMIT 10;

select for_loop_dyn_query(1,5);




-- ##################################
-- 12. CURSER
-- A PL/pgSQL cursor allows us to encapsulate a query and process each individual 
-- row at a time. We use cursors when we want to divide a large result set into parts 
-- and process each part individually. If we process it at once, we may have a memory 
-- overflow error.


-- ###################################
-- 13. Others

-- 13.1 %, $,
-- ref: https://www.postgresql.org/docs/current/static/plpgsql-statements.html#PLPGSQL-STATEMENTS-EXECUTING-DYN
--%I specification for table or column names

-- The command string can use parameter values, which are referenced in the command as $1, $2, etc. 
-- These symbols refer to values supplied in the USING clause. This method is often preferable to inserting data 
-- values into the command string as text

-- EXECUTE format('SELECT count(*) FROM %I '
--    'WHERE inserted_by = $1 AND inserted <= $2', tabname)
--    INTO c
--    USING checked_user, checked_date; 

-- type text vs varchar
-- The background of this is: The old Postgres system used the PostQUEL language and used a data type 
-- named text (because someone thought that was a good name for a type that stores text). 
-- Then, Postgres was converted to use SQL as its language. To achieve SQL compatibility, 
-- instead of renaming the text type, a new type varchar was added. But both type use the 
-- same C routines internally.



--##############################
-- 14. pass table as parameter
-- https://stackoverflow.com/questions/11740256/refactor-a-pl-pgsql-function-to-return-the-output-of-various-select-queries/11751557#11751557
-- anyelement is a pseudo data type, a polymorphic type, 
-- a placeholder for any non-array data type. All occurrences 
-- of anyelement in the function evaluate to the same type provided 
-- at run time. By supplying a value of a defined type as argument 
-- to the function, we implicitly define the return type.
-- DROP FUNCTION data_of(anyelement,integer)
CREATE OR REPLACE FUNCTION data_of(_tbl anyelement, 
limit_no int) RETURNS SETOF record AS
$$
DECLARE
   input_name varchar(100) := 'id_customer';

BEGIN
    RETURN QUERY EXECUTE format('
    SELECT f_anz_cust
    FROM %s
    LIMIT $1
    ', pg_typeof(_tbl))
    USING limit_no;
END;
$$
LANGUAGE plpgsql;

--
select * from data_of(NULL::insto_data_analytics_dev.cc_raw_dim_customer_fake,10);



--



