DROP view IF EXISTS credit_card_feature.cc_features_company_view;

CREATE VIEW credit_card_feature.cc_features_company_view
AS
(
	SELECT  cmpny.*
	, round(cmpny.Txn_Cnt/cmpny.Cust_Cnt::DECIMAL, 2) txncnt_percust
	--
	, round(cmpny.txn_gndr_F_amt/cmpny.txn_gndr_f_cnt::DECIMAL, 2) txnamt_gndr_f_percust
	, round(cmpny.txn_gndr_m_amt/cmpny.txn_gndr_m_cnt::DECIMAL, 2) txnamt_gndr_M_percust
	, round(cmpny.txn_gndr_c_amt/cmpny.txn_gndr_c_cnt::DECIMAL, 2) txnamt_gndr_c_percust

	, round(cmpny.txn_gndr_F_amt/cmpny.Cust_gndr_F_Cnt::DECIMAL, 2) txnamt_gndr_f_pertxn
	, round(cmpny.txn_gndr_m_amt/cmpny.Cust_gndr_m_Cnt::DECIMAL, 2) txnamt_gndr_M_pertxn
	, round(cmpny.txn_gndr_c_amt/cmpny.Cust_gndr_c_Cnt::DECIMAL, 2) txnamt_gndr_c_pertxn

	, round(100*cmpny.cust_gndr_f_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_gndr_f_pcn
	, round(100*cmpny.cust_gndr_m_cnt/cmpny.Cust_Cnt::DECIMAL, 2) custcnt_gndr_m_pcn
	, round(100*cmpny.cust_gndr_c_cnt/cmpny.Cust_Cnt::DECIMAL, 2) custcnt_gndr_c_pcn
	--
	, round(cmpny.txn_age_0_4_amt/cmpny.Cust_age_0_4_cnt::DECIMAL, 2) txnamt_age_0_4_percust
	, round(cmpny.txn_age_5_9_amt/cmpny.Cust_age_5_9_cnt::DECIMAL, 2) txnamt_age_5_9_percust
	, round(cmpny.txn_age_10_14_amt/cmpny.Cust_age_10_14_cnt::DECIMAL, 2) txnamt_age_10_14_percust
	, round(cmpny.txn_age_15_19_amt/cmpny.Cust_age_15_19_cnt::DECIMAL, 2) txnamt_age_15_19_percust
	, round(cmpny.txn_age_20_24_amt/cmpny.Cust_age_20_24_cnt::DECIMAL, 2) txnamt_age_20_24_percust
	, round(cmpny.txn_age_25_29_amt/cmpny.Cust_age_25_29_cnt::DECIMAL, 2) txnamt_age_25_29_percust
	, round(cmpny.txn_age_30_34_amt/cmpny.Cust_age_30_34_cnt::DECIMAL, 2) txnamt_age_30_34_percust
	, round(cmpny.txn_age_35_39_amt/cmpny.Cust_age_35_39_cnt::DECIMAL, 2) txnamt_age_35_39_percust
	, round(cmpny.txn_age_40_44_amt/cmpny.Cust_age_40_44_cnt::DECIMAL, 2) txnamt_age_40_44_percust
	, round(cmpny.txn_age_45_49_amt/cmpny.Cust_age_45_49_cnt::DECIMAL, 2) txnamt_age_45_49_percust
	, round(cmpny.txn_age_50_54_amt/cmpny.Cust_age_50_54_cnt::DECIMAL, 2) txnamt_age_50_54_percust
	, round(cmpny.txn_age_55_59_amt/cmpny.Cust_age_55_59_cnt::DECIMAL, 2) txnamt_age_55_59_percust
	, round(cmpny.txn_age_60_64_amt/cmpny.Cust_age_60_64_cnt::DECIMAL, 2) txnamt_age_60_64_percust
	, round(cmpny.txn_age_65_69_amt/cmpny.Cust_age_65_69_cnt::DECIMAL, 2) txnamt_age_65_69_percust
	, round(cmpny.txn_age_70_74_amt/cmpny.Cust_age_70_74_cnt::DECIMAL, 2) txnamt_age_70_74_percust
	, round(cmpny.txn_age_75_79_amt/cmpny.Cust_age_75_79_cnt::DECIMAL, 2) txnamt_age_75_79_percust
	, round(cmpny.txn_age_80_84_amt/cmpny.Cust_age_80_84_cnt::DECIMAL, 2) txnamt_age_80_84_percust
	, round(cmpny.txn_age_85_above_amt/cmpny.Cust_age_85_above_cnt::DECIMAL, 2) txnamt_age_85_above_percust
	, round(cmpny.txn_age_na_amt/cmpny.Cust_age_na_cnt::DECIMAL, 2) txnamt_age_na_percust

	, round(cmpny.txn_age_0_4_amt/cmpny.txn_age_0_4_cnt::DECIMAL, 2) txnamt_age_0_4_pertxn
	, round(cmpny.txn_age_5_9_amt/cmpny.txn_age_5_9_cnt::DECIMAL, 2) txnamt_age_5_9_pertxn
	, round(cmpny.txn_age_10_14_amt/cmpny.txn_age_10_14_cnt::DECIMAL, 2) txnamt_age_10_14_pertxn
	, round(cmpny.txn_age_15_19_amt/cmpny.txn_age_15_19_cnt::DECIMAL, 2) txnamt_age_15_19_pertxn
	, round(cmpny.txn_age_20_24_amt/cmpny.txn_age_20_24_cnt::DECIMAL, 2) txnamt_age_20_24_pertxn
	, round(cmpny.txn_age_25_29_amt/cmpny.txn_age_25_29_cnt::DECIMAL, 2) txnamt_age_25_29_pertxn
	, round(cmpny.txn_age_30_34_amt/cmpny.txn_age_30_34_cnt::DECIMAL, 2) txnamt_age_30_34_pertxn
	, round(cmpny.txn_age_35_39_amt/cmpny.txn_age_35_39_cnt::DECIMAL, 2) txnamt_age_35_39_pertxn
	, round(cmpny.txn_age_40_44_amt/cmpny.txn_age_40_44_cnt::DECIMAL, 2) txnamt_age_40_44_pertxn
	, round(cmpny.txn_age_45_49_amt/cmpny.txn_age_45_49_cnt::DECIMAL, 2) txnamt_age_45_49_pertxn
	, round(cmpny.txn_age_50_54_amt/cmpny.txn_age_50_54_cnt::DECIMAL, 2) txnamt_age_50_54_pertxn
	, round(cmpny.txn_age_55_59_amt/cmpny.txn_age_55_59_cnt::DECIMAL, 2) txnamt_age_55_59_pertxn
	, round(cmpny.txn_age_60_64_amt/cmpny.txn_age_60_64_cnt::DECIMAL, 2) txnamt_age_60_64_pertxn
	, round(cmpny.txn_age_65_69_amt/cmpny.txn_age_65_69_cnt::DECIMAL, 2) txnamt_age_65_69_pertxn
	, round(cmpny.txn_age_70_74_amt/cmpny.txn_age_70_74_cnt::DECIMAL, 2) txnamt_age_70_74_pertxn
	, round(cmpny.txn_age_75_79_amt/cmpny.txn_age_75_79_cnt::DECIMAL, 2) txnamt_age_75_79_pertxn
	, round(cmpny.txn_age_80_84_amt/cmpny.txn_age_80_84_cnt::DECIMAL, 2) txnamt_age_80_84_pertxn
	, round(cmpny.txn_age_85_above_amt/cmpny.txn_age_85_above_cnt::DECIMAL, 2) txnamt_age_85_above_pertxn
	, round(cmpny.txn_age_na_amt/cmpny.txn_age_na_cnt::DECIMAL, 2) txnamt_age_na_pertxn	
	
	, round(100*cmpny.cust_age_0_4_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_0_4_pcn
	, round(100*cmpny.cust_age_5_9_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_5_9_pcn
	, round(100*cmpny.cust_age_10_14_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_10_14_pcn
	, round(100*cmpny.cust_age_15_19_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_15_19_pcn
	, round(100*cmpny.cust_age_20_24_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_20_24_pcn
	, round(100*cmpny.cust_age_25_29_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_25_29_pcn
	, round(100*cmpny.cust_age_30_34_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_30_34_pcn
	, round(100*cmpny.cust_age_35_39_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_35_39_pcn
	, round(100*cmpny.cust_age_40_44_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_40_44_pcn
	, round(100*cmpny.cust_age_45_49_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_45_49_pcn
	, round(100*cmpny.cust_age_50_54_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_50_54_pcn
	, round(100*cmpny.cust_age_55_59_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_55_59_pcn
	, round(100*cmpny.cust_age_60_64_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_60_64_pcn
	, round(100*cmpny.cust_age_65_69_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_65_69_pcn
	, round(100*cmpny.cust_age_70_74_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_70_74_pcn
	, round(100*cmpny.cust_age_75_79_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_75_79_pcn
	, round(100*cmpny.cust_age_80_84_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_80_84_pcn
	, round(100*cmpny.cust_age_85_above_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_85_above_pcn
	, round(100*cmpny.cust_age_na_cnt/cmpny.cust_cnt::DECIMAL, 2) custcnt_age_na_pcn

	--
	, round(cmpny.txn_dyofwk_mon_amt/cmpny.Cust_dyofwk_mon_Cnt::DECIMAL, 2) txnamt_dyofwk_mon_percust
	, round(cmpny.txn_dyofwk_tue_amt/cmpny.Cust_dyofwk_tue_Cnt::DECIMAL, 2) txnamt_dyofwk_tue_percust
	, round(cmpny.txn_dyofwk_wed_amt/cmpny.Cust_dyofwk_wed_Cnt::DECIMAL, 2) txnamt_dyofwk_wed_percust
	, round(cmpny.txn_dyofwk_thu_amt/cmpny.Cust_dyofwk_thu_Cnt::DECIMAL, 2) txnamt_dyofwk_thu_percust
	, round(cmpny.txn_dyofwk_fri_amt/cmpny.Cust_dyofwk_fri_Cnt::DECIMAL, 2) txnamt_dyofwk_fri_percust
	, round(cmpny.txn_dyofwk_sat_amt/cmpny.Cust_dyofwk_sat_Cnt::DECIMAL, 2) txnamt_dyofwk_sat_percust
	, round(cmpny.txn_dyofwk_sun_amt/cmpny.Cust_dyofwk_sun_Cnt::DECIMAL, 2) txnamt_dyofwk_sun_percust

	, round(cmpny.txn_dyofwk_mon_amt/cmpny.txn_dyofwk_mon_Cnt::DECIMAL, 2) txnamt_dyofwk_mon_pertxn
	, round(cmpny.txn_dyofwk_tue_amt/cmpny.txn_dyofwk_tue_Cnt::DECIMAL, 2) txnamt_dyofwk_tue_pertxn
	, round(cmpny.txn_dyofwk_wed_amt/cmpny.txn_dyofwk_wed_Cnt::DECIMAL, 2) txnamt_dyofwk_wed_pertxn
	, round(cmpny.txn_dyofwk_thu_amt/cmpny.txn_dyofwk_thu_Cnt::DECIMAL, 2) txnamt_dyofwk_thu_pertxn
	, round(cmpny.txn_dyofwk_fri_amt/cmpny.txn_dyofwk_fri_Cnt::DECIMAL, 2) txnamt_dyofwk_fri_pertxn
	, round(cmpny.txn_dyofwk_sat_amt/cmpny.txn_dyofwk_sat_Cnt::DECIMAL, 2) txnamt_dyofwk_sat_pertxn
	, round(cmpny.txn_dyofwk_sun_amt/cmpny.txn_dyofwk_sun_Cnt::DECIMAL, 2) txnamt_dyofwk_sun_pertxn

-- 	, round(100*cmpny.txn_dyofwk_mon_amt/cmpny.txn_dyofwk_mon_Cnt::DECIMAL, 2) txnamt_dyofwk_mon_pcn
-- 	, round(100*cmpny.txn_dyofwk_tue_amt/cmpny.txn_dyofwk_tue_Cnt::DECIMAL, 2) txnamt_dyofwk_tue_pcn
-- 	, round(100*cmpny.txn_dyofwk_wed_amt/cmpny.txn_dyofwk_wed_Cnt::DECIMAL, 2) txnamt_dyofwk_wed_pcn
-- 	, round(100*cmpny.txn_dyofwk_thu_amt/cmpny.txn_dyofwk_thu_Cnt::DECIMAL, 2) txnamt_dyofwk_thu_pcn
-- 	, round(100*cmpny.txn_dyofwk_fri_amt/cmpny.txn_dyofwk_fri_Cnt::DECIMAL, 2) txnamt_dyofwk_fri_pcn
-- 	, round(100*cmpny.txn_dyofwk_sat_amt/cmpny.txn_dyofwk_sat_Cnt::DECIMAL, 2) txnamt_dyofwk_sat_pcn
-- 	, round(100*cmpny.txn_dyofwk_sun_amt/cmpny.txn_dyofwk_sun_Cnt::DECIMAL, 2) txnamt_dyofwk_sun_pcn


	FROM
	(
		SELECT *
		FROM credit_card_feature.cc_features_company
		-- where 
	) cmpny
);


-- grand access permission 
ALTER TABLE credit_card_feature.cc_features_company_view
OWNER TO gcppoc;