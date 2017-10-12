DROP view IF EXISTS credit_card_feature.cc_features_company_view;

CREATE VIEW credit_card_feature.cc_features_company_view
AS
(
	SELECT  cmpny.*
	, round(cmpny.Txn_Cnt/cmpny.Cust_Cnt::DECIMAL, 2) txncnt_percust
	--
	, round(cmpny.Custgndr_F_amt/cmpny.Custgndr_F_Cnt::DECIMAL, 2) txnamt_gndr_f_pertxn
	, round(cmpny.Custgndr_m_amt/cmpny.Custgndr_m_Cnt::DECIMAL, 2) txnamt_gndr_M_pertxn
	, round(cmpny.Custgndr_c_amt/cmpny.Custgndr_c_Cnt::DECIMAL, 2) txnamt_gndr_c_pertxn
	--
	, round(cmpny.Custgndr_F_amt/cmpny.Custgndr_F_Cnt::DECIMAL, 2) txnamt_gndr_f_pertxn
	, round(cmpny.Custgndr_m_amt/cmpny.Custgndr_m_Cnt::DECIMAL, 2) txnamt_gndr_M_pertxn
	, round(cmpny.Custgndr_c_amt/cmpny.Custgndr_c_Cnt::DECIMAL, 2) txnamt_gndr_c_pertxn

	--
	, round(cmpny.custage_0_4_amt/cmpny.Custage_0_4_cnt::DECIMAL, 2) txnamt_custage_0_4_pertxn
	, round(cmpny.custage_5_9_amt/cmpny.Custage_5_9_cnt::DECIMAL, 2) txnamt_custage_5_9_pertxn
	, round(cmpny.custage_10_14_amt/cmpny.Custage_10_14_cnt::DECIMAL, 2) txnamt_custage_10_14_pertxn
	, round(cmpny.custage_15_19_amt/cmpny.Custage_15_19_cnt::DECIMAL, 2) txnamt_custage_15_19_pertxn
	, round(cmpny.custage_20_24_amt/cmpny.Custage_20_24_cnt::DECIMAL, 2) txnamt_custage_20_24_pertxn
	, round(cmpny.custage_25_29_amt/cmpny.Custage_25_29_cnt::DECIMAL, 2) txnamt_custage_25_29_pertxn
	, round(cmpny.custage_30_34_amt/cmpny.Custage_30_34_cnt::DECIMAL, 2) txnamt_custage_30_34_pertxn
	, round(cmpny.custage_35_39_amt/cmpny.Custage_35_39_cnt::DECIMAL, 2) txnamt_custage_35_39_pertxn
	, round(cmpny.custage_40_44_amt/cmpny.Custage_40_44_cnt::DECIMAL, 2) txnamt_custage_40_44_pertxn
	, round(cmpny.custage_45_49_amt/cmpny.Custage_45_49_cnt::DECIMAL, 2) txnamt_custage_45_49_pertxn
	, round(cmpny.custage_50_54_amt/cmpny.Custage_50_54_cnt::DECIMAL, 2) txnamt_custage_50_54_pertxn
	, round(cmpny.custage_55_59_amt/cmpny.Custage_55_59_cnt::DECIMAL, 2) txnamt_custage_55_59_pertxn
	, round(cmpny.custage_60_64_amt/cmpny.Custage_60_64_cnt::DECIMAL, 2) txnamt_custage_60_64_pertxn
	, round(cmpny.custage_65_69_amt/cmpny.Custage_65_69_cnt::DECIMAL, 2) txnamt_custage_65_69_pertxn
	, round(cmpny.custage_70_74_amt/cmpny.Custage_70_74_cnt::DECIMAL, 2) txnamt_custage_70_74_pertxn
	, round(cmpny.custage_75_79_amt/cmpny.Custage_75_79_cnt::DECIMAL, 2) txnamt_custage_75_79_pertxn
	, round(cmpny.custage_80_84_amt/cmpny.Custage_80_84_cnt::DECIMAL, 2) txnamt_custage_80_84_pertxn
	, round(cmpny.custage_85_above_amt/cmpny.Custage_85_above_cnt::DECIMAL, 2) txnamt_custage_85_above_pertxn
	, round(cmpny.custage_na_amt/cmpny.Custage_na_cnt::DECIMAL, 2) txnamt_custage_na_pertxn
	--
	, round(100*cmpny.custage_25_29_cnt/cmpny.cust_cnt::DECIMAL, 2) custage_25_29_pct	

	--
	, round(cmpny.Custdayofwk_mon_amt/cmpny.Custdayofwk_mon_Cnt::DECIMAL, 2) Custamt_dayofwk_mon_pertxn
	, round(cmpny.Custdayofwk_tue_amt/cmpny.Custdayofwk_tue_Cnt::DECIMAL, 2) Custamt_dayofwk_tue_pertxn
	, round(cmpny.Custdayofwk_wed_amt/cmpny.Custdayofwk_wed_Cnt::DECIMAL, 2) Custamt_dayofwk_wed_pertxn
	, round(cmpny.Custdayofwk_thu_amt/cmpny.Custdayofwk_thu_Cnt::DECIMAL, 2) Custamt_dayofwk_thu_pertxn
	, round(cmpny.Custdayofwk_fri_amt/cmpny.Custdayofwk_fri_Cnt::DECIMAL, 2) Custamt_dayofwk_fri_pertxn
	, round(cmpny.Custdayofwk_sat_amt/cmpny.Custdayofwk_sat_Cnt::DECIMAL, 2) Custamt_dayofwk_sat_pertxn
	, round(cmpny.Custdayofwk_sun_amt/cmpny.Custdayofwk_sun_Cnt::DECIMAL, 2) Custamt_dayofwk_sun_pertxn
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