DROP view IF EXISTS credit_card_feature.cc_features_company_view;

CREATE VIEW credit_card_feature.cc_features_company_view
AS
(
	SELECT  cmpny.*
	, round(cmpny.Txn_Cnt/cmpny.Cust_Cnt::DECIMAL, 2) txncnt_percust
	, round(100*cmpny.custage_25_29_cnt/cmpny.cust_cnt::DECIMAL, 2) custage_25_29_pct	
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