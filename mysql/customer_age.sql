#select * from instoDataAnalyticsDev.cc_raw_dim_merchant_pos_fake
/*
select count(distinct c_post_terml)	
from cc_raw_dim_merchant_pos_fake;


select * from cc_raw_dim_merchant_pos_fake;
*/


create temporary table tmp(
select txn.a_prchsd, txn.a_txn_cash, txn.id_plastic_card
,card.id_customer, cust.n_age, cust.c_gender, cust.c_postcode 
from cc_raw_fct_base_card_fake txn
left join cc_raw_dim_plastic_card_fake card
on txn.id_plastic_card = card.id_plastic_card
left join cc_raw_dim_customer_fake cust
on card.id_customer = card.id_customer
);


select * from cc_raw_dim_plastic_card_fake;


select txn.a_prchsd, txn.a_txn_cash, txn.id_plastic_card
,card.id_customer 
from cc_raw_fct_base_card_fake txn
left join cc_raw_dim_plastic_card_fake card
on txn.id_plastic_card = card.id_plastic_card;