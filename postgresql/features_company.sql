SELECT txn_terml_cust_card.nm_terml
, sum(txn_terml_cust_card.a_prchsd) Txn_amt_Sum
, count(DISTINCT txn_terml_cust_card.id_customer) Cust_Cnt
, count(txn_terml_cust_card.a_prchsd) Txn_Cnt
, sum(txn_terml_cust_card.a_prchsd)/count(DISTINCT txn_terml_cust_card.id_customer) Txn_Cnt_per_cust
, sum(txn_terml_cust_card.a_prchsd)/count(txn_terml_cust_card.a_prchsd) Txn_amt_Mean
, count(CASE WHEN txn_terml_cust_card.c_gender = 'F' THEN 1 ELSE NULL END) Cust_gndr_F_Cnt
, count(CASE WHEN txn_terml_cust_card.c_gender = 'M' THEN 1 ELSE NULL END) Cust_gndr_M_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 0 AND 4 THEN 1 ELSE NULL END) Cust_age_0_4_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 5 AND 9 THEN 1 ELSE NULL END) Cust_age_5_9_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 10 AND 14 THEN 1 ELSE NULL END) Cust_age_10_14_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 15 AND 19 THEN 1 ELSE NULL END) Cust_age_15_19_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 20 AND 24 THEN 1 ELSE NULL END) Cust_age_20_24_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 25 AND 29 THEN 1 ELSE NULL END) Cust_age_25_29_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 30 AND 34 THEN 1 ELSE NULL END) Cust_age_30_34_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 35 AND 39 THEN 1 ELSE NULL END) Cust_age_35_39_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 40 AND 44 THEN 1 ELSE NULL END) Cust_age_40_44_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 45 AND 49 THEN 1 ELSE NULL END) Cust_age_45_49_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 50 AND 54 THEN 1 ELSE NULL END) Cust_age_50_54_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 55 AND 59 THEN 1 ELSE NULL END) Cust_age_55_59_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 60 AND 64 THEN 1 ELSE NULL END) Cust_age_60_64_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 65 AND 69 THEN 1 ELSE NULL END) Cust_age_65_69_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 70 AND 74 THEN 1 ELSE NULL END) Cust_age_70_74_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 75 AND 79 THEN 1 ELSE NULL END) Cust_age_75_79_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 80 AND 84 THEN 1 ELSE NULL END) Cust_age_80_84_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 85 AND 89 THEN 1 ELSE NULL END) Cust_age_85_89_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 90 AND 94 THEN 1 ELSE NULL END) Cust_age_90_94_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 95 AND 99 THEN 1 ELSE NULL END) Cust_age_95_99_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 100 AND 104 THEN 1 ELSE NULL END) Cust_age_100_104_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 105 AND 109 THEN 1 ELSE NULL END) Cust_age_105_109_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 110 AND 114 THEN 1 ELSE NULL END) Cust_age_110_114_Cnt
, count(CASE WHEN txn_terml_cust_card.n_age BETWEEN 115 AND 119 THEN 1 ELSE NULL END) Cust_age_115_119_Cnt
FROM
(
	SELECT txn_terml_card.a_prchsd, txn_terml_card.id_day, txn_terml_card.id_customer, txn_terml_card.nm_terml
	, cust.n_age, cust.c_gender
	FROM
	(
		SELECT txn_terml.a_prchsd, txn_terml.id_plastic_card, txn_terml.id_day, txn_terml.nm_terml
		, card.id_customer
		FROM
		(

			SELECT txn.a_prchsd, txn.id_plastic_card, txn.id_day
			, merch_pos.nm_terml
			FROM
			(-- get merch infor
				SELECT nm_terml, id_merchant_locn, id_merchant_pos 
				FROM "instoDataAnalyticsDev".cc_raw_dim_merchant_Pos_fake
				--WHERE nm_terml in ('Ariana Tran', 'Tommy Mcdonald')
				ORDER BY random()
				LIMIT 100
			)merch_pos
			INNER JOIN "instoDataAnalyticsDev".cc_raw_fct_base_card_fake txn
			ON merch_pos.id_merchant_pos = txn.id_merchant_pos
		)txn_terml
		INNER JOIN "instoDataAnalyticsDev".cc_raw_dim_plastic_card_fake card
		ON txn_terml.id_plastic_card = card.id_plastic_card
	) txn_terml_card
	INNER JOIN "instoDataAnalyticsDev".cc_raw_dim_customer_fake cust
	ON txn_terml_card.id_customer = cust.id_customer
) txn_terml_cust_card
GROUP BY nm_terml


