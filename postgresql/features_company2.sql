DROP VIEW credit_card_feature.cc_features_company_view CASCADE;

DROP TABLE IF EXISTS credit_card_feature.cc_features_company;

CREATE TABLE  credit_card_feature.cc_features_company
AS
(
	SELECT txn_merch_cust_card.id_merchant_locn
	, max(txn_merch_cust_card.id_industry_clsfn) industry_clsfn 
	, sum(txn_merch_cust_card.a_prchsd) Txnamt_Sum
	, ROUND(avg(txn_merch_cust_card.a_prchsd)::DECIMAL, 2) txmamt_mean
	, count(DISTINCT txn_merch_cust_card.id_customer) Cust_Cnt
	, count(txn_merch_cust_card.a_prchsd) Txn_Cnt
	, max(txn_merch_cust_card.id_day) last_date
	, min(txn_merch_cust_card.id_day) first_date
	, count(CASE WHEN txn_merch_cust_card.hr = '13' THEN 1 ELSE NULL END) txn_hr_13_cnt
	, count(CASE WHEN txn_merch_cust_card.weekdays = 'monday' THEN 1 ELSE NULL END) Custdayofwk_mon_Cnt
	, count(CASE WHEN txn_merch_cust_card.months = 'jul' THEN 1 ELSE NULL END) Custmth_jul_Cnt
	, count(CASE WHEN txn_merch_cust_card.c_gender = 'F' THEN 1 ELSE NULL END) Custgndr_F_Cnt
	, count(CASE WHEN txn_merch_cust_card.c_gender = 'M' THEN 1 ELSE NULL END) Custgndr_M_Cnt
	, count(CASE WHEN txn_merch_cust_card.c_gender = 'C' THEN 1 ELSE NULL END) Custgndr_C_Cnt
	, sum(CASE WHEN txn_merch_cust_card.c_gender = 'F' THEN (1*a_prchsd) END) Custgndr_F_amt
	, sum(CASE WHEN txn_merch_cust_card.c_gender = 'M' THEN (1*a_prchsd)  END) Custgndr_M_amt
	, sum(CASE WHEN txn_merch_cust_card.c_gender = 'C' THEN (1*a_prchsd)  END) Custgndr_C_amt
	, count(CASE WHEN txn_merch_cust_card.c_gender IS NULL THEN 1 ELSE NULL END) custgndr_na_cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 0 AND 4 THEN 1 ELSE NULL END) Custage_0_4_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 5 AND 9 THEN 1 ELSE NULL END) Custage_5_9_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 10 AND 14 THEN 1 ELSE NULL END) Custage_10_14_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 15 AND 19 THEN 1 ELSE NULL END) Custage_15_19_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 20 AND 24 THEN 1 ELSE NULL END) Custage_20_24_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 25 AND 29 THEN 1 ELSE NULL END) Custage_25_29_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 30 AND 34 THEN 1 ELSE NULL END) Custage_30_34_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 35 AND 39 THEN 1 ELSE NULL END) Custage_35_39_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 40 AND 44 THEN 1 ELSE NULL END) Custage_40_44_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 45 AND 49 THEN 1 ELSE NULL END) Custage_45_49_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 50 AND 54 THEN 1 ELSE NULL END) Custage_50_54_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 55 AND 59 THEN 1 ELSE NULL END) Custage_55_59_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 60 AND 64 THEN 1 ELSE NULL END) Custage_60_64_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 65 AND 69 THEN 1 ELSE NULL END) Custage_65_69_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 70 AND 74 THEN 1 ELSE NULL END) Custage_70_74_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 75 AND 79 THEN 1 ELSE NULL END) Custage_75_79_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 80 AND 84 THEN 1 ELSE NULL END) Custage_80_84_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age >= 85 THEN 1 ELSE NULL END) Custage_85_above_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age IS NULL THEN 1 ELSE NULL END) Custage_na_Cnt

	FROM
	(
		SELECT txn_merch_card.a_prchsd, txn_merch_card.id_day, txn_merch_card.weekdays, txn_merch_card.months,txn_merch_card.id_customer
		, txn_merch_card.nm_terml, txn_merch_card.id_merchant_locn, txn_merch_card.id_industry_clsfn, txn_merch_card.hr
		, cust.n_age, cust.c_gender
		FROM
		(-- join customer information with merch and txn
			SELECT txn_merch.a_prchsd, txn_merch.id_plastic_card, txn_merch.nm_terml, txn_merch.id_merchant_locn, txn_merch.id_day, txn_merch.id_industry_clsfn
			 , to_char(txn_merch.id_day, 'day') weekdays
			 , to_char(txn_merch.id_day, 'mon') months
			 , to_char(txn_merch.id_time_of_day, 'HH24') hr
			 , card.id_customer
			FROM
			( -- join merch information with txn

				SELECT txn.a_prchsd, txn.id_plastic_card, to_date(to_char(txn.id_day, '99999999'), 'YYYYMMDD') id_day
				,  to_timestamp(to_char(txn.id_time_of_day, '999999'),'HH24MISS') id_time_of_day 
				, merch_locn_pos.nm_terml, merch_locn_pos.id_merchant_locn, merch_locn_pos.id_industry_clsfn
				FROM
				(-- get merch infor by joining merch locn and merch pos
					SELECT DISTINCT merch_pos.nm_terml, merch_pos.id_merchant_locn, merch_pos.id_merchant_pos, merch_locn.id_industry_clsfn
					FROM
					(
						SELECT id_merchant_locn, nm_state, id_industry_clsfn 
						FROM insto_data_analytics_dev.cc_raw_dim_merchant_Locn_fake 
						WHERE id_merchant_locn IN (681551, 667140, 183950, 215864)					
					) merch_locn
					INNER JOIN insto_data_analytics_dev.cc_raw_dim_merchant_Pos_fake merch_pos
					ON merch_locn.id_merchant_locn = merch_pos.id_merchant_locn
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
	GROUP BY id_merchant_locn 
);  


-- grand access permission 
alter table credit_card_feature.cc_features_company
owner to gcppoc;

-- add primary key
alter table credit_card_feature.cc_features_company
add primary key (id_merchant_locn);


select * from credit_card_feature.cc_features_company

