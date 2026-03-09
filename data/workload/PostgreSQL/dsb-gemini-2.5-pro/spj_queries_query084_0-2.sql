WITH filtered_income AS
  (SELECT ib_income_band_sk
   FROM income_band
   WHERE ib_lower_bound >= 3 * 10000
     AND ib_upper_bound <= 3 * 10000 + 50000),
     filtered_address AS
  (SELECT ca_address_sk
   FROM customer_address
   WHERE ca_city = 'Hopewell')
SELECT min(c.c_customer_id),
       min(sr.sr_ticket_number),
       min(sr.sr_item_sk)
FROM store_returns sr
JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk
JOIN customer c ON cd.cd_demo_sk = c.c_current_cdemo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN filtered_income fi ON hd.hd_income_band_sk = fi.ib_income_band_sk
JOIN filtered_address fa ON c.c_current_addr_sk = fa.ca_address_sk;