create table create_test(
SELECT  row_id, nm_terml, id_merchant_locn, id_merchant_pos, id_plastic_card, 
       id_customer, id_mrchnt, id_day, id_time_of_day, id_card_present, 
       a_prchsd, c_post_terml, n_age, c_gender, c_postcode
  FROM "instoDataAnalyticsDev".credit_card_fake
  limit 100);
