--SELECT * INTO "creditCardFeature".cc_features_company
--FROM
--	(
	SELECT txn_merch_cust_card.id_merchant_locn
	, txn_merch_cust_card.nm_terml
	, sum(txn_merch_cust_card.a_prchsd) Txn_amt_Sum
	, count(DISTINCT txn_merch_cust_card.id_customer) Cust_Cnt
	, count(txn_merch_cust_card.a_prchsd) Txn_Cnt
	, sum(txn_merch_cust_card.a_prchsd)/count(DISTINCT txn_merch_cust_card.id_customer) Txn_Cnt_per_cust
	, sum(txn_merch_cust_card.a_prchsd)/count(txn_merch_cust_card.a_prchsd) Txn_amt_Mean
	, count(CASE WHEN txn_merch_cust_card.c_gender = 'F' THEN 1 ELSE NULL END) Cust_gndr_F_Cnt
	, count(CASE WHEN txn_merch_cust_card.c_gender = 'M' THEN 1 ELSE NULL END) Cust_gndr_M_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 0 AND 4 THEN 1 ELSE NULL END) Cust_age_0_4_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 5 AND 9 THEN 1 ELSE NULL END) Cust_age_5_9_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 10 AND 14 THEN 1 ELSE NULL END) Cust_age_10_14_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 15 AND 19 THEN 1 ELSE NULL END) Cust_age_15_19_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 20 AND 24 THEN 1 ELSE NULL END) Cust_age_20_24_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 25 AND 29 THEN 1 ELSE NULL END) Cust_age_25_29_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 30 AND 34 THEN 1 ELSE NULL END) Cust_age_30_34_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 35 AND 39 THEN 1 ELSE NULL END) Cust_age_35_39_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 40 AND 44 THEN 1 ELSE NULL END) Cust_age_40_44_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 45 AND 49 THEN 1 ELSE NULL END) Cust_age_45_49_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 50 AND 54 THEN 1 ELSE NULL END) Cust_age_50_54_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 55 AND 59 THEN 1 ELSE NULL END) Cust_age_55_59_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 60 AND 64 THEN 1 ELSE NULL END) Cust_age_60_64_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 65 AND 69 THEN 1 ELSE NULL END) Cust_age_65_69_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 70 AND 74 THEN 1 ELSE NULL END) Cust_age_70_74_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 75 AND 79 THEN 1 ELSE NULL END) Cust_age_75_79_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 80 AND 84 THEN 1 ELSE NULL END) Cust_age_80_84_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 85 AND 89 THEN 1 ELSE NULL END) Cust_age_85_89_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 90 AND 94 THEN 1 ELSE NULL END) Cust_age_90_94_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 95 AND 99 THEN 1 ELSE NULL END) Cust_age_95_99_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 100 AND 104 THEN 1 ELSE NULL END) Cust_age_100_104_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 105 AND 109 THEN 1 ELSE NULL END) Cust_age_105_109_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 110 AND 114 THEN 1 ELSE NULL END) Cust_age_110_114_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 115 AND 119 THEN 1 ELSE NULL END) Cust_age_115_119_Cnt
	FROM
	(
		SELECT txn_merch_card.a_prchsd, txn_merch_card.id_day, txn_merch_card.id_customer, txn_merch_card.nm_terml, txn_merch_card.id_merchant_locn
		, cust.n_age, cust.c_gender
		FROM
		(
			SELECT txn_merch.a_prchsd, txn_merch.id_plastic_card, txn_merch.id_day, txn_merch.nm_terml, txn_merch.id_merchant_locn
			, card.id_customer
			FROM
			(

				SELECT txn.a_prchsd, txn.id_plastic_card, txn.id_day
				, merch_locn_pos.nm_terml, merch_locn_pos.id_merchant_locn
				FROM
				(-- get merch infor
					SELECT DISTINCT merch_pos.nm_terml, merch_pos.id_merchant_locn, merch_pos.id_merchant_pos
					from
					(
						SELECT id_merchant_locn 
						FROM "instoDataAnalyticsDev".cc_raw_dim_merchant_Locn_fake 
						WHERE id_merchant_locn IN (681551, 667140)					
					) merch_locn
					INNER JOIN "instoDataAnalyticsDev".cc_raw_dim_merchant_Pos_fake merch_pos
					ON merch_locn.id_merchant_locn = merch_pos.id_merchant_locn
					--ORDER BY merch_pos.id_merchant_locn, merch_pos.nm_terml
				)merch_locn_pos
				INNER JOIN "instoDataAnalyticsDev".cc_raw_fct_base_card_fake txn
				ON merch_locn_pos.id_merchant_pos = txn.id_merchant_pos
			)txn_merch
			INNER JOIN "instoDataAnalyticsDev".cc_raw_dim_plastic_card_fake card
			ON txn_merch.id_plastic_card = card.id_plastic_card
		) txn_merch_card
		INNER JOIN "instoDataAnalyticsDev".cc_raw_dim_customer_fake cust
		ON txn_merch_card.id_customer = cust.id_customer
	) txn_merch_cust_card
	GROUP BY id_merchant_locn, nm_terml
--) AS feature_company
