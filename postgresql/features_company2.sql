DROP VIEW IF EXISTS credit_card_feature.cc_features_company_view CASCADE;

DROP TABLE IF EXISTS credit_card_feature.cc_features_company;

CREATE TABLE  credit_card_feature.cc_features_company
AS
(
	SELECT cmpnyid
	--, txn_merch_cust_card.id_merchant_locn
	, max(txn_merch_cust_card.id_industry_clsfn) industry_clsfn 
	, sum(txn_merch_cust_card.a_prchsd) Txnamt_Sum
	, ROUND(avg(txn_merch_cust_card.a_prchsd)::DECIMAL, 2) txmamt_mean
	, count(DISTINCT txn_merch_cust_card.id_customer) Cust_Cnt
	, count(txn_merch_cust_card.a_prchsd) Txn_Cnt
	, max(txn_merch_cust_card.id_day) last_date
	, min(txn_merch_cust_card.id_day) first_date
	--
	, count(CASE WHEN txn_merch_cust_card.hr = '13' THEN 1 ELSE NULL END) txn_hr_13_cnt

	--
	, count(CASE WHEN txn_merch_cust_card.weekdays = 'mon' THEN 1 ELSE NULL END) txn_dyofwk_mon_Cnt
	, count(CASE WHEN txn_merch_cust_card.weekdays = 'tue' THEN 1 ELSE NULL END) txn_dyofwk_tue_Cnt
	, count(CASE WHEN txn_merch_cust_card.weekdays = 'wed' THEN 1 ELSE NULL END) txn_dyofwk_wed_Cnt
	, count(CASE WHEN txn_merch_cust_card.weekdays = 'thu' THEN 1 ELSE NULL END) txn_dyofwk_thu_Cnt
	, count(CASE WHEN txn_merch_cust_card.weekdays = 'fri' THEN 1 ELSE NULL END) txn_dyofwk_fri_Cnt
	, count(CASE WHEN txn_merch_cust_card.weekdays = 'sat' THEN 1 ELSE NULL END) txn_dyofwk_sat_Cnt
	, count(CASE WHEN txn_merch_cust_card.weekdays = 'sun' THEN 1 ELSE NULL END) txn_dyofwk_sun_Cnt

	, count(distinct(CASE WHEN txn_merch_cust_card.weekdays = 'mon' THEN txn_merch_cust_card.id_customer END)) Cust_dyofwk_mon_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.weekdays = 'tue' THEN txn_merch_cust_card.id_customer END)) Cust_dyofwk_tue_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.weekdays = 'wed' THEN txn_merch_cust_card.id_customer END)) Cust_dyofwk_wed_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.weekdays = 'thu' THEN txn_merch_cust_card.id_customer END)) Cust_dyofwk_thu_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.weekdays = 'fri' THEN txn_merch_cust_card.id_customer END)) Cust_dyofwk_fri_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.weekdays = 'sat' THEN txn_merch_cust_card.id_customer END)) Cust_dyofwk_sat_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.weekdays = 'sun' THEN txn_merch_cust_card.id_customer END)) Cust_dyofwk_sun_Cnt
	
	, sum(CASE WHEN txn_merch_cust_card.weekdays = 'mon' THEN (1*a_prchsd) END) txn_dyofwk_mon_amt
	, sum(CASE WHEN txn_merch_cust_card.weekdays = 'tue' THEN (1*a_prchsd) END) txn_dyofwk_tue_amt
	, sum(CASE WHEN txn_merch_cust_card.weekdays = 'wed' THEN (1*a_prchsd) END) txn_dyofwk_wed_amt
	, sum(CASE WHEN txn_merch_cust_card.weekdays = 'thu' THEN (1*a_prchsd) END) txn_dyofwk_thu_amt
	, sum(CASE WHEN txn_merch_cust_card.weekdays = 'fri' THEN (1*a_prchsd) END) txn_dyofwk_fri_amt
	, sum(CASE WHEN txn_merch_cust_card.weekdays = 'sat' THEN (1*a_prchsd) END) txn_dyofwk_sat_amt
	, sum(CASE WHEN txn_merch_cust_card.weekdays = 'sun' THEN (1*a_prchsd) END) txn_dyofwk_sun_amt
	
	--
	, count(CASE WHEN txn_merch_cust_card.months = 'jan' THEN 1 ELSE NULL END) txn_mth_jan_Cnt
	, count(CASE WHEN txn_merch_cust_card.months = 'feb' THEN 1 ELSE NULL END) txn_mth_feb_Cnt
	, count(CASE WHEN txn_merch_cust_card.months = 'mar' THEN 1 ELSE NULL END) txn_mth_mar_Cnt
	, count(CASE WHEN txn_merch_cust_card.months = 'apr' THEN 1 ELSE NULL END) txt_mth_apr_Cnt	
	, count(CASE WHEN txn_merch_cust_card.months = 'may' THEN 1 ELSE NULL END) txn_mth_may_Cnt
	, count(CASE WHEN txn_merch_cust_card.months = 'jun' THEN 1 ELSE NULL END) txn_mth_jun_Cnt	
	, count(CASE WHEN txn_merch_cust_card.months = 'jul' THEN 1 ELSE NULL END) txn_mth_jul_Cnt
	, count(CASE WHEN txn_merch_cust_card.months = 'aug' THEN 1 ELSE NULL END) txn_mth_aug_Cnt	
	, count(CASE WHEN txn_merch_cust_card.months = 'sep' THEN 1 ELSE NULL END) txn_mth_sep_Cnt
	, count(CASE WHEN txn_merch_cust_card.months = 'oct' THEN 1 ELSE NULL END) txn_mth_oct_Cnt
	, count(CASE WHEN txn_merch_cust_card.months = 'nov' THEN 1 ELSE NULL END) txn_mth_nov_Cnt
	, count(CASE WHEN txn_merch_cust_card.months = 'dec' THEN 1 ELSE NULL END) txn_mth_dec_Cnt


	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'jan' THEN txn_merch_cust_card.id_customer END)) Cust_mth_jan_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'feb' THEN txn_merch_cust_card.id_customer END)) Cust_mth_feb_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'mar' THEN txn_merch_cust_card.id_customer END)) Cust_mth_mar_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'apr' THEN txn_merch_cust_card.id_customer END)) Cust_mth_apr_Cnt	
	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'may' THEN txn_merch_cust_card.id_customer END)) Cust_mth_may_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'jun' THEN txn_merch_cust_card.id_customer END)) Cust_mth_jun_Cnt	
	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'jul' THEN txn_merch_cust_card.id_customer END)) Cust_mth_jul_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'aug' THEN txn_merch_cust_card.id_customer END)) Cust_mth_aug_Cnt	
	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'sep' THEN txn_merch_cust_card.id_customer END)) Cust_mth_sep_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'oct' THEN txn_merch_cust_card.id_customer END)) Cust_mth_oct_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'nov' THEN txn_merch_cust_card.id_customer END)) Cust_mth_nov_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.months = 'dec' THEN txn_merch_cust_card.id_customer END)) Cust_mth_dec_Cnt

	, sum(CASE WHEN txn_merch_cust_card.months = 'jan' THEN (1*a_prchsd) END) txn_mth_jan_amt
	, sum(CASE WHEN txn_merch_cust_card.months = 'feb' THEN (1*a_prchsd) END) txn_mth_feb_amt
	, sum(CASE WHEN txn_merch_cust_card.months = 'mar' THEN (1*a_prchsd) END) txn_mth_mar_amt
	, sum(CASE WHEN txn_merch_cust_card.months = 'apr' THEN (1*a_prchsd) END) txn_mth_apr_amt	
	, sum(CASE WHEN txn_merch_cust_card.months = 'may' THEN (1*a_prchsd) END) txn_mth_may_amt
	, sum(CASE WHEN txn_merch_cust_card.months = 'jun' THEN (1*a_prchsd) END) txn_mth_jun_amt	
	, sum(CASE WHEN txn_merch_cust_card.months = 'jul' THEN (1*a_prchsd) END) txn_mth_jul_amt
	, sum(CASE WHEN txn_merch_cust_card.months = 'aug' THEN (1*a_prchsd) END) txn_mth_aug_amt	
	, sum(CASE WHEN txn_merch_cust_card.months = 'sep' THEN (1*a_prchsd) END) txn_mth_sep_amt
	, sum(CASE WHEN txn_merch_cust_card.months = 'oct' THEN (1*a_prchsd) END) txn_mth_oct_amt
	, sum(CASE WHEN txn_merch_cust_card.months = 'nov' THEN (1*a_prchsd) END) txn_mth_nov_amt
	, sum(CASE WHEN txn_merch_cust_card.months = 'dec' THEN (1*a_prchsd) END) txn_mth_dec_amt
	
	
	--
	, count(CASE WHEN txn_merch_cust_card.c_gender = 'F' THEN 1 END) txn_gndr_F_Cnt
	, count(CASE WHEN txn_merch_cust_card.c_gender = 'M' THEN 1 END) txn_gndr_M_Cnt
	, count(CASE WHEN txn_merch_cust_card.c_gender = 'C' THEN 1 END) txn_gndr_C_Cnt
	, count(CASE WHEN txn_merch_cust_card.c_gender IS NULL THEN 1 END) txn_gndr_na_cnt	
	
	, count(distinct(CASE WHEN txn_merch_cust_card.c_gender = 'F' THEN txn_merch_cust_card.id_customer END)) Cust_gndr_F_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.c_gender = 'M' THEN txn_merch_cust_card.id_customer END)) Cust_gndr_M_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.c_gender = 'C' THEN txn_merch_cust_card.id_customer END)) Cust_gndr_C_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.c_gender IS NULL THEN txn_merch_cust_card.id_customer END)) cust_gndr_na_cnt	
	
	, sum(CASE WHEN txn_merch_cust_card.c_gender = 'F' THEN (1*a_prchsd) END) txn_gndr_F_amt
	, sum(CASE WHEN txn_merch_cust_card.c_gender = 'M' THEN (1*a_prchsd)  END) txn_gndr_M_amt
	, sum(CASE WHEN txn_merch_cust_card.c_gender = 'C' THEN (1*a_prchsd)  END) txn_gndr_C_amt
	, sum(CASE WHEN txn_merch_cust_card.c_gender IS NULL THEN (1*a_prchsd) END) txn_gndr_na_amt

	--
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 0 AND 4 THEN 1 ELSE NULL END) txn_age_0_4_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 5 AND 9 THEN 1 ELSE NULL END) txn_age_5_9_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 10 AND 14 THEN 1 ELSE NULL END) txn_age_10_14_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 15 AND 19 THEN 1 ELSE NULL END) txn_age_15_19_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 20 AND 24 THEN 1 ELSE NULL END) txn_age_20_24_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 25 AND 29 THEN 1 ELSE NULL END) txn_age_25_29_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 30 AND 34 THEN 1 ELSE NULL END) txn_age_30_34_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 35 AND 39 THEN 1 ELSE NULL END) txn_age_35_39_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 40 AND 44 THEN 1 ELSE NULL END) txn_age_40_44_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 45 AND 49 THEN 1 ELSE NULL END) txn_age_45_49_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 50 AND 54 THEN 1 ELSE NULL END) txn_age_50_54_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 55 AND 59 THEN 1 ELSE NULL END) txn_age_55_59_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 60 AND 64 THEN 1 ELSE NULL END) txn_age_60_64_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 65 AND 69 THEN 1 ELSE NULL END) txn_age_65_69_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 70 AND 74 THEN 1 ELSE NULL END) txn_age_70_74_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 75 AND 79 THEN 1 ELSE NULL END) txn_age_75_79_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age BETWEEN 80 AND 84 THEN 1 ELSE NULL END) txn_age_80_84_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age >= 85 THEN 1 ELSE NULL END) txn_age_85_above_Cnt
	, count(CASE WHEN txn_merch_cust_card.n_age IS NULL THEN 1 ELSE NULL END) txn_age_na_Cnt

	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 0 AND 4 THEN txn_merch_cust_card.id_customer END)) cust_age_0_4_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 5 AND 9 THEN txn_merch_cust_card.id_customer END)) cust_age_5_9_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 10 AND 14 THEN txn_merch_cust_card.id_customer END)) cust_age_10_14_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 15 AND 19 THEN txn_merch_cust_card.id_customer END)) cust_age_15_19_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 20 AND 24 THEN txn_merch_cust_card.id_customer END)) cust_age_20_24_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 25 AND 29 THEN txn_merch_cust_card.id_customer END)) cust_age_25_29_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 30 AND 34 THEN txn_merch_cust_card.id_customer END)) cust_age_30_34_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 35 AND 39 THEN txn_merch_cust_card.id_customer END)) cust_age_35_39_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 40 AND 44 THEN txn_merch_cust_card.id_customer END)) cust_age_40_44_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 45 AND 49 THEN txn_merch_cust_card.id_customer END)) cust_age_45_49_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 50 AND 54 THEN txn_merch_cust_card.id_customer END)) cust_age_50_54_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 55 AND 59 THEN txn_merch_cust_card.id_customer END)) cust_age_55_59_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 60 AND 64 THEN txn_merch_cust_card.id_customer END)) cust_age_60_64_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 65 AND 69 THEN txn_merch_cust_card.id_customer END)) cust_age_65_69_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 70 AND 74 THEN txn_merch_cust_card.id_customer END)) cust_age_70_74_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 75 AND 79 THEN txn_merch_cust_card.id_customer END)) cust_age_75_79_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age BETWEEN 80 AND 84 THEN txn_merch_cust_card.id_customer END)) cust_age_80_84_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age >= 85 THEN txn_merch_cust_card.id_customer END)) cust_age_85_above_Cnt
	, count(distinct(CASE WHEN txn_merch_cust_card.n_age IS NULL THEN txn_merch_cust_card.id_customer END)) cust_age_na_Cnt
	
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 0 AND 4 THEN (1*a_prchsd) END) txn_age_0_4_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 5 AND 9 THEN (1*a_prchsd) END) txn_age_5_9_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 10 AND 14 THEN (1*a_prchsd) END) txn_age_10_14_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 15 AND 19 THEN (1*a_prchsd) END) txn_age_15_19_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 20 AND 24 THEN (1*a_prchsd) END) txn_age_20_24_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 25 AND 29 THEN (1*a_prchsd) END) txn_age_25_29_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 30 AND 34 THEN (1*a_prchsd) END) txn_age_30_34_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 35 AND 39 THEN (1*a_prchsd) END) txn_age_35_39_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 40 AND 44 THEN (1*a_prchsd) END) txn_age_40_44_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 45 AND 49 THEN (1*a_prchsd) END) txn_age_45_49_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 50 AND 54 THEN (1*a_prchsd) END) txn_age_50_54_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 55 AND 59 THEN (1*a_prchsd) END) txn_age_55_59_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 60 AND 64 THEN (1*a_prchsd) END) txn_age_60_64_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 65 AND 69 THEN (1*a_prchsd) END) txn_age_65_69_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 70 AND 74 THEN (1*a_prchsd) END) txn_age_70_74_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 75 AND 79 THEN (1*a_prchsd) END) txn_age_75_79_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age BETWEEN 80 AND 84 THEN (1*a_prchsd) END) txn_age_80_84_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age >= 85 THEN (1*a_prchsd) END) txn_age_85_above_amt
	, sum(CASE WHEN txn_merch_cust_card.n_age IS NULL THEN (1*a_prchsd) END) txn_age_na_amt

	FROM
	(
		SELECT txn_merch_card.a_prchsd, txn_merch_card.id_day, txn_merch_card.weekdays, txn_merch_card.months,txn_merch_card.id_customer
		,txn_merch_card.cmpnyid, txn_merch_card.nm_terml, txn_merch_card.id_merchant_locn, txn_merch_card.id_industry_clsfn, txn_merch_card.hr
		, cust.n_age, cust.c_gender
		FROM
		(-- join customer information with merch and txn
			SELECT txn_merch.a_prchsd, txn_merch.id_plastic_card, txn_merch.cmpnyid, txn_merch.nm_terml, txn_merch.id_merchant_locn, txn_merch.id_day, txn_merch.id_industry_clsfn
			 , to_char(txn_merch.id_day, 'dy') weekdays
			 , to_char(txn_merch.id_day, 'mon') months
			 , to_char(txn_merch.id_time_of_day, 'FMHH24') hr
			 , card.id_customer
			FROM
			( -- join merch information with txn

				SELECT txn.a_prchsd, txn.id_plastic_card, to_date(to_char(txn.id_day, '99999999'), 'YYYYMMDD') id_day
				,  to_timestamp(to_char(txn.id_time_of_day, '999999'),'FMHH24MISS') id_time_of_day 
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
	GROUP BY cmpnyid 
);  


-- grand access permission 
alter table credit_card_feature.cc_features_company
owner to gcppoc;

-- add primary key
alter table credit_card_feature.cc_features_company
add primary key (cmpnyid);


select * from credit_card_feature.cc_features_company

